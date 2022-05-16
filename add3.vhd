--Written by Colton on July 13th
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY add3 IS
		PORT( A : IN UNSIGNED(3 DOWNTO 0);
				S : OUT UNSIGNED(3 DOWNTO 0));
END add3;

ARCHITECTURE Behaviour OF add3 IS
BEGIN
	WITH A SELECT --simple select structure
		S <= "0000" WHEN "0000",
			  "0001" WHEN "0001",
			  "0010" WHEN "0010",
			  "0011" WHEN "0011",
			  "0100" WHEN "0100",
			  "1000" WHEN "0101",
			  "1001" WHEN "0110",
			  "1010" WHEN "0111",
			  "1011" WHEN "1000",
			  "1100" WHEN "1001",
			  "XXXX" WHEN OTHERS;
END Behaviour;