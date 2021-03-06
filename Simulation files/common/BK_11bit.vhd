library ieee;
use ieee.std_logic_1164.all;


ENTITY BK_11bit IS
	PORT(
		G_in: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE struct OF BK_11bit IS

	SIGNAL Gin_lv2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Pin_lv2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL GoutBK_lv2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL PoutBK_lv2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Gout_lv2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Pout_lv2 : STD_LOGIC_VECTOR(4 DOWNTO 0);

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

COMPONENT BK_5bit IS
	PORT(
		G_in: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
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
	AMP_OP_4: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(1),
		Pin0 => PoutBK_lv2(1),
		Gin1 => G_in(4),
		Pin1 => P_in(4),
		Gout => Gout_lv2(1),
		Pout => Pout_lv2(1)
	);

	AMP_OP_5: AMPERSAND PORT MAP(
		Gin0 => G_in(4),
		Pin0 => P_in(4),
		Gin1 => G_in(5),
		Pin1 => P_in(5),
		Gout => Gin_lv2(2),
		Pout => Pin_lv2(2)
	);
	AMP_OP_6: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(2),
		Pin0 => PoutBK_lv2(2),
		Gin1 => G_in(6),
		Pin1 => P_in(6),
		Gout => Gout_lv2(2),
		Pout => Pout_lv2(2)
	);

	AMP_OP_7: AMPERSAND PORT MAP(
		Gin0 => G_in(6),
		Pin0 => P_in(6),
		Gin1 => G_in(7),
		Pin1 => P_in(7),
		Gout => Gin_lv2(3),
		Pout => Pin_lv2(3)
	);
	AMP_OP_8: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(3),
		Pin0 => PoutBK_lv2(3),
		Gin1 => G_in(8),
		Pin1 => P_in(8),
		Gout => Gout_lv2(3),
		Pout => Pout_lv2(3)
	);

	AMP_OP_9: AMPERSAND PORT MAP(
		Gin0 => G_in(8),
		Pin0 => P_in(8),
		Gin1 => G_in(9),
		Pin1 => P_in(9),
		Gout => Gin_lv2(4),
		Pout => Pin_lv2(4)
	);
	AMP_OP_10: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(4),
		Pin0 => PoutBK_lv2(4),
		Gin1 => G_in(10),
		Pin1 => P_in(10),
		Gout => Gout_lv2(4),
		Pout => Pout_lv2(4)
	);


	BK_Ndiv2: BK_5bit PORT MAP(
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
	G_out(4) <= Gout_lv2(1);
	P_out(4) <= Pout_lv2(1);
	G_out(5) <= GoutBK_lv2(2);
	P_out(5) <= PoutBK_lv2(2);
	G_out(6) <= Gout_lv2(2);
	P_out(6) <= Pout_lv2(2);
	G_out(7) <= GoutBK_lv2(3);
	P_out(7) <= PoutBK_lv2(3);
	G_out(8) <= Gout_lv2(3);
	P_out(8) <= Pout_lv2(3);
	G_out(9) <= GoutBK_lv2(4);
	P_out(9) <= PoutBK_lv2(4);
	G_out(10) <= Gout_lv2(4);
	P_out(10) <= Pout_lv2(4);

END struct;
