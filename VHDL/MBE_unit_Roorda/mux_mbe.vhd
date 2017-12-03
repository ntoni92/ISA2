LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mux_mbe IS
	GENERIC(Nb: INTEGER := 9);
	PORT(	sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			mux_out: OUT STD_LOGIC_VECTOR(Nb DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE beh_mux_mbe OF mux_mbe IS	
	SIGNAL A1, A2, A1_n, A2_n: STD_LOGIC_VECTOR(Nb DOWNTO 0);
	
BEGIN
	-- generates 2A, -A, -2A starting from the input A
	A1(Nb-1 DOWNTO 0) <= A;
	A1(Nb) <= A(Nb-1);
	
	A2(0) <= '0';
	A2(Nb DOWNTO 1) <= A(Nb-1 DOWNTO 0);
	
	A1_n <= NOT(A1);
	A2_n <= NOT(A2);
	
	-- multiplexer whose selection are mapped accordingly to the LUT for MBE (Radix-4)
	WITH sel SELECT
	mux_out <= A1 WHEN "001",
				A1 WHEN "010",
				A2 WHEN "011",
				A2_n WHEN "100",
				A1_n WHEN "101",
				A1_n WHEN "110",
				(OTHERS => '0') WHEN OTHERS;
				
END beh_mux_mbe;