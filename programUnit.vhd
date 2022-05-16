--Written by Colton on July 16th
--Important update on July 19th
--looks like 1 clock cycle was enough time to write to SRAM
--code structure based on SHORT VHDL Text page 395
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY programUnit IS
		PORT( clock, reset, hard_reset, set, enable : IN STD_LOGIC;
				product : IN UNSIGNED(1 DOWNTO 0);
				NDQ : IN UNSIGNED(2 DOWNTO 0);
				done, wen : OUT STD_LOGIC;
				addr_out : OUT UNSIGNED(1 DOWNTO 0);
				data_mem : OUT UNSIGNED(5 DOWNTO 0));
END programUnit;

ARCHITECTURE Behaviour OF programUnit IS
	TYPE state_type IS (idle, adding, mem_writing);
	SIGNAL next_state, current_state : state_type := idle;
	SIGNAL accumInternEn : STD_LOGIC := '0';
	SIGNAL accumInternRst : STD_LOGIC := '0';
	SIGNAL accumInternOut : UNSIGNED(5 DOWNTO 0) := "000000";
	
	COMPONENT accumulator IS
		PORT( clock, reset, en, N, D, Q : IN STD_LOGIC;
				accum_out : OUT UNSIGNED(5 DOWNTO 0));
	END COMPONENT;

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

outputs: PROCESS(current_state, set, product, accumInternOut) --added things to sensitivity list
BEGIN
	CASE current_state IS
		WHEN idle =>
			accumInternRst <= '1';
			accumInternEn <= '0';
			wen <= '0';
			addr_out <= product;
			data_mem <= accumInternOut;
			done <= '1';
		WHEN adding =>
			IF(set = '1') THEN
				accumInternRst <= '0';
				accumInternEn <= '0';
				wen <= '1';
				addr_out <= product;
				data_mem <= accumInternOut;
				done <= '0';
			ELSE --set is not 1 so do the accumulation
				accumInternRst <= '0';
				accumInternEn <= '1';
				wen <= '0';
				addr_out <= product;
				data_mem <= accumInternOut;
				done <= '0';
			END If;
		WHEN mem_writing =>
				accumInternRst <= '0';
				accumInternEn <= '0';
				wen <= '1';
				addr_out <= product;
				data_mem <= accumInternOut;
				done <= '0';
	END CASE;
END PROCESS;

nextState: PROCESS(current_state, enable, set)
BEGIN
	CASE current_state IS
		WHEN idle =>
			IF(enable = '1') THEN
				next_state <= adding;
			ELSE
				next_state <= idle;
			END IF;
		WHEN adding =>
			IF(set = '1') THEN
				next_state <= mem_writing;
			ELSE
				next_state <= adding;
			END IF;
		WHEN mem_writing =>
			next_state <= idle; --looks like 1 clock cycle was all it needed to write to SRAM                    
	END CASE;                 
END PROCESS;
	
	--accumulator port map
	accum: accumulator PORT MAP(clock => clock, reset => accumInternRst, en => accumInternEn, N => NDQ(2), D => NDQ(1), Q => NDQ(0), accum_out => accumInternOut);

END Behaviour;