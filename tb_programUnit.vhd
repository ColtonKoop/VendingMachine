LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY tb_programUnit IS
END tb_programUnit;

ARCHITECTURE test of tb_programUnit IS

COMPONENT programUnit IS
		PORT( clock, reset, hard_reset, set, enable : IN STD_LOGIC;
				product : IN UNSIGNED(1 DOWNTO 0);
				NDQ : IN UNSIGNED(2 DOWNTO 0);
				done, wen : OUT STD_LOGIC;
				addr_out : OUT UNSIGNED(1 DOWNTO 0);
				data_mem : OUT UNSIGNED(5 DOWNTO 0));
END COMPONENT;

SIGNAL clockSIG, resetSIG, hard_resetSIG, setSIG, enableSIG : STD_LOGIC;
SIGNAL productSIG : UNSIGNED(1 DOWNTO 0);
SIGNAL NDQSIG : UNSIGNED(2 DOWNTO 0);
SIGNAL doneSIG, wenSIG : STD_LOGIC;
SIGNAL addr_outSIG : UNSIGNED(1 DOWNTO 0);
SIGNAL data_memSIG : UNSIGNED(5 DOWNTO 0);

BEGIN
DUT : programUnit
PORT MAP(clock => clockSIG, reset => resetSIG, hard_reset => hard_resetSIG, set => setSIG, enable => enableSIG, product => productSIG, NDQ => NDQSIG, done => doneSIG, wen => wenSIG, addr_out => addr_outSIG, data_mem => data_memSIG);

--test lasts <200ns
PROCESS IS
BEGIN
	
  for i in 1 to 5 loop --5 empty clock cycles at beginning
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
	
	clockSIG <= '0'; --enable on 
	productSIG <= "00"; --product selected
	enableSIG <= '1';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0'; --enable off 
	enableSIG <= '0';
	NDQSIG <= "001"; --insert quarter
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0'; --insert quarter
	NDQSIG <= "001";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert quarter
	NDQSIG <= "001";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert dime
	NDQSIG <= "010";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert dime
	NDQSIG <= "010";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert nickel
	NDQSIG <= "100";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert nickel
	NDQSIG <= "100";
	--resetSIG <= '1'; --testing soft reset (asynchronous)
	hard_resetSIG <= '1'; --testing hard reset (synchronous)
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--insert nothing
	NDQSIG <= "000";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--set turned on
	setSIG <= '1';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';	--set turned off
	setSIG <= '0';
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