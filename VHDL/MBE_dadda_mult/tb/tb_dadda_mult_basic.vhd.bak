LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_dadda_mult_basic IS

END tb_dadda_mult_basic;

ARCHITECTURE test OF tb_dadda_mult_basic IS

SIGNAL A,B: std_logic_vector(8 DOWNTO 0);
SIGNAL m_out: std_logic_vector(17 DOWNTO 0);

component MBE_dadda_mult_9x9 IS
	Port(	A: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		B: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		m_out: OUT std_logic_vector (17 DOWNTO 0)
	);
END component;

BEGIN
	
DUT: 	ENTITY work.MBE_dadda_mult_9x9(final)
	PORT MAP(	A => A, 
			B => B,
			m_out => m_out);

input_process: PROCESS
	BEGIN
		A <= "000100110"; -- all0
		B <= "110100111";
		WAIT FOR 100 ns;
		A <= "001110000"; -- all0
		B <= "000011000";
		WAIT FOR 100 ns;
		A <= "111100000"; -- all0
		B <= "110000000";
		WAIT FOR 100 ns;
		A <= "111110000"; -- all0
		B <= "001100000";
		WAIT FOR 100 ns;
		A <= "011000000"; -- all0
		B <= "010000100";
		WAIT FOR 100 ns;
		A <= "000000000"; -- all0
		B <= "000000000";
		WAIT;
	END PROCESS;
	
END test;