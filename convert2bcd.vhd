--Written by Colton on July 13th
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY convert2bcd IS 
	PORT( binary : IN UNSIGNED(7 DOWNTO 0); 
			bcd : OUT UNSIGNED(11 DOWNTO 0)); 
END convert2bcd;

--naming convention: col<column number of wire (corresponding bit)>_<row number of wire counting from top to bottom>
ARCHITECTURE Behaviour OF convert2bcd IS
	SIGNAL col2_1 : STD_LOGIC := '0';
	SIGNAL col3_1 : STD_LOGIC := '0';
	SIGNAL col3_2 : STD_LOGIC := '0';
	SIGNAL col4_1 : STD_LOGIC := '0';
	SIGNAL col4_2 : STD_LOGIC := '0';
	SIGNAL col4_3 : STD_LOGIC := '0';
	SIGNAL col5_1 : STD_LOGIC := '0';
	SIGNAL col5_2 : STD_LOGIC := '0';
	SIGNAL col5_3 : STD_LOGIC := '0';
	SIGNAL col5_4 : STD_LOGIC := '0';
	SIGNAL col6_1 : STD_LOGIC := '0';
	SIGNAL col6_2 : STD_LOGIC := '0';
	SIGNAL col6_3 : STD_LOGIC := '0';
	SIGNAL col6_4 : STD_LOGIC := '0';
	SIGNAL col7_1 : STD_LOGIC := '0';
	SIGNAL col7_2 : STD_LOGIC := '0';
	SIGNAL col7_3 : STD_LOGIC := '0';
	SIGNAL col8_1 : STD_LOGIC := '0';
	SIGNAL col8_2 : STD_LOGIC := '0';

COMPONENT add3 IS
		PORT( A : IN UNSIGNED(3 DOWNTO 0);
				S : OUT UNSIGNED(3 DOWNTO 0));
END COMPONENT;

BEGIN
--simply portmapped the circuit in the figure
--naming convention: add3_<row number of add3 component counting from top to bottom>_<column number of add3 component when more than one is next to each other>
add3_1_1: add3 PORT MAP(A(3) => '0', A(2) => binary(7), A(1) => binary(6), A(0) => binary(5), S(3) => col8_1, S(2) => col7_1, S(1) => col6_1, S(0) => col5_1);
add3_2_1: add3 PORT MAP(A(3) => col7_1, A(2) => col6_1, A(1) => col5_1, A(0) => binary(4), S(3) => col7_2, S(2) => col6_2, S(1) => col5_2, S(0) => col4_1);
add3_3_1: add3 PORT MAP(A(3) => col6_2, A(2) => col5_2, A(1) => col4_1, A(0) => binary(3), S(3) => col6_3, S(2) => col5_3, S(1) => col4_2, S(0) => col3_1);
add3_4_1: add3 PORT MAP(A(3) => '0', A(2) => col8_1, A(1) => col7_2, A(0) => col6_3, S(3) => bcd(9), S(2) => col8_2, S(1) => col7_3, S(0) => col6_4);
add3_4_2: add3 PORT MAP(A(3) => col5_3, A(2) => col4_2, A(1) => col3_1, A(0) => binary(2), S(3) => col5_4, S(2) => col4_3, S(1) => col3_2, S(0) => col2_1);
add3_5_1: add3 PORT MAP(A(3) => col8_2, A(2) => col7_3, A(1) => col6_4, A(0) => col5_4, S(3) => bcd(8), S(2) => bcd(7), S(1) => bcd(6), S(0) => bcd(5));
add3_5_2: add3 PORT MAP(A(3) => col4_3, A(2) => col3_2, A(1) => col2_1, A(0) => binary(1), S(3) => bcd(4), S(2) => bcd(3), S(1) => bcd(2), S(0) => bcd(1));

bcd(0) <= binary(0);
bcd(10) <= '0';
bcd(11) <= '0';

END Behaviour;