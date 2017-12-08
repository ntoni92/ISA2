LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY GP_UNIT IS
	GENERIC(N: INTEGER := 9);
	PORT(
		a: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		b: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		P_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)		
	);
END ENTITY;

ARCHITECTURE struct OF GP_UNIT IS
BEGIN
	G_out_gen: FOR i IN 0 TO N-1 GENERATE
		G_out(i) <= a(i) AND b(i);
		P_out(i) <= a(i) OR b(i);
	END GENERATE;
END struct;