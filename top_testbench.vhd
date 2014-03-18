--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:29:54 03/13/2014
-- Design Name:   
-- Module Name:   C:/Users/C15Tramaine.Barnett/WorkSpace/lab4/top_testbench.vhd
-- Project Name:  lab4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pico_top_level
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_testbench IS
END top_testbench;
 
ARCHITECTURE behavior OF top_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pico_top_level
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         serial_in : IN  std_logic;
         serial_out : OUT  std_logic;
         switch : IN  std_logic_vector(7 downto 0);
         btn : IN  std_logic_vector(4 downto 1);
         Led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal serial_in : std_logic := '0';
   signal switch : std_logic_vector(7 downto 0) := (others => '0');
   signal btn : std_logic_vector(4 downto 1) := (others => '0');

 	--Outputs
   signal serial_out : std_logic;
   signal Led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pico_top_level PORT MAP (
          clk => clk,
          reset => reset,
          serial_in => serial_in,
          serial_out => serial_out,
          switch => switch,
          btn => btn,
          Led => Led
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

		reset <= '1';
		switch <= "00000000";
		btn <= "0000";
		

      wait for clk_period*10;

		switch <= "00001111";
		wait for clk_period*20;
		
		btn <= "1111";
		wait for clk_period*20;
		
		switch <= "00111100";
		wait for clk_period*20;
		
		btn <= "0011";
		wait for clk_period*20;
      
		

      wait;
   end process;

END;
