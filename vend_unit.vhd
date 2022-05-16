--Written by Cyrus on July 18th
--Updated by Colton on July 22nd
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY vend_unit IS
		PORT( clock, reset, enable, N, D, Q : IN STD_LOGIC;
				price_in								: IN UNSIGNED(5 DOWNTO 0);
				done                          : OUT STD_LOGIC;
				change, insert_out 				: OUT UNSIGNED(11 DOWNTO 0)); 
END vend_unit;

ARCHITECTURE structure OF vend_unit IS
	TYPE state_type IS (idle, calculating, convert);
	SIGNAL nextState, currentState : state_type := idle;
	
	SIGNAL ACC_INT_enable : STD_LOGIC := '0';
	SIGNAL ACC_INT_accum_out : UNSIGNED(5 DOWNTO 0) := "000000";
	SIGNAL C2B_MON_INT_binary : UNSIGNED(7 DOWNTO 0) := "00000000";
	SIGNAL C2B_MON_INT_bcd : UNSIGNED(11 DOWNTO 0) := "000000000000";
	SIGNAL C2B_CHG_INT_binary : UNSIGNED(7 DOWNTO 0) := "00000000";
	SIGNAL C2B_CHG_INT_bcd : UNSIGNED(11 DOWNTO 0) := "000000000000";
	
	COMPONENT accumulator IS
		PORT( clock, reset, en, N, D, Q : IN STD_LOGIC;
				accum_out : OUT UNSIGNED(5 DOWNTO 0)); 
	END COMPONENT;
	
	COMPONENT convert2bcd IS 
	PORT( binary : IN UNSIGNED(7 DOWNTO 0); 
			bcd : OUT UNSIGNED(11 DOWNTO 0)); 
	END COMPONENT;

BEGIN

	PROCESS(clock, reset)
	BEGIN
		IF(reset = '1') THEN --soft reset is asynchoronous
			currentState <= idle;
		ELSIF(rising_edge(clock)) THEN
			currentState <= nextState;
		END IF;
	END PROCESS;
	
	PROCESS(currentState, ACC_INT_accum_out, C2B_MON_INT_bcd, C2B_MON_INT_binary, C2B_CHG_INT_binary, C2B_CHG_INT_bcd, price_in)
	BEGIN
		CASE currentState IS
			WHEN idle =>
				done <= '1'; --done is 1 until new calculation is started
				change <= "000000000000";
				insert_out <= "000000000000";
				ACC_INT_enable <= '0';
				C2B_MON_INT_binary <= "00000000";
				C2B_CHG_INT_binary <= "00000000";
			
			WHEN calculating =>
			
				ACC_INT_enable <= '1';
				done <= '0';
				insert_out <= C2B_MON_INT_bcd;
				C2B_MON_INT_binary <= ACC_INT_accum_out & "00" + ACC_INT_accum_out; --how to multiply by 5 in VHDL
				
				IF(ACC_INT_accum_out <= price_in) THEN --short of item price
					change <= "000000000000";
					C2B_CHG_INT_binary <= "00000000";
				ELSE --exceeded item price		
					change <= C2B_CHG_INT_bcd;
					C2B_CHG_INT_binary <= (ACC_INT_accum_out - price_in) & "00" + (ACC_INT_accum_out - price_in);
				END IF;
				
			WHEN convert =>
				done <= '1';
				change <= C2B_CHG_INT_bcd;
				insert_out <= C2B_MON_INT_bcd;
				ACC_INT_enable <= '0';
				C2B_MON_INT_binary <= ACC_INT_accum_out & "00" + ACC_INT_accum_out; --how to multiply by 5 in VHDL
				C2B_CHG_INT_binary <= (ACC_INT_accum_out - price_in) & "00" + (ACC_INT_accum_out - price_in);
		END CASE;
	END PROCESS;
	
   PROCESS(currentState, enable, N, D, Q)
	BEGIN
		CASE currentState IS
			WHEN idle =>
				IF(enable = '1') THEN
					nextState <= calculating;
				ELSE
					nextState <= idle;
				END IF;
			WHEN calculating =>
				IF((N = '0') AND (D = '0') AND (Q = '0')) THEN
					nextState <= convert;
				ELSE
					nextState <= calculating;
				END IF;				
			WHEN convert =>
				nextState <= idle;                   
		END CASE;                 
	END PROCESS;
	
	C1: convert2bcd --for coins inserted
	PORT MAP(binary=>C2B_MON_INT_binary, bcd=>C2B_MON_INT_bcd);
	
	C2: convert2bcd --for change
	PORT MAP(binary=>C2B_CHG_INT_binary, bcd=>C2B_CHG_INT_bcd);
	
	A: accumulator
	PORT MAP(clock=>clock, reset=>reset, en=>ACC_INT_enable, N=>N, D=>D, Q=>Q, accum_out=>ACC_INT_accum_out);
			
END structure;

--possible things you can assign to inputs
--C2B_MON_INT_bcd
--C2B_CHG_INT_bcd
--ACC_INT_accum_out
--clock, reset, enable, N, D, Q
--price_in