library ieee;
use ieee.std_logic_1164.all;


ENTITY BK_2bit IS
	PORT(
		G_in: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE struct OF BK_2bit IS

	SIGNAL Gin_lv2 : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL Pin_lv2 : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL GoutBK_lv2 : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL PoutBK_lv2 : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL Gout_lv2 : STD_LOGIC_VECTOR(0 DOWNTO 0);
	SIGNAL Pout_lv2 : STD_LOGIC_VECTOR(0 DOWNTO 0);

COMPONENT AMPERSAND IS
	PORT(
		Gin0 : IN STD_LOGIC;
		Pin0 : IN STD_LOGIC;
		Gin1 : IN STD_LOGIC;
		Pin1 : IN STD_LOGIC;
		Gout : OUT STD_LOGIC;
		Pout : OUT STD_LOGIC
	);
END COMPONENT;

BEGIN

	AMP_OP_1: AMPERSAND PORT MAP(
		Gin0 => G_in(0),
		Pin0 => P_in(0),
		Gin1 => G_in(1),
		Pin1 => P_in(1),
		Gout => Gin_lv2(0),
		Pout => Pin_lv2(0)
	);


GoutBK_lv2 <= Gin_lv2;
PoutBK_lv2 <= Pin_lv2;


	G_out(0) <= G_in(0);
	P_out(0) <= P_in(0);
	G_out(1) <= GoutBK_lv2(0);
	P_out(1) <= PoutBK_lv2(0);

END struct;
