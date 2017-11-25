Library IEEE;
Use ieee.std_logic_1164.all;

entity halfadd is
  port(A,   B:     in  STD_LOGIC;
       SUM, CARRY: out STD_LOGIC);
end entity;

architecture DATAFLOW of halfadd is
begin
    SUM   <= A xor B;
    CARRY <= A and B;
end DATAFLOW;