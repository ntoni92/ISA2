library ieee;
use ieee.std_logic_1164.all;


ENTITY BK_4bit IS
	GENERIC(N: INTEGER := 4);
	PORT(
		G_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE struct OF BK_4bit IS

	SIGNAL Gin_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
	SIGNAL Pin_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
	SIGNAL GoutBK_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
	SIGNAL PoutBK_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
	SIGNAL Gout_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);
	SIGNAL Pout_lv2 : STD_LOGIC_VECTOR((N/2)-1 DOWNTO 0);

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

COMPONENT BK_2bit IS
	GENERIC(N: INTEGER := 2);
	PORT(
		G_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		G_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
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
	AMP_OP_2: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(0),
		Pin0 => PoutBK_lv2(0),
		Gin1 => G_in(2),
		Pin1 => P_in(2),
		Gout => Gout_lv2(0),
		Pout => Pout_lv2(0)
	);

	AMP_OP_3: AMPERSAND PORT MAP(
		Gin0 => G_in(2),
		Pin0 => P_in(2),
		Gin1 => G_in(3),
		Pin1 => P_in(3),
		Gout => Gin_lv2(1),
		Pout => Pin_lv2(1)
	);

	BK_Ndiv2: BK_2bit PORT MAP(
		G_in => Gin_lv2,
		P_in => Pin_lv2,
		G_out => GoutBK_lv2,
		P_out => PoutBK_lv2
	);


	G_out(0) <= G_in(0);
	P_out(0) <= P_in(0);
	G_out(1) <= GoutBK_lv2(0);
	P_out(1) <= PoutBK_lv2(0);
	G_out(2) <= Gout_lv2(0);
	P_out(2) <= Pout_lv2(0);
	G_out(3) <= GoutBK_lv2(1);
	P_out(3) <= PoutBK_lv2(1);

END struct;
