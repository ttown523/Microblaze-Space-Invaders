-------------------------------------------------------------------------------
-- fit_timer_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library fit_timer_v1_01_b;
use fit_timer_v1_01_b.all;

entity fit_timer_0_wrapper is
  port (
    Clk : in std_logic;
    Rst : in std_logic;
    Interrupt : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of fit_timer_0_wrapper : entity is "fit_timer_v1_01_b";

end fit_timer_0_wrapper;

architecture STRUCTURE of fit_timer_0_wrapper is

  component fit_timer is
    generic (
      C_FAMILY : string;
      C_NO_CLOCKS : integer;
      C_INACCURACY : integer;
      C_EXT_RESET_HIGH : integer
    );
    port (
      Clk : in std_logic;
      Rst : in std_logic;
      Interrupt : out std_logic
    );
  end component;

begin

  fit_timer_0 : fit_timer
    generic map (
      C_FAMILY => "spartan6",
      C_NO_CLOCKS => 1000000,
      C_INACCURACY => 0,
      C_EXT_RESET_HIGH => 1
    )
    port map (
      Clk => Clk,
      Rst => Rst,
      Interrupt => Interrupt
    );

end architecture STRUCTURE;

