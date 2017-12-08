LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY AMPERSAND IS
	PORT(
		Gin0 : IN STD_LOGIC;
		Pin0 : IN STD_LOGIC;
		Gin1 : IN STD_LOGIC;
		Pin1 : IN STD_LOGIC;
		Gout : OUT STD_LOGIC;
		Pout : OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE struct OF AMPERSAND IS
BEGIN
	Gout <= Gin1 OR (Pin1 AND Gin0);
	Pout <= Pin1 AND Pin0;
END struct;