LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE Ieee.numeric_std.all;

ENTITY tb_displayUnit IS
END tb_displayUnit;

ARCHITECTURE test of tb_displayUnit IS

SIGNAL clockSIG, resetSIG, hard_resetSIG, enableSIG : STD_LOGIC;
SIGNAL productSIG : UNSIGNED(1 DOWNTO 0);
SIGNAL doneSIG, renSIG : STD_LOGIC;

COMPONENT displayUnit IS
		PORT( clock, reset, hard_reset, enable : IN STD_LOGIC;
				product : IN UNSIGNED(1 DOWNTO 0);
				done, ren : OUT STD_LOGIC);
END COMPONENT;

BEGIN
DUT : displayUnit
PORT MAP(clock => clockSIG, reset => resetSIG, hard_reset => hard_resetSIG, enable => enableSIG, product => productSIG, done => doneSIG, ren => renSIG);

PROCESS IS
BEGIN

  for i in 1 to 5 loop --5 empty clock cycles at beginning
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
  	clockSIG <= '0'; --enable the unit
	enableSIG <= '1';
	productSIG <= "00";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --5 empty clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
	clockSIG <= '0'; --change product
	productSIG <= "01";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --5 empty clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
	clockSIG <= '0'; --change product
	productSIG <= "10";
	wait for 5 ns;
	clockSIG <= '1';
	wait for 5 ns;
	
  for i in 1 to 5 loop --5 empty clock cycles
    clockSIG <= '0';
    wait for 5 ns;
    clockSIG <= '1';
    wait for 5 ns;
  end loop;
  
	clockSIG <= '0'; --change product
	productSIG <= "11";
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