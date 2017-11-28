Library IEEE;
Use ieee.std_logic_1164.all;

ENTITY FULLADD IS
PORT (    
			Cin, a, b: IN STD_LOGIC ;
			sum, Cout: OUT STD_LOGIC ) ;
END ENTITY;

ARCHITECTURE beh OF FULLADD IS
BEGIN
sum <= a XOR b XOR Cin ;
Cout <= (a AND b) OR (Cin AND b) OR (Cin AND b) ;
END beh ;