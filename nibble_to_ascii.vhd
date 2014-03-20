----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:57:26 03/17/2014 
-- Design Name: 
-- Module Name:    nibble_to_ascii - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity nibble_to_ascii is
    Port ( nibble : in  STD_LOGIC_VECTOR (3 downto 0);
           ascii : out  STD_LOGIC_VECTOR (7 downto 0));
end nibble_to_ascii;

architecture Behavioral of nibble_to_ascii is

begin

process(Nibble)
begin	
	case Nibble is

		when x"0" => Ascii <= x"48" ;
		when x"1" => Ascii <= x"49" ;
		when x"2" => Ascii <= x"50" ; 
		when x"3" => Ascii <= x"51" ;
		when x"4" => Ascii <= x"52" ;
		when x"5" => Ascii <= x"53" ;
		when x"6" => Ascii <= x"54" ;
		when x"7" => Ascii <= x"55" ;
		when x"8" => Ascii <= x"56" ;
		when x"9" => Ascii <= x"57" ;
		when x"A" => Ascii <= x"65" ;
		when x"B" => Ascii <= x"66" ;
		when x"C" => Ascii <= x"67" ;
		when x"D" => Ascii <= x"68" ;
		when x"E" => Ascii <= x"69" ;
		when x"F" => Ascii <= x"70" ;
		when others => Ascii <= x"00" ;

	end case;

end process;

end Behavioral;
