LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Cell_Unf_Pipe IS
	GENERIC
	(
		Nb: INTEGER := 9;
		Ord: INTEGER := 8;
		pipe_d: INTEGER := 5
	);
	PORT
	(
		CLK, RST_n: IN STD_LOGIC;
		EN_IN : IN STD_LOGIC;
		DIN: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		COEFF: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		SUM_IN: IN STD_LOGIC_VECTOR(Ord+Nb+1 DOWNTO 0);
		EN_OUT : OUT STD_LOGIC;
		SUM_OUT: OUT STD_LOGIC_VECTOR(Ord+Nb+1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE beh OF Cell_Unf_Pipe IS
	
	SIGNAL mult_out: STD_LOGIC_VECTOR(Nb+Ord DOWNTO 0);
	SIGNAL mult_ext, Sum_reg_out: STD_LOGIC_VECTOR(Nb+Ord+1 DOWNTO 0);
	
	COMPONENT adder_n IS
	GENERIC(Nb: INTEGER := 9);
	PORT
	(
		in_a: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		in_b: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		sum_out: OUT STD_LOGIC_VECTOR(Nb-1 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT mult_n IS
	GENERIC(
		Nb: INTEGER := 9;
		pipe_d: INTEGER:= 5);
	PORT(
		CLK: IN STD_LOGIC;
		RST_n: IN STD_LOGIC;
		enable_in: IN STD_LOGIC;
		in_a: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		in_b: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		enable_out: OUT STD_LOGIC;
		mult_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT pipeline IS
	GENERIC(
		Nb: INTEGER := 9;
		pipe_d: INTEGER:= 5);
	PORT(
		CLK: IN STD_LOGIC;
		RST_n: IN STD_LOGIC;
		enable_in: IN STD_LOGIC;
		DIN: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		enable_out: OUT STD_LOGIC;
		DOUT: OUT STD_LOGIC_VECTOR(Nb-1 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	
	mult: mult_n GENERIC MAP(Nb => Nb, pipe_d=> pipe_d +1)
	PORT MAP
	(	
		CLK => CLK, RST_n => RST_n,
		enable_in => EN_IN,
		in_a => DIN,
		in_b => COEFF,
		--enable_out => EN_OUT,
		mult_out => mult_out
	);
	
	mult_ext(Nb+1 DOWNTO 0) <= mult_out(Nb+Ord DOWNTO Ord-1);
	mult_ext(Nb+Ord+1 DOWNTO Nb+2) <= (OTHERS => mult_ext(Nb+1));
	
	sum_pipe: pipeline GENERIC MAP(Nb => SUM_IN'LENGTH, pipe_d => pipe_d + 1)
					PORT MAP (
							  CLK => CLK,
							  RST_n => RST_n,
							  enable_in => EN_IN,
							  DIN => SUM_IN,
							  enable_out => EN_OUT,
							  DOUT => Sum_reg_out
							  );
	
	sum: adder_n GENERIC MAP(Nb => Ord+Nb+2)
	PORT MAP
	(
		in_a => mult_ext,
		in_b => Sum_reg_out,
		sum_out => SUM_OUT
	);
	
END ARCHITECTURE;
