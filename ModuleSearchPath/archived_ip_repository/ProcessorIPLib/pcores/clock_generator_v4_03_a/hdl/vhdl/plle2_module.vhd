-- (c) Copyright 2009 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 
--

-------------------------------------------------------------------------------
-- Filename:        plle2_module.vhd
-------------------------------------------------------------------------------
-- Naming Conventions:
-- active low signals: "*_n"
-- clock signals: "clk", "clk_div#", "clk_#x"
-- reset signals: "rst", "rst_n"
-- generics: "C_*"
-- user defined types: "*_TYPE"
-- state machine next state: "*_ns"
-- state machine current state: "*_cs"
-- combinatorial signals: "*_com"
-- pipelined or register delay signals: "*_d#"
-- counter signals: "*cnt*"
-- clock enable signals: "*_ce"
-- internal version of output port "*_i"
-- device pins: "*_pin"
-- ports: - Names begin with Uppercase
-- processes: "*_PROCESS"
-- component instantiations: "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library Unisim;
use Unisim.vcomponents.all;

entity plle2_module is
  generic (
    -- base plle2_adv parameters
    C_BANDWIDTH             : string  := "OPTIMIZED"; 
    C_COMPENSATION          : string  := "ZHOLD";  
    C_STARTUP_WAIT          : string  := "false";
    C_CLKOUT0_DIVIDE        : integer := 1;  -- Division factor for CLKOUT0
    C_CLKOUT1_DIVIDE        : integer := 1;  -- Division factor for CLKOUT1 (1 to 128)
    C_CLKOUT2_DIVIDE        : integer := 1;  -- Division factor for CLKOUT2 (1 to 128)
    C_CLKOUT3_DIVIDE        : integer := 1;  -- Division factor for CLKOUT3 (1 to 128)
    C_CLKOUT4_DIVIDE        : integer := 1;  -- Division factor for CLKOUT4 (1 to 128)
    C_CLKOUT5_DIVIDE        : integer := 1;  -- Division factor for CLKOUT5 (1 to 128)
    C_DIVCLK_DIVIDE         : integer := 1;  -- Division factor for all clocks (1 to 52)
    C_CLKFBOUT_MULT         : integer := 1;  -- Multiplication factor for all output clocks
    C_CLKFBOUT_PHASE        : real    := 0.0;  -- Phase shift (degrees) of all output clocks
    C_CLKIN1_PERIOD         : real    := 0.000;  -- Clock period (ns) of input clock on CLKIN1
    C_CLKOUT0_DUTY_CYCLE    : real    := 0.5;  -- Duty cycle for CLKOUT0 (0.01 to 0.99)
    C_CLKOUT0_PHASE         : real    := 0.0;  -- Phase shift (degrees) for CLKOUT0 (0.0 to 360.0)
    C_CLKOUT1_DUTY_CYCLE    : real    := 0.5;  -- Duty cycle for CLKOUT1 (0.01 to 0.99)
    C_CLKOUT1_PHASE         : real    := 0.0;  -- Phase shift (degrees) for CLKOUT1 (0.0 to 360.0)
    C_CLKOUT2_DUTY_CYCLE    : real    := 0.5;  -- Duty cycle for CLKOUT2 (0.01 to 0.99)
    C_CLKOUT2_PHASE         : real    := 0.0;  -- Phase shift (degrees) for CLKOUT2 (0.0 to 360.0)
    C_CLKOUT3_DUTY_CYCLE    : real    := 0.5;  -- Duty cycle for CLKOUT3 (0.01 to 0.99)
    C_CLKOUT3_PHASE         : real    := 0.0;  -- Phase shift (degrees) for CLKOUT3 (0.0 to 360.0)
    C_CLKOUT4_DUTY_CYCLE    : real    := 0.5;  -- Duty cycle for CLKOUT4 (0.01 to 0.99)
    C_CLKOUT4_PHASE         : real    := 0.0;  -- Phase shift (degrees) for CLKOUT4 (0.0 to 360.0)
    C_CLKOUT5_DUTY_CYCLE    : real    := 0.5;  -- Duty cycle for CLKOUT5 (0.01 to 0.99)
    C_CLKOUT5_PHASE         : real    := 0.0;  -- Phase shift (degrees) for CLKOUT5 (0.0 to 360.0)
    C_REF_JITTER1           : real    := 0.010;  -- Input reference jitter
    -- pcore parameters
    C_CLKIN1_BUF            : boolean := false;
    C_CLKFBOUT_BUF          : boolean := false;
    C_CLKOUT0_BUF           : boolean := false;
    C_CLKOUT1_BUF           : boolean := false;
    C_CLKOUT2_BUF           : boolean := false;
    C_CLKOUT3_BUF           : boolean := false;
    C_CLKOUT4_BUF           : boolean := false;
    C_CLKOUT5_BUF           : boolean := false;
    C_EXT_RESET_HIGH        : integer := 1;
    C_FAMILY                : string  := "virtex7"
    );
  port (
    CLKFBOUT         : out std_logic;
    CLKOUT0          : out std_logic;
    CLKOUT1          : out std_logic;
    CLKOUT2          : out std_logic;
    CLKOUT3          : out std_logic;
    CLKOUT4          : out std_logic;
    CLKOUT5          : out std_logic;
    LOCKED           : out std_logic;
    CLKFBIN          : in  std_logic;
    CLKIN1           : in  std_logic;
    PWRDWN           : in  std_logic;
    RST              : in  std_logic
    );
end plle2_module;

architecture STRUCT of plle2_module is

  signal rsti : std_logic;
  signal CLKIN1_BUF   : std_logic;
  signal CLKFBOUT_BUF : std_logic;
  signal CLKOUT0_BUF  : std_logic;
  signal CLKOUT1_BUF  : std_logic;
  signal CLKOUT2_BUF  : std_logic;
  signal CLKOUT3_BUF  : std_logic;
  signal CLKOUT4_BUF  : std_logic;
  signal CLKOUT5_BUF  : std_logic;

----- component plle2_ADV -----
  component plle2_ADV
    generic (
       BANDWIDTH            : string  := "OPTIMIZED";
       COMPENSATION         : string  := "ZHOLD";
       STARTUP_WAIT         : string := "FALSE";
       CLKOUT0_DIVIDE       : integer := 1;
       CLKOUT1_DIVIDE       : integer := 1;
       CLKOUT2_DIVIDE       : integer := 1;
       CLKOUT3_DIVIDE       : integer := 1;
       CLKOUT4_DIVIDE       : integer := 1;
       CLKOUT5_DIVIDE       : integer := 1;
       DIVCLK_DIVIDE        : integer := 1;
       CLKFBOUT_MULT        : integer := 1;
       CLKFBOUT_PHASE       : real    := 0.0;
       CLKIN1_PERIOD        : real    := 0.0;
       CLKIN2_PERIOD        : real    := 0.0;
       CLKOUT0_DUTY_CYCLE   : real    := 0.5;
       CLKOUT0_PHASE        : real    := 0.0;
       CLKOUT1_DUTY_CYCLE   : real    := 0.5;
       CLKOUT1_PHASE        : real    := 0.0;
       CLKOUT2_DUTY_CYCLE   : real    := 0.5;
       CLKOUT2_PHASE        : real    := 0.0;
       CLKOUT3_DUTY_CYCLE   : real    := 0.5;
       CLKOUT3_PHASE        : real    := 0.0;
       CLKOUT4_DUTY_CYCLE   : real    := 0.5;
       CLKOUT4_PHASE        : real    := 0.0;
       CLKOUT5_DUTY_CYCLE   : real    := 0.5;
       CLKOUT5_PHASE        : real    := 0.0;
       REF_JITTER1          : real    := 0.0;
       REF_JITTER2          : real    := 0.0
    );
    port (
       CLKFBOUT : out std_ulogic := '0';
       CLKOUT0 : out std_ulogic := '0';
       CLKOUT1 : out std_ulogic := '0';
       CLKOUT2 : out std_ulogic := '0';
       CLKOUT3 : out std_ulogic := '0';
       CLKOUT4 : out std_ulogic := '0';
       CLKOUT5 : out std_ulogic := '0';
       DRDY : out std_ulogic := '0';
       LOCKED : out std_ulogic := '0';
       DO : out std_logic_vector (15 downto 0);
       CLKFBIN : in std_ulogic;
       CLKIN1 : in std_ulogic;
       CLKIN2 : in std_ulogic;
       CLKINSEL : in std_ulogic;
       DCLK : in std_ulogic;
       DEN : in std_ulogic;
       DWE : in std_ulogic;
       PWRDWN : in std_ulogic;
       RST : in std_ulogic;
       DI : in std_logic_vector(15 downto 0);
       DADDR : in std_logic_vector(6 downto 0)
    );
  end component;

  function UpperCase_Char(char : character) return character is
  begin
    -- If char is not an upper case letter then return char
    if char < 'a' or char > 'z' then
      return char;
    end if;
    -- Otherwise map char to its corresponding lower case character and
    -- return that
    case char is
      when 'a'    => return 'A'; when 'b' => return 'B'; when 'c' => return 'C'; when 'd' => return 'D';
      when 'e'    => return 'E'; when 'f' => return 'F'; when 'g' => return 'G'; when 'h' => return 'H';
      when 'i'    => return 'I'; when 'j' => return 'J'; when 'k' => return 'K'; when 'l' => return 'L';
      when 'm'    => return 'M'; when 'n' => return 'N'; when 'o' => return 'O'; when 'p' => return 'P';
      when 'q'    => return 'Q'; when 'r' => return 'R'; when 's' => return 'S'; when 't' => return 'T';
      when 'u'    => return 'U'; when 'v' => return 'V'; when 'w' => return 'W'; when 'x' => return 'X';
      when 'y'    => return 'Y'; when 'z' => return 'Z';
      when others => return char;
    end case;
  end UpperCase_Char;

  function UpperCase_String (s : string) return string is
    variable res               : string(s'range);
  begin 
    for I in s'range loop
      res(I) := UpperCase_Char(s(I));
    end loop;  -- I
    return res;
  end function UpperCase_String;

begin

  -----------------------------------------------------------------------------
  -- handle the reset
  -----------------------------------------------------------------------------
  Rst_is_Active_High : if (C_EXT_RESET_HIGH = 1) generate
    rsti <= RST;
  end generate Rst_is_Active_High;

  Rst_is_Active_Low : if (C_EXT_RESET_HIGH /= 1) generate
    rsti <= not RST;
  end generate Rst_is_Active_Low;

    PLLE2_ADV_inst : PLLE2_ADV
      generic map (
        BANDWIDTH             => UpperCase_String(C_BANDWIDTH),
        COMPENSATION          => UpperCase_String(C_COMPENSATION),
        STARTUP_WAIT          => C_STARTUP_WAIT,
        CLKOUT0_DIVIDE        => C_CLKOUT0_DIVIDE,
        CLKOUT1_DIVIDE        => C_CLKOUT1_DIVIDE,
        CLKOUT2_DIVIDE        => C_CLKOUT2_DIVIDE,
        CLKOUT3_DIVIDE        => C_CLKOUT3_DIVIDE,
        CLKOUT4_DIVIDE        => C_CLKOUT4_DIVIDE,
        CLKOUT5_DIVIDE        => C_CLKOUT5_DIVIDE,
        DIVCLK_DIVIDE         => C_DIVCLK_DIVIDE,
        CLKFBOUT_MULT         => C_CLKFBOUT_MULT,
        CLKFBOUT_PHASE        => C_CLKFBOUT_PHASE,
        CLKIN1_PERIOD         => C_CLKIN1_PERIOD,
        CLKIN2_PERIOD         => C_CLKIN1_PERIOD,
        CLKOUT0_DUTY_CYCLE    => C_CLKOUT0_DUTY_CYCLE,
        CLKOUT0_PHASE         => C_CLKOUT0_PHASE,
        CLKOUT1_DUTY_CYCLE    => C_CLKOUT1_DUTY_CYCLE,
        CLKOUT1_PHASE         => C_CLKOUT1_PHASE,
        CLKOUT2_DUTY_CYCLE    => C_CLKOUT2_DUTY_CYCLE,
        CLKOUT2_PHASE         => C_CLKOUT2_PHASE,
        CLKOUT3_DUTY_CYCLE    => C_CLKOUT3_DUTY_CYCLE,
        CLKOUT3_PHASE         => C_CLKOUT3_PHASE,
        CLKOUT4_DUTY_CYCLE    => C_CLKOUT4_DUTY_CYCLE,
        CLKOUT4_PHASE         => C_CLKOUT4_PHASE,
        CLKOUT5_DUTY_CYCLE    => C_CLKOUT5_DUTY_CYCLE,
        CLKOUT5_PHASE         => C_CLKOUT5_PHASE,
        REF_JITTER1            => C_REF_JITTER1,
        REF_JITTER2            => C_REF_JITTER1
        )
      port map (
        CLKFBOUT              => CLKFBOUT_BUF,
        CLKOUT0               => CLKOUT0_BUF,
        CLKOUT1               => CLKOUT1_BUF,
        CLKOUT2               => CLKOUT2_BUF,
        CLKOUT3               => CLKOUT3_BUF,
        CLKOUT4               => CLKOUT4_BUF,
        CLKOUT5               => CLKOUT5_BUF,
        LOCKED                => LOCKED,
        CLKFBIN               => CLKFBIN,
        CLKIN1                => CLKIN1_BUF,
        CLKIN2                => '0', 
        CLKINSEL              => '1', -- selects CLKIN1
        DADDR                 => "0000000",
        DCLK                  => '0',
        DEN                   => '0',
        DI                    => "0000000000000000",
        DWE                   => '0',
        PWRDWN                => PWRDWN,
        RST                   => rsti    -- Asynchronous PLL reset
        );

  -----------------------------------------------------------------------------
  -- Clkin1 and Clkin2
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKIN1 : if (C_CLKIN1_BUF) generate
    CLKIN1_BUFG_INST    : BUFG
      port map (
        I => CLKIN1,
        O => CLKIN1_BUF);
  end generate Using_BUFG_for_CLKIN1;

  No_BUFG_for_CLKIN1 : if (not C_CLKIN1_BUF) generate
    CLKIN1_BUF <= CLKIN1;
  end generate No_BUFG_for_CLKIN1;

  -----------------------------------------------------------------------------
  -- Clkfb
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKFBOUT : if (C_CLKFBOUT_BUF) generate
    CLKFBOUT_BUFG_INST       : BUFG
      port map (
        I => CLKFBOUT_BUF,
        O => CLKFBOUT);
  end generate Using_BUFG_for_CLKFBOUT;

  No_BUFG_for_CLKFBOUT : if (not C_CLKFBOUT_BUF) generate
    CLKFBOUT <= CLKFBOUT_BUF;
  end generate No_BUFG_for_CLKFBOUT;

  -----------------------------------------------------------------------------
  -- ClkOut0
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKOUT0 : if (C_CLKOUT0_BUF) generate

    CLKOUT0_BUFG_INST : BUFG
      port map (
        I => CLKOUT0_BUF,
        O => CLKOUT0);
  end generate Using_BUFG_for_CLKOUT0;

  No_BUFG_for_CLKOUT0 : if (not C_CLKOUT0_BUF) generate
    CLKOUT0 <= CLKOUT0_BUF;
  end generate No_BUFG_for_CLKOUT0;

  -----------------------------------------------------------------------------
  -- ClkOut1
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKOUT1 : if (C_CLKOUT1_BUF) generate

    CLKOUT1_BUFG_INST : BUFG
      port map (
        I => CLKOUT1_BUF,
        O => CLKOUT1);
  end generate Using_BUFG_for_CLKOUT1;

  No_BUFG_for_CLKOUT1 : if (not C_CLKOUT1_BUF) generate
    CLKOUT1 <= CLKOUT1_BUF;
  end generate No_BUFG_for_CLKOUT1;

  -----------------------------------------------------------------------------
  -- ClkOut2
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKOUT2 : if (C_CLKOUT2_BUF) generate

    CLKOUT2_BUFG_INST : BUFG
      port map (
        I => CLKOUT2_BUF,
        O => CLKOUT2);
  end generate Using_BUFG_for_CLKOUT2;

  No_BUFG_for_CLKOUT2 : if (not C_CLKOUT2_BUF) generate
    CLKOUT2 <= CLKOUT2_BUF;
  end generate No_BUFG_for_CLKOUT2;

  -----------------------------------------------------------------------------
  -- ClkOut3
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKOUT3 : if (C_CLKOUT3_BUF) generate

    CLKOUT3_BUFG_INST : BUFG
      port map (
        I => CLKOUT3_BUF,
        O => CLKOUT3);
  end generate Using_BUFG_for_CLKOUT3;

  No_BUFG_for_CLKOUT3    : if (not C_CLKOUT3_BUF) generate
    CLKOUT3 <= CLKOUT3_BUF;
  end generate No_BUFG_for_CLKOUT3;
  -----------------------------------------------------------------------------
  -- ClkOut4
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKOUT4 : if (C_CLKOUT4_BUF) generate

    CLKOUT4_BUFG_INST : BUFG
      port map (
        I => CLKOUT4_BUF,
        O => CLKOUT4);
  end generate Using_BUFG_for_CLKOUT4;

  No_BUFG_for_CLKOUT4 : if (not C_CLKOUT4_BUF) generate
    CLKOUT4 <= CLKOUT4_BUF;
  end generate No_BUFG_for_CLKOUT4;

  -----------------------------------------------------------------------------
  -- ClkOut5
  -----------------------------------------------------------------------------
  Using_BUFG_for_CLKOUT5 : if (C_CLKOUT5_BUF) generate

    CLKOUT5_BUFG_INST : BUFG
      port map (
        I => CLKOUT5_BUF,
        O => CLKOUT5);
  end generate Using_BUFG_for_CLKOUT5;

  No_BUFG_for_CLKOUT5 : if (not C_CLKOUT5_BUF) generate
    CLKOUT5 <= CLKOUT5_BUF;
  end generate No_BUFG_for_CLKOUT5;

end STRUCT;

