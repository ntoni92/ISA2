LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY TB_ADDER18 IS
GENERIC(Nb: INTEGER := 18);
END ENTITY;

ARCHITECTURE beh OF TB_ADDER18 IS
	
	SIGNAL ck, resetn, cout: STD_LOGIC;
	SIGNAL A_signed, B_signed: SIGNED(Nb-1 DOWNTO 0);
	SIGNAL A_tb, B_tb: STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
	SIGNAL result_no_OVF: STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
	SIGNAL result_OVF: STD_LOGIC_VECTOR(Nb DOWNTO 0);

	
	SIGNAL rand_num_A, rand_num_B: INTEGER := 0;
	
	COMPONENT PP_ADDER18 IS
		PORT(
			a: IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			b: IN STD_LOGIC_VECTOR(17 DOWNTO 0);
			cin: IN STD_LOGIC;
			cout: OUT STD_LOGIC;
			sum: OUT STD_LOGIC_VECTOR(17 DOWNTO 0)
		);
	END COMPONENT;
	
BEGIN
	
	DUT: PP_ADDER18	PORT MAP(a => A_tb, b => B_tb, cin => '0', cout => cout, sum => result_no_OVF);
				
	result_OVF <= cout & result_no_OVF;
				
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
        VARIABLE range_of_randA : REAL := 45725.0;    -- 
		VARIABLE range_of_randB : REAL := -74072.0;    --
	BEGIN
		IF ck'event AND ck='1' THEN
			IF resetn='0' THEN
				rand_num_A <= 0;
				rand_num_B <= 0;
			ELSE
				uniform(seed1, seed2, randA);    -- generate random number between 0.0 and 1.0
				rand_num_A <= INTEGER(randA*range_of_randA);    -- rescale and convert integer part
				A_signed <= TO_SIGNED(rand_num_A, A_signed'LENGTH);
				A_tb <= STD_LOGIC_VECTOR(A_signed);
				uniform(seed3, seed4, randB);    -- generate random number between 0.0 and 1.0
				rand_num_B <= INTEGER(randB*range_of_randB);    -- rescale and convert integer part
				B_signed <= TO_SIGNED(rand_num_B, B_signed'LENGTH);
				B_tb <= STD_LOGIC_VECTOR(B_signed);
			END IF;
		END IF;	
	END PROCESS;
	
END beh;