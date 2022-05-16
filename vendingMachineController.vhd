LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY vendingMachineController IS
		PORT( clock, reset, hard_reset, start, set, N, D, Q 												  : IN STD_LOGIC;
				func, prod 												 												  : IN UNSIGNED(1 DOWNTO 0);
				change0, change1, change2, runTotal0, runTotal1, runTotal2, total0, total1, total2 : OUT UNSIGNED(3 DOWNTO 0);
				finished 																								  : OUT STD_LOGIC);
END vendingMachineController;

ARCHITECTURE Behaviour OF vendingMachineController IS

	TYPE state_type IS (idle, hardReset, program, display, vend, free);
	SIGNAL next_state, current_state : state_type := idle;
	
	--SRAM internal signals
	SIGNAL SRAM_INT_rden, SRAM_INT_wren : STD_LOGIC := '0';
	SIGNAL SRAM_INT_address             : STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
	SIGNAL SRAM_INT_data, SRAM_INT_q    : STD_LOGIC_VECTOR (5 DOWNTO 0) := "000000";
	
	--programUnit internal signals
	SIGNAL PU_INT_enable, PU_INT_done, PU_INT_wen : STD_LOGIC := '0';
	SIGNAL PU_INT_addr_out                        : UNSIGNED(1 DOWNTO 0) := "00";
	SIGNAL PU_INT_NDQ                             : UNSIGNED(2 DOWNTO 0) := "000";
	SIGNAL PU_INT_data_mem                        : UNSIGNED(5 DOWNTO 0) := "000000";
	
	--vendUnit internal signals
	SIGNAL VU_INT_enable, VU_INT_done, VU_INT_reset : STD_LOGIC := '0';
	SIGNAL VU_INT_price_in	               			: UNSIGNED(5 downto 0) := "000000";
	SIGNAL VU_INT_change, VU_INT_insert_out 			: UNSIGNED(11 DOWNTO 0) := "000000000000";
	
	--convert2bcd internal signals
	SIGNAL C2B_INT_binary : UNSIGNED(7 DOWNTO 0) := "00000000"; 
	SIGNAL C2B_INT_bcd    : UNSIGNED(11 DOWNTO 0) := "000000000000";
	
	--signal delay pipelines
	SIGNAL pip_signal0  : STD_LOGIC := '0';
	SIGNAL pip_signal1  : STD_LOGIC := '0';
	SIGNAL pip_signal2  : STD_LOGIC := '0';
	
	--previous product signal needed to know if product has changed
	SIGNAL prevProduct : UNSIGNED(1 DOWNTO 0);
	
	--dBounce signals
	SIGNAL dBounce_input, dBounce_output, dBounce_value : STD_LOGIC := '0';
	
	--clear addy
	SIGNAL clearAddy : UNSIGNED(1 DOWNTO 0) := "00";
	
	COMPONENT SRAM IS
	PORT( address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			clock   : IN STD_LOGIC := '1';
			data    : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			rden    : IN STD_LOGIC := '1';
			wren    : IN STD_LOGIC;
			q       : OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT programUnit IS
		PORT( clock, reset, hard_reset, set, enable : IN STD_LOGIC;
				product   : IN UNSIGNED(1 DOWNTO 0);
				NDQ       : IN UNSIGNED(2 DOWNTO 0);
				done, wen : OUT STD_LOGIC;
				addr_out  : OUT UNSIGNED(1 DOWNTO 0);
				data_mem  : OUT UNSIGNED(5 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT vend_unit is
		PORT( clock, reset, enable, N, D, Q : IN STD_LOGIC;
				price_in								: IN unsigned(5 downto 0);
				done                          : OUT STD_LOGIC;
				change, insert_out 				: OUT UNSIGNED(11 DOWNTO 0)); 
	END COMPONENT;
	
	COMPONENT convert2bcd IS 
		PORT( binary : IN UNSIGNED(7 DOWNTO 0); 
				bcd    : OUT UNSIGNED(11 DOWNTO 0)); 
	END COMPONENT;
	
BEGIN

	PROCESS(clock, reset)
	BEGIN
		IF(reset = '1') THEN --soft reset is asynchoronous
			current_state <= idle;
		ELSIF(rising_edge(clock)) THEN
			IF(hard_reset = '1') THEN --hard reset is synchornous
				current_state <= hardReset;
			ELSE
				current_state <= next_state;
			END IF;
		END IF;
	END PROCESS;

	outputs: PROCESS(current_state, clock) --for Moore need outputs to depend on clock edge
	BEGIN
	IF(rising_edge(clock)) THEN
		CASE current_state IS
			WHEN idle =>
				SRAM_INT_address <= std_logic_vector(prod);
				SRAM_INT_data <= "000000";
				SRAM_INT_rden <= '0';
				SRAM_INT_wren <= '0';
				PU_INT_enable <= '0';
				VU_INT_enable <= '0';
				VU_INT_price_in <= "000000";
				VU_INT_reset <= reset;
				C2B_INT_binary <= "00000000";
				change0 <= "0000";
				change1 <= "0000";
				change2 <= "0000";
				runTotal0 <= "0000";
				runTotal1 <= "0000";
				runTotal2 <= "0000";
				total0 <= "0000";
				total1 <= "0000";
				total2 <= "0000";
				finished <= '1';
				--clear pipeline delay signals
				pip_signal0 <= '0';
				pip_signal1 <= '0';
				pip_signal2 <= '0';
				clearAddy <= "00";
			WHEN hardReset => --add functionality to trigger resets on every component
				SRAM_INT_address <= std_logic_vector(clearAddy);
				SRAM_INT_data <= "000000";
				SRAM_INT_rden <= '0';
				SRAM_INT_wren <= '1';
				PU_INT_enable <= '0';
				VU_INT_enable <= '0';
				VU_INT_price_in <= "000000";
				VU_INT_reset <= '1';
				C2B_INT_binary <= "00000000";
				change0 <= "0000";
				change1 <= "0000";
				change2 <= "0000";
				runTotal0 <= "0000";
				runTotal1 <= "0000";
				runTotal2 <= "0000";
				total0 <= "0000";
				total1 <= "0000";
				total2 <= "0000";
				finished <= '0';
				pip_signal0 <= '0'; --clear delay pipeline
				pip_signal1 <= '0';
				pip_signal2 <= '0';
				IF(clearAddy <= "00") THEN
					clearAddy <= "01";
				ELSIF(clearAddy <= "01") THEN
					clearAddy <= "10";
				ELSIF(clearAddy <= "10") THEN
					clearAddy <= "11";
				ELSE--11
					clearAddy <= "00";
				END IF;
			WHEN program =>
				IF(set = '1') THEN
					SRAM_INT_address <= std_logic_vector(prod);
					SRAM_INT_data <= std_logic_vector(PU_INT_data_mem);
					SRAM_INT_rden <= '0';
					SRAM_INT_wren <= '1'; --writing
					PU_INT_enable <= '0';
					VU_INT_enable <= '0';
					VU_INT_price_in <= "000000";
					VU_INT_reset <= reset;
					C2B_INT_binary <= "00000000";
					change0 <= "0000";
					change1 <= "0000";
					change2 <= "0000";
					runTotal0 <= "0000";
					runTotal1 <= "0000";
					runTotal2 <= "0000";
					total0 <= "0000";
					total1 <= "0000";
					total2 <= "0000";
					finished <= '0';
					pip_signal0 <= '0'; --clear delay pipeline
					pip_signal1 <= '0';
					pip_signal2 <= '0';
					clearAddy <= "00";
				ELSE --set is 0
					SRAM_INT_address <= std_logic_vector(prod);
					SRAM_INT_data <= std_logic_vector(PU_INT_data_mem);
					SRAM_INT_rden <= '0';
					SRAM_INT_wren <= '0'; --not writing
					PU_INT_enable <= '1';
					VU_INT_enable <= '0';
					VU_INT_price_in <= "000000";	
					VU_INT_reset <= reset;
					C2B_INT_binary <= "00000000";
					change0 <= "0000";
					change1 <= "0000";
					change2 <= "0000";
					runTotal0 <= "0000";
					runTotal1 <= "0000";
					runTotal2 <= "0000";
					total0 <= "0000";
					total1 <= "0000";
					total2 <= "0000";
					finished <= '0';
					pip_signal0 <= '0'; --clear delay pipeline
					pip_signal1 <= '0';
					pip_signal2 <= '0';
					clearAddy <= "00";
				END IF;
			WHEN display =>
				SRAM_INT_address <= std_logic_vector(prod);
				SRAM_INT_data <= "000000";
				SRAM_INT_rden <= '1';
				SRAM_INT_wren <= '0'; --not writing
				PU_INT_enable <= '0';
				VU_INT_enable <= '0';
				VU_INT_price_in <= "000000";
				VU_INT_reset <= reset;
				C2B_INT_binary <= unsigned(SRAM_INT_q & "00") + unsigned(SRAM_INT_q); --how you multiply by 5 in VHDL
				change0 <= "0000";
				change1 <= "0000";
				change2 <= "0000";
				runTotal0 <= "0000";
				runTotal1 <= "0000";
				runTotal2 <= "0000";
				total0 <= C2B_INT_bcd(3 DOWNTO 0);
				total1 <= C2B_INT_bcd(7 DOWNTO 4);
				total2 <= C2B_INT_bcd(11 DOWNTO 8);
				finished <= '0';
				clearAddy <= "00";
				IF(prod /= prevProduct) THEN
					pip_signal0 <= '0';
					pip_signal1 <= '0';
					pip_signal2 <= '0';
					finished <= '0';
				ELSIF(SRAM_INT_rden = '1') THEN --rden = '1' lags 1 clock cycle behind state change
					pip_signal0 <= '1';
					pip_signal1 <= pip_signal0;
					pip_signal2 <= pip_signal1;
					finished <= pip_signal2;
				ELSE
					pip_signal0 <= '0';
					pip_signal1 <= '0';
					pip_signal2 <= '0';
					finished <= '0';
				END IF;
			WHEN vend =>
				SRAM_INT_address <= std_logic_vector(prod);
				SRAM_INT_data <= "000000";
				SRAM_INT_rden <= '1';
				SRAM_INT_wren <= '0';
				PU_INT_enable <= '0';
				VU_INT_price_in <= unsigned(SRAM_INT_q);
				VU_INT_reset <= reset;
				C2B_INT_binary <= "00000000";
				change0 <= VU_INT_change(3 DOWNTO 0);
				change1 <= VU_INT_change(7 DOWNTO 4);
				change2 <= VU_INT_change(11 DOWNTO 8);
				runTotal0 <= "0000";
				runTotal1 <= "0000";
				runTotal2 <= "0000";
				total0 <= "0000";
				total1 <= "0000";
				total2 <= "0000";
				finished <= VU_INT_done;
				clearAddy <= "00";
				IF(VU_INT_done = '1') THEN
					runTotal0 <= "0000";
					runTotal1 <= "0000";
					runTotal2 <= "0000";
					total0 <= VU_INT_insert_out(3 DOWNTO 0);
					total1 <= VU_INT_insert_out(7 DOWNTO 4);
					total2 <= VU_INT_insert_out(11 DOWNTO 8);
				ELSE --not done inserting coins
					runTotal0 <= VU_INT_insert_out(3 DOWNTO 0);
					runTotal1 <= VU_INT_insert_out(7 DOWNTO 4);
					runTotal2 <= VU_INT_insert_out(11 DOWNTO 8);
					total0 <= "0000";
					total1 <= "0000";
					total2 <= "0000";
				END IF;
				IF(prod /= prevProduct) THEN
					dBounce_input <= '1';
				ELSE
					dBounce_input <= '0';
				END IF;
				dBounce_value <= NOT (dBounce_value) AND dBounce_input;
				dBounce_output <= dBounce_value;
				VU_INT_enable <= dBounce_output;
			WHEN free => --basically idle with a finished signal
				SRAM_INT_address <= std_logic_vector(prod);
				SRAM_INT_data <= "000000";
				SRAM_INT_rden <= '0';
				SRAM_INT_wren <= '0';
				PU_INT_enable <= '0';
				VU_INT_enable <= '0';
				VU_INT_price_in <= "000000";
				VU_INT_reset <= reset;
				C2B_INT_binary <= "00000000";
				change0 <= "0000";
				change1 <= "0000";
				change2 <= "0000";
				runTotal0 <= "0000";
				runTotal1 <= "0000";
				runTotal2 <= "0000";
				total0 <= "0000";
				total1 <= "0000";
				total2 <= "0000";
				finished <= '1';
				pip_signal0 <= '0'; --clear delay pipeline
				pip_signal1 <= '0';
				pip_signal2 <= '0';
				clearAddy <= "00";
		END CASE;
		
		prevProduct <= prod; --needs to be placed here or it'll update instantly and not detect changes
		
	END IF;
	END PROCESS;

	nextState: PROCESS(current_state, start, func, clearAddy)
	BEGIN
		CASE current_state IS
			WHEN free =>
				IF(start = '1') THEN	
					CASE func IS
						WHEN "00" =>
							next_state <= program;
						WHEN "01" =>
							next_state <= display;
						WHEN "10" =>
							next_state <= vend;
						WHEN "11" =>
							next_state <= free;
						WHEN OTHERS =>
							next_state <= idle;
					END CASE;
				ELSE
					next_state <= idle; --free mode lasts 1 clock cycle
				END IF;
			WHEN hardReset =>
				IF(clearAddy = "11") THEN
					next_state <= idle;
				ELSE
					next_state <= current_state;
				END IF;
			WHEN OTHERS =>
				IF(start = '1') THEN	
					CASE func IS
						WHEN "00" =>
							next_state <= program;
						WHEN "01" =>
							next_state <= display;
						WHEN "10" =>
							next_state <= vend;
						WHEN "11" =>
							next_state <= free;
						WHEN OTHERS =>
							next_state <= idle;
					END CASE;
				ELSE
					next_state <= current_state; 
				END IF;
		END CASE;
END PROCESS;

PU_INT_NDQ <= N&D&Q; -- can't concatenate directly in the portmap

SRAMcomp : SRAM PORT MAP(address=>SRAM_INT_address, clock=>clock, data=>SRAM_INT_data, rden=>SRAM_INT_rden, wren=>SRAM_INT_wren, q=>SRAM_INT_q);
PUcomp : programUnit PORT MAP(clock=>clock, reset=>reset, hard_reset=>hard_reset, set=>set, enable=>PU_INT_enable, product=>prod, NDQ=>PU_INT_NDQ, done=>PU_INT_done, wen=>PU_INT_wen, addr_out=>PU_INT_addr_out, data_mem=>PU_INT_data_mem);
VUcomp : vend_unit PORT MAP(clock=>clock, reset=>VU_INT_reset, enable=>VU_INT_enable, N=>N, D=>D, Q=>Q, price_in=>VU_INT_price_in, done=>VU_INT_done, change=>VU_INT_change, insert_out=>VU_INT_insert_out);
C2Bcomp : convert2bcd PORT MAP(binary=>C2B_INT_binary, bcd=>C2B_INT_bcd);

END Behaviour;