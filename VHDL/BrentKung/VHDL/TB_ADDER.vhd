LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY TB_ADDER IS
	GENERIC(Nb: INTEGER := 9);
END ENTITY;

ARCHITECTURE beh OF TB_ADDER IS
	
	SIGNAL ck, resetn: STD_LOGIC;
	SIGNAL A_unsigned, B_unsigned: UNSIGNED(Nb-1 DOWNTO 0);
	SIGNAL A_tb, B_tb: STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
	SIGNAL result: STD_LOGIC_VECTOR(Nb DOWNTO 0);
	
	SIGNAL rand_num_A, rand_num_B: INTEGER := 0;
	
	COMPONENT PP_ADDER IS
	GENERIC(N: INTEGER :=9);
	PORT(
		a: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		b: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		c0: IN STD_LOGIC;
		sum: OUT STD_LOGIC_VECTOR(N DOWNTO 0)
	);
	END COMPONENT;
	
BEGIN
	
	UUT: PP_ADDER 	GENERIC MAP(N => Nb)
				PORT MAP(a => A_tb, b => B_tb, c0 => '0', sum => result);
				
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
		VARIABLE seed1, seed2, seed3, seed4: POSITIVE;    -- seed values for random generator
        VARIABLE randA, randB: REAL;    -- random real-number value in range 0 to 1.0
        VARIABLE range_of_randA : REAL := 65536.0;    -- 
		VARIABLE range_of_randB : REAL := -74086.0;    --
	BEGIN
		IF ck'event AND ck='1' THEN
			IF resetn='0' THEN
				rand_num_A <= 0;
				rand_num_B <= 0;
			ELSE
				uniform(seed1, seed2, randA);    -- generate random number between 0.0 and 1.0
				rand_num_A <= INTEGER(randA*range_of_randA);    -- rescale and convert integer part
				A_unsigned <= TO_UNSIGNED(rand_num_A, A_unsigned'LENGTH);
				A_tb <= STD_LOGIC_VECTOR(A_unsigned);
				uniform(seed3, seed4, randB);    -- generate random number between 0.0 and 1.0
				rand_num_B <= INTEGER(randB*range_of_randB);    -- rescale and convert integer part
				B_unsigned <= TO_UNSIGNED(rand_num_B, B_unsigned'LENGTH);
				B_tb <= STD_LOGIC_VECTOR(B_unsigned);
			END IF;
		END IF;	
	END PROCESS;
	
END beh;