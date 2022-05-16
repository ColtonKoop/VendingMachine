LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY tb_convert2bcd IS
END tb_convert2bcd;

ARCHITECTURE test of tb_convert2bcd IS

COMPONENT convert2bcd IS 
	PORT( binary : IN UNSIGNED(7 DOWNTO 0); 
			bcd : OUT UNSIGNED(11 DOWNTO 0)); 
END COMPONENT;

SIGNAL binSIG : UNSIGNED(7 DOWNTO 0); 
SIGNAL bcdSIG : UNSIGNED(11 DOWNTO 0);

BEGIN
DUT : convert2bcd
PORT MAP(binary => binSIG, bcd => bcdSIG);

PROCESS IS
BEGIN

binSIG <= "00000001";
wait for 20 ns; 

binSIG <= "00011011";
wait for 20 ns; 

binSIG <= "00110011";
wait for 20 ns; 

binSIG <= "00000000";
wait for 20 ns; 

binSIG <= "00111111";
wait for 20 ns; 

binSIG <= "00101010";
wait for 20 ns; 

binSIG <= "00010101";
wait for 20 ns; 

binSIG <= "00110110";
wait for 20 ns; 

WAIT;

END PROCESS;

END test;