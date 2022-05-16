--Written by Colton on July 12th
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY accumulator IS
		PORT( clock, reset, en, N, D, Q : IN STD_LOGIC;
				accum_out : OUT UNSIGNED(5 DOWNTO 0)); --6 bits needed to store up to 51 (255/5)
END accumulator;

ARCHITECTURE Behaviour OF accumulator IS
BEGIN

PROCESS(clock, reset)
	VARIABLE internalAccum : UNSIGNED(5 DOWNTO 0) := "000000"; --variable needed to update internalAccum multiple times within process
BEGIN
	IF(reset = '1') THEN --asynchronous reset: if active ignore clock
		internalAccum := "000000";
	ELSIF(rising_edge(clock)) THEN
		IF(en = '1') THEN
			IF(N = '1') THEN --accumulate money
				internalAccum := internalAccum + 1;
			END IF;
			IF(D = '1') THEN
				internalAccum := internalAccum + 2;
			END IF;
			IF(Q = '1') THEN
				internalAccum := internalAccum + 5;
			END IF;
		ELSE
			internalAccum := "000000"; --accumulator reset when en = '0'
		END IF;
	END IF;
	accum_out <= internalAccum;
END PROCESS;
	
END Behaviour;