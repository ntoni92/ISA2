LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY PP_ADDER IS
	GENERIC(N: INTEGER :=9);
	PORT(
		a: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		b: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		c0: IN STD_LOGIC;
		sum: OUT STD_LOGIC_VECTOR(N DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE struct OF PP_ADDER IS
	SIGNAL G_out_sig, P_out_sig: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL GBK_out_sig, PBK_out_sig: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL carry_sig: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

	COMPONENT GP_UNIT IS
		GENERIC(N: INTEGER := 9);
		PORT(
			a: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			b: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			G_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			P_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)		
		);
	END COMPONENT;
	
	COMPONENT BK_9bit IS
		GENERIC(N: INTEGER := 9);
		PORT(
			G_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			P_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			G_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			P_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT CARRY_UNIT IS
		GENERIC(N: INTEGER := 9);
		PORT(
			G: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			P: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			c0: IN STD_LOGIC;
			carry: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)	
		);
	END COMPONENT;
	
	COMPONENT FA_ARRAY IS
		GENERIC(N: INTEGER := 9);
		PORT(
			a: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			b: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			c0: IN STD_LOGIC;
			Cin: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			sum: OUT STD_LOGIC_VECTOR(N DOWNTO 0)  --the last element is the last one carry
		);
	END COMPONENT;
BEGIN
	GPunit: GP_UNIT GENERIC MAP(N => N)
					PORT MAP(	a => a,
								b => b,
								G_out => G_out_sig,
								P_out => P_out_sig);
								
	BKunit: BK_9bit GENERIC MAP(N => N)
					PORT MAP(	G_in => G_out_sig,
								P_in => P_out_sig,
								G_out => GBK_out_sig,
								P_out => PBK_out_sig);
	
	CARRYunit: CARRY_UNIT	GENERIC MAP(N => N)
							PORT MAP(	G => GBK_out_sig,
										P => PBK_out_sig,
										c0 => c0,
										carry => carry_sig);
										
	FAunit: FA_ARRAY 	GENERIC MAP(N => N)
						PORT MAP(	a => a,
									b => b,
									c0 => c0,
									Cin => carry_sig,
									sum => sum);	
END ARCHITECTURE;