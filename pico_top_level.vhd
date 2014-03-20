library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pico_top_level is
    port (
             clk        : in  std_logic;
             reset      : in  std_logic;
             serial_in  : in  std_logic;
             serial_out : out std_logic;
             switch     : in  std_logic_vector(7 downto 0);
             LED        : out std_logic_vector(7 downto 0)
         );
end pico_top_level;

architecture behavioral of pico_top_level is

	signal baud_16x_en_sig		: std_logic;

	component clk_to_baud
		port (
			clk         : in std_logic;  -- 100 MHz
			reset       : in std_logic;
			baud_16x_en : out std_logic -- 16*9.6 kHz (use a counter)
		);
	end component;

	component uart_rx6
		port(
			serial_in : in std_logic;
			en_16_x_baud : in std_logic;
			data_out : out std_logic_vector(7 downto 0);
			buffer_read : in std_logic;
			buffer_data_present : out std_logic;
			buffer_half_full : out std_logic;
			buffer_full : out std_logic;
			buffer_reset : in std_logic;
			clk : in std_logic
		);
	end component;

	component uart_tx6
		port(
			data_in : in std_logic_vector(7 downto 0);
			en_16_x_baud : in std_logic;
			serial_out : out std_logic;
			buffer_write : in std_logic;
			buffer_data_present : out std_logic;
			buffer_half_full : out std_logic;
			buffer_full : out std_logic;
			buffer_reset : in std_logic;
			clk : in std_logic
		);
	end component;

	component kcpsm6 
		 generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
							  interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
					 scratch_pad_memory_size : integer := 64);
		 port (                   address : out std_logic_vector(11 downto 0);
									 instruction : in std_logic_vector(17 downto 0);
									 bram_enable : out std_logic;
										  in_port : in std_logic_vector(7 downto 0);
										 out_port : out std_logic_vector(7 downto 0);
										  port_id : out std_logic_vector(7 downto 0);
									write_strobe : out std_logic;
								 k_write_strobe : out std_logic;
									 read_strobe : out std_logic;
										interrupt : in std_logic;
								  interrupt_ack : out std_logic;
											 sleep : in std_logic;
											 reset : in std_logic;
												clk : in std_logic);
	end component;

	component trae                           
		 generic(             C_FAMILY : string := "S6"; 
						 C_RAM_SIZE_KWORDS : integer := 1;
					 C_JTAG_LOADER_ENABLE : integer := 0);
		 Port (      address : in std_logic_vector(11 downto 0);
					instruction : out std_logic_vector(17 downto 0);
						  enable : in std_logic;
							  rdl : out std_logic;                    
							  clk : in std_logic);
	end component;

	COMPONENT nibble_to_ascii
	PORT(
		nibble : IN std_logic_vector(3 downto 0);          
		ascii : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	COMPONENT ascii_to_nibble
	PORT(
		ascii : IN std_logic_vector(7 downto 0);          
		nibble : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;


	signal         address : std_logic_vector(11 downto 0);
	signal     instruction : std_logic_vector(17 downto 0);
	signal     bram_enable : std_logic;
	signal   kcpsm6_in_port : std_logic_vector(7 downto 0);
	signal  kcpsm6_out_port : std_logic_vector(7 downto 0);
	signal         port_id : std_logic_vector(7 downto 0);
	signal    write_strobe : std_logic;
	signal  k_write_strobe : std_logic;
	signal     read_strobe : std_logic;
	signal       interrupt : std_logic;
	signal   interrupt_ack : std_logic;
	signal    kcpsm6_sleep : std_logic;
	signal    kcpsm6_reset : std_logic;

	--
	-- Some additional signals are required if your system also needs to reset KCPSM6. 
	--

	signal       cpu_reset : std_logic;
	signal             rdl : std_logic;

	signal		 data_route : std_logic_vector(7 downto 0);
	signal		 read_data_present : std_logic;
	signal		 write_data_present : std_logic;
	signal		 buffer_read_sig	: std_logic;
	signal		 buffer_write_sig : std_logic;

	-- uart signals
	signal data_in_sig, data_out_sig : std_logic_vector (7 downto 0);

begin

clk_to_baud_init: clk_to_baud
	port map(
		clk => clk,
		reset => reset,
		baud_16x_en => baud_16x_en_sig
	);

--LED output
LED <= kcpsm6_out_port;

processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => kcpsm6_out_port,
               read_strobe => read_strobe,
                   in_port => kcpsm6_in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);

  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;

  program_rom: trae
    generic map(             C_FAMILY => "S6",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 1,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);

rx: uart_rx6 
  port map (            serial_in => serial_in,
                     en_16_x_baud => baud_16x_en_sig,
                         data_out => data_out_sig,
                      buffer_read => write_data_present,
              buffer_data_present => read_data_present,
                 buffer_half_full => open,
                      buffer_full => open,
                     buffer_reset => reset,              
                              clk => clk
);

  tx: uart_tx6 
  port map (              data_in => data_out_sig,
                     en_16_x_baud => baud_16x_en_sig,
                       serial_out => serial_out,
                     buffer_write => read_data_present,
              buffer_data_present => write_data_present,
                 buffer_half_full => open,
                      buffer_full => open,
                     buffer_reset => reset,              
                              clk => clk
);

--enable read/write
buffer_read_sig <= '1' when port_id = X"02" and read_strobe = '1'
						 else '0';

buffer_write_sig <= '1' when port_id = X"03" and write_strobe = '1'
						 else '0';

----input to kcpsm6
kcpsm6_in_port <= data_out_sig when port_id = x"02" else
						"0000000" & read_data_present when port_id =x"01" else
						(others => '0');

----input to uart_tx6	
data_in_sig <= kcpsm6_out_port when port_id = x"03" else
					(others => '0');

--nibble_ascii_hi: nibble_to_ascii PORT MAP(
--	nibble => switch(7 downto 4),
--	ascii =>  switch_char_hi	
--);
--
--nibble_ascii_lo: nibble_to_ascii PORT MAP(
--	nibble => switch(3 downto 0),
--	ascii =>  switch_char_lo	
--);	

end behavioral;