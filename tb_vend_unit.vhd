LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY tb_vend_unit IS
END tb_vend_unit;

ARCHITECTURE test of tb_vend_unit IS

COMPONENT vend_unit is
		PORT( clock, reset, enable, N, D, Q : IN STD_LOGIC;
				price_in								: IN unsigned(5 downto 0);
				done                          : OUT STD_LOGIC;
				change, insert_out 				: OUT UNSIGNED(11 DOWNTO 0)); 
END COMPONENT;

SIGNAL clockSIG, resetSIG, enableSIG, NSIG, DSIG, QSIG : STD_LOGIC;
SIGNAL price_inSIG : unsigned(5 downto 0);
SIGNAL doneSIG : STD_LOGIC;
SIGNAL changeSIG, insert_outSIG : UNSIGNED(11 DOWNTO 0);

BEGIN
DUT : vend_unit
PORT MAP(clock => clockSIG, reset => resetSIG, enable => enableSIG, N => NSIG, D => DSIG, Q => QSIG, price_in => price_inSIG, done => doneSIG, change => changeSIG, insert_out => insert_outSIG);

--test lasts < 200ns
PROCESS IS
BEGIN
	for i in 1 to 5 loop --5 empty clock cycles at beginning
		clockSIG <= '0';
		wait for 5 ns;
		clockSIG <= '1';
		wait for 5 ns;
	end loop;
	
	clockSIG <= '0'; --enable on, product price loaded
		price_inSIG <= "011001"; --$1.25
		enableSIG <= '1';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0'; --enable off, insert quarter
		QSIG <= '1';  --running total $0.25
		DSIG <= '0';
		NSIG <= '0';
		enableSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0'; --insert quarter, dime, and nickel
		QSIG <= '1';  --running total $0.65
		DSIG <= '1';
		NSIG <= '1';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert quarter
		QSIG <= '1';   --running total $0.90
		DSIG <= '0';
		NSIG <= '0';
		--resetSIG <= '1'; --testing soft reset (asynchronous)
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert quarter
		QSIG <= '1';   --running total $1.15
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert quarter
		QSIG <= '1';   --running total $1.40
		DSIG <= '0';   --change should be $0.15
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--NDQ = "000" to signal that we're done
		QSIG <= '0';   --running total $1.40
		DSIG <= '0';   --change should be $0.15
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	for i in 1 to 5 loop --5 empty clock cycles at end
		clockSIG <= '0';
		wait for 5 ns;
		clockSIG <= '1';
		wait for 5 ns;
	end loop;
	
WAIT;

END PROCESS;

END test;