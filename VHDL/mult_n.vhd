LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
ENTITY mult_n IS
GENERIC(
Nb: INTEGER := 9;
pipe_d: INTEGER:= 10);
PORT(
in_a: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
in_b: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
mult_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0);
CLK: IN STD_LOGIC;
RST_n: IN STD_LOGIC;
enable_in: IN STD_LOGIC;
enable_out: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE beh_mult OF mult_n IS
	
	-- For testing multiplier alone:
	--CONSTANT pipe_depth: INTEGER := pipe_d;
	
	-- For use inside filter:
	CONSTANT pipe_depth: INTEGER := pipe_d-2;
	TYPE pipe_array_type IS ARRAY(pipe_depth DOWNTO 0) OF STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0);

	COMPONENT Reg_n IS
		GENERIC(Nb: INTEGER :=9);
		PORT(
		CLK, RST_n, EN: IN STD_LOGIC;
		DIN: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		DOUT: OUT STD_LOGIC_VECTOR(Nb-1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL mult_signed: SIGNED((2*Nb)-1 DOWNTO 0);
	SIGNAL in_a_reg_to_mult: STD_LOGIC_VECTOR (Nb-1 DOWNTO 0);
	SIGNAL in_b_reg_to_mult: STD_LOGIC_VECTOR (Nb-1 DOWNTO 0);
	SIGNAL pipe_array_signal: pipe_array_type;
	SIGNAL enable_array_signal: STD_LOGIC_VECTOR (pipe_depth DOWNTO 0); --ARRAY OF ENABLE SIGNALS
	SIGNAL enable_in_vect: STD_LOGIC_VECTOR (0 DOWNTO 0);
	SIGNAL enable_out_vect: STD_LOGIC_VECTOR (0 DOWNTO 0);
	

BEGIN
	enable_in_vect(0) <= enable_in;
	enable_out <= enable_out_vect(0); 
	a_in_reg: Reg_n GENERIC MAP (Nb => Nb)
			PORT MAP (CLK => CLK, RST_n => RST_n, EN => enable_in, 
					DIN => in_a, 
					DOUT => in_a_reg_to_mult);

	b_in_reg: Reg_n GENERIC MAP (Nb => Nb)
			PORT MAP (CLK => CLK, RST_n => RST_n, EN => enable_in, 
					DIN => in_b, 
					DOUT => in_b_reg_to_mult);

	mult_out_reg: Reg_n GENERIC MAP (Nb => 2*Nb)
				PORT MAP (CLK => CLK, RST_n => RST_n, EN => enable_array_signal(pipe_depth), 
						DIN => pipe_array_signal(pipe_depth), 
						DOUT => mult_out);

	en_in_reg: Reg_n GENERIC MAP (Nb => 1)
				PORT MAP (CLK => CLK, RST_n => RST_n, EN => '1', 
						DIN => enable_in_vect, 
						DOUT => enable_array_signal(0 DOWNTO 0));
	en_out_reg: Reg_n GENERIC MAP (Nb => 1)
				PORT MAP (CLK => CLK, RST_n => RST_n, EN => '1', 
						DIN => enable_array_signal(pipe_depth DOWNTO pipe_depth), 
						DOUT => enable_out_vect);
	
	mult_pipe: FOR i IN 0 TO pipe_depth-1 GENERATE
		mult_pipe_cell: Reg_n 
				GENERIC MAP (Nb => 2*Nb) 
				PORT MAP (CLK => CLK, RST_n => RST_n, 
						EN => enable_array_signal(i), 
						DIN => pipe_array_signal(i), 
						DOUT => pipe_array_signal(i+1));   
		mult_delay_cell: Reg_n 
				GENERIC MAP (Nb => 1) 
				PORT MAP (CLK => CLK, RST_n => RST_n, EN => '1', 
						DIN => enable_array_signal(i DOWNTO i), 
						DOUT => enable_array_signal(i+1 DOWNTO i+1));
	END GENERATE;

	multiplication: PROCESS(in_a_reg_to_mult, in_b_reg_to_mult)
			BEGIN
				mult_signed <= SIGNED(in_a_reg_to_mult) * SIGNED(in_b_reg_to_mult);
			END PROCESS;

	pipe_array_signal(0) <= STD_LOGIC_VECTOR(mult_signed);
END beh_mult;
