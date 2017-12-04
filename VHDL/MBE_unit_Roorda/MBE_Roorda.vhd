LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY MBE_Roorda IS
	GENERIC(	Nb: INTEGER := 9;
				shift: INTEGER :=2
	);
	PORT(	A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			B: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			PP_out: OUT STD_LOGIC_VECTOR((2*Nb)*((Nb+3)/2)-1 DOWNTO 0)  --instantiate number of outputs according to the number of triplets
	);
END ENTITY;

ARCHITECTURE beh_mbe OF MBE_Roorda IS

	SIGNAL B_mbe: STD_LOGIC_VECTOR(Nb+1 DOWNTO 0);
	
	COMPONENT cell_Roorda IS
	GENERIC(	Nb: INTEGER := 9;
				shift: INTEGER := 2
	);
	PORT(	A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);  --selection bit from mux, they are taken from the operand B in the top entity
			PPx_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0)
	);
	END COMPONENT;
	
BEGIN
	B_mbe(0) <= '0';
	B_mbe(Nb DOWNTO 1) <= B;
	B_mbe(Nb+1) <= B(Nb-1);
	
	Cells_gen: FOR i IN 1 TO ((Nb+1)/2) GENERATE
		Single_cell: cell_Roorda 	GENERIC MAP(Nb => Nb, shift => (i-1)*shift)
							PORT MAP(	A => A,
										sel => B_mbe(2*i DOWNTO 2*(i-1)),
										PPx_out => PP_out(i*(2*Nb)-1 DOWNTO (2*Nb)*(i-1))
							);
	END GENERATE;
	
	--Generation of the correction term to obtain 2s complement
	PP_out((2*Nb)*((Nb+3)/2)-1 DOWNTO (2*Nb)*((Nb+1)/2)+Nb+1) <= (OTHERS => '0');
	
	PP_out((2*Nb)*((Nb+1)/2)+Nb) <= '1';
	
	bj_gen: FOR i IN 0 TO (Nb/2) GENERATE
		PP_out((2*Nb)*((Nb+1)/2)+2*i) <= B_mbe(2*i+2);
	END GENERATE;
	
	O_gen: FOR i IN 0 TO ((Nb-2)/2) GENERATE
		PP_out((2*Nb)*((Nb+1)/2)+2*i+1) <= '0';
	END GENERATE;
END beh_mbe;