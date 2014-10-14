-------------------------------------------------------------------------------
-- microblaze_0_bram_block_elaborate.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity microblaze_0_bram_block_elaborate is
  generic (
    C_MEMSIZE : integer;
    C_PORT_DWIDTH : integer;
    C_PORT_AWIDTH : integer;
    C_NUM_WE : integer;
    C_FAMILY : string
    );
  port (
    BRAM_Rst_A : in std_logic;
    BRAM_Clk_A : in std_logic;
    BRAM_EN_A : in std_logic;
    BRAM_WEN_A : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_A : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_A : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_A : in std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Rst_B : in std_logic;
    BRAM_Clk_B : in std_logic;
    BRAM_EN_B : in std_logic;
    BRAM_WEN_B : in std_logic_vector(0 to C_NUM_WE-1);
    BRAM_Addr_B : in std_logic_vector(0 to C_PORT_AWIDTH-1);
    BRAM_Din_B : out std_logic_vector(0 to C_PORT_DWIDTH-1);
    BRAM_Dout_B : in std_logic_vector(0 to C_PORT_DWIDTH-1)
  );

  attribute keep_hierarchy : STRING;
  attribute keep_hierarchy of microblaze_0_bram_block_elaborate : entity is "yes";

end microblaze_0_bram_block_elaborate;

architecture STRUCTURE of microblaze_0_bram_block_elaborate is

  component RAMB16BWER is
    generic (
      INIT_FILE : string;
      DATA_WIDTH_A : integer;
      DATA_WIDTH_B : integer
    );
    port (
      ADDRA : in std_logic_vector(13 downto 0);
      CLKA : in std_logic;
      DIA : in std_logic_vector(31 downto 0);
      DIPA : in std_logic_vector(3 downto 0);
      DOA : out std_logic_vector(31 downto 0);
      DOPA : out std_logic_vector(3 downto 0);
      ENA : in std_logic;
      REGCEA : in std_logic;
      RSTA : in std_logic;
      WEA : in std_logic_vector(3 downto 0);
      ADDRB : in std_logic_vector(13 downto 0);
      CLKB : in std_logic;
      DIB : in std_logic_vector(31 downto 0);
      DIPB : in std_logic_vector(3 downto 0);
      DOB : out std_logic_vector(31 downto 0);
      DOPB : out std_logic_vector(3 downto 0);
      ENB : in std_logic;
      REGCEB : in std_logic;
      RSTB : in std_logic;
      WEB : in std_logic_vector(3 downto 0)
    );
  end component;

  attribute BMM_INFO : STRING;

  attribute BMM_INFO of ramb16bwer_0: label is " ";
  attribute BMM_INFO of ramb16bwer_1: label is " ";
  attribute BMM_INFO of ramb16bwer_2: label is " ";
  attribute BMM_INFO of ramb16bwer_3: label is " ";
  attribute BMM_INFO of ramb16bwer_4: label is " ";
  attribute BMM_INFO of ramb16bwer_5: label is " ";
  attribute BMM_INFO of ramb16bwer_6: label is " ";
  attribute BMM_INFO of ramb16bwer_7: label is " ";
  attribute BMM_INFO of ramb16bwer_8: label is " ";
  attribute BMM_INFO of ramb16bwer_9: label is " ";
  attribute BMM_INFO of ramb16bwer_10: label is " ";
  attribute BMM_INFO of ramb16bwer_11: label is " ";
  attribute BMM_INFO of ramb16bwer_12: label is " ";
  attribute BMM_INFO of ramb16bwer_13: label is " ";
  attribute BMM_INFO of ramb16bwer_14: label is " ";
  attribute BMM_INFO of ramb16bwer_15: label is " ";
  -- Internal signals

  signal net_gnd0 : std_logic;
  signal net_gnd4 : std_logic_vector(3 downto 0);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 29);
  signal pgassign3 : std_logic_vector(13 downto 0);
  signal pgassign4 : std_logic_vector(31 downto 0);
  signal pgassign5 : std_logic_vector(31 downto 0);
  signal pgassign6 : std_logic_vector(3 downto 0);
  signal pgassign7 : std_logic_vector(13 downto 0);
  signal pgassign8 : std_logic_vector(31 downto 0);
  signal pgassign9 : std_logic_vector(31 downto 0);
  signal pgassign10 : std_logic_vector(3 downto 0);
  signal pgassign11 : std_logic_vector(13 downto 0);
  signal pgassign12 : std_logic_vector(31 downto 0);
  signal pgassign13 : std_logic_vector(31 downto 0);
  signal pgassign14 : std_logic_vector(3 downto 0);
  signal pgassign15 : std_logic_vector(13 downto 0);
  signal pgassign16 : std_logic_vector(31 downto 0);
  signal pgassign17 : std_logic_vector(31 downto 0);
  signal pgassign18 : std_logic_vector(3 downto 0);
  signal pgassign19 : std_logic_vector(13 downto 0);
  signal pgassign20 : std_logic_vector(31 downto 0);
  signal pgassign21 : std_logic_vector(31 downto 0);
  signal pgassign22 : std_logic_vector(3 downto 0);
  signal pgassign23 : std_logic_vector(13 downto 0);
  signal pgassign24 : std_logic_vector(31 downto 0);
  signal pgassign25 : std_logic_vector(31 downto 0);
  signal pgassign26 : std_logic_vector(3 downto 0);
  signal pgassign27 : std_logic_vector(13 downto 0);
  signal pgassign28 : std_logic_vector(31 downto 0);
  signal pgassign29 : std_logic_vector(31 downto 0);
  signal pgassign30 : std_logic_vector(3 downto 0);
  signal pgassign31 : std_logic_vector(13 downto 0);
  signal pgassign32 : std_logic_vector(31 downto 0);
  signal pgassign33 : std_logic_vector(31 downto 0);
  signal pgassign34 : std_logic_vector(3 downto 0);
  signal pgassign35 : std_logic_vector(13 downto 0);
  signal pgassign36 : std_logic_vector(31 downto 0);
  signal pgassign37 : std_logic_vector(31 downto 0);
  signal pgassign38 : std_logic_vector(3 downto 0);
  signal pgassign39 : std_logic_vector(13 downto 0);
  signal pgassign40 : std_logic_vector(31 downto 0);
  signal pgassign41 : std_logic_vector(31 downto 0);
  signal pgassign42 : std_logic_vector(3 downto 0);
  signal pgassign43 : std_logic_vector(13 downto 0);
  signal pgassign44 : std_logic_vector(31 downto 0);
  signal pgassign45 : std_logic_vector(31 downto 0);
  signal pgassign46 : std_logic_vector(3 downto 0);
  signal pgassign47 : std_logic_vector(13 downto 0);
  signal pgassign48 : std_logic_vector(31 downto 0);
  signal pgassign49 : std_logic_vector(31 downto 0);
  signal pgassign50 : std_logic_vector(3 downto 0);
  signal pgassign51 : std_logic_vector(13 downto 0);
  signal pgassign52 : std_logic_vector(31 downto 0);
  signal pgassign53 : std_logic_vector(31 downto 0);
  signal pgassign54 : std_logic_vector(3 downto 0);
  signal pgassign55 : std_logic_vector(13 downto 0);
  signal pgassign56 : std_logic_vector(31 downto 0);
  signal pgassign57 : std_logic_vector(31 downto 0);
  signal pgassign58 : std_logic_vector(3 downto 0);
  signal pgassign59 : std_logic_vector(13 downto 0);
  signal pgassign60 : std_logic_vector(31 downto 0);
  signal pgassign61 : std_logic_vector(31 downto 0);
  signal pgassign62 : std_logic_vector(3 downto 0);
  signal pgassign63 : std_logic_vector(13 downto 0);
  signal pgassign64 : std_logic_vector(31 downto 0);
  signal pgassign65 : std_logic_vector(31 downto 0);
  signal pgassign66 : std_logic_vector(3 downto 0);
  signal pgassign67 : std_logic_vector(13 downto 0);
  signal pgassign68 : std_logic_vector(31 downto 0);
  signal pgassign69 : std_logic_vector(31 downto 0);
  signal pgassign70 : std_logic_vector(3 downto 0);
  signal pgassign71 : std_logic_vector(13 downto 0);
  signal pgassign72 : std_logic_vector(31 downto 0);
  signal pgassign73 : std_logic_vector(31 downto 0);
  signal pgassign74 : std_logic_vector(3 downto 0);
  signal pgassign75 : std_logic_vector(13 downto 0);
  signal pgassign76 : std_logic_vector(31 downto 0);
  signal pgassign77 : std_logic_vector(31 downto 0);
  signal pgassign78 : std_logic_vector(3 downto 0);
  signal pgassign79 : std_logic_vector(13 downto 0);
  signal pgassign80 : std_logic_vector(31 downto 0);
  signal pgassign81 : std_logic_vector(31 downto 0);
  signal pgassign82 : std_logic_vector(3 downto 0);
  signal pgassign83 : std_logic_vector(13 downto 0);
  signal pgassign84 : std_logic_vector(31 downto 0);
  signal pgassign85 : std_logic_vector(31 downto 0);
  signal pgassign86 : std_logic_vector(3 downto 0);
  signal pgassign87 : std_logic_vector(13 downto 0);
  signal pgassign88 : std_logic_vector(31 downto 0);
  signal pgassign89 : std_logic_vector(31 downto 0);
  signal pgassign90 : std_logic_vector(3 downto 0);
  signal pgassign91 : std_logic_vector(13 downto 0);
  signal pgassign92 : std_logic_vector(31 downto 0);
  signal pgassign93 : std_logic_vector(31 downto 0);
  signal pgassign94 : std_logic_vector(3 downto 0);
  signal pgassign95 : std_logic_vector(13 downto 0);
  signal pgassign96 : std_logic_vector(31 downto 0);
  signal pgassign97 : std_logic_vector(31 downto 0);
  signal pgassign98 : std_logic_vector(3 downto 0);
  signal pgassign99 : std_logic_vector(13 downto 0);
  signal pgassign100 : std_logic_vector(31 downto 0);
  signal pgassign101 : std_logic_vector(31 downto 0);
  signal pgassign102 : std_logic_vector(3 downto 0);
  signal pgassign103 : std_logic_vector(13 downto 0);
  signal pgassign104 : std_logic_vector(31 downto 0);
  signal pgassign105 : std_logic_vector(31 downto 0);
  signal pgassign106 : std_logic_vector(3 downto 0);
  signal pgassign107 : std_logic_vector(13 downto 0);
  signal pgassign108 : std_logic_vector(31 downto 0);
  signal pgassign109 : std_logic_vector(31 downto 0);
  signal pgassign110 : std_logic_vector(3 downto 0);
  signal pgassign111 : std_logic_vector(13 downto 0);
  signal pgassign112 : std_logic_vector(31 downto 0);
  signal pgassign113 : std_logic_vector(31 downto 0);
  signal pgassign114 : std_logic_vector(3 downto 0);
  signal pgassign115 : std_logic_vector(13 downto 0);
  signal pgassign116 : std_logic_vector(31 downto 0);
  signal pgassign117 : std_logic_vector(31 downto 0);
  signal pgassign118 : std_logic_vector(3 downto 0);
  signal pgassign119 : std_logic_vector(13 downto 0);
  signal pgassign120 : std_logic_vector(31 downto 0);
  signal pgassign121 : std_logic_vector(31 downto 0);
  signal pgassign122 : std_logic_vector(3 downto 0);
  signal pgassign123 : std_logic_vector(13 downto 0);
  signal pgassign124 : std_logic_vector(31 downto 0);
  signal pgassign125 : std_logic_vector(31 downto 0);
  signal pgassign126 : std_logic_vector(3 downto 0);
  signal pgassign127 : std_logic_vector(13 downto 0);
  signal pgassign128 : std_logic_vector(31 downto 0);
  signal pgassign129 : std_logic_vector(31 downto 0);
  signal pgassign130 : std_logic_vector(3 downto 0);

begin

  -- Internal assignments

  pgassign1(0 to 0) <= B"0";
  pgassign2(0 to 29) <= B"000000000000000000000000000000";
  pgassign3(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign3(0 downto 0) <= B"0";
  pgassign4(31 downto 2) <= B"000000000000000000000000000000";
  pgassign4(1 downto 0) <= BRAM_Dout_A(0 to 1);
  BRAM_Din_A(0 to 1) <= pgassign5(1 downto 0);
  pgassign6(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign6(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign6(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign6(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign7(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign7(0 downto 0) <= B"0";
  pgassign8(31 downto 2) <= B"000000000000000000000000000000";
  pgassign8(1 downto 0) <= BRAM_Dout_B(0 to 1);
  BRAM_Din_B(0 to 1) <= pgassign9(1 downto 0);
  pgassign10(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign10(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign10(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign10(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign11(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign11(0 downto 0) <= B"0";
  pgassign12(31 downto 2) <= B"000000000000000000000000000000";
  pgassign12(1 downto 0) <= BRAM_Dout_A(2 to 3);
  BRAM_Din_A(2 to 3) <= pgassign13(1 downto 0);
  pgassign14(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign14(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign14(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign14(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign15(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign15(0 downto 0) <= B"0";
  pgassign16(31 downto 2) <= B"000000000000000000000000000000";
  pgassign16(1 downto 0) <= BRAM_Dout_B(2 to 3);
  BRAM_Din_B(2 to 3) <= pgassign17(1 downto 0);
  pgassign18(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign18(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign18(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign18(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign19(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign19(0 downto 0) <= B"0";
  pgassign20(31 downto 2) <= B"000000000000000000000000000000";
  pgassign20(1 downto 0) <= BRAM_Dout_A(4 to 5);
  BRAM_Din_A(4 to 5) <= pgassign21(1 downto 0);
  pgassign22(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign22(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign22(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign22(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign23(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign23(0 downto 0) <= B"0";
  pgassign24(31 downto 2) <= B"000000000000000000000000000000";
  pgassign24(1 downto 0) <= BRAM_Dout_B(4 to 5);
  BRAM_Din_B(4 to 5) <= pgassign25(1 downto 0);
  pgassign26(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign26(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign26(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign26(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign27(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign27(0 downto 0) <= B"0";
  pgassign28(31 downto 2) <= B"000000000000000000000000000000";
  pgassign28(1 downto 0) <= BRAM_Dout_A(6 to 7);
  BRAM_Din_A(6 to 7) <= pgassign29(1 downto 0);
  pgassign30(3 downto 3) <= BRAM_WEN_A(0 to 0);
  pgassign30(2 downto 2) <= BRAM_WEN_A(0 to 0);
  pgassign30(1 downto 1) <= BRAM_WEN_A(0 to 0);
  pgassign30(0 downto 0) <= BRAM_WEN_A(0 to 0);
  pgassign31(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign31(0 downto 0) <= B"0";
  pgassign32(31 downto 2) <= B"000000000000000000000000000000";
  pgassign32(1 downto 0) <= BRAM_Dout_B(6 to 7);
  BRAM_Din_B(6 to 7) <= pgassign33(1 downto 0);
  pgassign34(3 downto 3) <= BRAM_WEN_B(0 to 0);
  pgassign34(2 downto 2) <= BRAM_WEN_B(0 to 0);
  pgassign34(1 downto 1) <= BRAM_WEN_B(0 to 0);
  pgassign34(0 downto 0) <= BRAM_WEN_B(0 to 0);
  pgassign35(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign35(0 downto 0) <= B"0";
  pgassign36(31 downto 2) <= B"000000000000000000000000000000";
  pgassign36(1 downto 0) <= BRAM_Dout_A(8 to 9);
  BRAM_Din_A(8 to 9) <= pgassign37(1 downto 0);
  pgassign38(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign38(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign38(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign38(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign39(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign39(0 downto 0) <= B"0";
  pgassign40(31 downto 2) <= B"000000000000000000000000000000";
  pgassign40(1 downto 0) <= BRAM_Dout_B(8 to 9);
  BRAM_Din_B(8 to 9) <= pgassign41(1 downto 0);
  pgassign42(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign42(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign42(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign42(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign43(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign43(0 downto 0) <= B"0";
  pgassign44(31 downto 2) <= B"000000000000000000000000000000";
  pgassign44(1 downto 0) <= BRAM_Dout_A(10 to 11);
  BRAM_Din_A(10 to 11) <= pgassign45(1 downto 0);
  pgassign46(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign46(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign46(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign46(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign47(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign47(0 downto 0) <= B"0";
  pgassign48(31 downto 2) <= B"000000000000000000000000000000";
  pgassign48(1 downto 0) <= BRAM_Dout_B(10 to 11);
  BRAM_Din_B(10 to 11) <= pgassign49(1 downto 0);
  pgassign50(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign50(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign50(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign50(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign51(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign51(0 downto 0) <= B"0";
  pgassign52(31 downto 2) <= B"000000000000000000000000000000";
  pgassign52(1 downto 0) <= BRAM_Dout_A(12 to 13);
  BRAM_Din_A(12 to 13) <= pgassign53(1 downto 0);
  pgassign54(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign54(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign54(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign54(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign55(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign55(0 downto 0) <= B"0";
  pgassign56(31 downto 2) <= B"000000000000000000000000000000";
  pgassign56(1 downto 0) <= BRAM_Dout_B(12 to 13);
  BRAM_Din_B(12 to 13) <= pgassign57(1 downto 0);
  pgassign58(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign58(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign58(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign58(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign59(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign59(0 downto 0) <= B"0";
  pgassign60(31 downto 2) <= B"000000000000000000000000000000";
  pgassign60(1 downto 0) <= BRAM_Dout_A(14 to 15);
  BRAM_Din_A(14 to 15) <= pgassign61(1 downto 0);
  pgassign62(3 downto 3) <= BRAM_WEN_A(1 to 1);
  pgassign62(2 downto 2) <= BRAM_WEN_A(1 to 1);
  pgassign62(1 downto 1) <= BRAM_WEN_A(1 to 1);
  pgassign62(0 downto 0) <= BRAM_WEN_A(1 to 1);
  pgassign63(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign63(0 downto 0) <= B"0";
  pgassign64(31 downto 2) <= B"000000000000000000000000000000";
  pgassign64(1 downto 0) <= BRAM_Dout_B(14 to 15);
  BRAM_Din_B(14 to 15) <= pgassign65(1 downto 0);
  pgassign66(3 downto 3) <= BRAM_WEN_B(1 to 1);
  pgassign66(2 downto 2) <= BRAM_WEN_B(1 to 1);
  pgassign66(1 downto 1) <= BRAM_WEN_B(1 to 1);
  pgassign66(0 downto 0) <= BRAM_WEN_B(1 to 1);
  pgassign67(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign67(0 downto 0) <= B"0";
  pgassign68(31 downto 2) <= B"000000000000000000000000000000";
  pgassign68(1 downto 0) <= BRAM_Dout_A(16 to 17);
  BRAM_Din_A(16 to 17) <= pgassign69(1 downto 0);
  pgassign70(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign70(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign70(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign70(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign71(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign71(0 downto 0) <= B"0";
  pgassign72(31 downto 2) <= B"000000000000000000000000000000";
  pgassign72(1 downto 0) <= BRAM_Dout_B(16 to 17);
  BRAM_Din_B(16 to 17) <= pgassign73(1 downto 0);
  pgassign74(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign74(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign74(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign74(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign75(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign75(0 downto 0) <= B"0";
  pgassign76(31 downto 2) <= B"000000000000000000000000000000";
  pgassign76(1 downto 0) <= BRAM_Dout_A(18 to 19);
  BRAM_Din_A(18 to 19) <= pgassign77(1 downto 0);
  pgassign78(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign78(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign78(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign78(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign79(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign79(0 downto 0) <= B"0";
  pgassign80(31 downto 2) <= B"000000000000000000000000000000";
  pgassign80(1 downto 0) <= BRAM_Dout_B(18 to 19);
  BRAM_Din_B(18 to 19) <= pgassign81(1 downto 0);
  pgassign82(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign82(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign82(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign82(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign83(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign83(0 downto 0) <= B"0";
  pgassign84(31 downto 2) <= B"000000000000000000000000000000";
  pgassign84(1 downto 0) <= BRAM_Dout_A(20 to 21);
  BRAM_Din_A(20 to 21) <= pgassign85(1 downto 0);
  pgassign86(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign86(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign86(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign86(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign87(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign87(0 downto 0) <= B"0";
  pgassign88(31 downto 2) <= B"000000000000000000000000000000";
  pgassign88(1 downto 0) <= BRAM_Dout_B(20 to 21);
  BRAM_Din_B(20 to 21) <= pgassign89(1 downto 0);
  pgassign90(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign90(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign90(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign90(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign91(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign91(0 downto 0) <= B"0";
  pgassign92(31 downto 2) <= B"000000000000000000000000000000";
  pgassign92(1 downto 0) <= BRAM_Dout_A(22 to 23);
  BRAM_Din_A(22 to 23) <= pgassign93(1 downto 0);
  pgassign94(3 downto 3) <= BRAM_WEN_A(2 to 2);
  pgassign94(2 downto 2) <= BRAM_WEN_A(2 to 2);
  pgassign94(1 downto 1) <= BRAM_WEN_A(2 to 2);
  pgassign94(0 downto 0) <= BRAM_WEN_A(2 to 2);
  pgassign95(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign95(0 downto 0) <= B"0";
  pgassign96(31 downto 2) <= B"000000000000000000000000000000";
  pgassign96(1 downto 0) <= BRAM_Dout_B(22 to 23);
  BRAM_Din_B(22 to 23) <= pgassign97(1 downto 0);
  pgassign98(3 downto 3) <= BRAM_WEN_B(2 to 2);
  pgassign98(2 downto 2) <= BRAM_WEN_B(2 to 2);
  pgassign98(1 downto 1) <= BRAM_WEN_B(2 to 2);
  pgassign98(0 downto 0) <= BRAM_WEN_B(2 to 2);
  pgassign99(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign99(0 downto 0) <= B"0";
  pgassign100(31 downto 2) <= B"000000000000000000000000000000";
  pgassign100(1 downto 0) <= BRAM_Dout_A(24 to 25);
  BRAM_Din_A(24 to 25) <= pgassign101(1 downto 0);
  pgassign102(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign102(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign102(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign102(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign103(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign103(0 downto 0) <= B"0";
  pgassign104(31 downto 2) <= B"000000000000000000000000000000";
  pgassign104(1 downto 0) <= BRAM_Dout_B(24 to 25);
  BRAM_Din_B(24 to 25) <= pgassign105(1 downto 0);
  pgassign106(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign106(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign106(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign106(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign107(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign107(0 downto 0) <= B"0";
  pgassign108(31 downto 2) <= B"000000000000000000000000000000";
  pgassign108(1 downto 0) <= BRAM_Dout_A(26 to 27);
  BRAM_Din_A(26 to 27) <= pgassign109(1 downto 0);
  pgassign110(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign110(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign110(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign110(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign111(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign111(0 downto 0) <= B"0";
  pgassign112(31 downto 2) <= B"000000000000000000000000000000";
  pgassign112(1 downto 0) <= BRAM_Dout_B(26 to 27);
  BRAM_Din_B(26 to 27) <= pgassign113(1 downto 0);
  pgassign114(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign114(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign114(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign114(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign115(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign115(0 downto 0) <= B"0";
  pgassign116(31 downto 2) <= B"000000000000000000000000000000";
  pgassign116(1 downto 0) <= BRAM_Dout_A(28 to 29);
  BRAM_Din_A(28 to 29) <= pgassign117(1 downto 0);
  pgassign118(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign118(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign118(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign118(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign119(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign119(0 downto 0) <= B"0";
  pgassign120(31 downto 2) <= B"000000000000000000000000000000";
  pgassign120(1 downto 0) <= BRAM_Dout_B(28 to 29);
  BRAM_Din_B(28 to 29) <= pgassign121(1 downto 0);
  pgassign122(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign122(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign122(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign122(0 downto 0) <= BRAM_WEN_B(3 to 3);
  pgassign123(13 downto 1) <= BRAM_Addr_A(17 to 29);
  pgassign123(0 downto 0) <= B"0";
  pgassign124(31 downto 2) <= B"000000000000000000000000000000";
  pgassign124(1 downto 0) <= BRAM_Dout_A(30 to 31);
  BRAM_Din_A(30 to 31) <= pgassign125(1 downto 0);
  pgassign126(3 downto 3) <= BRAM_WEN_A(3 to 3);
  pgassign126(2 downto 2) <= BRAM_WEN_A(3 to 3);
  pgassign126(1 downto 1) <= BRAM_WEN_A(3 to 3);
  pgassign126(0 downto 0) <= BRAM_WEN_A(3 to 3);
  pgassign127(13 downto 1) <= BRAM_Addr_B(17 to 29);
  pgassign127(0 downto 0) <= B"0";
  pgassign128(31 downto 2) <= B"000000000000000000000000000000";
  pgassign128(1 downto 0) <= BRAM_Dout_B(30 to 31);
  BRAM_Din_B(30 to 31) <= pgassign129(1 downto 0);
  pgassign130(3 downto 3) <= BRAM_WEN_B(3 to 3);
  pgassign130(2 downto 2) <= BRAM_WEN_B(3 to 3);
  pgassign130(1 downto 1) <= BRAM_WEN_B(3 to 3);
  pgassign130(0 downto 0) <= BRAM_WEN_B(3 to 3);
  net_gnd0 <= '0';
  net_gnd4(3 downto 0) <= B"0000";

  ramb16bwer_0 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_0.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign3,
      CLKA => BRAM_Clk_A,
      DIA => pgassign4,
      DIPA => net_gnd4,
      DOA => pgassign5,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign6,
      ADDRB => pgassign7,
      CLKB => BRAM_Clk_B,
      DIB => pgassign8,
      DIPB => net_gnd4,
      DOB => pgassign9,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign10
    );

  ramb16bwer_1 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_1.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign11,
      CLKA => BRAM_Clk_A,
      DIA => pgassign12,
      DIPA => net_gnd4,
      DOA => pgassign13,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign14,
      ADDRB => pgassign15,
      CLKB => BRAM_Clk_B,
      DIB => pgassign16,
      DIPB => net_gnd4,
      DOB => pgassign17,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign18
    );

  ramb16bwer_2 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_2.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign19,
      CLKA => BRAM_Clk_A,
      DIA => pgassign20,
      DIPA => net_gnd4,
      DOA => pgassign21,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign22,
      ADDRB => pgassign23,
      CLKB => BRAM_Clk_B,
      DIB => pgassign24,
      DIPB => net_gnd4,
      DOB => pgassign25,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign26
    );

  ramb16bwer_3 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_3.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign27,
      CLKA => BRAM_Clk_A,
      DIA => pgassign28,
      DIPA => net_gnd4,
      DOA => pgassign29,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign30,
      ADDRB => pgassign31,
      CLKB => BRAM_Clk_B,
      DIB => pgassign32,
      DIPB => net_gnd4,
      DOB => pgassign33,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign34
    );

  ramb16bwer_4 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_4.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign35,
      CLKA => BRAM_Clk_A,
      DIA => pgassign36,
      DIPA => net_gnd4,
      DOA => pgassign37,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign38,
      ADDRB => pgassign39,
      CLKB => BRAM_Clk_B,
      DIB => pgassign40,
      DIPB => net_gnd4,
      DOB => pgassign41,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign42
    );

  ramb16bwer_5 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_5.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign43,
      CLKA => BRAM_Clk_A,
      DIA => pgassign44,
      DIPA => net_gnd4,
      DOA => pgassign45,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign46,
      ADDRB => pgassign47,
      CLKB => BRAM_Clk_B,
      DIB => pgassign48,
      DIPB => net_gnd4,
      DOB => pgassign49,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign50
    );

  ramb16bwer_6 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_6.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign51,
      CLKA => BRAM_Clk_A,
      DIA => pgassign52,
      DIPA => net_gnd4,
      DOA => pgassign53,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign54,
      ADDRB => pgassign55,
      CLKB => BRAM_Clk_B,
      DIB => pgassign56,
      DIPB => net_gnd4,
      DOB => pgassign57,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign58
    );

  ramb16bwer_7 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_7.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign59,
      CLKA => BRAM_Clk_A,
      DIA => pgassign60,
      DIPA => net_gnd4,
      DOA => pgassign61,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign62,
      ADDRB => pgassign63,
      CLKB => BRAM_Clk_B,
      DIB => pgassign64,
      DIPB => net_gnd4,
      DOB => pgassign65,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign66
    );

  ramb16bwer_8 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_8.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign67,
      CLKA => BRAM_Clk_A,
      DIA => pgassign68,
      DIPA => net_gnd4,
      DOA => pgassign69,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign70,
      ADDRB => pgassign71,
      CLKB => BRAM_Clk_B,
      DIB => pgassign72,
      DIPB => net_gnd4,
      DOB => pgassign73,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign74
    );

  ramb16bwer_9 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_9.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign75,
      CLKA => BRAM_Clk_A,
      DIA => pgassign76,
      DIPA => net_gnd4,
      DOA => pgassign77,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign78,
      ADDRB => pgassign79,
      CLKB => BRAM_Clk_B,
      DIB => pgassign80,
      DIPB => net_gnd4,
      DOB => pgassign81,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign82
    );

  ramb16bwer_10 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_10.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign83,
      CLKA => BRAM_Clk_A,
      DIA => pgassign84,
      DIPA => net_gnd4,
      DOA => pgassign85,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign86,
      ADDRB => pgassign87,
      CLKB => BRAM_Clk_B,
      DIB => pgassign88,
      DIPB => net_gnd4,
      DOB => pgassign89,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign90
    );

  ramb16bwer_11 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_11.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign91,
      CLKA => BRAM_Clk_A,
      DIA => pgassign92,
      DIPA => net_gnd4,
      DOA => pgassign93,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign94,
      ADDRB => pgassign95,
      CLKB => BRAM_Clk_B,
      DIB => pgassign96,
      DIPB => net_gnd4,
      DOB => pgassign97,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign98
    );

  ramb16bwer_12 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_12.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign99,
      CLKA => BRAM_Clk_A,
      DIA => pgassign100,
      DIPA => net_gnd4,
      DOA => pgassign101,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign102,
      ADDRB => pgassign103,
      CLKB => BRAM_Clk_B,
      DIB => pgassign104,
      DIPB => net_gnd4,
      DOB => pgassign105,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign106
    );

  ramb16bwer_13 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_13.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign107,
      CLKA => BRAM_Clk_A,
      DIA => pgassign108,
      DIPA => net_gnd4,
      DOA => pgassign109,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign110,
      ADDRB => pgassign111,
      CLKB => BRAM_Clk_B,
      DIB => pgassign112,
      DIPB => net_gnd4,
      DOB => pgassign113,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign114
    );

  ramb16bwer_14 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_14.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign115,
      CLKA => BRAM_Clk_A,
      DIA => pgassign116,
      DIPA => net_gnd4,
      DOA => pgassign117,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign118,
      ADDRB => pgassign119,
      CLKB => BRAM_Clk_B,
      DIB => pgassign120,
      DIPB => net_gnd4,
      DOB => pgassign121,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign122
    );

  ramb16bwer_15 : RAMB16BWER
    generic map (
      INIT_FILE => "microblaze_0_bram_block_combined_15.mem",
      DATA_WIDTH_A => 2,
      DATA_WIDTH_B => 2
    )
    port map (
      ADDRA => pgassign123,
      CLKA => BRAM_Clk_A,
      DIA => pgassign124,
      DIPA => net_gnd4,
      DOA => pgassign125,
      DOPA => open,
      ENA => BRAM_EN_A,
      REGCEA => net_gnd0,
      RSTA => BRAM_Rst_A,
      WEA => pgassign126,
      ADDRB => pgassign127,
      CLKB => BRAM_Clk_B,
      DIB => pgassign128,
      DIPB => net_gnd4,
      DOB => pgassign129,
      DOPB => open,
      ENB => BRAM_EN_B,
      REGCEB => net_gnd0,
      RSTB => BRAM_Rst_B,
      WEB => pgassign130
    );

end architecture STRUCTURE;

