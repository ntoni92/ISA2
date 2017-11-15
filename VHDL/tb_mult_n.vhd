LIBRARY ieee;
USE ieee.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
USE ieee.math_real.all;

ENTITY tb_mult_n IS
GENERIC(N: INTEGER :=9;
	pipe_depth: INTEGER :=10);
END tb_mult_n;

ARCHITECTURE test OF tb_mult_n IS

TYPE pipe_array_type IS ARRAY(pipe_depth+2 DOWNTO 0) OF STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);

SIGNAL ck, resetn, err: STD_LOGIC;
SIGNAL in_a, in_b: SIGNED(N-1 DOWNTO 0);
SIGNAL mult_out: SIGNED(2*N-1 DOWNTO 0);
SIGNAL mult_out_std: STD_LOGIC_VECTOR(2*N-1 DOWNTO 0);
SIGNAL mult_cmp: SIGNED(2*N-1 DOWNTO 0);
SIGNAL sync_array_signal: pipe_array_type;
SIGNAL en_sync_array_signal: STD_LOGIC_VECTOR (pipe_depth+2 DOWNTO 0);
SIGNAL VIN,VOUT: STD_LOGIC;

COMPONENT Reg_n IS
		GENERIC(Nb: INTEGER :=9);
		PORT(
		CLK, RST_n, EN: IN STD_LOGIC;
		DIN: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		DOUT: OUT STD_LOGIC_VECTOR(Nb-1 DOWNTO 0)
		);
	END COMPONENT;

component mult_n IS
	GENERIC(
		Nb: INTEGER := 9
	);
	PORT(
		in_a: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		in_b: IN STD_LOGIC_VECTOR(Nb-1 DOWNTO 0);
		mult_out: OUT STD_LOGIC_VECTOR(2*Nb-1 DOWNTO 0);
		CLK: IN STD_LOGIC;
		RST_n: IN STD_LOGIC;
		enable_in: IN STD_LOGIC;
		enable_out: OUT STD_LOGIC
	);
END component;

BEGIN
DUT: mult_n GENERIC MAP(Nb => 9)
	PORT MAP(	CLK => ck, RST_n => resetn, enable_in => VIN, enable_out => VOUT,
			in_a => STD_LOGIC_VECTOR(in_a), 
			in_b => STD_LOGIC_VECTOR(in_b), 
			mult_out => mult_out_std);

in_sync_delay: FOR i IN 0 TO pipe_depth+1 GENERATE
		in_sync_delay_cell: Reg_n 
					GENERIC MAP (Nb => 2*N) 
					PORT MAP (CLK => ck, RST_n => resetn, 
							EN => en_sync_array_signal(i), 
							DIN => sync_array_signal(i), 
							DOUT => sync_array_signal(i+1));   
		enable_sync_delay_cell: Reg_n 
					GENERIC MAP (Nb => 1) 
					PORT MAP (CLK => ck, RST_n => resetn, EN => '1', 
							DIN => en_sync_array_signal(i DOWNTO i), 
							DOUT => en_sync_array_signal(i+1 DOWNTO i+1));
	END GENERATE;
			 
	mult_out <= SIGNED(mult_out_std);
	en_sync_array_signal(0) <= VIN;
	sync_array_signal(0)(2*N-1 DOWNTO N) <= STD_LOGIC_VECTOR(in_a);
	sync_array_signal(0)(N-1 DOWNTO 0) <= STD_LOGIC_VECTOR(in_b);

	reset_PROCESS: PROCESS
	BEGIN
		VIN <= '0';
		resetn <= '0';
		WAIT FOR 25 ns;
		resetn <= '1';
		WAIT FOR 10 ns;
		VIN <= '1';
		WAIT FOR 300 ns;
		VIN <= '0';
		WAIT FOR 50 ns;
		VIN <= '1';	
		WAIT FOR 600 ns;
		VIN <='0';	
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
	BEGIN
		IF ck'event and ck = '1' THEN
			IF resetn = '0' THEN
				in_a <= to_SIGNED(-2**(N-1), in_a'length);            --siccome abbiamo scelto SIGNED partiamo dal valore minimo IN complemento a due
				in_b <= to_SIGNED(-2**(N-1), in_b'length);
			ELSIF VIN='1' THEN			
				in_a <= in_a + 1;
			
				IF in_a = to_SIGNED(2**(N-1) - 1, in_a'length) THEN       --quando a arriva a fondo scala incrementa b
					in_a <= to_SIGNED(-2**(N-1), in_a'length);
					in_b <= in_b + 1;
				ELSIF in_b = to_SIGNED(2**(N-1) - 1, in_b'length) THEN    --quando b arriva a fondo scala resetta entrambi i contatori      
					in_a <= to_SIGNED(-2**(N-1), in_a'length);
					in_b <= to_SIGNED(-2**(N-1), in_b'length);
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
	mult_cmp <= signed(sync_array_signal(pipe_depth+2)(2*N-1 DOWNTO N)) * signed(sync_array_signal(pipe_depth+2)(N-1 DOWNTO 0));
	
	compare_PROCESS: PROCESS(ck)
	BEGIN
		IF ck'event and ck = '1' THEN
			IF VOUT = '1' THEN
				IF mult_cmp = mult_out THEN
					err <= '0';
				ELSE
					err <= '1';
				END IF;
			END IF;
		END IF;
	END PROCESS;
	
END test;
