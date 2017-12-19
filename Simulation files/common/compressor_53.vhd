Library IEEE;
Use ieee.std_logic_1164.all;

entity compressor_53 is
  port(A,B,C,D,CARRY_IN:     in  STD_LOGIC;
       SUM0, SUM1, CARRY_OUT: out STD_LOGIC);
end entity;

architecture DATAFLOW of compressor_53 is

	Signal f1tof2: std_logic;

	Component fulladd IS
	PORT (    Cin, x, y: IN STD_LOGIC ;
					s, Cout: OUT STD_LOGIC ) ;
	END component;
	
begin
   f1: fulladd PORT MAP (C,A,B,f1tof2,CARRY_OUT);
	f2: fulladd PORT MAP (CARRY_IN,f1tof2,D,SUM0,SUM1);
end DATAFLOW;