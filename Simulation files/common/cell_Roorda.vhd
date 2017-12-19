LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY cell_Roorda IS
	GENERIC(Nb: INTEGER := 9;
			shift: INTEGER :=2
	);
	PORT(	A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);  --selection bit from mux, they are taken from the operand B in the top entity
			PPx_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE beh_cell OF cell_Roorda IS
	SIGNAL mux_out: STD_LOGIC_VECTOR(Nb DOWNTO 0);
	--SIGNAL PPx_out: STD_LOGIC_VECTOR(2*Nb-2 DOWNTO 0);
	
	COMPONENT mux_mbe_Roorda IS
	GENERIC(Nb: INTEGER := 9);
	PORT(	sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			mux_out: OUT STD_LOGIC_VECTOR(Nb DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT shift_n_Roorda IS
	GENERIC(Nb: INTEGER := 9;
			shift: INTEGER :=2
	);
	PORT(	data_in: IN STD_LOGIC_VECTOR(Nb DOWNTO 0);
			data_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0)
	);
	END COMPONENT;
	
BEGIN
	
	LUT: mux_mbe_Roorda	GENERIC MAP(Nb => Nb)
					PORT MAP(sel => sel, A => A, mux_out => mux_out);
	shiftREG: shift_n_Roorda 	GENERIC MAP(Nb => Nb, shift => shift)
						PORT MAP(data_in => mux_out, data_out => PPx_out);
	
END beh_cell;