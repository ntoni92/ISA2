LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_dadda IS

END tb_dadda;

ARCHITECTURE test OF tb_dadda IS

SIGNAL in_0, in_1, in_2, in_3, in_4: signed(17 DOWNTO 0);
SIGNAL out_0, out_1: std_logic_vector(17 DOWNTO 0);
SIGNAL SUM: INTEGER;

component dadda_tree_18x5 IS
	Port(
		in0: IN std_logic_vector (17 DOWNTO 0);
		in1: IN std_logic_vector (17 DOWNTO 0);
		in2: IN std_logic_vector (17 DOWNTO 0);
		in3: IN std_logic_vector (17 DOWNTO 0);
		in4: IN std_logic_vector (17 DOWNTO 0);
		out0: OUT std_logic_vector (17 DOWNTO 0);
		out1: OUT std_logic_vector (17 DOWNTO 0)
	);
END component;

BEGIN
	
DUT: dadda_tree_18x5	PORT MAP(in0 => STD_LOGIC_VECTOR(in_0), 
				in1 => STD_LOGIC_VECTOR(in_1), 
				in2 => STD_LOGIC_VECTOR(in_2), 
				in3 => STD_LOGIC_VECTOR(in_3), 
				in4 => STD_LOGIC_VECTOR(in_4), 
				out0 => out_0,
				out1 => out_1);

input_process: PROCESS
	BEGIN
		in_0 <= "000000000000000011"; --3
		in_1 <= "000000000000001100"; --12
		in_2 <= "000000000000110000"; --48
		in_3 <= "000000000011000000"; --192
		in_4 <= "000000001100000000"; --768
		WAIT FOR 100 ns;
		in_0 <= "000000000000000111"; --7
		in_1 <= "000000000000011100"; --28
		in_2 <= "000000000001110000"; --112
		in_3 <= "000000000111000000"; --448
		in_4 <= "000000011100000000"; --1792
		WAIT FOR 100 ns;
		in_0 <= "111111111000000011"; -- -509
		in_1 <= "111111100000001100"; -- -2036
		in_2 <= "000000000000110000"; -- 48
		in_3 <= "000000000011000000"; -- 192
		in_4 <= "111111110000000000"; -- -1024
		WAIT;
	END PROCESS;

SUM <= to_integer(signed(out_0))+to_integer(signed(out_1));
	
END test;