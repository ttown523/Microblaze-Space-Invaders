-------------------------------------------------------------------------------
-- axi_vdma_lite_if
-------------------------------------------------------------------------------
--
-- *************************************************************************
--
-- (c) Copyright 2010, 2011 Xilinx, Inc. All rights reserved.
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
-- *************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:          axi_vdma_lite_if.vhd
-- Description: This entity is AXI Lite Interface Module for the AXI DMA
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--                  axi_vdma.vhd
--                   |- axi_vdma_pkg.vhd
--                   |- axi_vdma_intrpt.vhd
--                   |- axi_vdma_rst_module.vhd
--                   |   |- axi_vdma_reset.vhd (mm2s)
--                   |   |   |- axi_vdma_cdc.vhd
--                   |   |- axi_vdma_reset.vhd (s2mm)
--                   |   |   |- axi_vdma_cdc.vhd
--                   |
--                   |- axi_vdma_reg_if.vhd
--                   |   |- axi_vdma_lite_if.vhd
--                   |   |- axi_vdma_cdc.vhd (mm2s)
--                   |   |- axi_vdma_cdc.vhd (s2mm)
--                   |
--                   |- axi_vdma_sg_cdc.vhd (mm2s)
--                   |- axi_vdma_vid_cdc.vhd (mm2s)
--                   |- axi_vdma_fsync_gen.vhd (mm2s)
--                   |- axi_vdma_sof_gen.vhd (mm2s)
--                   |- axi_vdma_reg_module.vhd (mm2s)
--                   |   |- axi_vdma_register.vhd (mm2s)
--                   |   |- axi_vdma_regdirect.vhd (mm2s)
--                   |- axi_vdma_mngr.vhd (mm2s)
--                   |   |- axi_vdma_sg_if.vhd (mm2s)
--                   |   |- axi_vdma_sm.vhd (mm2s)
--                   |   |- axi_vdma_cmdsts_if.vhd (mm2s)
--                   |   |- axi_vdma_vidreg_module.vhd (mm2s)
--                   |   |   |- axi_vdma_sgregister.vhd (mm2s)
--                   |   |   |- axi_vdma_vregister.vhd (mm2s)
--                   |   |   |- axi_vdma_vaddrreg_mux.vhd (mm2s)
--                   |   |   |- axi_vdma_blkmem.vhd (mm2s)
--                   |   |- axi_vdma_genlock_mngr.vhd (mm2s)
--                   |       |- axi_vdma_genlock_mux.vhd (mm2s)
--                   |       |- axi_vdma_greycoder.vhd (mm2s)
--                   |- axi_vdma_mm2s_linebuf.vhd (mm2s)
--                   |   |- axi_vdma_sfifo_autord.vhd (mm2s)
--                   |   |- axi_vdma_afifo_autord.vhd (mm2s)
--                   |   |- axi_vdma_skid_buf.vhd (mm2s)
--                   |   |- axi_vdma_cdc.vhd (mm2s)
--                   |
--                   |- axi_vdma_sg_cdc.vhd (s2mm)
--                   |- axi_vdma_vid_cdc.vhd (s2mm)
--                   |- axi_vdma_fsync_gen.vhd (s2mm)
--                   |- axi_vdma_sof_gen.vhd (s2mm)
--                   |- axi_vdma_reg_module.vhd (s2mm)
--                   |   |- axi_vdma_register.vhd (s2mm)
--                   |   |- axi_vdma_regdirect.vhd (s2mm)
--                   |- axi_vdma_mngr.vhd (s2mm)
--                   |   |- axi_vdma_sg_if.vhd (s2mm)
--                   |   |- axi_vdma_sm.vhd (s2mm)
--                   |   |- axi_vdma_cmdsts_if.vhd (s2mm)
--                   |   |- axi_vdma_vidreg_module.vhd (s2mm)
--                   |   |   |- axi_vdma_sgregister.vhd (s2mm)
--                   |   |   |- axi_vdma_vregister.vhd (s2mm)
--                   |   |   |- axi_vdma_vaddrreg_mux.vhd (s2mm)
--                   |   |   |- axi_vdma_blkmem.vhd (s2mm)
--                   |   |- axi_vdma_genlock_mngr.vhd (s2mm)
--                   |       |- axi_vdma_genlock_mux.vhd (s2mm)
--                   |       |- axi_vdma_greycoder.vhd (s2mm)
--                   |- axi_vdma_s2mm_linebuf.vhd (s2mm)
--                   |   |- axi_vdma_sfifo_autord.vhd (s2mm)
--                   |   |- axi_vdma_afifo_autord.vhd (s2mm)
--                   |   |- axi_vdma_skid_buf.vhd (s2mm)
--                   |   |- axi_vdma_cdc.vhd (s2mm)
--                   |
--                   |- axi_datamover_v3_00_a.axi_datamover.vhd (FULL)
--                   |- axi_sg_v3_00_a.axi_sg.vhd
--
-------------------------------------------------------------------------------
-- Author:      Gary Burch
-- History:
--  GAB     7/14/10    v1_00_a
-- ^^^^^^
--  - Initial Release
-- ~~~~~~
--  GAB     9/3/10     v2_00_a
-- ^^^^^^
--  Updated to version v2_00_a
-- ~~~~~~
--  GAB     9/30/10     v2_00_a
-- ^^^^^^
-- CR577019 - Modified to accerpt back to back read/write address requests, i.e.
--            requests where arvalid or awvalid do not de-assert between requests
-- ~~~~~~
--  GAB     10/25/10     v3_00_a
-- ^^^^^^
--  Updated to version v3_00_a
-- ~~~~~~
--  GAB     2/23/11     v3_01_a
-- ^^^^^^
--  Updated to version v3_01_a
-- ~~~~~~
--  GAB     4/12/11     v3_01_a
-- ^^^^^^
-- CR605883 (CDC) need to provide pure register output to synchronizers
-- ~~~~~~
--  GAB     4/14/11     v3_01_a
-- ^^^^^^
-- CR606122 - Align awvalid_re pulse and wvalid_re pulse for proper async writes
-- ~~~~~~
--  GAB     4/14/11     v3_01_a
-- ^^^^^^
-- CR607165 - asynch operation allowed acceptance of 2nd read address prior
--          to completion of the previous reads.  CR Fixed.
-- ~~~~~~
--  GAB     6/8/11     v4_00_a
-- ^^^^^^
--  Updated to version v4_00_a for 13.3
-- ~~~~~~
--  GAB     8/10/11    v4_00_a
-- ^^^^^^
--  CR620124 - fixed issue with wr timing
-- ~~~~~~
--  GAB     8/19/11     v5_00_a
-- ^^^^^^
--  Intial release of v5_00_a
--  Added fsync on tuser(0) feature
--  Added fsync crossbar feature
--  Increased Frame Stores to 32
--  Added internal GenLock Option
-- ~~~~~~
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

library axi_vdma_v5_00_a;
use axi_vdma_v5_00_a.axi_vdma_pkg.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.clog2;


-------------------------------------------------------------------------------
entity  axi_vdma_lite_if is
    generic(
        C_NUM_CE                    : integer                := 8           ;
        C_S_AXI_LITE_ADDR_WIDTH     : integer range 32 to 32 := 32          ;
        C_S_AXI_LITE_DATA_WIDTH     : integer range 32 to 32 := 32
    );
    port (
        -----------------------------------------------------------------------         --
        -- AXI Lite Control Interface                                                   --
        -----------------------------------------------------------------------         --
        s_axi_lite_aclk             : in  std_logic                         ;           --
        s_axi_lite_aresetn          : in  std_logic                         ;           --
                                                                                        --
        -- AXI Lite Write Address Channel                                               --
        s_axi_lite_awvalid          : in  std_logic                         ;           --
        s_axi_lite_awready          : out std_logic                         ;           --
        s_axi_lite_awaddr           : in  std_logic_vector                              --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);           --
                                                                                        --
        -- AXI Lite Write Data Channel                                                  --
        s_axi_lite_wvalid           : in  std_logic                         ;           --
        s_axi_lite_wready           : out std_logic                         ;           --
        s_axi_lite_wdata            : in  std_logic_vector                              --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0);           --
                                                                                        --
        -- AXI Lite Write Response Channel                                              --
        s_axi_lite_bresp            : out std_logic_vector(1 downto 0)      ;           --
        s_axi_lite_bvalid           : out std_logic                         ;           --
        s_axi_lite_bready           : in  std_logic                         ;           --
                                                                                        --
        -- AXI Lite Read Address Channel                                                --
        s_axi_lite_arvalid          : in  std_logic                         ;           --
        s_axi_lite_arready          : out std_logic                         ;           --
        s_axi_lite_araddr           : in  std_logic_vector                              --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);           --
        s_axi_lite_rvalid           : out std_logic                         ;           --
        s_axi_lite_rready           : in  std_logic                         ;           --
        s_axi_lite_rdata            : out std_logic_vector                              --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0);           --
        s_axi_lite_rresp            : out std_logic_vector(1 downto 0)      ;           --
                                                                                        --
        -- User IP Interface                                                            --
        axi2ip_wren                 : out std_logic                         ;           --
        axi2ip_wrce                 : out std_logic_vector                              --
                                        (C_NUM_CE-1 downto 0)               ;           --
        axi2ip_wrdata               : out std_logic_vector                              --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0);           --
        axi2ip_wraddr               : out std_logic_vector                              --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);           -- CR620124
                                                                                        --
        ip2axi_wrack                : in  std_logic                         ;           -- CR620124
        axi2ip_rden                 : out std_logic                         ;           --
        axi2ip_rdce                 : out std_logic_vector                              --
                                        (C_NUM_CE-1 downto 0)               ;           --
                                                                                        --
        axi2ip_rdaddr               : out std_logic_vector                              --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);           --
        ip2axi_rdata_valid          : in std_logic                          ;           --
        ip2axi_rddata               : in std_logic_vector                               --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)            --
    );
end axi_vdma_lite_if;


-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma_lite_if is

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------
-- Register I/F Address offset
constant ADDR_OFFSET    : integer := clog2(C_S_AXI_LITE_DATA_WIDTH/8);
-- Register I/F CE number
constant CE_ADDR_SIZE   : integer := clog2(C_NUM_CE);

-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
-- AXI Lite slave interface signals
signal awvalid              : std_logic := '0';
signal awaddr               : std_logic_vector
                                (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0) := (others => '0');
signal wvalid               : std_logic := '0';
signal wdata                : std_logic_vector
                                (C_S_AXI_LITE_DATA_WIDTH-1 downto 0) := (others => '0');


signal arvalid              : std_logic := '0';
signal araddr               : std_logic_vector
                                (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0) := (others => '0');
signal awvalid_d1           : std_logic := '0';
signal awvalid_re           : std_logic := '0';
signal awready_i            : std_logic := '0';
signal wvalid_d1            : std_logic := '0';
signal wvalid_re            : std_logic := '0';
signal wready_i             : std_logic := '0';
signal bvalid_i             : std_logic := '0';

signal wr_addr_cap          : std_logic := '0';
signal wr_data_cap          : std_logic := '0';

-- AXI to IP interface signals
signal axi2ip_wraddr_i      : std_logic_vector
                                (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0) := (others => '0');
signal axi2ip_wrdata_i      : std_logic_vector
                                (C_S_AXI_LITE_DATA_WIDTH-1 downto 0) := (others => '0');
signal axi2ip_wren_i        : std_logic := '0';
signal wrce                 : std_logic_vector(C_NUM_CE-1 downto 0);
signal write_in_progress    : std_logic := '0';



signal rdce                 : std_logic_vector(C_NUM_CE-1 downto 0) := (others => '0');
signal arvalid_d1           : std_logic := '0';
signal arvalid_re           : std_logic := '0';
signal arvalid_re_d1        : std_logic := '0';
signal arvalid_i            : std_logic := '0';
signal arready_i            : std_logic := '0';
signal axi2ip_rdaddr_i      : std_logic_vector
                                (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0) := (others => '0');

signal s_axi_lite_rvalid_i  : std_logic := '0';
signal read_in_progress     : std_logic := '0'; -- CR607165
signal rst_rvalid_re        : std_logic := '0'; -- CR576999
signal rst_wvalid_re        : std_logic := '0'; -- CR576999
signal addr_data_cap_d1     : std_logic := '0';

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin

--*****************************************************************************
--** AXI LITE READ
--*****************************************************************************

s_axi_lite_wready   <= wready_i;
s_axi_lite_awready  <= awready_i;
s_axi_lite_arready  <= arready_i;

s_axi_lite_bvalid   <= bvalid_i;

-------------------------------------------------------------------------------
-- Register AXI Inputs
-------------------------------------------------------------------------------
REG_INPUTS : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                awvalid <=  '0'                 ;
                awaddr  <=  (others => '0')     ;
                wvalid  <=  '0'                 ;
                wdata   <=  (others => '0')     ;
                arvalid <=  '0'                 ;
                araddr  <=  (others => '0')     ;
            else
                awvalid <= s_axi_lite_awvalid   ;
                awaddr  <= s_axi_lite_awaddr    ;
                wvalid  <= s_axi_lite_wvalid    ;
                wdata   <= s_axi_lite_wdata     ;
                arvalid <= s_axi_lite_arvalid   ;
                araddr  <= s_axi_lite_araddr    ;
            end if;
        end if;
    end process REG_INPUTS;

-------------------------------------------------------------------------------
-- Assert Write Adddress Ready Handshake
-- Capture rising edge of valid and register out as ready.  This creates
-- a 3 clock cycle address phase but also registers all inputs and outputs.
-- Note : Single clock cycle address phase can be accomplished using
-- combinatorial logic.
-------------------------------------------------------------------------------
REG_AWVALID : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_wvalid_re = '1')then
                awvalid_d1  <= '0';
            else
                awvalid_d1  <= awvalid;
            end if;
        end if;
    end process REG_AWVALID;

awvalid_re  <= awvalid and not awvalid_d1                       -- CR620124
           and not rst_wvalid_re and not write_in_progress;     -- CR620124


REG_AWREADY : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or wr_addr_cap = '1')then
                awready_i <= '0';
            else
                awready_i <= awvalid_re;
            end if;
        end if;
    end process REG_AWREADY;

-- Flag to prevent overlapping writes (CR620124)
WRITE_PROGRESS : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_wvalid_re = '1')then
                write_in_progress <= '0';
            elsif(awvalid_re = '1')then
                write_in_progress <= '1';
            end if;
        end if;
    end process WRITE_PROGRESS;

-------------------------------------------------------------------------------
-- Capture assertion of awvalid to indicate that we have captured
-- a valid address
-------------------------------------------------------------------------------
WRADDR_CAP_FLAG : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_wvalid_re = '1')then
                wr_addr_cap <= '0';
            elsif(awvalid_re = '1')then
                wr_addr_cap <= '1';
            end if;
        end if;
    end process WRADDR_CAP_FLAG;

-------------------------------------------------------------------------------
-- Assert Write Data Ready Handshake
-- Capture rising edge of valid and register out as ready.  This creates
-- a 3 clock cycle address phase but also registers all inputs and outputs.
-- Note : Single clock cycle address phase can be accomplished using
-- combinatorial logic.
-------------------------------------------------------------------------------
REG_WVALID : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_wvalid_re = '1')then
                wvalid_d1   <= '0';
            else
                wvalid_d1   <= wvalid;
            end if;
        end if;
    end process REG_WVALID;

wvalid_re  <= wvalid and not wvalid_d1
                and not rst_wvalid_re
                and not (wr_data_cap and write_in_progress);     -- CR620124

REG_WREADY : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                wready_i <= '0';
            else
                wready_i <= wvalid_re;
            end if;
        end if;
    end process REG_WREADY;

-------------------------------------------------------------------------------
-- Capture assertion of wvalid to indicate that we have captured
-- valid data
-------------------------------------------------------------------------------
WRDATA_CAP_FLAG : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_wvalid_re = '1')then
                wr_data_cap <= '0';
            elsif(wvalid_re = '1')then
                wr_data_cap <= '1';
            end if;
        end if;
    end process WRDATA_CAP_FLAG;


-------------------------------------------------------------------------------
-- Capture Write Address
-------------------------------------------------------------------------------
REG_WRITE_ADDRESS : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                axi2ip_wraddr_i   <= (others => '0');

            -- Register address on valid
            elsif(awvalid_re = '1')then
                axi2ip_wraddr_i   <= awaddr;

            end if;
        end if;
    end process REG_WRITE_ADDRESS;

-------------------------------------------------------------------------------
-- Capture Write Data
-------------------------------------------------------------------------------
REG_WRITE_DATA : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                axi2ip_wrdata_i     <= (others => '0');

            -- Register address and assert ready
            elsif(wvalid_re = '1')then
                axi2ip_wrdata_i     <= wdata;

            end if;
        end if;
    end process REG_WRITE_DATA;

-------------------------------------------------------------------------------
-- Must have both a valid address and valid data before updating
-- a register.  Note in AXI write address can come before or
-- after AXI write data.
--axi2ip_wren_i <= '1' when wr_data_cap = '1' and wr_addr_cap = '1'
--            else '0';


REG_WREN_PULSE : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then

                addr_data_cap_d1 <= '0';
            else
                addr_data_cap_d1 <= wr_data_cap and wr_addr_cap;
            end if;
        end if;
    end process REG_WREN_PULSE;

axi2ip_wren_i <= '1' when (wr_data_cap = '1' and wr_addr_cap = '1')
                      and addr_data_cap_d1 = '0'
            else '0';



-------------------------------------------------------------------------------
-- Decode and assert proper chip enable per captured axi lite write address
-------------------------------------------------------------------------------
WRCE_GEN: for j in 0 to C_NUM_CE - 1 generate

constant BAR    : std_logic_vector(CE_ADDR_SIZE-1 downto 0) :=
                std_logic_vector(to_unsigned(j,CE_ADDR_SIZE));
begin

    wrce(j) <= axi2ip_wren_i when axi2ip_wraddr_i
                                ((CE_ADDR_SIZE + ADDR_OFFSET) - 1
                                                    downto ADDR_OFFSET)

                                = BAR(CE_ADDR_SIZE-1 downto 0)
          else '0';

end generate WRCE_GEN;

-------------------------------------------------------------------------------
-- register write ce's and data out to axi dma register module
-------------------------------------------------------------------------------
REG_WR_OUT : process(s_axi_lite_aclk)
    begin
    if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
        if(s_axi_lite_aresetn = '0')then
            axi2ip_wrce     <= (others => '0');
            axi2ip_wrdata   <= (others => '0');
            axi2ip_wren     <= '0';
            axi2ip_wraddr   <= (others => '0'); -- CR620124
        else
            axi2ip_wrce     <= wrce;
            axi2ip_wrdata   <= axi2ip_wrdata_i;
            axi2ip_wren     <= axi2ip_wren_i;
            axi2ip_wraddr   <= axi2ip_wraddr_i; -- CR620124
        end if;
    end if;
end process REG_WR_OUT;

-------------------------------------------------------------------------------
-- Write Response
-------------------------------------------------------------------------------
s_axi_lite_bresp    <= OKAY_RESP;

WRESP_PROCESS : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                bvalid_i        <= '0';
                rst_wvalid_re   <= '0';     -- CR576999
            -- If response issued and target indicates ready then
            -- clear response
            elsif(bvalid_i = '1' and s_axi_lite_bready = '1')then
                bvalid_i        <= '0';
                rst_wvalid_re   <= '0';     -- CR576999
            -- Issue a resonse on write
            --elsif(axi2ip_wren_i = '1')then    -- CR620124
            elsif(ip2axi_wrack = '1')then       -- CR620124
                bvalid_i        <= '1';
                rst_wvalid_re   <= '1';     -- CR576999
            end if;
        end if;
    end process WRESP_PROCESS;






--*****************************************************************************
--** AXI LITE READ
--*****************************************************************************

-------------------------------------------------------------------------------
-- Assert Read Adddress Ready Handshake
-- Capture rising edge of valid and register out as ready.  This creates
-- a 3 clock cycle address phase but also registers all inputs and outputs.
-- Note : Single clock cycle address phase can be accomplished using
-- combinatorial logic.
-------------------------------------------------------------------------------
REG_ARVALID : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_rvalid_re = '1')then
                arvalid_d1 <= '0';
            else
                arvalid_d1 <= arvalid;
            end if;
        end if;
    end process REG_ARVALID;

arvalid_re  <= arvalid and not arvalid_d1
                and not rst_rvalid_re and not read_in_progress; -- CR607165

-- register for proper alignment
REG_ARREADY : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                arready_i <= '0';
            else
                arready_i <= arvalid_re;
            end if;
        end if;
    end process REG_ARREADY;

-- Always respond 'okay' axi lite read
s_axi_lite_rresp    <= OKAY_RESP;
s_axi_lite_rvalid   <= s_axi_lite_rvalid_i;

-- Flag to prevent overlapping reads
RD_PROGRESS : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_rvalid_re = '1')then
                read_in_progress <= '0';

            elsif(arvalid_re = '1')then
                read_in_progress <= '1';
            end if;
        end if;
    end process RD_PROGRESS;


-------------------------------------------------------------------------------
-- Capture Read Address
-------------------------------------------------------------------------------
REG_READ_ADDRESS : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                axi2ip_rdaddr_i   <= (others => '0');

            -- Register address on valid
            elsif(arvalid_re = '1')then
                axi2ip_rdaddr_i   <= araddr;

            end if;
        end if;
    end process REG_READ_ADDRESS;



-------------------------------------------------------------------------------
-- Generate RdCE based on address match to address bar
-------------------------------------------------------------------------------
RDCE_GEN: for j in 0 to C_NUM_CE - 1 generate

constant BAR    : std_logic_vector(CE_ADDR_SIZE-1 downto 0) :=
                std_logic_vector(to_unsigned(j,CE_ADDR_SIZE));
begin

  rdce(j) <= arvalid_re_d1
    when axi2ip_rdaddr_i((CE_ADDR_SIZE + ADDR_OFFSET) - 1
                          downto ADDR_OFFSET)
         = BAR(CE_ADDR_SIZE-1 downto 0)
    else '0';

end generate RDCE_GEN;

-------------------------------------------------------------------------------
-- Register out to IP
-------------------------------------------------------------------------------
REG_RDCNTRL_OUT : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                axi2ip_rdaddr   <= (others => '0');
                axi2ip_rden     <= '0';
            else
                axi2ip_rdaddr   <= axi2ip_rdaddr_i;
                axi2ip_rden     <= arvalid_re_d1;
            end if;
        end if;
    end process REG_RDCNTRL_OUT;

-- Sample and hold rdce value until rvalid assertion
REG_RDCE_OUT : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0' or rst_rvalid_re = '1')then
                axi2ip_rdce     <= (others => '0');
            elsif(arvalid_re_d1 = '1')then
                axi2ip_rdce     <= rdce;
            end if;
        end if;
    end process REG_RDCE_OUT;


    -- Register for proper alignment
    REG_RVALID : process(s_axi_lite_aclk)
        begin
            if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                if(s_axi_lite_aresetn = '0')then
                    arvalid_re_d1   <= '0';
                else
                    arvalid_re_d1   <= arvalid_re;
                end if;
            end if;
        end process REG_RVALID;

-------------------------------------------------------------------------------
-- Drive read data and read data valid out on capture of valid address.
-------------------------------------------------------------------------------
REG_RD_OUT : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_aresetn = '0')then
                s_axi_lite_rdata    <= (others => '0');
                s_axi_lite_rvalid_i <= '0';
                rst_rvalid_re       <= '0';                 -- CR576999

            -- If rvalid driving out to target and target indicates ready
            -- then de-assert rvalid. (structure guarentees min 1 clock of rvalid)
            elsif(s_axi_lite_rvalid_i = '1' and s_axi_lite_rready = '1')then
                s_axi_lite_rdata    <= (others => '0');
                s_axi_lite_rvalid_i <= '0';
                rst_rvalid_re       <= '0';                 -- CR576999

            -- If read cycle then assert rvalid and rdata out to target
            elsif(ip2axi_rdata_valid = '1')then
                s_axi_lite_rdata    <= ip2axi_rddata;
                s_axi_lite_rvalid_i <= '1';
                rst_rvalid_re       <= '1';                 -- CR576999

            end if;
        end if;
    end process REG_RD_OUT;


end implementation;



