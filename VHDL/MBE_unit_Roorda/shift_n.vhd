LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY shift_n IS
	GENERIC(	Nb: INTEGER := 9;
				shift: INTEGER := 2
	);
	PORT(	data_in: IN STD_LOGIC_VECTOR(Nb DOWNTO 0);
			data_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE beh_shift OF shift_n IS

BEGIN
	data_out(shift-1 DOWNTO 0) <= (OTHERS => '0');
	data_out(Nb-1+shift DOWNTO shift) <= data_in(Nb-1 DOWNTO 0);
	data_out(Nb+shift) <= NOT(data_in(Nb));
	data_out(2*Nb-1 DOWNTO Nb+shift+1) <= (OTHERS => '1');
END beh_shift;