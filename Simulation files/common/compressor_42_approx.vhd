Library IEEE;
Use ieee.std_logic_1164.all;


entity compressor_42_approx is

  port(A,B,C,D:     in  STD_LOGIC;

       SUM0, SUM1: out STD_LOGIC);

end entity;



architecture DATAFLOW of compressor_42_approx is

	Signal l0tol1: std_logic_vector (3 downto 0);

begin
	
	l0tol1(0) <= D NOR C;
	l0tol1(1) <= B NOR A;
	l0tol1(2) <= D XNOR C;
	l0tol1(3) <= B XNOR A;
	
	SUM0<= l0tol1(2) OR l0tol1(3);
	SUM1<= l0tol1(0) NOR l0tol1(1);
	
	
end DATAFLOW;