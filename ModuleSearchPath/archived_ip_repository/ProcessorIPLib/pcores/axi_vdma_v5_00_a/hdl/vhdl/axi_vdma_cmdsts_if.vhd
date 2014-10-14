-------------------------------------------------------------------------------
-- axi_vdma_cmdsts_if
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
-- Filename:    axi_vdma_cmdsts_if.vhd
-- Description: This entity is the descriptor fetch command and status inteface
--              for the Scatter Gather Engine AXI DataMover.
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
--  GAB     10/25/10   v3_00_a
-- ^^^^^^
--  Updated to version v3_00_a
-- ~~~~~~
--  GAB     11/05/10   v3_00_a
-- ^^^^^^
-- CR579593/CR579597 - Map new hsize/vsize zero error flag to interr for proper
--                     setting of DMAIntErr flag in DMASR.
-- ~~~~~~
--  GAB     2/23/11     v3_01_a
-- ^^^^^^
--  Updated to version v3_01_a
-- ~~~~~~
--  GAB     6/6/11     v3_01_a
-- ^^^^^^
--  CR613214 - Fixed issue with falsly flagging a underflow error on datamover
--           halt.
-- ~~~~~~
--  GAB     6/8/11     v4_00_a
-- ^^^^^^
--  Updated to version v4_00_a for 13.3
-- ~~~~~~
--  GAB     8/1/11     v4_00_a
-- ^^^^^^
--  CR591965 - Updated to support flush on frame sync option.
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

-------------------------------------------------------------------------------
entity  axi_vdma_cmdsts_if is
    generic (
        C_M_AXI_ADDR_WIDTH       : integer range 32 to 64       := 32;
            -- Master AXI Memory Map Address Width for Scatter Gather R/W Port

        C_DM_STATUS_WIDTH               : integer               := 8;
            -- CR608521
            -- DataMover status width - is based on mode of operation

        C_ENABLE_FLUSH_ON_FSYNC     : integer range 0 to 1      := 0                            -- CR591965
            -- Specifies VDMA Flush on Frame sync enabled
            -- 0 = Disabled
            -- 1 = Enabled

    );
    port (
        -----------------------------------------------------------------------
        -- AXI Scatter Gather Interface
        -----------------------------------------------------------------------
        prmry_aclk              : in  std_logic                             ;                   --
        prmry_resetn            : in  std_logic                             ;                   --
                                                                                                --
        -- Command write interface from mm2s sm                                                 --
        cmnd_wr                 : in  std_logic                             ;                   --
        cmnd_data               : in  std_logic_vector                                          --
                                    ((C_M_AXI_ADDR_WIDTH+CMD_BASE_WIDTH)-1 downto 0);           --
        cmnd_pending            : out std_logic                             ;                   --
        sts_received            : out std_logic                             ;                   --
        halt                    : in  std_logic                             ;                   -- CR613214
        stop                    : in  std_logic                             ;                   --
        crnt_hsize              : in  std_logic_vector                                          --
                                    (HSIZE_DWIDTH-1 downto 0)               ;                   --
        dmasr_halt              : in  std_logic                             ;                   --
                                                                                                --
        -- User Command Interface Ports (AXI Stream)                                            --
        s_axis_cmd_tvalid       : out std_logic                             ;                   --
        s_axis_cmd_tready       : in  std_logic                             ;                   --
        s_axis_cmd_tdata        : out std_logic_vector                                          --
                                    ((C_M_AXI_ADDR_WIDTH+CMD_BASE_WIDTH)-1 downto 0);           --
                                                                                                --
        -- User Status Interface Ports (AXI Stream)                                             --
        m_axis_sts_tvalid       : in  std_logic                             ;                   --
        m_axis_sts_tready       : out std_logic                             ;                   --
        m_axis_sts_tdata        : in  std_logic_vector                                          --
                                    (C_DM_STATUS_WIDTH-1 downto 0)          ;                   -- CR608521
        m_axis_sts_tkeep        : in  std_logic_vector                                          --
                                    ((C_DM_STATUS_WIDTH/8)-1  downto 0)     ;                   -- CR608521
                                                                                                --
        -- Zero Hsize and/or Vsize. mapped here to combine with interr                          --
        zero_size_err           : in  std_logic                             ;                   -- CR579593/CR579597
        -- Frame Mismatch. mapped here to combine with interr                                   --
        fsize_mismatch_err      : in  std_logic                             ;                   -- CR591965
        lsize_mismatch_err      : out std_logic                             ;                   -- CR591965
                                                                                                --
        -- Datamover status                                                                     --
        err                     : in  std_logic                             ;                   --
        done                    : out std_logic                             ;                   --
        error                   : out std_logic                             ;                   --
        interr                  : out std_logic                             ;                   --
        slverr                  : out std_logic                             ;                   --
        decerr                  : out std_logic                             ;                   --
        tag                     : out std_logic_vector(3 downto 0)                              --

    );

end axi_vdma_cmdsts_if;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma_cmdsts_if is

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------

-- Bytes received MSB index bit
constant BRCVD_MSB_BIT : integer := (C_DM_STATUS_WIDTH - 2);
-- Bytes received LSB index bit
constant BRCVD_LSB_BIT : integer := (C_DM_STATUS_WIDTH - 2) - (BUFFER_LENGTH_WIDTH - 1);

constant PAD_HSIZE     : std_logic_vector(22 - HSIZE_DWIDTH downto 0) := (others => '0');

-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
signal sts_tready           : std_logic := '0';

signal slverr_i             : std_logic := '0';
signal decerr_i             : std_logic := '0';
signal interr_i             : std_logic := '0';
signal error_i              : std_logic := '0';
signal error_or             : std_logic := '0';


signal ufof_err             : std_logic := '0';
signal undrflo_ovrflo_err   : std_logic := '0';
signal ext_crnt_hsize       : std_logic_vector(22 downto 0) := (others => '0');


-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin

slverr <= slverr_i;
decerr <= decerr_i;
--interr <= interr_i or zero_size_err;                          -- CR608521
--interr <= interr_i or zero_size_err or undrflo_ovrflo_err;    -- CR608521
interr <= interr_i or zero_size_err
                   or undrflo_ovrflo_err
                   or fsize_mismatch_err;                       -- CR591965


-- Asserted with each valid status
sts_received <= m_axis_sts_tvalid and sts_tready;

-------------------------------------------------------------------------------
-- DataMover Command Interface
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- When command by fetch sm, drive descriptor fetch command to data mover.
-- Hold until data mover indicates ready.
-------------------------------------------------------------------------------
GEN_DATAMOVER_CMND : process(prmry_aclk)
    begin
        if(prmry_aclk'EVENT and prmry_aclk = '1')then
            if(prmry_resetn = '0' or dmasr_halt = '1')then
                s_axis_cmd_tvalid  <= '0';
                s_axis_cmd_tdata   <= (others => '0');
                cmnd_pending       <= '0';
            -- New command write and not flagged as stale descriptor
            elsif(cmnd_wr = '1')then
                s_axis_cmd_tvalid  <= '1';
                s_axis_cmd_tdata   <= cmnd_data;
                cmnd_pending       <= '1';
            -- Clear flags when command excepted by datamover
            elsif(s_axis_cmd_tready = '1')then
                s_axis_cmd_tvalid  <= '0';
                s_axis_cmd_tdata   <= (others => '0');
                cmnd_pending       <= '0';

            end if;
        end if;
    end process GEN_DATAMOVER_CMND;

-------------------------------------------------------------------------------
-- DataMover Status Interface
-------------------------------------------------------------------------------
-- Drive ready low during reset to indicate not ready
REG_STS_READY : process(prmry_aclk)
    begin
        if(prmry_aclk'EVENT and prmry_aclk = '1')then
            if(prmry_resetn = '0')then
                sts_tready <= '0';
            else
                sts_tready <= '1';
            end if;
        end if;
    end process REG_STS_READY;

-- Pass to DataMover
m_axis_sts_tready <= sts_tready;

-------------------------------------------------------------------------------
-- Log status bits out of data mover.
-------------------------------------------------------------------------------
DATAMOVER_STS : process(prmry_aclk)
    begin
        if(prmry_aclk'EVENT and prmry_aclk = '1')then
            if(prmry_resetn = '0')then
                done       <= '0';
                slverr_i   <= '0';
                decerr_i   <= '0';
                interr_i   <= '0';
                tag        <= (others => '0');
            -- Status valid, therefore capture status
            elsif(m_axis_sts_tvalid = '1')then
                done       <= m_axis_sts_tdata(DATAMOVER_STS_CMDDONE_BIT);
                slverr_i   <= m_axis_sts_tdata(DATAMOVER_STS_SLVERR_BIT);
                decerr_i   <= m_axis_sts_tdata(DATAMOVER_STS_DECERR_BIT);
                interr_i   <= m_axis_sts_tdata(DATAMOVER_STS_INTERR_BIT);
                tag        <= m_axis_sts_tdata(DATAMOVER_STS_TAGMSB_BIT downto DATAMOVER_STS_TAGLSB_BIT);
            else
                done       <= '0';
                slverr_i   <= '0';
                decerr_i   <= '0';
                interr_i   <= '0';
                tag        <= (others => '0');
            end if;
        end if;
    end process DATAMOVER_STS;


-------------------------------------------------------------------------------
-- Line MisMatch Detection (Datamover underflow or overflow)
-------------------------------------------------------------------------------
-- Status is for MM2S or S2MM with Store and Forward turned OFF
-- therefore Datamover detects overflow and underflow
GEN_STS_EQL_TO_8 : if C_DM_STATUS_WIDTH = 8 generate
begin
    ufof_err            <= '0';
    undrflo_ovrflo_err  <= '0';
    lsize_mismatch_err  <= '0';
end generate GEN_STS_EQL_TO_8;

-- Status is for S2MM with Store and Forward turned OON (i.e. Indeterimate BTT mode)
-- therefore need to detect overflow and underflow here
GEN_STS_GRTR_THAN_8 : if C_DM_STATUS_WIDTH > 8 generate
begin

    -- Pad current hsize up to the full 23 bit BTT
    ext_crnt_hsize <= PAD_HSIZE & crnt_hsize;

    -- CR608521 - Under Flow or Over Flow error detected
    ufof_err <= '1' when m_axis_sts_tvalid = '1'
                   and  ((ext_crnt_hsize /= m_axis_sts_tdata(BRCVD_MSB_BIT      -- Underflow or Overflow
                                                 downto BRCVD_LSB_BIT))
                     or (m_axis_sts_tdata(DATAMOVER_STS_TLAST_BIT) = '0'))      -- Overflow
           else '0';

    -- CR608521- Under Flow or Over Flow error detected
    -- Register and hold error
    -- CR613214 - need to qualify overflow with datamover halt
    REG_UFOF_ERR : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk = '1')then
                if(prmry_resetn = '0')then
                    undrflo_ovrflo_err <= '0';
                -- set on underflow or overflow
                -- CR609038 qualify with error already being set because on
                -- datamover shut down the byte count in the rcved status is
                -- invalid.
                -- CR613214 - need to qualify overflow with datamover halt
                elsif(ufof_err = '1' and error_i = '0' and stop = '0' and halt = '0')then
                    undrflo_ovrflo_err <= '1';
                else                                            -- CR591965
                    undrflo_ovrflo_err <= '0';                  -- CR591965
                end if;
            end if;
        end process REG_UFOF_ERR;

    -- CR591965
    -- pass underflow/overflow to line size mismatch for use
    -- in genlock repeat frame logic
    lsize_mismatch_err <= undrflo_ovrflo_err;

end generate GEN_STS_GRTR_THAN_8;

-------------------------------------------------------------------------------
-- Register global error from data mover.
-------------------------------------------------------------------------------
-- Flush On Frame Sync disabled therefore...
-- Halt channel on all errors.  Done by OR'ing all errors and using
-- to set error_i which is used in axi_vdma_mngr to assert stop.  Stop
-- will shut down channel. (CR591965)
GEN_ERROR_FOR_NO_FLUSH : if C_ENABLE_FLUSH_ON_FSYNC = 0 generate
begin
    error_or <= slverr_i            -- From DataMover
             or decerr_i            -- From DataMover
             or interr_i            -- From DataMover
             or zero_size_err       -- From axi_vdma_sm
             or fsize_mismatch_err  -- From axi_vdma_sm (CR591965)
             or undrflo_ovrflo_err; -- From underflow/overflow process (above)

end generate GEN_ERROR_FOR_NO_FLUSH;

-- Flush On Frame Sync enabled therefore...
-- Halt channel on all errors except underflow and overflow (line size mismatch)
-- and frame size mismatch errors.  Shutdown is accomplished by OR'ing select errors
-- and using to set error_i which is used in axi_vdma_mngr to assert stop.  Stop
-- will shut down channel. (CR591965)
GEN_ERROR_FOR_FLUSH : if C_ENABLE_FLUSH_ON_FSYNC = 1 generate
begin
    error_or <= slverr_i            -- From DataMover
             or decerr_i            -- From DataMover
             or interr_i            -- From DataMover
             or zero_size_err;      -- From axi_vdma_sm

end generate GEN_ERROR_FOR_FLUSH;

-- Log errors into a global error output
ERROR_PROCESS : process(prmry_aclk)
    begin
        if(prmry_aclk'EVENT and prmry_aclk = '1')then
            if(prmry_resetn = '0')then
                error_i <= '0';
            -- If Datamover issues error on the transfer or if a stale descriptor is
            -- detected when in tailpointer mode then issue an error
            elsif(error_or = '1')then
                error_i <= '1';
            end if;
        end if;
    end process ERROR_PROCESS;
---- CR609038
error <= error_i;

end implementation;
