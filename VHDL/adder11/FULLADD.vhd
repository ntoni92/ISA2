Library IEEE;
Use ieee.std_logic_1164.all;

ENTITY FULLADD IS
PORT (    
			Cin, x, y: IN STD_LOGIC ;
			s, Cout: OUT STD_LOGIC ) ;
END ENTITY;

ARCHITECTURE beh OF FULLADD IS
BEGIN
s <= x XOR y XOR Cin ;
Cout <= (x AND y) OR (Cin AND x) OR (Cin AND y) ;
END beh ;