-------------------------------------------------------------------------------
-- $Id: mdm.vhd,v 1.1.2.3 2010/12/22 09:46:25 stefana Exp $
-------------------------------------------------------------------------------
-- mdm.vhd - Entity and architecture
--
--  ***************************************************************************
--  **  Copyright(C) 2003-2011 by Xilinx, Inc. All rights reserved.          **
--  **                                                                       **
--  **  This text contains proprietary, confidential                         **
--  **  information of Xilinx, Inc. , is distributed by                      **
--  **  under license from Xilinx, Inc., and may be used,                    **
--  **  copied and/or disclosed only pursuant to the terms                   **
--  **  of a valid license agreement with Xilinx, Inc.                       **
--  **                                                                       **
--  **  Unmodified source code is guaranteed to place and route,             **
--  **  function and run at speed according to the datasheet                 **
--  **  specification. Source code is provided "as-is", with no              **
--  **  obligation on the part of Xilinx to provide support.                 **
--  **                                                                       **
--  **  Xilinx Hotline support of source code IP shall only include          **
--  **  standard level Xilinx Hotline support, and will only address         **
--  **  issues and questions related to the standard released Netlist        **
--  **  version of the core (and thus indirectly, the original core source). **
--  **                                                                       **
--  **  The Xilinx Support Hotline does not have access to source            **
--  **  code and therefore cannot answer specific questions related          **
--  **  to source HDL. The Xilinx Support Hotline will only be able          **
--  **  to confirm the problem in the Netlist version of the core.           **
--  **                                                                       **
--  **  This copyright and support notice must be retained as part           **
--  **  of this text at all times.                                           **
--  ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        mdm.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93/02
-------------------------------------------------------------------------------
-- Structure:   
--              mdm.vhd
--
-------------------------------------------------------------------------------
-- Author:          goran
-- Revision:        $Revision: 1.1.2.3 $
-- Date:            $Date: 2010/12/22 09:46:25 $
--
-- History:
--   goran  2006-10-27    First Version
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
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

library mdm_v2_00_b;
use mdm_v2_00_b.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.family_support.all;
use proc_common_v3_00_a.ipif_pkg.SLV64_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.INTEGER_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.calc_num_ce;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

entity MDM is
  generic (
    C_FAMILY              : string                        := "virtex2";
    C_JTAG_CHAIN          : integer                       := 2;
    C_INTERCONNECT        : integer                       := 0;
    C_BASEADDR            : std_logic_vector(0 to 31)     := X"FFFF_FFFF";
    C_HIGHADDR            : std_logic_vector(0 to 31)     := X"0000_0000";
    C_SPLB_AWIDTH         : integer                       := 32;
    C_SPLB_DWIDTH         : integer                       := 32;
    C_SPLB_P2P            : integer                       := 0;
    C_SPLB_MID_WIDTH      : integer                       := 3;
    C_SPLB_NUM_MASTERS    : integer                       := 8;
    C_SPLB_NATIVE_DWIDTH  : integer                       := 32;
    C_SPLB_SUPPORT_BURSTS : integer                       := 0;
    C_MB_DBG_PORTS        : integer                       := 1;
    C_USE_UART            : integer                       := 1;
    C_S_AXI_ADDR_WIDTH    : integer range 32 to 36        := 32;
    C_S_AXI_DATA_WIDTH    : integer range 32 to 128       := 32
  );

  port (
    -- Global signals
    S_AXI_ACLK    : in std_logic;
    S_AXI_ARESETN : in std_logic;

    SPLB_Clk : in std_logic;
    SPLB_Rst : in std_logic;

    Interrupt     : out std_logic;
    Ext_BRK       : out std_logic;
    Ext_NM_BRK    : out std_logic;
    Debug_SYS_Rst : out std_logic;

    -- AXI signals
    S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID : in  std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID  : in  std_logic;
    S_AXI_WREADY  : out std_logic;
    S_AXI_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_BVALID  : out std_logic;
    S_AXI_BREADY  : in  std_logic;
    S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID : in  std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP   : out std_logic_vector(1 downto 0);
    S_AXI_RVALID  : out std_logic;
    S_AXI_RREADY  : in  std_logic;

    -- PLBv46 signals
    PLB_ABus       : in std_logic_vector(0 to 31);
    PLB_UABus      : in std_logic_vector(0 to 31);
    PLB_PAValid    : in std_logic;
    PLB_SAValid    : in std_logic;
    PLB_rdPrim     : in std_logic;
    PLB_wrPrim     : in std_logic;
    PLB_masterID   : in std_logic_vector(0 to C_SPLB_MID_WIDTH-1);
    PLB_abort      : in std_logic;
    PLB_busLock    : in std_logic;
    PLB_RNW        : in std_logic;
    PLB_BE         : in std_logic_vector(0 to (C_SPLB_DWIDTH/8) - 1);
    PLB_MSize      : in std_logic_vector(0 to 1);
    PLB_size       : in std_logic_vector(0 to 3);
    PLB_type       : in std_logic_vector(0 to 2);
    PLB_lockErr    : in std_logic;
    PLB_wrDBus     : in std_logic_vector(0 to C_SPLB_DWIDTH-1);
    PLB_wrBurst    : in std_logic;
    PLB_rdBurst    : in std_logic;
    PLB_wrPendReq  : in std_logic;
    PLB_rdPendReq  : in std_logic;
    PLB_wrPendPri  : in std_logic_vector(0 to 1);
    PLB_rdPendPri  : in std_logic_vector(0 to 1);
    PLB_reqPri     : in std_logic_vector(0 to 1);
    PLB_TAttribute : in std_logic_vector(0 to 15);

    Sl_addrAck     : out std_logic;
    Sl_SSize       : out std_logic_vector(0 to 1);
    Sl_wait        : out std_logic;
    Sl_rearbitrate : out std_logic;
    Sl_wrDAck      : out std_logic;
    Sl_wrComp      : out std_logic;
    Sl_wrBTerm     : out std_logic;
    Sl_rdDBus      : out std_logic_vector(0 to C_SPLB_DWIDTH-1);
    Sl_rdWdAddr    : out std_logic_vector(0 to 3);
    Sl_rdDAck      : out std_logic;
    Sl_rdComp      : out std_logic;
    Sl_rdBTerm     : out std_logic;
    Sl_MBusy       : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    Sl_MWrErr      : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    Sl_MRdErr      : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    Sl_MIRQ        : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);

    -- MicroBlaze Debug Signals
    Dbg_Clk_0     : out std_logic;
    Dbg_TDI_0     : out std_logic;
    Dbg_TDO_0     : in  std_logic;
    Dbg_Reg_En_0  : out std_logic_vector(0 to 7);
    Dbg_Capture_0 : out std_logic;
    Dbg_Shift_0   : out std_logic;
    Dbg_Update_0  : out std_logic;
    Dbg_Rst_0     : out std_logic;

    Dbg_Clk_1     : out std_logic;
    Dbg_TDI_1     : out std_logic;
    Dbg_TDO_1     : in  std_logic;
    Dbg_Reg_En_1  : out std_logic_vector(0 to 7);
    Dbg_Capture_1 : out std_logic;
    Dbg_Shift_1   : out std_logic;
    Dbg_Update_1  : out std_logic;
    Dbg_Rst_1     : out std_logic;

    Dbg_Clk_2     : out std_logic;
    Dbg_TDI_2     : out std_logic;
    Dbg_TDO_2     : in  std_logic;
    Dbg_Reg_En_2  : out std_logic_vector(0 to 7);
    Dbg_Capture_2 : out std_logic;
    Dbg_Shift_2   : out std_logic;
    Dbg_Update_2  : out std_logic;
    Dbg_Rst_2     : out std_logic;

    Dbg_Clk_3     : out std_logic;
    Dbg_TDI_3     : out std_logic;
    Dbg_TDO_3     : in  std_logic;
    Dbg_Reg_En_3  : out std_logic_vector(0 to 7);
    Dbg_Capture_3 : out std_logic;
    Dbg_Shift_3   : out std_logic;
    Dbg_Update_3  : out std_logic;
    Dbg_Rst_3     : out std_logic;

    Dbg_Clk_4     : out std_logic;
    Dbg_TDI_4     : out std_logic;
    Dbg_TDO_4     : in  std_logic;
    Dbg_Reg_En_4  : out std_logic_vector(0 to 7);
    Dbg_Capture_4 : out std_logic;
    Dbg_Shift_4   : out std_logic;
    Dbg_Update_4  : out std_logic;
    Dbg_Rst_4     : out std_logic;

    Dbg_Clk_5     : out std_logic;
    Dbg_TDI_5     : out std_logic;
    Dbg_TDO_5     : in  std_logic;
    Dbg_Reg_En_5  : out std_logic_vector(0 to 7);
    Dbg_Capture_5 : out std_logic;
    Dbg_Shift_5   : out std_logic;
    Dbg_Update_5  : out std_logic;
    Dbg_Rst_5     : out std_logic;

    Dbg_Clk_6     : out std_logic;
    Dbg_TDI_6     : out std_logic;
    Dbg_TDO_6     : in  std_logic;
    Dbg_Reg_En_6  : out std_logic_vector(0 to 7);
    Dbg_Capture_6 : out std_logic;
    Dbg_Shift_6   : out std_logic;
    Dbg_Update_6  : out std_logic;
    Dbg_Rst_6     : out std_logic;

    Dbg_Clk_7     : out std_logic;
    Dbg_TDI_7     : out std_logic;
    Dbg_TDO_7     : in  std_logic;
    Dbg_Reg_En_7  : out std_logic_vector(0 to 7);
    Dbg_Capture_7 : out std_logic;
    Dbg_Shift_7   : out std_logic;
    Dbg_Update_7  : out std_logic;
    Dbg_Rst_7     : out std_logic;

-- Connect the BSCAN's USER1 + common signals to the external pins
-- These signals can be connected to an ICON core instantiated by the user
-- Will not be used if the ICON is inserted within the mdm

    bscan_tdi     : out std_logic;
    bscan_reset   : out std_logic;
    bscan_shift   : out std_logic;
    bscan_update  : out std_logic;
    bscan_capture : out std_logic;
    bscan_sel1    : out std_logic;
    bscan_drck1   : out std_logic;
    bscan_tdo1    : in  std_logic;

    ---------------------------------------------------------------------------
    -- External JTAG ports
    ---------------------------------------------------------------------------

    Ext_JTAG_DRCK    : out std_logic;
    Ext_JTAG_RESET   : out std_logic;
    Ext_JTAG_SEL     : out std_logic;
    Ext_JTAG_CAPTURE : out std_logic;
    Ext_JTAG_SHIFT   : out std_logic;
    Ext_JTAG_UPDATE  : out std_logic;
    Ext_JTAG_TDI     : out std_logic;
    Ext_JTAG_TDO     : in  std_logic

  );

end entity MDM;

architecture IMP of MDM is

  --------------------------------------------------------------------------
  -- Constant declarations
  --------------------------------------------------------------------------

  constant ZEROES : std_logic_vector(31 downto 0) := X"00000000";

  constant C_ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE := (
    -- Registers Base Address (not used)
    ZEROES & C_BASEADDR,
    ZEROES & (C_BASEADDR or X"0000000F")
  );

  constant C_ARD_NUM_CE_ARRAY : INTEGER_ARRAY_TYPE := (
    0 => 4
  );

  constant C_S_AXI_MIN_SIZE : std_logic_vector(31 downto 0) := X"0000000F";
  constant C_USE_WSTRB      : integer                       := 0;
  constant C_DPHASE_TIMEOUT : integer                       := 4;

  --------------------------------------------------------------------------
  -- Component declarations
  --------------------------------------------------------------------------  

  component MDM_Core
    generic (
      C_BASEADDR            : std_logic_vector(0 to 31);
      C_HIGHADDR            : std_logic_vector(0 to 31);
      C_INTERCONNECT        : integer := 0;
      C_SPLB_AWIDTH         : integer := 32;
      C_SPLB_DWIDTH         : integer := 32;
      C_SPLB_P2P            : integer := 0;
      C_SPLB_MID_WIDTH      : integer := 3;
      C_SPLB_NUM_MASTERS    : integer := 8;
      C_SPLB_NATIVE_DWIDTH  : integer := 32;
      C_SPLB_SUPPORT_BURSTS : integer := 0;
      C_MB_DBG_PORTS        : integer;
      C_USE_UART            : integer;
      C_UART_WIDTH          : integer := 8);

    port (
      -- Global signals
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;

      Interrupt     : out std_logic;
      Ext_BRK       : out std_logic;
      Ext_NM_BRK    : out std_logic;
      Debug_SYS_Rst : out std_logic;

      -- PLBv46 signals
      PLB_ABus       : in std_logic_vector(0 to 31);
      PLB_UABus      : in std_logic_vector(0 to 31);
      PLB_PAValid    : in std_logic;
      PLB_SAValid    : in std_logic;
      PLB_rdPrim     : in std_logic;
      PLB_wrPrim     : in std_logic;
      PLB_masterID   : in std_logic_vector(0 to C_SPLB_MID_WIDTH-1);
      PLB_abort      : in std_logic;
      PLB_busLock    : in std_logic;
      PLB_RNW        : in std_logic;
      PLB_BE         : in std_logic_vector(0 to (C_SPLB_DWIDTH/8) - 1);
      PLB_MSize      : in std_logic_vector(0 to 1);
      PLB_size       : in std_logic_vector(0 to 3);
      PLB_type       : in std_logic_vector(0 to 2);
      PLB_lockErr    : in std_logic;
      PLB_wrDBus     : in std_logic_vector(0 to C_SPLB_DWIDTH-1);
      PLB_wrBurst    : in std_logic;
      PLB_rdBurst    : in std_logic;
      PLB_wrPendReq  : in std_logic;
      PLB_rdPendReq  : in std_logic;
      PLB_wrPendPri  : in std_logic_vector(0 to 1);
      PLB_rdPendPri  : in std_logic_vector(0 to 1);
      PLB_reqPri     : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);

      Sl_addrAck     : out std_logic;
      Sl_SSize       : out std_logic_vector(0 to 1);
      Sl_wait        : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck      : out std_logic;
      Sl_wrComp      : out std_logic;
      Sl_wrBTerm     : out std_logic;
      Sl_rdDBus      : out std_logic_vector(0 to C_SPLB_DWIDTH-1);
      Sl_rdWdAddr    : out std_logic_vector(0 to 3);
      Sl_rdDAck      : out std_logic;
      Sl_rdComp      : out std_logic;
      Sl_rdBTerm     : out std_logic;
      Sl_MBusy       : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
      Sl_MWrErr      : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
      Sl_MRdErr      : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
      Sl_MIRQ        : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);

      -- AXI IPIC signals
      bus2ip_clk    : in  std_logic;
      bus2ip_resetn : in  std_logic;
      bus2ip_data   : in  std_logic_vector(0 to 7);
      bus2ip_rdce   : in  std_logic_vector(0 to 3);
      bus2ip_wrce   : in  std_logic_vector(0 to 3);
      bus2ip_cs     : in  std_logic;
      ip2bus_rdack  : out std_logic;
      ip2bus_wrack  : out std_logic;
      ip2bus_error  : out std_logic;
      ip2bus_data   : out std_logic_vector(0 to 7);

      -- JTAG signals
      TDI     : in  std_logic;
      RESET   : in  std_logic;
      UPDATE  : in  std_logic;
      SHIFT   : in  std_logic;
      CAPTURE : in  std_logic;
      SEL     : in  std_logic;
      DRCK    : in  std_logic;
      TDO     : out std_logic;

      -- MicroBlaze Debug Signals
      Dbg_Clk_0     : out std_logic;
      Dbg_TDI_0     : out std_logic;
      Dbg_TDO_0     : in  std_logic;
      Dbg_Reg_En_0  : out std_logic_vector(0 to 7);
      Dbg_Capture_0 : out std_logic;
      Dbg_Shift_0   : out std_logic;
      Dbg_Update_0  : out std_logic;
      Dbg_Rst_0     : out std_logic;

      Dbg_Clk_1     : out std_logic;
      Dbg_TDI_1     : out std_logic;
      Dbg_TDO_1     : in  std_logic;
      Dbg_Reg_En_1  : out std_logic_vector(0 to 7);
      Dbg_Capture_1 : out std_logic;
      Dbg_Shift_1   : out std_logic;
      Dbg_Update_1  : out std_logic;
      Dbg_Rst_1     : out std_logic;

      Dbg_Clk_2     : out std_logic;
      Dbg_TDI_2     : out std_logic;
      Dbg_TDO_2     : in  std_logic;
      Dbg_Reg_En_2  : out std_logic_vector(0 to 7);
      Dbg_Capture_2 : out std_logic;
      Dbg_Shift_2   : out std_logic;
      Dbg_Update_2  : out std_logic;
      Dbg_Rst_2     : out std_logic;

      Dbg_Clk_3     : out std_logic;
      Dbg_TDI_3     : out std_logic;
      Dbg_TDO_3     : in  std_logic;
      Dbg_Reg_En_3  : out std_logic_vector(0 to 7);
      Dbg_Capture_3 : out std_logic;
      Dbg_Shift_3   : out std_logic;
      Dbg_Update_3  : out std_logic;
      Dbg_Rst_3     : out std_logic;

      Dbg_Clk_4     : out std_logic;
      Dbg_TDI_4     : out std_logic;
      Dbg_TDO_4     : in  std_logic;
      Dbg_Reg_En_4  : out std_logic_vector(0 to 7);
      Dbg_Capture_4 : out std_logic;
      Dbg_Shift_4   : out std_logic;
      Dbg_Update_4  : out std_logic;
      Dbg_Rst_4     : out std_logic;

      Dbg_Clk_5     : out std_logic;
      Dbg_TDI_5     : out std_logic;
      Dbg_TDO_5     : in  std_logic;
      Dbg_Reg_En_5  : out std_logic_vector(0 to 7);
      Dbg_Capture_5 : out std_logic;
      Dbg_Shift_5   : out std_logic;
      Dbg_Update_5  : out std_logic;
      Dbg_Rst_5     : out std_logic;

      Dbg_Clk_6     : out std_logic;
      Dbg_TDI_6     : out std_logic;
      Dbg_TDO_6     : in  std_logic;
      Dbg_Reg_En_6  : out std_logic_vector(0 to 7);
      Dbg_Capture_6 : out std_logic;
      Dbg_Shift_6   : out std_logic;
      Dbg_Update_6  : out std_logic;
      Dbg_Rst_6     : out std_logic;

      Dbg_Clk_7     : out std_logic;
      Dbg_TDI_7     : out std_logic;
      Dbg_TDO_7     : in  std_logic;
      Dbg_Reg_En_7  : out std_logic_vector(0 to 7);
      Dbg_Capture_7 : out std_logic;
      Dbg_Shift_7   : out std_logic;
      Dbg_Update_7  : out std_logic;
      Dbg_Rst_7     : out std_logic;

      Ext_JTAG_DRCK    : out std_logic;
      Ext_JTAG_RESET   : out std_logic;
      Ext_JTAG_SEL     : out std_logic;
      Ext_JTAG_CAPTURE : out std_logic;
      Ext_JTAG_SHIFT   : out std_logic;
      Ext_JTAG_UPDATE  : out std_logic;
      Ext_JTAG_TDI     : out std_logic;
      Ext_JTAG_TDO     : in  std_logic

    );
  end component MDM_Core;

  --------------------------------------------------------------------------
  -- Functions
  --------------------------------------------------------------------------  

  --
  -- The native_bscan function returns the native BSCAN primitive for the given
  -- family. This funtion needs to be revised for every new architecture.
  --
  function native_bscan (C_FAMILY     : string)
    return proc_common_v3_00_a.family_support.primitives_type is
  begin
    if supported(C_FAMILY, u_BSCANE2) then return u_BSCANE2;  -- 7 series
    elsif supported(C_FAMILY, u_BSCAN_VIRTEX6) then return u_BSCAN_VIRTEX6;
    elsif supported(C_FAMILY, u_BSCAN_VIRTEX5) then return u_BSCAN_VIRTEX5;
    elsif supported(C_FAMILY, u_BSCAN_VIRTEX4) then return u_BSCAN_VIRTEX4;
    elsif supported(C_FAMILY, u_BSCAN_SPARTAN6) then return u_BSCAN_SPARTAN6;
    elsif supported(C_FAMILY, u_BSCAN_SPARTAN3A) then return u_BSCAN_SPARTAN3A;
    elsif supported(C_FAMILY, u_BSCAN_SPARTAN3) then return u_BSCAN_SPARTAN3;
    else
      assert false
        report "Function native_bscan : No BSCAN available for " & C_FAMILY
        severity error;
      return u_BSCANE2;  -- To prevent simulator warnings
    end if;
  end;

  --------------------------------------------------------------------------
  -- Signal declarations
  --------------------------------------------------------------------------
  signal tdi     : std_logic;
  signal reset   : std_logic;
  signal update  : std_logic;
  signal capture : std_logic;
  signal shift   : std_logic;
  signal sel     : std_logic;
  signal drck    : std_logic;
  signal tdo     : std_logic;

  signal tdo1  : std_logic;
  signal sel1  : std_logic;
  signal drck1 : std_logic;

  signal drck_i   : std_logic;
  signal drck1_i  : std_logic;
  signal update_i : std_logic;

  signal bus2ip_clk    : std_logic;
  signal bus2ip_resetn : std_logic;
  signal ip2bus_data   : std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0) := (others => '0');
  signal ip2bus_error  : std_logic                                         := '0';
  signal ip2bus_wrack  : std_logic                                         := '0';
  signal ip2bus_rdack  : std_logic                                         := '0';
  signal bus2ip_data   : std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
  signal bus2ip_cs     : std_logic_vector(((C_ARD_ADDR_RANGE_ARRAY'length)/2)-1 downto 0);
  signal bus2ip_rdce   : std_logic_vector(calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal bus2ip_wrce   : std_logic_vector(calc_num_ce(C_ARD_NUM_CE_ARRAY)-1 downto 0);

  --------------------------------------------------------------------------
  -- Attibute declarations
  --------------------------------------------------------------------------
  attribute period           : string;
  attribute period of update : signal is "200 ns";

  attribute buffer_type                : string;
  attribute buffer_type of update_i    : signal is "none";
  attribute buffer_type of update      : signal   is "none";
  attribute buffer_type of MDM_Core_I1 : label is "none";

begin  -- architecture IMP
  
  -- Connect USER1 signal to external ports
  tdo1 <= bscan_tdo1;

  bscan_drck1   <= drck1;
  bscan_sel1    <= sel1;
  bscan_tdi     <= tdi;
  bscan_reset   <= reset;
  bscan_shift   <= shift;
  bscan_update  <= update;
  bscan_capture <= capture;

  Use_Spartan3       : if native_bscan(C_FAMILY) = u_BSCAN_SPARTAN3 generate
  begin
    BSCAN_SPARTAN3_I : BSCAN_SPARTAN3
      port map (
        UPDATE  => update_i,            -- [out std_logic]
        SHIFT   => shift,               -- [out std_logic]
        RESET   => reset,               -- [out std_logic]
        TDI     => tdi,                 -- [out std_logic]
        SEL1    => sel1,                -- [out std_logic]
        DRCK1   => drck1_i,             -- [out std_logic]
        SEL2    => sel,                 -- [out std_logic]
        DRCK2   => drck_i,              -- [out std_logic]
        CAPTURE => capture,             -- [out std_logic]
        TDO1    => tdo1,                -- [in  std_logic]
        TDO2    => tdo                  -- [in  std_logic]
      );
  end generate Use_Spartan3;

  Use_Spartan3A       : if native_bscan(C_FAMILY) = u_BSCAN_SPARTAN3A generate
  begin
    BSCAN_SPARTAN3A_I : BSCAN_SPARTAN3A
      port map (
        TCK     => open,                -- [out std_logic]
        TMS     => open,                -- [out std_logic]
        CAPTURE => capture,             -- [out std_logic]
        UPDATE  => update_i,            -- [out std_logic]
        SHIFT   => shift,               -- [out std_logic]
        RESET   => reset,               -- [out std_logic]
        TDI     => tdi,                 -- [out std_logic]
        SEL1    => sel1,                -- [out std_logic]
        SEL2    => sel,                 -- [out std_logic]
        DRCK1   => drck1_i,             -- [out std_logic]
        DRCK2   => drck_i,              -- [out std_logic]
        TDO1    => tdo1,                -- [in  std_logic]
        TDO2    => tdo                  -- [in  std_logic]
      );
  end generate Use_Spartan3A;

  Use_Spartan6       : if native_bscan(C_FAMILY) = u_BSCAN_SPARTAN6 generate
  begin
    BSCAN_SPARTAN6_I : BSCAN_SPARTAN6
      generic map (
        JTAG_CHAIN => C_JTAG_CHAIN)
      port map (
        CAPTURE    => capture,
        DRCK       => drck_i,
        RESET      => reset,
        RUNTEST    => open,
        SEL        => sel,
        SHIFT      => shift,
        TCK        => open,
        TDI        => tdi,
        TMS        => open,
        UPDATE     => update_i,
        TDO        => tdo);

    -- Ground signals pretending to be CHAIN 1
    -- This does not actually use CHAIN 1
    sel1    <= '0';
    drck1_i <= '0';

    -- tdo1 is unused

  end generate Use_Spartan6;

  Use_Virtex4       : if native_bscan(C_FAMILY) = u_BSCAN_VIRTEX4 generate
  begin
    BSCAN_VIRTEX4_I : BSCAN_VIRTEX4
      generic map (
        JTAG_CHAIN => C_JTAG_CHAIN)
      port map (
        TDO        => tdo,              -- [in  std_logic]
        UPDATE     => update_i,         -- [out std_logic]
        SHIFT      => shift,            -- [out std_logic]
        RESET      => reset,            -- [out std_logic]
        TDI        => tdi,              -- [out std_logic]
        SEL        => sel,              -- [out std_logic]
        DRCK       => drck_i,           -- [out std_logic]
        CAPTURE    => capture);         -- [out std_logic]

    -- Ground signals pretending to be CHAIN 1
    -- This does not actually use CHAIN 1
    sel1    <= '0';
    drck1_i <= '0';

    -- tdo1 is unused

  end generate Use_Virtex4;

  Use_Virtex5       : if native_bscan(C_FAMILY) = u_BSCAN_VIRTEX5 generate
  begin
    BSCAN_VIRTEX5_I : BSCAN_VIRTEX5
      generic map (
        JTAG_CHAIN => C_JTAG_CHAIN)
      port map (
        TDO        => tdo,              -- [in  std_logic]
        UPDATE     => update_i,         -- [out std_logic]
        SHIFT      => shift,            -- [out std_logic]
        RESET      => reset,            -- [out std_logic]
        TDI        => tdi,              -- [out std_logic]
        SEL        => sel,              -- [out std_logic]
        DRCK       => drck_i,           -- [out std_logic]
        CAPTURE    => capture);         -- [out std_logic]

    -- Ground signals pretending to be CHAIN 1
    -- This does not actually use CHAIN 1
    sel1    <= '0';
    drck1_i <= '0';

    -- tdo1 is unused

  end generate Use_Virtex5;

  Use_Virtex6       : if native_bscan(C_FAMILY) = u_BSCAN_VIRTEX6 generate
  begin
    BSCAN_VIRTEX6_I : BSCAN_VIRTEX6
      generic map (
        DISABLE_JTAG => false,
        JTAG_CHAIN   => C_JTAG_CHAIN)
      port map (
        CAPTURE      => capture,
        DRCK         => drck_i,
        RESET        => reset,
        RUNTEST      => open,
        SEL          => sel,
        SHIFT        => shift,
        TCK          => open,
        TDI          => tdi,
        TMS          => open,
        UPDATE       => update_i,
        TDO          => tdo
      );

    -- Ground signals pretending to be CHAIN 1
    -- This does not actually use CHAIN 1
    sel1    <= '0';
    drck1_i <= '0';

    -- tdo1 is unused

  end generate Use_Virtex6;

  Use_E2       : if native_bscan(C_FAMILY) = u_BSCANE2 generate
  begin
    BSCANE2_I : BSCANE2
      generic map (
        DISABLE_JTAG => "FALSE",
        JTAG_CHAIN   => C_JTAG_CHAIN)
      port map (
        CAPTURE      => capture,          -- [out std_logic]
        DRCK         => drck_i,           -- [out std_logic]
        RESET        => reset,            -- [out std_logic]
        RUNTEST      => open,             -- [out std_logic]
        SEL          => sel,              -- [out std_logic]
        SHIFT        => shift,            -- [out std_logic]
        TCK          => open,             -- [out std_logic]
        TDI          => tdi,              -- [out std_logic]
        TMS          => open,             -- [out std_logic]
        UPDATE       => update_i,         -- [out std_logic]
        TDO          => tdo);             -- [in  std_logic]

    -- Ground signals pretending to be CHAIN 1
    -- This does not actually use CHAIN 1
    sel1    <= '0';
    drck1_i <= '0';

    -- tdo1 is unused

  end generate Use_E2;

  BUFG_DRCK1 : BUFG
    port map (
      O => drck1,
      I => drck1_i
    );

-- drck1 <= drck1_i;

  BUFG_DRCK : BUFG
    port map (
      O => drck,
      I => drck_i
    );

-- drck <= drck_i;

-- BUFG_UPDATE : BUFG
-- port map (
-- O => update,
-- I => update_i
-- );

  update <= update_i;

  ---------------------------------------------------------------------------
  -- MDM core
  ---------------------------------------------------------------------------
  MDM_Core_I1 : MDM_Core
    generic map (
      C_BASEADDR            => C_BASEADDR,  -- [std_logic_vector(0 to 31)]
      C_HIGHADDR            => C_HIGHADDR,  -- [std_logic_vector(0 to 31)]
      C_INTERCONNECT        => C_INTERCONNECT,
      C_SPLB_AWIDTH         => C_SPLB_AWIDTH,  -- [integer = 32]
      C_SPLB_DWIDTH         => C_SPLB_DWIDTH,  -- [integer = 32]
      C_SPLB_P2P            => C_SPLB_P2P,  -- [integer = 0]
      C_SPLB_MID_WIDTH      => C_SPLB_MID_WIDTH,  -- [integer = 3]
      C_SPLB_NUM_MASTERS    => C_SPLB_NUM_MASTERS,  -- [integer = 8]
      C_SPLB_NATIVE_DWIDTH  => C_SPLB_NATIVE_DWIDTH,  -- [integer = 32]
      C_SPLB_SUPPORT_BURSTS => C_SPLB_SUPPORT_BURSTS,  -- [integer = 0]
      C_MB_DBG_PORTS        => C_MB_DBG_PORTS,  -- [integer]
      C_USE_UART            => C_USE_UART,  -- [integer]
      C_UART_WIDTH          => 8  -- [integer]
    )

    port map (
      -- Global signals
      SPLB_Clk => SPLB_Clk,             -- [in  std_logic]
      SPLB_Rst => SPLB_Rst,             -- [in  std_logic]

      Interrupt     => Interrupt,       -- [out std_logic]
      Ext_BRK       => Ext_BRK,         -- [out std_logic]
      Ext_NM_BRK    => Ext_NM_BRK,      -- [out std_logic]
      Debug_SYS_Rst => Debug_SYS_Rst,   -- [out std_logic]

      -- PLBv46 signals
      PLB_ABus       => PLB_ABus,       -- [in  std_logic_vector(0 to 31)]
      PLB_UABus      => PLB_UABus,      -- [in  std_logic_vector(0 to 31)]
      PLB_PAValid    => PLB_PAValid,    -- [in  std_logic]
      PLB_SAValid    => PLB_SAValid,    -- [in  std_logic]
      PLB_rdPrim     => PLB_rdPrim,     -- [in  std_logic]
      PLB_wrPrim     => PLB_wrPrim,     -- [in  std_logic]
      PLB_masterID   => PLB_masterID,   -- [in  std_logic_vector(0 to C_SPLB_MID_WIDTH-1)]
      PLB_abort      => PLB_abort,      -- [in  std_logic]
      PLB_busLock    => PLB_busLock,    -- [in  std_logic]
      PLB_RNW        => PLB_RNW,        -- [in  std_logic]
      PLB_BE         => PLB_BE,         -- [in  std_logic_vector(0 to (C_SPLB_DWIDTH/8) - 1)]
      PLB_MSize      => PLB_MSize,      -- [in  std_logic_vector(0 to 1)]
      PLB_size       => PLB_size,       -- [in  std_logic_vector(0 to 3)]
      PLB_type       => PLB_type,       -- [in  std_logic_vector(0 to 2)]
      PLB_lockErr    => PLB_lockErr,    -- [in  std_logic]
      PLB_wrDBus     => PLB_wrDBus,     -- [in  std_logic_vector(0 to C_SPLB_DWIDTH-1)]
      PLB_wrBurst    => PLB_wrBurst,    -- [in  std_logic]
      PLB_rdBurst    => PLB_rdBurst,    -- [in  std_logic]
      PLB_wrPendReq  => PLB_wrPendReq,  -- [in  std_logic]
      PLB_rdPendReq  => PLB_rdPendReq,  -- [in  std_logic]
      PLB_wrPendPri  => PLB_wrPendPri,  -- [in  std_logic_vector(0 to 1)]
      PLB_rdPendPri  => PLB_rdPendPri,  -- [in  std_logic_vector(0 to 1)]
      PLB_reqPri     => PLB_reqPri,     -- [in  std_logic_vector(0 to 1)]
      PLB_TAttribute => PLB_TAttribute, -- [in  std_logic_vector(0 to 15)]

      Sl_addrAck     => Sl_addrAck,     -- [out std_logic]
      Sl_SSize       => Sl_SSize,       -- [out std_logic_vector(0 to 1)]
      Sl_wait        => Sl_wait,        -- [out std_logic]
      Sl_rearbitrate => Sl_rearbitrate, -- [out std_logic]
      Sl_wrDAck      => Sl_wrDAck,      -- [out std_logic]
      Sl_wrComp      => Sl_wrComp,      -- [out std_logic]
      Sl_wrBTerm     => Sl_wrBTerm,     -- [out std_logic]
      Sl_rdDBus      => Sl_rdDBus,      -- [out std_logic_vector(0 to C_SPLB_DWIDTH-1)]
      Sl_rdWdAddr    => Sl_rdWdAddr,    -- [out std_logic_vector(0 to 3)]
      Sl_rdDAck      => Sl_rdDAck,      -- [out std_logic]
      Sl_rdComp      => Sl_rdComp,      -- [out std_logic]
      Sl_rdBTerm     => Sl_rdBTerm,     -- [out std_logic]
      Sl_MBusy       => Sl_MBusy,       -- [out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1)]
      Sl_MWrErr      => Sl_MWrErr,      -- [out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1)]
      Sl_MRdErr      => Sl_MRdErr,      -- [out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1)]
      Sl_MIRQ        => Sl_MIRQ,        -- [out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1)]

      -- AXI IPIC signals
      bus2ip_clk    => bus2ip_clk,
      bus2ip_resetn => bus2ip_resetn,
      bus2ip_data   => bus2ip_data(7 downto 0),
      bus2ip_rdce   => bus2ip_rdce(3 downto 0),
      bus2ip_wrce   => bus2ip_wrce(3 downto 0),
      bus2ip_cs     => bus2ip_cs(0),
      ip2bus_rdack  => ip2bus_rdack,
      ip2bus_wrack  => ip2bus_wrack,
      ip2bus_error  => ip2bus_error,
      ip2bus_data   => ip2bus_data(7 downto 0),

      -- JTAG signals
      TDI     => tdi,                   -- [in  std_logic]
      RESET   => reset,                 -- [in  std_logic]
      UPDATE  => update,                -- [in  std_logic]
      SHIFT   => shift,                 -- [in  std_logic]
      CAPTURE => capture,               -- [in  std_logic]
      SEL     => sel,                   -- [in  std_logic]
      DRCK    => drck,                  -- [in  std_logic]
      TDO     => tdo,                   -- [out std_logic]

      -- MicroBlaze Debug Signals
      Dbg_Clk_0     => Dbg_Clk_0,       -- [out std_logic]
      Dbg_TDI_0     => Dbg_TDI_0,       -- [out std_logic]
      Dbg_TDO_0     => Dbg_TDO_0,       -- [in  std_logic]
      Dbg_Reg_En_0  => Dbg_Reg_En_0,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_0 => Dbg_Capture_0,   -- [out std_logic]
      Dbg_Shift_0   => Dbg_Shift_0,     -- [out std_logic]
      Dbg_Update_0  => Dbg_Update_0,    -- [out std_logic]
      Dbg_Rst_0     => Dbg_Rst_0,       -- [out std_logic]

      Dbg_Clk_1     => Dbg_Clk_1,       -- [out std_logic]
      Dbg_TDI_1     => Dbg_TDI_1,       -- [out std_logic]
      Dbg_TDO_1     => Dbg_TDO_1,       -- [in  std_logic]
      Dbg_Reg_En_1  => Dbg_Reg_En_1,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_1 => Dbg_Capture_1,   -- [out std_logic]
      Dbg_Shift_1   => Dbg_Shift_1,     -- [out std_logic]
      Dbg_Update_1  => Dbg_Update_1,    -- [out std_logic]
      Dbg_Rst_1     => Dbg_Rst_1,       -- [out std_logic]

      Dbg_Clk_2     => Dbg_Clk_2,       -- [out std_logic]
      Dbg_TDI_2     => Dbg_TDI_2,       -- [out std_logic]
      Dbg_TDO_2     => Dbg_TDO_2,       -- [in  std_logic]
      Dbg_Reg_En_2  => Dbg_Reg_En_2,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_2 => Dbg_Capture_2,   -- [out std_logic]
      Dbg_Shift_2   => Dbg_Shift_2,     -- [out std_logic]
      Dbg_Update_2  => Dbg_Update_2,    -- [out std_logic]
      Dbg_Rst_2     => Dbg_Rst_2,       -- [out std_logic]

      Dbg_Clk_3     => Dbg_Clk_3,       -- [out std_logic]
      Dbg_TDI_3     => Dbg_TDI_3,       -- [out std_logic]
      Dbg_TDO_3     => Dbg_TDO_3,       -- [in  std_logic]
      Dbg_Reg_En_3  => Dbg_Reg_En_3,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_3 => Dbg_Capture_3,   -- [out std_logic]
      Dbg_Shift_3   => Dbg_Shift_3,     -- [out std_logic]
      Dbg_Update_3  => Dbg_Update_3,    -- [out std_logic]
      Dbg_Rst_3     => Dbg_Rst_3,       -- [out std_logic]

      Dbg_Clk_4     => Dbg_Clk_4,       -- [out std_logic]
      Dbg_TDI_4     => Dbg_TDI_4,       -- [out std_logic]
      Dbg_TDO_4     => Dbg_TDO_4,       -- [in  std_logic]
      Dbg_Reg_En_4  => Dbg_Reg_En_4,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_4 => Dbg_Capture_4,   -- [out std_logic]
      Dbg_Shift_4   => Dbg_Shift_4,     -- [out std_logic]
      Dbg_Update_4  => Dbg_Update_4,    -- [out std_logic]
      Dbg_Rst_4     => Dbg_Rst_4,       -- [out std_logic]

      Dbg_Clk_5     => Dbg_Clk_5,       -- [out std_logic]
      Dbg_TDI_5     => Dbg_TDI_5,       -- [out std_logic]
      Dbg_TDO_5     => Dbg_TDO_5,       -- [in  std_logic]
      Dbg_Reg_En_5  => Dbg_Reg_En_5,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_5 => Dbg_Capture_5,   -- [out std_logic]
      Dbg_Shift_5   => Dbg_Shift_5,     -- [out std_logic]
      Dbg_Update_5  => Dbg_Update_5,    -- [out std_logic]
      Dbg_Rst_5     => Dbg_Rst_5,       -- [out std_logic]

      Dbg_Clk_6     => Dbg_Clk_6,       -- [out std_logic]
      Dbg_TDI_6     => Dbg_TDI_6,       -- [out std_logic]
      Dbg_TDO_6     => Dbg_TDO_6,       -- [in  std_logic]
      Dbg_Reg_En_6  => Dbg_Reg_En_6,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_6 => Dbg_Capture_6,   -- [out std_logic]
      Dbg_Shift_6   => Dbg_Shift_6,     -- [out std_logic]
      Dbg_Update_6  => Dbg_Update_6,    -- [out std_logic]
      Dbg_Rst_6     => Dbg_Rst_6,       -- [out std_logic]

      Dbg_Clk_7     => Dbg_Clk_7,       -- [out std_logic]
      Dbg_TDI_7     => Dbg_TDI_7,       -- [out std_logic]
      Dbg_TDO_7     => Dbg_TDO_7,       -- [in  std_logic]
      Dbg_Reg_En_7  => Dbg_Reg_En_7,    -- [out std_logic_vector(0 to 7)]
      Dbg_Capture_7 => Dbg_Capture_7,   -- [out std_logic]
      Dbg_Shift_7   => Dbg_Shift_7,     -- [out std_logic]
      Dbg_Update_7  => Dbg_Update_7,    -- [out std_logic]
      Dbg_Rst_7     => Dbg_Rst_7,       -- [out std_logic]

      Ext_JTAG_DRCK    => Ext_JTAG_DRCK,
      Ext_JTAG_RESET   => Ext_JTAG_RESET,
      Ext_JTAG_SEL     => Ext_JTAG_SEL,
      Ext_JTAG_CAPTURE => Ext_JTAG_CAPTURE,
      Ext_JTAG_SHIFT   => Ext_JTAG_SHIFT,
      Ext_JTAG_UPDATE  => Ext_JTAG_UPDATE,
      Ext_JTAG_TDI     => Ext_JTAG_TDI,
      Ext_JTAG_TDO     => Ext_JTAG_TDO
    );

  Use_PLB : if (C_INTERCONNECT = 1) generate
  begin
    -- Unused AXI output signals
    S_AXI_AWREADY <= '0';
    S_AXI_WREADY  <= '0';
    S_AXI_BRESP   <= (others => '0');
    S_AXI_BVALID  <= '0';
    S_AXI_ARREADY <= '0';
    S_AXI_RDATA   <= (others => '0');
    S_AXI_RRESP   <= (others => '0');
    S_AXI_RVALID  <= '0';
  end generate Use_PLB;

  Use_AXI_IPIF : if (C_INTERCONNECT = 2) generate
  begin
    -- ip2bus_data assignment - as core is using maximum of 8 bits
    ip2bus_data((C_S_AXI_DATA_WIDTH-1) downto 8) <= (others => '0');

    ---------------------------------------------------------------------------
    -- AXI lite IPIF
    ---------------------------------------------------------------------------
    AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
      generic map (
        C_FAMILY               => C_FAMILY,
        C_S_AXI_ADDR_WIDTH     => C_S_AXI_ADDR_WIDTH,
        C_S_AXI_DATA_WIDTH     => C_S_AXI_DATA_WIDTH,
        C_S_AXI_MIN_SIZE       => C_S_AXI_MIN_SIZE,
        C_USE_WSTRB            => C_USE_WSTRB,
        C_DPHASE_TIMEOUT       => C_DPHASE_TIMEOUT,
        C_ARD_ADDR_RANGE_ARRAY => C_ARD_ADDR_RANGE_ARRAY,
        C_ARD_NUM_CE_ARRAY     => C_ARD_NUM_CE_ARRAY
      )

      port map(
        S_AXI_ACLK    => S_AXI_ACLK,
        S_AXI_ARESETN => S_AXI_ARESETN,
        S_AXI_AWADDR  => S_AXI_AWADDR,
        S_AXI_AWVALID => S_AXI_AWVALID,
        S_AXI_AWREADY => S_AXI_AWREADY,
        S_AXI_WDATA   => S_AXI_WDATA,
        S_AXI_WSTRB   => S_AXI_WSTRB,
        S_AXI_WVALID  => S_AXI_WVALID,
        S_AXI_WREADY  => S_AXI_WREADY,
        S_AXI_BRESP   => S_AXI_BRESP,
        S_AXI_BVALID  => S_AXI_BVALID,
        S_AXI_BREADY  => S_AXI_BREADY,
        S_AXI_ARADDR  => S_AXI_ARADDR,
        S_AXI_ARVALID => S_AXI_ARVALID,
        S_AXI_ARREADY => S_AXI_ARREADY,
        S_AXI_RDATA   => S_AXI_RDATA,
        S_AXI_RRESP   => S_AXI_RRESP,
        S_AXI_RVALID  => S_AXI_RVALID,
        S_AXI_RREADY  => S_AXI_RREADY,

        -- IP Interconnect (IPIC) port signals
        Bus2IP_Clk    => bus2ip_clk,
        Bus2IP_Resetn => bus2ip_resetn,
        IP2Bus_Data   => ip2bus_data,
        IP2Bus_WrAck  => ip2bus_wrack,
        IP2Bus_RdAck  => ip2bus_rdack,
        IP2Bus_Error  => ip2bus_error,
        Bus2IP_Addr   => open,
        Bus2IP_Data   => bus2ip_data,
        Bus2IP_RNW    => open,
        Bus2IP_BE     => open,
        Bus2IP_CS     => bus2ip_cs,
        Bus2IP_RdCE   => bus2ip_rdce,
        Bus2IP_WrCE   => bus2ip_wrce
      );

  end generate Use_AXI_IPIF;

end architecture IMP;
