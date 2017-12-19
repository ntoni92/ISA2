LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY FA_ARRAY IS
	GENERIC(N: INTEGER := 9);
	PORT(
		a: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		b: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		c0: IN STD_LOGIC;
		Cin: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		cout: OUT STD_LOGIC;
		sum: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)  --the last element is the last one carry
	);
END ENTITY;

ARCHITECTURE struct OF FA_ARRAY IS
	SIGNAL carry_vector: STD_LOGIC_VECTOR(N DOWNTO 0);
	SIGNAL sel: STD_LOGIC;
	SIGNAL sum_sig: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

	COMPONENT FULLADD IS
PORT (    
			Cin, x, y: IN STD_LOGIC ;
			s, Cout: OUT STD_LOGIC ) ;
	END COMPONENT;
BEGIN
	carry_vector(0) <= c0;
	carry_vector(N DOWNTO 1) <= Cin;
	Cin_conn: FOR i IN 0 TO N-1 GENERATE
		FA: FULLADD PORT MAP(	Cin => carry_vector(i),
								x => a(i),
								y => b(i),
								s => sum_sig(i));
	END GENERATE;
	
	sum <= sum_sig;
	sel <= a(N-1) XOR b(N-1);
	
	cout <= sum_sig(N-1) WHEN (sel = '1') ELSE carry_vector(N);
END ARCHITECTURE;