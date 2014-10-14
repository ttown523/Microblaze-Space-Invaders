-------------------------------------------------------------------------------
-- $Id: plb_interface.vhd,v 1.1.2.3 2010/10/11 08:21:49 rolandp Exp $
-------------------------------------------------------------------------------
--
-- (c) Copyright [2003] - [2011] Xilinx, Inc. All rights reserved.
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
-- PART OF THIS FILE AT ALL TIMES
--
------------------------------------------------------------------------------
-- Filename:        plb_interface.vhd
--
-- Description:
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--              plb_interface
--                pselect_mask
-------------------------------------------------------------------------------
-- Author:          rolandp
-- Revision:        $Revision: 1.1.2.3 $
-- Date:            $Date: 2010/10/11 08:21:49 $
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
library lmb_bram_if_cntlr_v3_00_b;
use lmb_bram_if_cntlr_v3_00_b.all;

entity plb_interface is
  generic (
    C_SPLB_BASEADDR       : std_logic_vector(0 to 31) := X"FFFF_FFFF";
    C_SPLB_HIGHADDR       : std_logic_vector(0 to 31) := X"0000_0000";
    C_SPLB_AWIDTH         : integer                   := 32;
    C_SPLB_DWIDTH         : integer                   := 32;
    C_SPLB_P2P            : integer                   := 0;
    C_SPLB_MID_WIDTH      : integer                   := 1;
    C_SPLB_NUM_MASTERS    : integer                   := 1;
    C_SPLB_SUPPORT_BURSTS : integer                   := 0;
    C_SPLB_NATIVE_DWIDTH  : integer                   := 32;
    C_DWIDTH              : integer                   := 32;
    C_REGADDR_WIDTH       : integer                   := 5);
  port (
    
    LMB_Clk        : in std_logic;
    LMB_Rst        : in std_logic;

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

    -- lmb_bram_if_cntlr signals
    RegWr          : out std_logic;
    RegWrData      : out std_logic_vector(0 to C_DWIDTH - 1);
    RegAddr        : out std_logic_vector(0 to C_REGADDR_WIDTH-1);  
    RegRdData      : in  std_logic_vector(0 to C_DWIDTH - 1));
end entity plb_interface;

library unisim;
use unisim.vcomponents.all;

architecture IMP of plb_interface is

  -----------------------------------------------------------------------------
  -- Function declaration
  -----------------------------------------------------------------------------
  function Addr_Bits (x, y : std_logic_vector(0 to C_SPLB_AWIDTH-1)) return integer is
    variable addr_nor : std_logic_vector(0 to C_SPLB_AWIDTH-1);
  begin
    addr_nor := x xor y;
    for i in 0 to C_SPLB_AWIDTH-1 loop
      if addr_nor(i) = '1' then return i;
      end if;
    end loop;
    return(C_SPLB_AWIDTH);
  end function Addr_Bits;
  
  -----------------------------------------------------------------------------
  -- Constant declaration
  -----------------------------------------------------------------------------
  constant C_AB : integer := Addr_Bits(C_SPLB_HIGHADDR, C_SPLB_BASEADDR);

  -----------------------------------------------------------------------------
  -- Component declaration
  -----------------------------------------------------------------------------
  component pselect is
    generic (
      C_AB  : integer;
      C_AW  : integer;
      C_BAR : std_logic_vector);
    port (
      A      : in  std_logic_vector(0 to C_AW-1);
      AValid : in  std_logic;
      cs     : out std_logic);
  end component pselect;

  -----------------------------------------------------------------------------
  -- Signal declaration
  -----------------------------------------------------------------------------
  signal lmb_bram_if_cntlr_CS : std_logic;  -- Valid address in a address phase
  signal valid_access         : std_logic;  -- Active during the address phase (2 clock cycles)

  signal Sl_addrAck_i         : std_logic;
  signal Sl_rdDAck_i          : std_logic;
  signal Sl_wrDAck_i          : std_logic;
  signal Sl_rdDBus_I          : std_logic_vector(0 to C_SPLB_NATIVE_DWIDTH - 1);

  signal RegRd                : std_logic;
  signal RegWr_i              : std_logic;

  signal RegRdData_i          : std_logic_vector(0 to C_DWIDTH - 1);

begin  -- architecture IMP

  -----------------------------------------------------------------------------
  -- Adjust buswidth
  -----------------------------------------------------------------------------
  Using_32_2_128_Size: if C_SPLB_DWIDTH = 128 and C_SPLB_NATIVE_DWIDTH = 32 generate
  begin
    Sl_rdDBus(0 to 31)   <=  Sl_rdDBus_i;
    Sl_rdDBus(32 to 63)  <=  Sl_rdDBus_i;
    Sl_rdDBus(64 to 95)  <=  Sl_rdDBus_i;
    Sl_rdDBus(96 to 127) <=  Sl_rdDBus_i;
  end generate Using_32_2_128_Size;
  
  Using_32_2_64_Size: if C_SPLB_DWIDTH = 64 and C_SPLB_NATIVE_DWIDTH = 32 generate
  begin
    Sl_rdDBus(0 to 31)  <=  Sl_rdDBus_i;
    Sl_rdDBus(32 to 63) <=  Sl_rdDBus_i;
  end generate Using_32_2_64_Size;
  
  Using_Equal_Size: if C_SPLB_DWIDTH = 32 and C_SPLB_NATIVE_DWIDTH = 32 generate
  begin
    Sl_rdDBus <= Sl_rddbus_i;
  end generate Using_Equal_Size;
  
  -----------------------------------------------------------------------------
  -- Handling the PLBv46 bus interface
  -----------------------------------------------------------------------------
  -- Ignoring these signals
  -- PLB_abort, PLB_UABus, PLB_busLock, PLB_lockErr, PLB_rdPendPri, PLB_wrPendPri
  -- PLB_rdPendReq, PLB_wrPendReq, PLB_rdBurst, PLB_rdPrim, PLB_reqPri, PLB_SAValid
  -- PLB_Msize, PLB_TAttribute, PLB_type, PLB_wrBurst, PLB_wrPrim

  -- Drive these signals to constant values
  Sl_MIRQ        <= (others => '0');
  Sl_rdBTerm     <= '0';
  Sl_rdWdAddr    <= (others => '0');
  Sl_wrBTerm     <= '0';
  Sl_SSize       <= "00";
  Sl_rearbitrate <= '0';              -- No rearbitration is needed
  Sl_MBusy       <= (others => '0');  -- There is no queue of outstanding accesses
  Sl_MRdErr      <= (others => '0');  -- There is no read errors accesses
  Sl_MWrErr      <= (others => '0');  -- There is no write errors accesses
  
  -- Do the PLBv46 address decoding
  pselect_I : pselect
    generic map (
      C_AB  => C_AB,
      C_AW  => 32,
      C_BAR => C_SPLB_BASEADDR)
    port map (
      A      => PLB_ABus,
      AValid => PLB_PAValid,
      cs     => lmb_bram_if_cntlr_CS);

  valid_access <= lmb_bram_if_cntlr_CS when (PLB_size = "0000") else '0';
  
  -- Respond to Valid Address
  AddrAck: process (LMB_Clk) is
  begin  -- process AddrAck
    if LMB_Clk'event and LMB_Clk = '1' then
      Sl_addrAck_i <= valid_access and not Sl_addrAck_i;
    end if;
  end process AddrAck;

  Sl_addrAck <= Sl_AddrAck_i;
  Sl_wait    <= '0';

  -- Capture address and read/write.
  Handle_Access: process (LMB_Clk) is
  begin  
    if LMB_Clk'event and LMB_Clk = '1' then
      if LMB_Rst = '1' then
        RegWr_i   <= '0';
        RegRd     <= '0';
        RegAddr   <= (others => '0');
        RegWrData <= (others => '0');
      elsif (Sl_addrAck_i = '1') then
        RegRd     <= PLB_RNW;
        RegWr_i   <= not PLB_RNW;
        RegAddr   <= PLB_ABus(29-C_REGADDR_WIDTH + 1 to 29);
        RegWrData <= PLB_wrDBus(C_SPLB_NATIVE_DWIDTH - C_DWIDTH to C_SPLB_NATIVE_DWIDTH - 1);
      else
        RegWr_i   <= '0';
        RegRd     <= '0';          
      end if;
    end if;
  end process Handle_Access;

  RegWr <= RegWr_i;
  
  -----------------------------------------------------------------------------
  -- Handling the PLBv46 bus interface
  -----------------------------------------------------------------------------
  Read_Align: process (RegRdData) is
  begin
    RegRdData_i <= (others => '0');
    RegRdData_i(C_SPLB_NATIVE_DWIDTH - C_DWIDTH to C_SPLB_NATIVE_DWIDTH - 1) <= RegRdData;
  end process Read_Align;

  Not_All_32_Bits_Are_Used: if (C_DWIDTH < C_SPLB_NATIVE_DWIDTH) generate
  begin
    Sl_rdDBus_i(0 to C_SPLB_NATIVE_DWIDTH - C_DWIDTH - 1) <= (others => '0');
  end generate Not_All_32_Bits_Are_Used;

  PLBv46_rdDBus_DFF : for I in C_SPLB_NATIVE_DWIDTH - C_DWIDTH to C_SPLB_NATIVE_DWIDTH - 1 generate
  begin
    PLBv46_rdBus_FDRE : FDRE
      port map (
        Q  => Sl_rdDBus_i(I),
        C  => LMB_Clk,
        CE => RegRd,
        D  => RegRdData_i(I),
        R  => Sl_rdDAck_i);
  end generate PLBv46_rdDBus_DFF;
  
  End_of_Transfer_Control : process (LMB_Clk) is
  begin
    if LMB_Clk'event and LMB_Clk = '1' then
      Sl_rdDAck_i <= RegRd;
      Sl_wrDAck_i <= RegWr_i;
    end if;
  end process End_of_Transfer_Control;

  Sl_rdDAck <= sl_rdDAck_i;
  Sl_rdComp <= sl_rdDAck_i;
  Sl_wrDAck <= sl_wrDAck_i;
  Sl_wrComp <= sl_wrDAck_i;
  
end architecture IMP;  

