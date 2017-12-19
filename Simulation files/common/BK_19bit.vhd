library ieee;
use ieee.std_logic_1164.all;


ENTITY BK_19bit IS
	PORT(
		G_in: IN STD_LOGIC_VECTOR(18 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(18 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(18 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(18 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE struct OF BK_19bit IS

	SIGNAL Gin_lv2 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Pin_lv2 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL GoutBK_lv2 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL PoutBK_lv2 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Gout_lv2 : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL Pout_lv2 : STD_LOGIC_VECTOR(8 DOWNTO 0);

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

COMPONENT BK_9bit IS
	PORT(
		G_in: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		P_in: IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		G_out: OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
		P_out : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
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

	AMP_OP_11: AMPERSAND PORT MAP(
		Gin0 => G_in(10),
		Pin0 => P_in(10),
		Gin1 => G_in(11),
		Pin1 => P_in(11),
		Gout => Gin_lv2(5),
		Pout => Pin_lv2(5)
	);
	AMP_OP_12: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(5),
		Pin0 => PoutBK_lv2(5),
		Gin1 => G_in(12),
		Pin1 => P_in(12),
		Gout => Gout_lv2(5),
		Pout => Pout_lv2(5)
	);

	AMP_OP_13: AMPERSAND PORT MAP(
		Gin0 => G_in(12),
		Pin0 => P_in(12),
		Gin1 => G_in(13),
		Pin1 => P_in(13),
		Gout => Gin_lv2(6),
		Pout => Pin_lv2(6)
	);
	AMP_OP_14: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(6),
		Pin0 => PoutBK_lv2(6),
		Gin1 => G_in(14),
		Pin1 => P_in(14),
		Gout => Gout_lv2(6),
		Pout => Pout_lv2(6)
	);

	AMP_OP_15: AMPERSAND PORT MAP(
		Gin0 => G_in(14),
		Pin0 => P_in(14),
		Gin1 => G_in(15),
		Pin1 => P_in(15),
		Gout => Gin_lv2(7),
		Pout => Pin_lv2(7)
	);
	AMP_OP_16: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(7),
		Pin0 => PoutBK_lv2(7),
		Gin1 => G_in(16),
		Pin1 => P_in(16),
		Gout => Gout_lv2(7),
		Pout => Pout_lv2(7)
	);

	AMP_OP_17: AMPERSAND PORT MAP(
		Gin0 => G_in(16),
		Pin0 => P_in(16),
		Gin1 => G_in(17),
		Pin1 => P_in(17),
		Gout => Gin_lv2(8),
		Pout => Pin_lv2(8)
	);
	AMP_OP_18: AMPERSAND PORT MAP(
		Gin0 => GoutBK_lv2(8),
		Pin0 => PoutBK_lv2(8),
		Gin1 => G_in(18),
		Pin1 => P_in(18),
		Gout => Gout_lv2(8),
		Pout => Pout_lv2(8)
	);


	BK_Ndiv2: BK_9bit PORT MAP(
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
	G_out(11) <= GoutBK_lv2(5);
	P_out(11) <= PoutBK_lv2(5);
	G_out(12) <= Gout_lv2(5);
	P_out(12) <= Pout_lv2(5);
	G_out(13) <= GoutBK_lv2(6);
	P_out(13) <= PoutBK_lv2(6);
	G_out(14) <= Gout_lv2(6);
	P_out(14) <= Pout_lv2(6);
	G_out(15) <= GoutBK_lv2(7);
	P_out(15) <= PoutBK_lv2(7);
	G_out(16) <= Gout_lv2(7);
	P_out(16) <= Pout_lv2(7);
	G_out(17) <= GoutBK_lv2(8);
	P_out(17) <= PoutBK_lv2(8);
	G_out(18) <= Gout_lv2(8);
	P_out(18) <= Pout_lv2(8);

END struct;
