LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY tb_mux_MBE IS
	GENERIC(Nb: INTEGER := 9);
END ENTITY;

ARCHITECTURE test OF tb_mux_MBE IS
	SIGNAL ck, resetn: STD_LOGIC;
	SIGNAL sel: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL A_unsigned: UNSIGNED(Nb-1 DOWNTO 0);
	SIGNAL A_tb: STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
	SIGNAL mux_out: STD_LOGIC_VECTOR(Nb DOWNTO 0);
	
	SIGNAL rand_num: INTEGER := 0;
	
	COMPONENT mux_MBE_Roorda IS
	GENERIC(
		Nb: INTEGER := 9
	);
	PORT(	sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			A: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
			mux_out: OUT STD_LOGIC_VECTOR(Nb DOWNTO 0)
	);
	END COMPONENT;
	
BEGIN
	
	UUT: mux_MBE_Roorda GENERIC MAP(Nb => 9)
					PORT MAP(sel => sel, A => A_tb, mux_out => mux_out);
					
	reset_PROCESS: PROCESS
	BEGIN
		resetn <= '0';
		WAIT FOR 25 ns;
		resetn <= '1';
		WAIT;
	END PROCESS;
	
	clock_PROCESS: PROCESS
	BEGIN
		ck <= '0';
		WAIT FOR 10 ns;
		ck <= '1';
		WAIT FOR 10 ns;
	END PROCESS;
	
	test_PROCESS: PROCESS(ck)
		VARIABLE seed1, seed2: POSITIVE;    -- seed values for random generator
        VARIABLE rand: REAL;    -- random real-number value in range 0 to 1.0
        VARIABLE range_of_rand : REAL := 65536.0;    -- the range of random values created will be 0 to +30.
	BEGIN
		IF ck'event AND ck='1' THEN
			IF resetn='0' THEN
				rand_num <= 0;
			ELSE
				uniform(seed1, seed2, rand);    -- generate random number between 0.0 and 1.0
				rand_num <= INTEGER(rand*range_of_rand);    -- rescale to 0..1000, convert integer part
				A_unsigned <= TO_UNSIGNED(rand_num, A_unsigned'LENGTH);
				A_tb <= STD_LOGIC_VECTOR(A_unsigned);
				sel <= A_tb(2 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;
	
END test;
