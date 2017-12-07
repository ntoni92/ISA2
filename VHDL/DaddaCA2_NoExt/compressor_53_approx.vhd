Library IEEE;
Use ieee.std_logic_1164.all;


entity compressor_53_approx is

  port(A,B,C,D,CARRY_IN:     in  STD_LOGIC;

       SUM0, SUM1, CARRY_OUT: out STD_LOGIC);

end entity;



architecture DATAFLOW of compressor_53_approx is

	Signal l1tol2: std_logic_vector (3 downto 0);
	Signal l3: std_logic;	

begin
	
	l1tol2(0) <= C NOR D;
	l1tol2(1) <= A NOR B;
	l1tol2(2) <= C XNOR D;
	l1tol2(3) <= A XNOR B;
	CARRY_OUT <= l1tol2(0) NOR l1tol2(1);
	l3 <= l1tol2(2) NOR l1tol2(3);
	SUM0 <= l3 NOR CARRY_IN;
	SUM1 <= CARRY_IN;
	
	
end DATAFLOW;