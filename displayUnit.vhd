LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY displayUnit IS
		PORT( clock, reset, hard_reset, enable : IN STD_LOGIC;
				product : IN UNSIGNED(1 DOWNTO 0);
				done, ren : OUT STD_LOGIC);
END displayUnit;

ARCHITECTURE Behaviour OF displayUnit IS
TYPE state_type IS (idle, reading);
SIGNAL next_state, current_state : state_type := idle;
SIGNAL prevProduct : UNSIGNED(1 DOWNTO 0);

BEGIN

PROCESS(clock, reset)
BEGIN
	IF(reset = '1') THEN --soft reset is asynchoronous
		current_state <= idle;
	ELSIF(rising_edge(clock)) THEN
		IF(hard_reset = '1') THEN --hard reset is synchornous
			current_state <= idle;
		ELSE
			current_state <= next_state;
		END IF;
	END IF;
END PROCESS;

outputs: PROCESS(current_state, product) --added things to sensitivity list
BEGIN
	CASE current_state IS
		WHEN idle =>
			done <= '1'; --done until new read is initiated
		WHEN reading =>
			done <= '0';
	END CASE;
END PROCESS;

nextState: PROCESS(current_state, product, enable)
BEGIN
	CASE current_state IS
		WHEN idle =>
			IF(enable = '1') THEN
				IF (product /= prevProduct) THEN
					next_state <= reading;
				END IF;
			ELSE
				next_state <= idle;
			END IF;
		WHEN reading =>
				next_state <= idle;
	END CASE;                 
END PROCESS;

ren <= '1';
prevProduct <= product;

END Behaviour;