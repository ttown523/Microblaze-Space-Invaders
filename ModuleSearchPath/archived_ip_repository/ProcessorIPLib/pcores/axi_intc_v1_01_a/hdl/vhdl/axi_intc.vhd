-------------------------------------------------------------------------------
-- axi_intc - entity / architecture pair
-------------------------------------------------------------------------------
--
-- ***************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This file contains proprietary and confidential information of
-- Xilinx, Inc. ("Xilinx"), that is distributed under a license
-- from Xilinx, and may be used, copied and/or disclosed only
-- pursuant to the terms of a valid license agreement with Xilinx.
--
-- XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
-- ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
-- EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
-- LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
-- MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
-- does not warrant that functions included in the Materials will
-- meet the requirements of Licensee, or that the operation of the
-- Materials will be uninterrupted or error-free, or that defects
-- in the Materials will be corrected. Furthermore, Xilinx does
-- not warrant or make any representations regarding use, or the
-- results of the use, of the Materials in terms of correctness,
-- accuracy, reliability or otherwise.
--
-- Xilinx products are not designed or intended to be fail-safe,
-- or for use in any application requiring fail-safe performance,
-- such as life-support or safety devices or systems, Class III
-- medical devices, nuclear facilities, applications related to
-- the deployment of airbags, or any other applications that could
-- lead to death, personal injury or severe property or
-- environmental damage (individually and collectively, "critical
-- applications"). Customer assumes the sole risk and liability
-- of any use of Xilinx products in critical applications,
-- subject only to applicable laws and regulations governing
-- limitations on product liability.
--
-- Copyright 2009 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
-- ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        axi_intc.vhd
-- Version:         v1.01a
-- Description:     Interrupt controller interfaced to AXI.
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--           -- axi_intc.vhd  (wrapper for top level)
--               -- axi_lite_ipif.vhd
--               -- intc_core.vhd
--
-------------------------------------------------------------------------------
-- Author:      PB
-- History:
--  PB     07/29/09
--  ^^^^^^^
--  - Initial release of v1.00.a
-- ~~~~~~
--  PB     03/26/10
--
--  - updated based on the xps_intc_v2_01_a
--  PB     09/21/10
--
--  - updated the axi_lite_ipif from v1.00.a to v1.01.a
-- ~~~~~~
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

library proc_common_v3_00_a;
-------------------------------------------------------------------------
-- Package proc_common_pkg is used because it contains the RESET_ACTIVE 
-- constant used to assign reset as active high status.
-------------------------------------------------------------------------
--use proc_common_v3_00_a.proc_common_pkg.RESET_ACTIVE;
-------------------------------------------------------------------------
-- Package ipif_pkg is used because it contains the calc_num_ce, 
-- INTEGER_ARRAY_TYPE & SLV64_ARRAY_TYPE.
-- 1. calc_num_ce is used to get the number of chip selects.
--    INTEGER_ARRAY_TYPE is used for type declaration on constants 
-- 2. ARD_ID_ARRAY & ARD_NUM_CE_ARRAY.
--    type declaration on constants ARD_ID_ARRAY & ARD_NUM_CE_ARRAY.
-- 3. SLV64_ARRAY_TYPE is used for type declaration on constants 
--    on constants ARD_ADDR_RANGE_ARRAY.
-------------------------------------------------------------------------
use proc_common_v3_00_a.ipif_pkg.calc_num_ce;
use proc_common_v3_00_a.ipif_pkg.INTEGER_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.SLV64_ARRAY_TYPE;

-------------------------------------------------------------------------
-- Library axi_lite_ipif_v1_01_a is used because it contains the 
-- axi_lite_ipif which interraces intc_core to AXI.
-------------------------------------------------------------------------
library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

-------------------------------------------------------------------------
-- Library axi_intc_v1_01_a is used because it contains the intc_core.
-- The complete interrupt controller logic is designed in intc_core.
-------------------------------------------------------------------------
library axi_intc_v1_01_a;
use axi_intc_v1_01_a.intc_core;

-------------------------------------------------------------------------------
-- Definition of Generics:
--  System Parameter
--   C_FAMILY           -- Target FPGA family
--  AXI Parameters
--   C_BASEADDR  -- AXI base address
--   C_HIGHADDR  -- AXI high address 
--   C_S_AXI_ADDR_WIDTH -- AXI address bus width
--   C_S_AXI_DATA_WIDTH -- AXI data bus width
--  Intc Parameters
--   C_NUM_INTR_INPUTS  -- Number of interrupt inputs
--   C_KIND_OF_INTR     -- Kind of interrupt (0-Level/1-Edge)
--   C_KIND_OF_EDGE     -- Kind of edge (0-falling/1-rising)
--   C_KIND_OF_LVL      -- Kind of level (0-low/1-high)
--   C_HAS_IPR          -- Set to 1 if has Interrupt Pending Register
--   C_HAS_SIE          -- Set to 1 if has Set Interrupt Enable Bits Register
--   C_HAS_CIE          -- Set to 1 if has Clear Interrupt Enable Bits Register
--   C_HAS_IVR          -- Set to 1 if has Interrupt Vector Register
--   C_IRQ_IS_LEVEL     -- If set to 0 generates edge interrupt
--                      -- If set to 1 generates level interrupt
--   C_IRQ_ACTIVE       -- Defines the edge for output interrupt if 
--                      -- C_IRQ_IS_LEVEL=0 (0-FALLING/1-RISING)
--                      -- Defines the level for output interrupt if 
--                      -- C_IRQ_IS_LEVEL=1 (0-LOW/1-HIGH)
--
-------------------------------------------------------------------------------
-- Definition of Ports:
-- Clocks and reset
--  S_AXI_ACLK          -- AXI Clock
--  S_AXI_ARESETN       -- AXI Reset - Active Low Reset
-- AXI interface signals 
--  S_AXI_AWADDR        -- AXI Write address
--  S_AXI_AWVALID       -- Write address valid
--  S_AXI_AWREADY       -- Write address ready
--  S_AXI_WDATA         -- Write data
--  S_AXI_WSTRB         -- Write strobes
--  S_AXI_WVALID        -- Write valid
--  S_AXI_WREADY        -- Write ready
--  S_AXI_BRESP         -- Write response
--  S_AXI_BVALID        -- Write response valid
--  S_AXI_BREADY        -- Response ready
--  S_AXI_ARADDR        -- Read address
--  S_AXI_ARVALID       -- Read address valid
--  S_AXI_ARREADY       -- Read address ready
--  S_AXI_RDATA         -- Read data
--  S_AXI_RRESP         -- Read response
--  S_AXI_RVALID        -- Read valid
--  S_AXI_RREADY        -- Read ready
-- Intc Interface Signals
--  Intr                -- Input Interruput request
--  Irq                 -- Output Interruput request
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity axi_intc is
  generic
  (
  -- System Parameter
   C_FAMILY           : string  := "virtex6";
  -- AXI Parameters
   C_BASEADDR  : std_logic_vector(31 downto 0) := X"FFFFFFFF";
   C_HIGHADDR  : std_logic_vector(31 downto 0) := X"00000000";
   C_S_AXI_ADDR_WIDTH : integer := 32;
   C_S_AXI_DATA_WIDTH : integer := 32;
  -- Intc Parameters
   C_NUM_INTR_INPUTS  : integer range 1 to 32 := 2;
   C_KIND_OF_INTR     : std_logic_vector(31 downto 0) :=
                                  "11111111111111111111111111111111";
   C_KIND_OF_EDGE     : std_logic_vector(31 downto 0) :=
                                  "11111111111111111111111111111111";
   C_KIND_OF_LVL      : std_logic_vector(31 downto 0) :=
                                  "11111111111111111111111111111111";
   C_HAS_IPR          : integer range 0 to 1 := 1;
   C_HAS_SIE          : integer range 0 to 1 := 1;
   C_HAS_CIE          : integer range 0 to 1 := 1;
   C_HAS_IVR          : integer range 0 to 1 := 1;
   C_IRQ_IS_LEVEL     : integer range 0 to 1 := 1;
   C_IRQ_ACTIVE       : std_logic := '1'
   );
   port
   (
   -- System signals
    S_AXI_ACLK      : in  std_logic;
    S_AXI_ARESETN   : in  std_logic;
   -- AXI interface signals
    S_AXI_AWADDR    : in  std_logic_vector (C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID   : in  std_logic;
    S_AXI_AWREADY   : out std_logic;
    S_AXI_WDATA     : in  std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB     : in  std_logic_vector ((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID    : in  std_logic;
    S_AXI_WREADY    : out std_logic;
    S_AXI_BRESP     : out std_logic_vector(1 downto 0);
    S_AXI_BVALID    : out std_logic;
    S_AXI_BREADY    : in  std_logic;
    S_AXI_ARADDR    : in  std_logic_vector (C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID   : in  std_logic;
    S_AXI_ARREADY   : out std_logic;
    S_AXI_RDATA     : out std_logic_vector (C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP     : out std_logic_vector(1 downto 0);
    S_AXI_RVALID    : out std_logic;
    S_AXI_RREADY    : in  std_logic;
   -- Intc iInterface signals
    Intr            : in  std_logic_vector(C_NUM_INTR_INPUTS-1 downto 0);
    Irq             : out std_logic
   );

-------------------------------------------------------------------------------
-- Attributes
-------------------------------------------------------------------------------
  -- Fan-Out attributes for XST
    ATTRIBUTE MAX_FANOUT                   : string;
    ATTRIBUTE MAX_FANOUT  of S_AXI_ACLK    : signal is "10000";
    ATTRIBUTE MAX_FANOUT  of S_AXI_ARESETN : signal is "10000";

-----------------------------------------------------------------
  -- Start of PSFUtil MPD attributes
-----------------------------------------------------------------
    -- SIGIS attribute for specifying clocks,interrupts,resets for EDK
    ATTRIBUTE IP_GROUP                    : string;
    ATTRIBUTE IP_GROUP of axi_intc        : entity is "LOGICORE";

    ATTRIBUTE IPTYPE                      : string;
    ATTRIBUTE IPTYPE of axi_intc          : entity is "PERIPHERAL";

    ATTRIBUTE HDL                         : string;
    ATTRIBUTE HDL of axi_intc             : entity is "VHDL";

    ATTRIBUTE STYLE                       : string;
    ATTRIBUTE STYLE of axi_intc           : entity is "HDL";

    ATTRIBUTE IMP_NETLIST                 : string;
    ATTRIBUTE IMP_NETLIST of axi_intc     : entity is "TRUE";

    ATTRIBUTE RUN_NGCBUILD                : string;
    ATTRIBUTE RUN_NGCBUILD of axi_intc    : entity is "TRUE";

    ATTRIBUTE ADDR_TYPE                   : string;
    ATTRIBUTE ADDR_TYPE of C_BASEADDR     : constant is "REGISTER";
    ATTRIBUTE ADDR_TYPE of C_HIGHADDR     : constant is "REGISTER";

    ATTRIBUTE ASSIGNMENT                  : string;
    ATTRIBUTE ASSIGNMENT of C_BASEADDR    : constant is "REQUIRE";
    ATTRIBUTE ASSIGNMENT of C_HIGHADDR    : constant is "REQUIRE";

    ATTRIBUTE SIGIS                       : string;
    ATTRIBUTE SIGIS of S_AXI_ACLK         : signal is "Clk";
    ATTRIBUTE SIGIS of S_AXI_ARESETN      : signal is "Rstn";

end axi_intc;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture imp of axi_intc is

-------------------------------------------------------------------------------
-- constant added for webtalk information
-------------------------------------------------------------------------------
function chr(sl: std_logic) return character is
    variable c: character;
    begin
      case sl is
         when '0' => c:= '0';
         when '1' => c:= '1';
         when 'Z' => c:= 'Z';
         when 'U' => c:= 'U';
         when 'X' => c:= 'X';
         when 'W' => c:= 'W';
         when 'L' => c:= 'L';
         when 'H' => c:= 'H';
         when '-' => c:= '-';
      end case;
    return c;
   end chr;

function str(slv: std_logic_vector) return string is
     variable result : string (1 to slv'length);
     variable r : integer;
   begin
     r := 1;
     for i in slv'range loop
        result(r) := chr(slv(i));
        r := r + 1;
     end loop;
     return result;
   end str;

  constant C_CORE_GENERATION_INFO : string := ",axi_intc,{"
    & "C_FAMILY = "            &  C_FAMILY
    & ",C_NUM_INTR_INPUTS = "  & integer'image(C_NUM_INTR_INPUTS)
    & ",C_KIND_OF_INTR = "     & str(C_KIND_OF_INTR)
    & ",C_KIND_OF_EDGE = "     & str(C_KIND_OF_EDGE)
    & ",C_KIND_OF_LVL = "      & str(C_KIND_OF_LVL)
    & ",C_HAS_IPR = "          & integer'image(C_HAS_IPR)
    & ",C_HAS_SIE = "          & integer'image(C_HAS_SIE)
    & ",C_HAS_CIE = "          & integer'image(C_HAS_CIE)
    & ",C_HAS_IVR = "          & integer'image(C_HAS_IVR)
    & ",C_IRQ_IS_LEVEL = "     & integer'image(C_IRQ_IS_LEVEL)
    & ",C_IRQ_ACTIVE = "       & chr(C_IRQ_ACTIVE)
    & "}";

  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of imp : architecture is C_CORE_GENERATION_INFO;

 ---------------------------------------------------------------------------
 -- Component Declarations
 ---------------------------------------------------------------------------
 constant ZERO_ADDR_PAD : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) 
                         := (others => '0');
 constant ARD_ID_ARRAY  : INTEGER_ARRAY_TYPE := (0 => 1);
 constant ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE 
                         := ( 
                            ZERO_ADDR_PAD & C_BASEADDR,
                            ZERO_ADDR_PAD & (C_BASEADDR or X"0000001F")
                            );
 constant ARD_NUM_CE_ARRAY : INTEGER_ARRAY_TYPE := (0 => 8);
 constant C_S_AXI_MIN_SIZE : std_logic_vector(31 downto 0):= X"0000001F";
 constant C_USE_WSTRB      : integer := 1;
 constant C_DPHASE_TIMEOUT : integer := 0;
 constant RESET_ACTIVE     : std_logic := '0';
 ---------------------------------------------------------------------------
 -- Signal Declarations
 ---------------------------------------------------------------------------
 signal register_addr : std_logic_vector(2 downto 0);
 signal read_data     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
 signal write_data    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
 signal bus2ip_clk    : std_logic;
 signal bus2ip_resetn : std_logic;
 signal bus2ip_addr   : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
 signal bus2ip_rnw    : std_logic;
 signal bus2ip_cs     : std_logic_vector((
                                (ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1 downto 0);
 signal bus2ip_rdce   : std_logic_vector(
 				calc_num_ce(ARD_NUM_CE_ARRAY)-1 downto 0);
 signal bus2ip_wrce   : std_logic_vector(
				calc_num_ce(ARD_NUM_CE_ARRAY)-1 downto 0);
 signal bus2ip_be     : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
 signal ip2bus_wrack  : std_logic;
 signal ip2bus_rdack  : std_logic;
 signal ip2bus_error  : std_logic;
 signal word_access   : std_logic;
 signal ip2bus_rdack_int    : std_logic;
 signal ip2bus_wrack_int    : std_logic;
 signal ip2bus_rdack_int_d1 : std_logic;
 signal ip2bus_wrack_int_d1 : std_logic;
 signal ip2bus_rdack_prev2  : std_logic;
 signal ip2bus_wrack_prev2  : std_logic;

begin

   register_addr <= bus2ip_addr(4 downto 2);
   -- Internal ack signals
   ip2bus_rdack_int <= bus2ip_rdce(0) or bus2ip_rdce(1) or bus2ip_rdce(2) or
                       bus2ip_rdce(3) or bus2ip_rdce(4) or bus2ip_rdce(5) or 
                       bus2ip_rdce(6) or bus2ip_rdce(7);
   ip2bus_wrack_int <= bus2ip_wrce(0) or bus2ip_wrce(1) or bus2ip_wrce(2) or 
                       bus2ip_wrce(3) or bus2ip_wrce(4) or bus2ip_wrce(5) or 
                       bus2ip_wrce(6) or bus2ip_wrce(7);
   -- Error signal generation
   word_access <= bus2ip_be(0) and bus2ip_be(1) and bus2ip_be(2) and 
                                   bus2ip_be(3);
   ip2bus_error <= not word_access;

    --------------------------------------------------------------------------
    -- Process DACK_DELAY_P for generating write and read data acknowledge 
    -- signals.
    --------------------------------------------------------------------------
    DACK_DELAY_P: process (bus2ip_clk) is
    begin
        if bus2ip_clk'event and bus2ip_clk='1' then
            if bus2ip_resetn = RESET_ACTIVE then
                ip2bus_rdack_int_d1 <= '0';
                ip2bus_wrack_int_d1 <= '0';
                ip2bus_rdack        <= '0';
                ip2bus_wrack        <= '0';
            else
                ip2bus_rdack_int_d1 <= ip2bus_rdack_int;
                ip2bus_wrack_int_d1 <= ip2bus_wrack_int;
                ip2bus_rdack        <= ip2bus_rdack_prev2;
                ip2bus_wrack        <= ip2bus_wrack_prev2;
            end if;
        end if;
    end process DACK_DELAY_P;

    -- Detecting rising edge by creating one shot
    ip2bus_rdack_prev2 <= ip2bus_rdack_int and (not ip2bus_rdack_int_d1);
    ip2bus_wrack_prev2 <= ip2bus_wrack_int and (not ip2bus_wrack_int_d1);
   
   ---------------------------------------------------------------------------
   -- Component Instantiations
   ---------------------------------------------------------------------------
   -----------------------------------------------------------------
   -- Instantiating intc_core from axi_intc_v1_01_a 
   -----------------------------------------------------------------
   INTC_CORE_I : entity axi_intc_v1_01_a.intc_core
     generic map
     (
      C_DWIDTH          => C_S_AXI_DATA_WIDTH,
      C_NUM_INTR_INPUTS => C_NUM_INTR_INPUTS,
      C_KIND_OF_INTR    => C_KIND_OF_INTR,
      C_KIND_OF_EDGE    => C_KIND_OF_EDGE,
      C_KIND_OF_LVL     => C_KIND_OF_LVL,
      C_HAS_IPR         => C_HAS_IPR,
      C_HAS_SIE         => C_HAS_SIE,
      C_HAS_CIE         => C_HAS_CIE,
      C_HAS_IVR         => C_HAS_IVR,
      C_IRQ_IS_LEVEL    => C_IRQ_IS_LEVEL,
      C_IRQ_ACTIVE      => C_IRQ_ACTIVE
     )
     port map
     (
     -- Intc Interface Signals
      Clk      => bus2ip_clk,
      Rst      => bus2ip_resetn,
      Intr     => Intr,
      Reg_addr => register_addr,
      Valid_rd => bus2ip_rdce,
      Valid_wr => bus2ip_wrce,
      Wr_data  => write_data,
      Rd_data  => read_data,
      Irq      => Irq
     );
   -----------------------------------------------------------------
   --Instantiating axi_lite_ipif from axi_lite_ipif_v1_01_a
   -----------------------------------------------------------------
   AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map 
     (
      C_S_AXI_DATA_WIDTH    => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH    => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_MIN_SIZE      => C_S_AXI_MIN_SIZE,
      C_USE_WSTRB           => C_USE_WSTRB,
      C_DPHASE_TIMEOUT      => C_DPHASE_TIMEOUT,
      C_ARD_ADDR_RANGE_ARRAY=> ARD_ADDR_RANGE_ARRAY,
      C_ARD_NUM_CE_ARRAY    => ARD_NUM_CE_ARRAY,
      C_FAMILY              => C_FAMILY
     )
     port map	
     (
     --System signals
      S_AXI_ACLK            => S_AXI_ACLK,
      S_AXI_ARESETN         => S_AXI_ARESETN,
     -- AXI interface signals 
      S_AXI_AWADDR          => S_AXI_AWADDR,
      S_AXI_AWVALID         => S_AXI_AWVALID,
      S_AXI_AWREADY         => S_AXI_AWREADY,
      S_AXI_WDATA           => S_AXI_WDATA,
      S_AXI_WSTRB           => S_AXI_WSTRB,
      S_AXI_WVALID          => S_AXI_WVALID,
      S_AXI_WREADY          => S_AXI_WREADY,
      S_AXI_BRESP           => S_AXI_BRESP,
      S_AXI_BVALID          => S_AXI_BVALID,
      S_AXI_BREADY          => S_AXI_BREADY,
      S_AXI_ARADDR          => S_AXI_ARADDR,
      S_AXI_ARVALID         => S_AXI_ARVALID,
      S_AXI_ARREADY         => S_AXI_ARREADY,
      S_AXI_RDATA           => S_AXI_RDATA,
      S_AXI_RRESP           => S_AXI_RRESP,
      S_AXI_RVALID          => S_AXI_RVALID,
      S_AXI_RREADY          => S_AXI_RREADY,
     -- Controls to the IP/IPIF modules
      Bus2IP_Clk            => bus2ip_clk,
      Bus2IP_Resetn         => bus2ip_resetn,
      Bus2IP_Addr           => bus2ip_addr,
      Bus2IP_RNW            => bus2ip_rnw,
      Bus2IP_BE             => bus2ip_be,
      Bus2IP_CS             => bus2ip_cs,
      Bus2IP_RdCE           => bus2ip_rdce,
      Bus2IP_WrCE           => bus2ip_wrce,
      Bus2IP_Data           => write_data,
      IP2Bus_Data           => read_data,
      IP2Bus_WrAck          => ip2bus_wrack,
      IP2Bus_RdAck          => ip2bus_rdack,
      IP2Bus_Error          => ip2bus_error
     );

end imp;
