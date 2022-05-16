LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY tb_vendingMachineController IS
END tb_vendingMachineController;

ARCHITECTURE test of tb_vendingMachineController IS

COMPONENT vendingMachineController IS
		PORT( clock, reset, hard_reset, start, set, N, D, Q : IN STD_LOGIC;
				func, prod : IN UNSIGNED(1 DOWNTO 0);
				change0, change1, change2, runTotal0, runTotal1, runTotal2, total0, total1, total2 : OUT UNSIGNED(3 DOWNTO 0);
				finished : OUT STD_LOGIC);
END COMPONENT;

SIGNAL clockSIG, resetSIG, hard_resetSIG, startSIG, setSIG, NSIG, DSIG, QSIG : STD_LOGIC;
SIGNAL funcSIG, prodSIG : UNSIGNED(1 DOWNTO 0);
SIGNAL change0SIG, change1SIG, change2SIG, runTotal0SIG, runTotal1SIG, runTotal2SIG, total0SIG, total1SIG, total2SIG : UNSIGNED(3 DOWNTO 0);
SIGNAL finishedSIG : STD_LOGIC;

BEGIN
DUT : vendingMachineController
PORT MAP(clock => clockSIG, reset => resetSIG, hard_reset => hard_resetSIG, start => startSIG, set => setSIG, N => NSIG, D => DSIG, Q => QSIG, func => funcSIG, prod => prodSIG, change0 => change0SIG, change1 => change1SIG, change2 => change2SIG, runTotal0 => runTotal0SIG, runTotal1 => runTotal1SIG, runTotal2 => runTotal2SIG, total0 => total0SIG, total1 => total1SIG, total2 => total2SIG, finished => finishedSIG);

--test is currently <1100ns
PROCESS IS
BEGIN
  for i in 1 to 3 loop --3 empty clock cycles at beginning
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;

------------------------------PROGRAM MODE TEST------------------------------
-------PRODUCT 0-------

  	clockSIG <= '0';
		funcSIG <= "00"; --enter program mode
		startSIG <= '1';
		prodSIG <= "00"; --select product 0
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		startSIG <= '0'; --unassert start signal while not changing states
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0'; --$1.40 total was inserted
		NSIG <= '0'; --140/5 = 28
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '1'; --set this as price for product 0
		QSIG <= '0';   --no coins inserted when setting 
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '0'; --release set when not setting
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;

-------PRODUCT 1-------
	
	clockSIG <= '0';
		prodSIG <= "01"; --switch to product 1
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;  --$0.65 total was inserted
	clockSIG <= '1';--65/5 = 13
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '1'; --set this as price for product 1
		QSIG <= '0';   --no coins inserted when setting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '0'; --release set when not setting
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
-------PRODUCT 2-------
	
	clockSIG <= '0';
		prodSIG <= "10"; --switch to product 2
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;  --$1.20 total was inserted
	clockSIG <= '1';--120/5 = 24
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '1'; --set this as price for product 2
		QSIG <= '0';   --no coins inserted when setting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '0'; --release set when not setting
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	-------PRODUCT 3-------
	
	clockSIG <= '0';
		prodSIG <= "11"; --switch to product 3
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '1'; --insert nickel
	wait for 5 ns;  --$0.90 total was inserted
	clockSIG <= '1';--90/5 = 18
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '1'; --set this as price for product 3
		QSIG <= '0';   --no coins inserted when setting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		setSIG <= '0'; --release set when not setting
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;

------------------------------OPTIONAL (COMMENT IN OR OUT) HARD RESET TEST------------------------------

--	clockSIG <= '0';
--		hard_resetSIG <= '1';
--	wait for 5 ns;
--	clockSIG <= '1';
--	wait for 5 ns;
--	
--	clockSIG <= '0';
--		hard_resetSIG <= '0';
--	wait for 5 ns;
--	clockSIG <= '1';
--	wait for 5 ns;
--	
--  for i in 1 to 6 loop --wait 6 clock cycles
--    clockSIG <= '0';
--    wait for 5 ns;
--    clockSIG <= '1';
--    wait for 5 ns;
--  end loop;

------------------------------OPTIONAL (COMMENT IN OR OUT) SOFT RESET TEST------------------------------

--	clockSIG <= '0';
--		resetSIG <= '1';
--	wait for 5 ns;
--	clockSIG <= '1';
--	wait for 5 ns;
--	
--	clockSIG <= '0';
--		resetSIG <= '0';
--	wait for 5 ns;
--	clockSIG <= '1';
--	wait for 5 ns;
--	
--  for i in 1 to 6 loop --wait 6 clock cycles
--    clockSIG <= '0';
--    wait for 5 ns;
--    clockSIG <= '1';
--    wait for 5 ns;
--  end loop;
	
------------------------------DISPLAY MODE TEST------------------------------ 
	
	clockSIG <= '0';
		funcSIG <= "01"; --enter display mode
		startSIG <= '1';
		prodSIG <= "00"; --select product 0
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		startSIG <= '0'; --unassert start signal while not changing states
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --wait 6 clock cycles for output to display
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
	
	clockSIG <= '0';
		prodSIG <= "01"; --select product 1
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --wait 5 clock cycles for output to display
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
  	clockSIG <= '0';
		prodSIG <= "10"; --select product 2
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --wait 5 clock cycles for output to display
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
	clockSIG <= '0';
		prodSIG <= "11"; --select product 3
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --wait 5 clock cycles for output to display
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
------------------------------VEND MODE TEST------------------------------
-------PRODUCT 0-------

  	clockSIG <= '0';
		funcSIG <= "10"; --enter vend mode
		startSIG <= '1';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
  
	clockSIG <= '0';
		startSIG <= '0'; --unassert start signal while not changing states
		prodSIG <= "00"; --select product 0
	wait for 5 ns;      --price of product 0 is $1.15
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 4 loop --wait 4 clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
  clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;  
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0'; --$1.65 was inserted
		NSIG <= '0'; --$1.15 was price of product
	wait for 5 ns;  --change will be $0.50
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '0';   --done inserting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
  
-------PRODUCT 1-------
  
	clockSIG <= '0';
		prodSIG <= "01"; --select product 1
	wait for 5 ns;		  --price of product 1 is $0.65
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 4 loop --wait 4 clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
  clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0';
		NSIG <= '0';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '0'; --$1.00 was inserted
		NSIG <= '0'; --$0.65 was price of product
	wait for 5 ns;  --change will be $0.35
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '0';   --done inserting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
-------PRODUCT 2-------
  
	clockSIG <= '0';
		prodSIG <= "10"; --select product 2
	wait for 5 ns;      --price of product 2 is $1.20
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 4 loop --wait 4 clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;	 --$2.00 inserted
	clockSIG <= '1';--$1.20 was price of product
	wait for 5 ns;  --$0.80 is change
	
	clockSIG <= '0';
		QSIG <= '0';   --done inserting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
-------PRODUCT 3-------
  
	clockSIG <= '0';
		prodSIG <= "11"; --select product 3
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 4 loop --wait 4 clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '1'; --insert quarter
		DSIG <= '1'; --insert dime
		NSIG <= '1'; --insert nickel
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
	clockSIG <= '0';
		QSIG <= '0';
		DSIG <= '1'; --insert dime
		NSIG <= '0'; --$0.90 was inserted
	wait for 5 ns;  --$0.90 was price of product
	clockSIG <= '1';--change will be $0.00
	wait for 5 ns;  --exact change!
	
	clockSIG <= '0';
		QSIG <= '0';   --done inserting
		DSIG <= '0'; 
		NSIG <= '0'; 
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
------------------------------FREE MODE TEST------------------------------	

  for i in 1 to 4 loop --wait 4 clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
  	clockSIG <= '0';
		funcSIG <= "11"; --enter free mode
		startSIG <= '1';
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
  
	clockSIG <= '0';
		startSIG <= '0'; --unassert start signal while not changing states
		prodSIG <= "00"; 
	wait for 5 ns;      
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 3 loop --3 empty clock cycles at end
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;

WAIT;

END PROCESS;

END test;