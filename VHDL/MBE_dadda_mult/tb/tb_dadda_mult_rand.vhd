LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY tb_dadda_mult_rand IS

END tb_dadda_mult_rand;

ARCHITECTURE test OF tb_dadda_mult_rand IS

SIGNAL A,B: std_logic_vector(8 DOWNTO 0);
SIGNAL m_out: std_logic_vector(17 DOWNTO 0);
SIGNAL E_out: SIGNED(17 DOWNTO 0);
SIGNAL ck, resetn: STD_LOGIC;
SIGNAL A_signed, B_signed: SIGNED(8 DOWNTO 0);
SIGNAL error: STD_LOGIC;
SIGNAL rand_num_A, rand_num_B: INTEGER := 0;
SIGNAL int_out: INTEGER;  
SIGNAL error_qty: INTEGER;

component MBE_dadda_mult_9x9 IS
	Port(	A: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		B: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		m_out: OUT std_logic_vector (17 DOWNTO 0)
	);
END component;

BEGIN
	
DUT: 	ENTITY work.MBE_dadda_mult_9x9(approxCut)
			PORT MAP(	A => A, 
					B => B,
					m_out => m_out);

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
	VARIABLE range_of_randB : REAL := -74086.0;  
	

	BEGIN
		IF ck'event AND ck='1' THEN
			IF resetn='0' THEN
				rand_num_A <= 0;
				rand_num_B <= 0;
			ELSE
				uniform(seed1, seed2, randA);    -- generate random number between 0.0 and 1.0
				rand_num_A <= INTEGER(randA*range_of_randA);    -- rescale and convert integer part
				A_signed <= TO_SIGNED(rand_num_A, A_signed'LENGTH);
				A <= STD_LOGIC_VECTOR(A_signed);
				uniform(seed3, seed4, randB);    -- generate random number between 0.0 and 1.0
				rand_num_B <= INTEGER(randB*range_of_randB);    -- rescale and convert integer part
				B_signed <= TO_SIGNED(rand_num_B, B_signed'LENGTH);
				B <= STD_LOGIC_VECTOR(B_signed);

				int_out <= to_integer(A_signed)*to_integer(B_signed);
				E_out <= to_signed(int_out,E_out'LENGTH); 
				
			END IF;
		END IF;	
		
	END PROCESS;

compare_PROCESS: PROCESS(E_out)

	BEGIN
		error <= '0';
		if to_integer(E_out) /= to_integer(signed(m_out)) then
			error <= '1';
			
		end if;
		error_qty <= abs(to_integer(E_out)-to_integer(signed(m_out)));
	END PROCESS;

	
END test;