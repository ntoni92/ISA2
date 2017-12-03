LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;

ENTITY tb_dadda IS

END tb_dadda;

ARCHITECTURE test OF tb_dadda IS

SIGNAL in_0, in_1, in_2, in_3, in_4, in_5: signed(17 DOWNTO 0);
SIGNAL out_0, out_1: std_logic_vector(17 DOWNTO 0);
SIGNAL SUM: INTEGER;

component dadda_tree_18x6_NoExt IS
Port(
	in0: IN std_logic_vector (17 DOWNTO 0);
	in1: IN std_logic_vector (17 DOWNTO 0);
	in2: IN std_logic_vector (17 DOWNTO 0);
	in3: IN std_logic_vector (17 DOWNTO 0);
	in4: IN std_logic_vector (17 DOWNTO 0);
	in5: IN std_logic_vector (17 DOWNTO 0);
	out0: OUT std_logic_vector (17 DOWNTO 0);
	out1: OUT std_logic_vector (17 DOWNTO 0)
);
END component;

BEGIN
	
DUT: dadda_tree_18x6_NoExt	PORT MAP(in0 => STD_LOGIC_VECTOR(in_0), 
					in1 => STD_LOGIC_VECTOR(in_1), 
					in2 => STD_LOGIC_VECTOR(in_2), 
					in3 => STD_LOGIC_VECTOR(in_3), 
					in4 => STD_LOGIC_VECTOR(in_4), 
					in5 => STD_LOGIC_VECTOR(in_5),
					out0 => out_0,
					out1 => out_1);

input_process: PROCESS
	BEGIN
		in_0 <= "111111111111011001"; --3
		in_1 <= "111011000100110000"; --12
		in_2 <= "110101101100110000"; --48
		in_3 <= "110111011001000000"; --192
		in_4 <= "011111111100000000"; --768
		in_5 <= "010101110111111011"; --768
		WAIT;
	END PROCESS;

SUM <= to_integer(signed(out_0))+to_integer(signed(out_1));
	
END test;