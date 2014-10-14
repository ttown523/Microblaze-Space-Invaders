-------------------------------------------------------------------------------
-- axi_vdma
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
-- Filename:          axi_vdma.vhd
-- Description: This entity is the top level entity for the AXI VDMA core.
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
--  Updated to axi_sg_v2_02_a library
--  Updated to axi_vdma_v5_00_a library
--  CR573828 - Double driven ***_irqthresh_rstdsbl when associated channel
--  not included
--  CR573703 - Renamed reset outputs to not use axi naming conventions
-- ~~~~~~
--  GAB     9/20/10     v2_00_a
-- ^^^^^^
-- CR575884 - Pass vertical line count to linebuffer logic for de-asserting
--           tready at the end of a frame.  This is used to keep Video IP
--           sync'ed with vdma logic.
-- ~~~~~~
--  GAB     9/30/10     v2_00_a
-- ^^^^^^
-- CR576993 - For margin system timing closer, added skid buffers to
--            line buffers for S2MM and MM2S.  This required two new
--            parameters to the line buffer instantiation.
-- ~~~~~~
--  GAB     10/6/10     v2_00_a
-- ^^^^^^
-- CR577698 - Made channel GenLock mode to register module to make
--            DMACR.SyncEn RO when GenLock mode set to Master
-- ~~~~~~
--  GAB     10/13/10     v2_00_a
-- ^^^^^^
-- CR578591 - Added fsync mask to qualifications for disabling delay timer
--          to prevent delay timer interrupt from occuring after FrmCntEn shutdown
-- ~~~~~~
--  GAB     10/25/10     v3_00_a
-- ^^^^^^
--  Updated to version v3_00_a
-- ~~~~~~
--  GAB     11/6/10     v3_00_a
-- ^^^^^^
-- CR581800 - Mapped C_INCLUDE_SG parameter to axi_vdma_mngr
-- ~~~~~~
--  GAB     11/10/10     v3_00_a
-- ^^^^^^
-- CR582182 - Fixes issue with wrong S2MM Frame STore value on Error capture
--            for case when using external fsync (C_USE_FSYNC=1)
-- ~~~~~~
--  GAB     11/15/10    v3_00_a
-- ^^^^^^
--  CR582802
--  Converted all stream paraters ***_DATA_WIDTH to ***_TDATA_WIDTH
--  Updated AXI Datamover to include new ports and new ***_TDATA_WIDTH parameters
--  Updated AXI SG to include new ***_TDATA_WIDTH parameters
-- ~~~~~~
--  GAB     2/23/11     v3_01_a
-- ^^^^^^
--  Updated to version v3_01_a
--  Updated to axi_sg_v2_02_a
--  Updated to axi_datamover_v2_01_a
--  Added dynamic frame store capability.
--  Optionalized ReadMux for video parameter registers when in register direct
--  mode (C_INCLUDE_SG = 0).
-- ~~~~~~
--  GAB     7/18/11     v4_00_a
-- ^^^^^^
--  Updated to version v4_00_a for 13.3
--  Updated to axi_datamover_v3_00_a and axi_sg_v3_00_a
--  Removed axi_upsizers and store and forward feature and utilized these in
--  axi_datamover
--  Updated to support 512 and 1024 data widths
--  Re-architected to support dynamic clock feature
--  Added dynamic line buffer threshold feature
-- ~~~~~~
--  GAB     8/1/11     v4_00_a
-- ^^^^^^
--  CR591965 - Added Flush On Frame sync
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

library axi_sg_v3_00_a;
use axi_sg_v3_00_a.all;

library axi_datamover_v3_00_a;
use axi_datamover_v3_00_a.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.max2;

-------------------------------------------------------------------------------
entity  axi_vdma is
    generic(
        C_S_AXI_LITE_ADDR_WIDTH         : integer range 32 to 32    := 32;
            -- Address width of the AXI Lite Interface

        C_S_AXI_LITE_DATA_WIDTH         : integer range 32 to 32    := 32;
            -- Data width of the AXI Lite Interface

        C_DLYTMR_RESOLUTION             : integer range 1 to 100000 := 125;
            -- Interrupt Delay Timer resolution in usec

        C_PRMRY_IS_ACLK_ASYNC           : integer range 0 to 1      := 0;
            -- Primary MM2S/S2MM sync/async mode
            -- 0 = synchronous mode     - all clocks are synchronous
            -- 1 = asynchronous mode    - Primary data path channels (MM2S and S2MM)
            --                            run asynchronous to AXI Lite, DMA Control,
            --                            and SG.
        -----------------------------------------------------------------------
        -- Video Specific Parameters
        -----------------------------------------------------------------------
        C_ENABLE_VIDPRMTR_READS         : integer range 0 to 1      := 1;
            -- Specifies whether video parameters are readable by axi_lite interface
            -- when configure for Register Direct Mode
            -- 0 = Disable Video Parameter Reads (Saves FPGA Resources)
            -- 1 = Enable Video Parameter Reads

        C_NUM_FSTORES                   : integer range 1 to 32     := 3;
            -- Number of Frame Stores

        C_USE_FSYNC                     : integer range 0 to 1      := 0;
            -- Specifies VDMA operation synchronized to frame sync input
            -- 0 = Free running
            -- 1 = Fsync synchronous

        C_FLUSH_ON_FSYNC                : integer range 0 to 1      := 1;
            -- Specifies VDMA will flush on frame sync
            -- 0 = Disabled - channel halts on error detection
            -- 1 = Enabled - channel does not halt and will flush on next fsync

        C_INCLUDE_INTERNAL_GENLOCK      : integer range 0 to 1      := 0;
            -- Include or exclude the use of internal genlock bus.
            -- 0 = Exclude internal genlock bus
            -- 1 = Include internal genlock bus

        -----------------------------------------------------------------------
        -- Scatter Gather Parameters
        -----------------------------------------------------------------------
        C_INCLUDE_SG                    : integer range 0 to 1      := 1;
            -- Include or Exclude Scatter Gather Engine
            -- 0 = Exclude Scatter Gather Engine (Enables Register Direct Mode)
            -- 1 = Include Scatter Gather Engine

        C_M_AXI_SG_ADDR_WIDTH           : integer range 32 to 32    := 32;
            -- Master AXI Memory Map Address Width for Scatter Gather R/W Port

        C_M_AXI_SG_DATA_WIDTH           : integer range 32 to 32    := 32;
            -- Master AXI Memory Map Data Width for Scatter Gather R/W Port

        -----------------------------------------------------------------------
        -- Memory Map to Stream (MM2S) Parameters
        -----------------------------------------------------------------------
        C_INCLUDE_MM2S                  : integer range 0 to 1      := 1;
            -- Include or exclude MM2S primary data path
            -- 0 = Exclude MM2S primary data path
            -- 1 = Include MM2S primary data path

        C_MM2S_GENLOCK_MODE             : integer range 0 to 1      := 0;
            -- Specifies the Gen-Lock mode for the MM2S Channel
            -- 0 = Master Mode
            -- 1 = Slave Mode

        C_MM2S_GENLOCK_NUM_MASTERS      : integer range 1 to 16     := 1;
            -- Specifies the number of Gen-Lock masters a Gen-Lock slave
            -- can be synchronized with

        C_MM2S_GENLOCK_REPEAT_EN        : integer range 0 to 1      := 0;
            -- In flush on frame sync mode specifies whether frame number
            -- will increment on error'ed frame or repeat error'ed frame
            -- 0 = increment frame
            -- 1 = repeat frame

        C_MM2S_SOF_ENABLE               : integer range 0 to 1      := 0;
            -- Enable/Disable start of frame generation on tuser(0). This
            -- is only valid for external frame sync (C_USE_FSYNC = 1)
            -- 0 = disable SOF
            -- 1 = enable SOF

        C_INCLUDE_MM2S_DRE              : integer range 0 to 1      := 0;
            -- Include or exclude MM2S data realignment engine (DRE)
            -- 0 = Exclude MM2S DRE
            -- 1 = Include MM2S DRE

        C_INCLUDE_MM2S_SF               : integer range 0 to 1      := 1;
            -- Include or exclude MM2S Store And Forward Functionality
            -- 0 = Exclude MM2S Store and Forward
            -- 1 = Include MM2S Store and Forward

        C_MM2S_LINEBUFFER_DEPTH         : integer range 0 to 65536  := 128;
            -- Depth of line buffer in bytes.  Must be a power of 2
            -- value, i.e. 1,2,4,8,16, etc.
            -- A depth of 0 will exclude the line buffer

        C_MM2S_LINEBUFFER_THRESH        : integer range 1 to 65536  := 1;
            -- Almost Empty Threshold. Threshold point at which MM2S line buffer
            -- almost empty flag asserts high.  Must be a resolution of
            -- C_M_AXIS_MM2S_TDATA_WIDTH/8
            -- Minimum valid value is C_M_AXIS_MM2S_TDATA_WIDTH/8
            -- Maximum valid value is C_MM2S_LINEBUFFER_DEPTH

        C_MM2S_MAX_BURST_LENGTH         : integer range 16 to 256   := 16;
            -- Maximum burst size in databeats per burst request on MM2S Read Port

        C_M_AXI_MM2S_ADDR_WIDTH         : integer range 32 to 32    := 32;
            -- Master AXI Memory Map Address Width for MM2S Read Port

        C_M_AXI_MM2S_DATA_WIDTH         : integer range 32 to 1024  := 32;
            -- Master AXI Memory Map Data Width for MM2S Read Port

        C_M_AXIS_MM2S_TDATA_WIDTH       : integer range 8 to 1024   := 32;
            -- Master AXI Stream Data Width for MM2S Channel

        C_M_AXIS_MM2S_TUSER_BITS        : integer range 1 to 1      := 1;
            -- Master AXI Stream User Width for MM2S Channel

        -----------------------------------------------------------------------
        -- Stream to Memory Map (S2MM) Parameters
        -----------------------------------------------------------------------
        C_INCLUDE_S2MM                  : integer range 0 to 1      := 1;
            -- Include or exclude S2MM primary data path
            -- 0 = Exclude S2MM primary data path
            -- 1 = Include S2MM primary data path

        C_S2MM_GENLOCK_MODE             : integer range 0 to 1      := 0;
            -- Specifies the Gen-Lock mode for the S2MM Channel
            -- 0 = Master Mode
            -- 1 = Slave Mode

        C_S2MM_GENLOCK_NUM_MASTERS      : integer range 1 to 16     := 1;
            -- Specifies the number of Gen-Lock masters a Gen-Lock slave
            -- can be synchronized with

        C_S2MM_GENLOCK_REPEAT_EN        : integer range 0 to 1      := 0;
            -- In flush on frame sync mode specifies whether frame number
            -- will increment on error'ed frame or repeat error'ed frame
            -- 0 = increment frame
            -- 1 = repeat frame

        C_S2MM_SOF_ENABLE               : integer range 0 to 1      := 0;
            -- Enable/Disable start of frame generation on tuser(0). This
            -- is only valid for external frame sync (C_USE_FSYNC = 1)
            -- 0 = disable SOF
            -- 1 = enable SOF

        C_INCLUDE_S2MM_DRE              : integer range 0 to 1      := 0;
            -- Include or exclude S2MM data realignment engine (DRE)
            -- 0 = Exclude S2MM DRE
            -- 1 = Include S2MM DRE

        C_INCLUDE_S2MM_SF               : integer range 0 to 1      := 1;
            -- Include or exclude MM2S Store And Forward Functionality
            -- 0 = Exclude S2MM Store and Forward
            -- 1 = Include S2MM Store and Forward

        C_S2MM_LINEBUFFER_DEPTH         : integer range 0 to 65536  := 128;
            -- Depth of line buffer in bytes.  Must be a power of 2
            -- value, i.e. 1,2,4,8,16, etc.
            -- A depth of 0 will exclude the line buffer

        C_S2MM_LINEBUFFER_THRESH        : integer range 1 to 65536  := 1;
            -- Almost Full Threshold. Threshold point at which S2MM line buffer
            -- almost full flag asserts high.  Must be a resolution of
            -- C_M_AXIS_MM2S_TDATA_WIDTH/8
            -- Minimum valid value is C_S_AXIS_S2MM_TDATA_WIDTH/8
            -- Maximum valid value is C_S2MM_LINEBUFFER_DEPTH

        C_S2MM_MAX_BURST_LENGTH         : integer range 16 to 256   := 16;
            -- Maximum burst size in data beats per burst request on S2MM Write Port

        C_M_AXI_S2MM_ADDR_WIDTH         : integer range 32 to 32    := 32;
            -- Master AXI Memory Map Address Width for S2MM Write Port

        C_M_AXI_S2MM_DATA_WIDTH         : integer range 32 to 1024  := 32;
            -- Master AXI Memory Map Data Width for MM2SS2MMWrite Port

        C_S_AXIS_S2MM_TDATA_WIDTH       : integer range 8 to 1024   := 32;
            -- Slave AXI Stream Data Width for S2MM Channel

        C_S_AXIS_S2MM_TUSER_BITS        : integer range 1 to 1      := 1;
            -- Slave AXI Stream User Width for S2MM Channel

        C_FAMILY                        : string                    := "virtex6"
            -- Target FPGA Device Family
    );
    port (
        -- Control Clocks
        s_axi_lite_aclk             : in  std_logic                         ;                   --
        m_axi_sg_aclk               : in  std_logic                         ;                   --

        -- MM2S Clocks
        m_axi_mm2s_aclk             : in  std_logic                         ;                   --
        m_axis_mm2s_aclk            : in  std_logic                         ;                   --

        -- S2MM Clocks
        m_axi_s2mm_aclk             : in  std_logic                         ;                   --
        s_axis_s2mm_aclk            : in  std_logic                         ;                   --

        axi_resetn                  : in  std_logic                         ;                   --
                                                                                                --
        -----------------------------------------------------------------------                 --
        -- AXI Lite Control Interface                                                           --
        -----------------------------------------------------------------------                 --
        -- AXI Lite Write Address Channel                                                       --
        s_axi_lite_awvalid          : in  std_logic                         ;                   --
        s_axi_lite_awready          : out std_logic                         ;                   --
        s_axi_lite_awaddr           : in  std_logic_vector                                      --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);                   --
                                                                                                --
        -- AXI Lite Write Data Channel                                                          --
        s_axi_lite_wvalid           : in  std_logic                         ;                   --
        s_axi_lite_wready           : out std_logic                         ;                   --
        s_axi_lite_wdata            : in  std_logic_vector                                      --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0);                   --
                                                                                                --
        -- AXI Lite Write Response Channel                                                      --
        s_axi_lite_bresp            : out std_logic_vector(1 downto 0)      ;                   --
        s_axi_lite_bvalid           : out std_logic                         ;                   --
        s_axi_lite_bready           : in  std_logic                         ;                   --
                                                                                                --
        -- AXI Lite Read Address Channel                                                        --
        s_axi_lite_arvalid          : in  std_logic                         ;                   --
        s_axi_lite_arready          : out std_logic                         ;                   --
        s_axi_lite_araddr           : in  std_logic_vector                                      --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);                   --
        s_axi_lite_rvalid           : out std_logic                         ;                   --
        s_axi_lite_rready           : in  std_logic                         ;                   --
        s_axi_lite_rdata            : out std_logic_vector                                      --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0);                   --
        s_axi_lite_rresp            : out std_logic_vector(1 downto 0)      ;                   --
                                                                                                --
        -----------------------------------------------------------------------                 --
        -- AXI Video Interface                                                                  --
        -----------------------------------------------------------------------                 --
        mm2s_fsync                  : in  std_logic                         ;                   --
        mm2s_frame_ptr_in           : in  std_logic_vector                                      --
                                        ((C_MM2S_GENLOCK_NUM_MASTERS*6)-1 downto 0);            --
        mm2s_frame_ptr_out          : out std_logic_vector(5 downto 0);                         --
        s2mm_fsync                  : in  std_logic                         ;                   --
        s2mm_frame_ptr_in           : in  std_logic_vector                                      --
                                        ((C_S2MM_GENLOCK_NUM_MASTERS*6)-1 downto 0);            --
        s2mm_frame_ptr_out          : out std_logic_vector(5 downto 0);                         --
        mm2s_buffer_empty           : out std_logic                         ;                   --
        mm2s_buffer_almost_empty    : out std_logic                         ;                   --
        s2mm_buffer_full            : out std_logic                         ;                   --
        s2mm_buffer_almost_full     : out std_logic                         ;                   --
                                                                                                --
        mm2s_fsync_out              : out std_logic                         ;                   --
        s2mm_fsync_out              : out std_logic                         ;                   --
        mm2s_prmtr_update           : out std_logic                         ;                   --
        s2mm_prmtr_update           : out std_logic                         ;                   --
                                                                                                --
        -----------------------------------------------------------------------                 --
        -- AXI Scatter Gather Interface                                                         --
        -----------------------------------------------------------------------                 --
        -- Scatter Gather Read Address Channel                                                  --
        m_axi_sg_araddr             : out std_logic_vector                                      --
                                        (C_M_AXI_SG_ADDR_WIDTH-1 downto 0)  ;                   --
        m_axi_sg_arlen              : out std_logic_vector(7 downto 0)      ;                   --
        m_axi_sg_arsize             : out std_logic_vector(2 downto 0)      ;                   --
        m_axi_sg_arburst            : out std_logic_vector(1 downto 0)      ;                   --
        m_axi_sg_arprot             : out std_logic_vector(2 downto 0)      ;                   --
        m_axi_sg_arcache            : out std_logic_vector(3 downto 0)      ;                   --
        m_axi_sg_arvalid            : out std_logic                         ;                   --
        m_axi_sg_arready            : in  std_logic                         ;                   --
                                                                                                --
        -- Memory Map to Stream Scatter Gather Read Data Channel                                --
        m_axi_sg_rdata              : in  std_logic_vector                                      --
                                        (C_M_AXI_SG_DATA_WIDTH-1 downto 0)  ;                   --
        m_axi_sg_rresp              : in  std_logic_vector(1 downto 0)      ;                   --
        m_axi_sg_rlast              : in  std_logic                         ;                   --
        m_axi_sg_rvalid             : in  std_logic                         ;                   --
        m_axi_sg_rready             : out std_logic                         ;                   --
                                                                                                --
        -----------------------------------------------------------------------                 --
        -- AXI MM2S Channel                                                                     --
        -----------------------------------------------------------------------                 --
        -- Memory Map To Stream Read Address Channel                                            --
        m_axi_mm2s_araddr           : out std_logic_vector                                      --
                                        (C_M_AXI_MM2S_ADDR_WIDTH-1 downto 0);                   --
        m_axi_mm2s_arlen            : out std_logic_vector(7 downto 0)      ;                   --
        m_axi_mm2s_arsize           : out std_logic_vector(2 downto 0)      ;                   --
        m_axi_mm2s_arburst          : out std_logic_vector(1 downto 0)      ;                   --
        m_axi_mm2s_arprot           : out std_logic_vector(2 downto 0)      ;                   --
        m_axi_mm2s_arcache          : out std_logic_vector(3 downto 0)      ;                   --
        m_axi_mm2s_arvalid          : out std_logic                         ;                   --
        m_axi_mm2s_arready          : in  std_logic                         ;                   --
                                                                                                --
        -- Memory Map  to Stream Read Data Channel                                              --
        m_axi_mm2s_rdata            : in  std_logic_vector                                      --
                                        (C_M_AXI_MM2S_DATA_WIDTH-1 downto 0);                   --
        m_axi_mm2s_rresp            : in  std_logic_vector(1 downto 0)      ;                   --
        m_axi_mm2s_rlast            : in  std_logic                         ;                   --
        m_axi_mm2s_rvalid           : in  std_logic                         ;                   --
        m_axi_mm2s_rready           : out std_logic                         ;                   --
                                                                                                --
        -- Memory Map to Stream Stream Interface                                                --
        mm2s_prmry_reset_out_n      : out std_logic                         ;                   --
        m_axis_mm2s_tdata           : out std_logic_vector                                      --
                                        (C_M_AXIS_MM2S_TDATA_WIDTH-1 downto 0);                 --
        m_axis_mm2s_tkeep           : out std_logic_vector                                      --
                                        ((C_M_AXIS_MM2S_TDATA_WIDTH/8)-1 downto 0);             --
        m_axis_mm2s_tuser           : out std_logic_vector                                      --
                                        (C_M_AXIS_MM2S_TUSER_BITS-1 downto 0);                  --
        m_axis_mm2s_tvalid          : out std_logic                         ;                   --
        m_axis_mm2s_tready          : in  std_logic                         ;                   --
        m_axis_mm2s_tlast           : out std_logic                         ;                   --
                                                                                                --
        -----------------------------------------------------------------------                 --
        -- AXI S2MM Channel                                                                     --
        -----------------------------------------------------------------------                 --
        -- Stream to Memory Map Write Address Channel                                           --
        m_axi_s2mm_awaddr           : out std_logic_vector                                      --
                                        (C_M_AXI_S2MM_ADDR_WIDTH-1 downto 0);                   --
        m_axi_s2mm_awlen            : out std_logic_vector(7 downto 0)      ;                   --
        m_axi_s2mm_awsize           : out std_logic_vector(2 downto 0)      ;                   --
        m_axi_s2mm_awburst          : out std_logic_vector(1 downto 0)      ;                   --
        m_axi_s2mm_awprot           : out std_logic_vector(2 downto 0)      ;                   --
        m_axi_s2mm_awcache          : out std_logic_vector(3 downto 0)      ;                   --
        m_axi_s2mm_awvalid          : out std_logic                         ;                   --
        m_axi_s2mm_awready          : in  std_logic                         ;                   --
                                                                                                --
        -- Stream to Memory Map Write Data Channel                                              --
        m_axi_s2mm_wdata            : out std_logic_vector                                      --
                                        (C_M_AXI_S2MM_DATA_WIDTH-1 downto 0);                   --
        m_axi_s2mm_wstrb            : out std_logic_vector                                      --
                                        ((C_M_AXI_S2MM_DATA_WIDTH/8)-1 downto 0);               --
        m_axi_s2mm_wlast            : out std_logic                         ;                   --
        m_axi_s2mm_wvalid           : out std_logic                         ;                   --
        m_axi_s2mm_wready           : in  std_logic                         ;                   --
                                                                                                --
        -- Stream to Memory Map Write Response Channel                                          --
        m_axi_s2mm_bresp            : in  std_logic_vector(1 downto 0)      ;                   --
        m_axi_s2mm_bvalid           : in  std_logic                         ;                   --
        m_axi_s2mm_bready           : out std_logic                         ;                   --
                                                                                                --
        -- Stream to Memory Map Steam Interface                                                 --
        s2mm_prmry_reset_out_n      : out std_logic                         ;                   --
        s_axis_s2mm_tdata           : in  std_logic_vector                                      --
                                        (C_S_AXIS_S2MM_TDATA_WIDTH-1 downto 0);                 --
        s_axis_s2mm_tkeep           : in  std_logic_vector                                      --
                                        ((C_S_AXIS_S2MM_TDATA_WIDTH/8)-1 downto 0);             --
        s_axis_s2mm_tuser           : in  std_logic_vector                                      --
                                        (C_S_AXIS_S2MM_TUSER_BITS-1 downto 0);                  --
        s_axis_s2mm_tvalid          : in  std_logic                         ;                   --
        s_axis_s2mm_tready          : out std_logic                         ;                   --
        s_axis_s2mm_tlast           : in  std_logic                         ;                   --
                                                                                                --
                                                                                                --
        -- MM2S and S2MM Channel Interrupts                                                     --
        mm2s_introut                : out std_logic                         ;                   --
        s2mm_introut                : out std_logic                         ;                   --
        axi_vdma_tstvec             : out std_logic_vector(63 downto 0)                         --
    );

-----------------------------------------------------------------
-- Start of PSFUtil MPD attributes
-----------------------------------------------------------------
attribute IP_GROUP                  : string;
attribute IP_GROUP     of axi_vdma   : entity   is "LOGICORE";

attribute IPTYPE                    : string;
attribute IPTYPE       of axi_vdma   : entity   is "PERIPHERAL";

attribute RUN_NGCBUILD              : string;
attribute RUN_NGCBUILD of axi_vdma   : entity   is "TRUE";

-----------------------------------------------------------------
-- End of PSFUtil MPD attributes
-----------------------------------------------------------------
end axi_vdma;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma is
-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------
-- Major Version number 0, 1, 2, 3 etc.
constant VERSION_MAJOR                  : std_logic_vector (3 downto 0) := X"5" ;
-- Minor Version Number 00, 01, 02, etc.
constant VERSION_MINOR                  : std_logic_vector (7 downto 0) := X"00";
-- Version Revision character (EDK) a,b,c,etc
constant VERSION_REVISION               : std_logic_vector (3 downto 0) := X"a" ;
-- Internal build number
constant REVISION_NUMBER                : string := "Build Number: O87";

--*****************************************************************************
--** Scatter Gather Engine Configuration
--*****************************************************************************
constant SG_INCLUDE_DESC_QUEUE          : integer range 0 to 1          := 0;
            -- Include or Exclude Scatter Gather Descriptor Queuing
            -- 0 = Exclude SG Descriptor Queuing
            -- 1 = Include SG Descriptor Queuing
-- Number of Fetch Descriptors to Queue
constant SG_FTCH_DESC2QUEUE             : integer := SG_INCLUDE_DESC_QUEUE * 4;
-- Number of Update Descriptors to Queue
constant SG_UPDT_DESC2QUEUE             : integer := SG_INCLUDE_DESC_QUEUE * 4;
-- Number of fetch words per descriptor for channel 1 (MM2S)
constant SG_CH1_WORDS_TO_FETCH          : integer := 7;
-- Number of fetch words per descriptor for channel 2 (S2MM)
constant SG_CH2_WORDS_TO_FETCH          : integer := 7;
-- Number of update words per descriptor for channel 1 (MM2S)
constant SG_CH1_WORDS_TO_UPDATE         : integer := 1; -- No Descriptor update for video
-- Number of update words per descriptor for channel 2 (S2MM)
constant SG_CH2_WORDS_TO_UPDATE         : integer := 1; -- No Descriptor update for video
-- First word offset (referenced to descriptor beginning) to update for channel 1 (MM2S)
constant SG_CH1_FIRST_UPDATE_WORD       : integer := 0; -- No Descriptor update for video
-- First word offset (referenced to descriptor beginning) to update for channel 2 (MM2S)
constant SG_CH2_FIRST_UPDATE_WORD       : integer := 0; -- No Descriptor update for video
-- Enable stale descriptor check for channel 1
constant SG_CH1_ENBL_STALE_ERROR        : integer := 0;
-- Enable stale descriptor check for channel 2
constant SG_CH2_ENBL_STALE_ERROR        : integer := 0;
-- Width of descriptor fetch bus
constant M_AXIS_SG_TDATA_WIDTH          : integer := 32;
-- Width of descriptor pointer update bus
constant S_AXIS_UPDPTR_TDATA_WIDTH      : integer := 32;
-- Width of descriptor status update bus
constant S_AXIS_UPDSTS_TDATA_WIDTH      : integer := 33;
-- Include SG Descriptor Updates
constant EXCLUDE_DESC_UPDATE            : integer := 0;  -- No Descriptor update for video
-- Include SG Interrupt Logic
constant EXCLUDE_INTRPT                 : integer := 0; -- Interrupt logic external to sg engine
-- Include SG Delay Interrupt
constant INCLUDE_DLYTMR                 : integer := 1;
constant EXCLUDE_DLYTMR                 : integer := 0;

--*****************************************************************************
--** General/Misc Constants
--*****************************************************************************
-- enable flush mode if both C_USE_FSYNC = 1 AND C_FLUSH_ON_FSYNC = 1
constant ENABLE_FLUSH_ON_FSYNC          : integer := C_USE_FSYNC
                                                   * C_FLUSH_ON_FSYNC;


--*****************************************************************************
--** AXI LITE Interface Constants
--*****************************************************************************
--constant TOTAL_NUM_REGISTER     : integer := NUM_REG_TOTAL_REGDIR;
constant TOTAL_NUM_REGISTER     : integer := get_num_registers(C_INCLUDE_SG,NUM_REG_TOTAL_SG,NUM_REG_TOTAL_REGDIR);








constant C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED     : integer :=calculated_mm2s_tdata_width(C_M_AXIS_MM2S_TDATA_WIDTH);
constant C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED     : integer :=calculated_s2mm_tdata_width(C_S_AXIS_S2MM_TDATA_WIDTH);
 







-- Specifies to register module which channel is which
constant CHANNEL_IS_MM2S        : integer := 1;
constant CHANNEL_IS_S2MM        : integer := 0;

--*****************************************************************************
--** DataMover General Constants
--*****************************************************************************
-- Primary DataMover Configuration
-- DataMover Command / Status FIFO Depth
-- Note :Set maximum to the number of update descriptors to queue, to prevent lock up do to
-- update data fifo full before
constant DM_CMDSTS_FIFO_DEPTH           : integer := 4;

-- DataMover Include Status FIFO
constant DM_INCLUDE_STS_FIFO            : integer := 1;

-- DataMover outstanding address request fifo depth
constant DM_ADDR_PIPE_DEPTH             : integer := 4;

-- Base status vector width
constant BASE_STATUS_WIDTH              : integer := 8;

-- AXI DataMover Full mode value
constant AXI_FULL_MODE                  : integer := 1;

-- Datamover clock always synchronous
constant DM_CLOCK_SYNC                  : integer := 0;

-- Always allow datamover address requests
constant ALWAYS_ALLOW                   : std_logic := '1';

constant ZERO_VALUE                     : std_logic_vector(1023 downto 0) := (others => '0');

--*****************************************************************************
--** S2MM DataMover Specific Constants
--*****************************************************************************
-- AXI DataMover mode for S2MM Channel (0 if channel not included)
constant S2MM_AXI_FULL_MODE             : integer := C_INCLUDE_S2MM * AXI_FULL_MODE;

-- CR591965 - Modified for flush on frame sync
-- Enable indeterminate BTT on datamover when S2MM Store And Forward Present
-- In this mode, the DataMovers S2MM store and forward buffer will be used
-- and underflow and overflow will be detected via receive byte compare
--constant DM_SUPPORT_INDET_BTT           : integer := 0;
-- Enable indeterminate BTT on datamover when S2MM flush on frame sync is
-- enabled allowing S2MM AXIS stream absorption and prevent datamover
-- halt.  Overflow and Underfow error detected external to datamover
-- in axi_vdma_cmdsts.vhd
constant DM_SUPPORT_INDET_BTT           : integer := ENABLE_FLUSH_ON_FSYNC;


-- Indterminate BTT Mode additional status vector width
constant INDETBTT_ADDED_STS_WIDTH       : integer := 24;

-- DataMover status width is based on mode of operation
constant S2MM_DM_STATUS_WIDTH           : integer := BASE_STATUS_WIDTH
                                                  + (DM_SUPPORT_INDET_BTT * INDETBTT_ADDED_STS_WIDTH);
-- Never extend on S2MM
constant S2MM_DM_CMD_EXTENDED           : integer := 0;

-- Minimum value required for length width based on burst size and stream dwidth
-- If hsize is too small based on setting of burst size and
-- dwidth then this will reset the width to a larger mimimum requirement.
constant S2MM_DM_BTT_LENGTH_WIDTH       : integer := required_btt_width(C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED,
                                                                   C_S2MM_MAX_BURST_LENGTH,
                                                                   HSIZE_DWIDTH);

-- Enable store and forward on datamover if data widths are mismatched (allows upsizers
-- to be instantiated) or when enabled by user.
constant DM_S2MM_INCLUDE_SF             : integer := enable_snf(C_INCLUDE_S2MM_SF,
                                                                C_M_AXI_S2MM_DATA_WIDTH,
                                                                C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED);

--*****************************************************************************
--** MM2S DataMover Specific Constants
--*****************************************************************************
-- AXI DataMover mode for MM2S Channel (0 if channel not included)
constant MM2S_AXI_FULL_MODE             : integer := C_INCLUDE_MM2S * AXI_FULL_MODE;

-- Never extend on MM2S
constant MM2S_DM_CMD_NOT_EXTENDED       : integer := 0;

-- DataMover status width - fixed to 8 for MM2S
constant MM2S_DM_STATUS_WIDTH           : integer := BASE_STATUS_WIDTH;

-- Minimum value required for length width based on burst size and stream dwidth
-- If hsize is too small based on setting of burst size and
-- dwidth then this will reset the width to a larger mimimum requirement.
constant MM2S_DM_BTT_LENGTH_WIDTH       : integer := required_btt_width(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED,
                                                                  C_MM2S_MAX_BURST_LENGTH,
                                                                  HSIZE_DWIDTH);

-- Enable store and forward on datamover if data widths are mismatched (allows upsizers
-- to be instantiated) or when enabled by user.
constant DM_MM2S_INCLUDE_SF             : integer := enable_snf(C_INCLUDE_MM2S_SF,
                                                                C_M_AXI_MM2S_DATA_WIDTH,
                                                                C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED);

--*****************************************************************************
--** Line Buffer Constants
--*****************************************************************************
-- For LineBuffer, track vertical lines to allow de-assertion of tready
-- when s2mm finished with frame. MM2S does not need to track lines
constant TRACK_NO_LINES                 : integer := 0;
constant TRACK_LINES                    : integer := 1;
-- zero vector of vsize width used to tie off mm2s line tracking ports
constant VSIZE_ZERO                     : std_logic_vector(VSIZE_DWIDTH-1 downto 0)
                                        := (others => '0');

-- Linebuffer default Almost Empty Threshold and Almost Full threshold
constant LINEBUFFER_AE_THRESH           : integer := 1;
constant LINEBUFFER_AF_THRESH           : integer := max2(1,C_MM2S_LINEBUFFER_DEPTH/2);

-- Include and Exclude settings for linebuffer skid buffers
constant INCLUDE_MSTR_SKID_BUFFER       : integer := 1;
constant EXCLUDE_MSTR_SKID_BUFFER       : integer := 0;
constant INCLUDE_SLV_SKID_BUFFER        : integer := 1;
constant EXCLUDE_SLV_SKID_BUFFER        : integer := 0;



-- Force a depth of 512 minimum if asynchronous clocks enabled and a 128 minimum for synchronous mode
-- Also converts depth in bytes to depth in data beats
constant MM2S_LINEBUFFER_DEPTH          : integer := max2(128,(max2((C_MM2S_LINEBUFFER_DEPTH/(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED/8)),
                                                          (C_PRMRY_IS_ACLK_ASYNC*512))));

-- Force a depth of 512 minimum if asynchronous clocks enabled and a 128 minimum for synchronous mode
-- Also converts depth in bytes to depth in data beats
constant S2MM_LINEBUFFER_DEPTH          : integer := max2(128,(max2((C_S2MM_LINEBUFFER_DEPTH/(C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED/8)),
                                                          (C_PRMRY_IS_ACLK_ASYNC*512))));



-- Enable SOF only for external frame sync and when SOF Enable parameter set
constant MM2S_SOF_ENABLE                : integer := C_USE_FSYNC * C_MM2S_SOF_ENABLE;
constant S2MM_SOF_ENABLE                : integer := C_USE_FSYNC * C_S2MM_SOF_ENABLE;


--*****************************************************************************
--** GenLock Constants
--*****************************************************************************
-- GenLock Data Widths for Clock Domain Crossing Module
constant MM2S_GENLOCK_SLVE_PTR_DWIDTH   : integer := (C_MM2S_GENLOCK_NUM_MASTERS*NUM_FRM_STORE_WIDTH);
constant S2MM_GENLOCK_SLVE_PTR_DWIDTH   : integer := (C_S2MM_GENLOCK_NUM_MASTERS*NUM_FRM_STORE_WIDTH);

constant INTERNAL_GENLOCK_ENABLE        : integer := enable_internal_genloc(C_INCLUDE_INTERNAL_GENLOCK,
                                                                            C_MM2S_GENLOCK_MODE,
                                                                            C_S2MM_GENLOCK_MODE);



-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
signal mm2s_prmry_resetn                : std_logic := '1';     -- AXI  MM2S Primary Reset
signal mm2s_dm_prmry_resetn             : std_logic := '1';     -- AXI  MM2S DataMover Primary Reset (Raw)
signal mm2s_axis_resetn                 : std_logic := '1';     -- AXIS MM2S Primary Reset
signal s2mm_prmry_resetn                : std_logic := '1';     -- AXI  S2MM Primary Reset
signal s2mm_dm_prmry_resetn             : std_logic := '1';     -- AXI  S2MM DataMover Primary Reset (Raw)
signal s2mm_axis_resetn                 : std_logic := '1';     -- AXIS S2MM Primary Reset
signal s_axi_lite_resetn                : std_logic := '1';     -- AXI  Lite Interface Reset (Hard Only)
signal m_axi_sg_resetn                  : std_logic := '1';     -- AXI  Scatter Gather Interface Reset
signal m_axi_dm_sg_resetn               : std_logic := '1';     -- AXI  Scatter Gather Interface Reset (Raw)
signal mm2s_hrd_resetn                  : std_logic := '1';     -- AXI Hard Reset Only for MM2S
signal s2mm_hrd_resetn                  : std_logic := '1';     -- AXI Hard Reset Only for S2MM


-- MM2S Register Module Signals
signal mm2s_stop                        : std_logic := '0';
signal mm2s_halted_clr                  : std_logic := '0';
signal mm2s_halted_set                  : std_logic := '0';
signal mm2s_idle_set                    : std_logic := '0';
signal mm2s_idle_clr                    : std_logic := '0';
signal mm2s_dma_interr_set              : std_logic := '0';
signal mm2s_dma_slverr_set              : std_logic := '0';
signal mm2s_dma_decerr_set              : std_logic := '0';
signal mm2s_ioc_irq_set                 : std_logic := '0';
signal mm2s_dly_irq_set                 : std_logic := '0';
signal mm2s_irqdelay_status             : std_logic_vector(7 downto 0) := (others => '0');
signal mm2s_irqthresh_status            : std_logic_vector(7 downto 0) := (others => '0');
signal mm2s_new_curdesc_wren            : std_logic := '0';
signal mm2s_new_curdesc                 : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0)    := (others => '0');
signal mm2s_tailpntr_updated            : std_logic := '0';
signal mm2s_dmacr                       : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal mm2s_dmasr                       : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal mm2s_curdesc                     : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0)    := (others => '0');
signal mm2s_taildesc                    : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0)    := (others => '0');
signal mm2s_num_frame_store             : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0)      := (others => '0');
signal mm2s_linebuf_threshold           : std_logic_vector(THRESH_MSB_BIT downto 0)           := (others => '0');
signal mm2s_packet_sof                  : std_logic := '0';
signal mm2s_all_idle                    : std_logic := '0';
signal mm2s_cmdsts_idle                 : std_logic := '0';
signal mm2s_frame_number                : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal mm2s_crnt_vsize                  : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');
signal mm2s_dlyirq_dsble                : std_logic := '0';
signal mm2s_irqthresh_rstdsbl           : std_logic := '0';
signal mm2s_valid_video_prmtrs          : std_logic := '0';
signal mm2s_all_lines_xfred             : std_logic := '0';
signal mm2s_fsize_mismatch_err          : std_logic := '0'; -- CR591965
signal mm2s_frame_ptr_out_i             : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0) := (others => '0');
signal mm2s_to_s2mm_fsync               : std_logic := '0';

-- MM2S Register Direct Support
signal mm2s_regdir_idle                 : std_logic := '0';
signal mm2s_prmtr_updt_complete         : std_logic := '0';
signal mm2s_reg_module_vsize            : std_logic_vector(VSIZE_DWIDTH-1 downto 0);
signal mm2s_reg_module_hsize            : std_logic_vector(HSIZE_DWIDTH-1 downto 0);
signal mm2s_reg_module_stride           : std_logic_vector(STRIDE_DWIDTH-1 downto 0);
signal mm2s_reg_module_frmdly           : std_logic_vector(FRMDLY_DWIDTH-1 downto 0);
signal mm2s_reg_module_strt_addr        : STARTADDR_ARRAY_TYPE(0 to C_NUM_FSTORES - 1);

-- MM2S Register Interface Signals
signal mm2s_axi2ip_wrce                 : std_logic_vector(TOTAL_NUM_REGISTER-1 downto 0)       := (others => '0');
signal mm2s_axi2ip_wrdata               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0')      ;
signal mm2s_axi2ip_rdaddr               : std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)  := (others => '0')      ;
signal mm2s_axi2ip_rden                 : std_logic := '0';
signal mm2s_ip2axi_rddata               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0')      ;
signal mm2s_ip2axi_rddata_valid         : std_logic := '0';
signal mm2s_ip2axi_frame_ptr_ref        : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal mm2s_ip2axi_frame_store          : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal mm2s_ip2axi_introut              : std_logic := '0';

-- MM2S Scatter Gather clock domain crossing signals
signal mm2s_cdc2sg_run_stop             : std_logic := '0';
signal mm2s_cdc2sg_stop                 : std_logic := '0';
signal mm2s_cdc2sg_taildesc_wren        : std_logic := '0';
signal mm2s_cdc2sg_taildesc             : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal mm2s_cdc2sg_curdesc              : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal mm2s_sg2cdc_ftch_idle            : std_logic := '0';
signal mm2s_sg2cdc_ftch_interr_set      : std_logic := '0';
signal mm2s_sg2cdc_ftch_slverr_set      : std_logic := '0';
signal mm2s_sg2cdc_ftch_decerr_set      : std_logic := '0';

-- MM2S DMA Controller Signals
signal mm2s_ftch_idle                   : std_logic := '0';
signal mm2s_updt_ioc_irq_set            : std_logic := '0';
signal mm2s_irqthresh_wren              : std_logic := '0';
signal mm2s_irqdelay_wren               : std_logic := '0';
signal mm2s_ftchcmdsts_idle             : std_logic := '0';

-- SG MM2S Descriptor Fetch AXI Stream IN
signal m_axis_mm2s_ftch_tdata           : std_logic_vector(M_AXIS_SG_TDATA_WIDTH-1 downto 0) := (others => '0');
signal m_axis_mm2s_ftch_tvalid          : std_logic := '0';
signal m_axis_mm2s_ftch_tready          : std_logic := '0';
signal m_axis_mm2s_ftch_tlast           : std_logic := '0';

-- DataMover MM2S Command Stream Signals
signal s_axis_mm2s_cmd_tvalid           : std_logic := '0';
signal s_axis_mm2s_cmd_tready           : std_logic := '0';
signal s_axis_mm2s_cmd_tdata            : std_logic_vector
                                            ((C_M_AXI_MM2S_ADDR_WIDTH+CMD_BASE_WIDTH)-1 downto 0) := (others => '0');
-- DataMover MM2S Status Stream Signals
signal m_axis_mm2s_sts_tvalid           : std_logic := '0';
signal m_axis_mm2s_sts_tready           : std_logic := '0';
signal m_axis_mm2s_sts_tdata            : std_logic_vector(MM2S_DM_STATUS_WIDTH - 1 downto 0) := (others => '0');   -- CR608521
signal m_axis_mm2s_sts_tkeep            : std_logic_vector((MM2S_DM_STATUS_WIDTH/8)-1 downto 0) := (others => '0'); -- CR608521
signal mm2s_err                         : std_logic := '0';
signal mm2s_halt                        : std_logic := '0';
signal mm2s_halt_cmplt                  : std_logic := '0';

-- DataMover To Line Buffer AXI Stream Signals
signal dm2linebuf_mm2s_tdata            : std_logic_vector(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED-1 downto 0);
signal dm2linebuf_mm2s_tkeep            : std_logic_vector((C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED/8)-1 downto 0);
signal dm2linebuf_mm2s_tlast            : std_logic := '0';
signal dm2linebuf_mm2s_tvalid           : std_logic := '0';
signal linebuf2dm_mm2s_tready           : std_logic := '0';

-- MM2S Error Status Control
signal mm2s_ftch_interr_set             : std_logic := '0';
signal mm2s_ftch_slverr_set             : std_logic := '0';
signal mm2s_ftch_decerr_set             : std_logic := '0';

-- MM2S Soft Reset support
signal mm2s_soft_reset                  : std_logic := '0';
signal mm2s_soft_reset_clr              : std_logic := '0';

-- MM2S SOF generation support
signal m_axis_mm2s_tvalid_i             : std_logic := '0';
signal m_axis_mm2s_tvalid_i_axis_dw_conv             : std_logic := '0';
signal m_axis_mm2s_tlast_i              : std_logic := '0';
signal m_axis_mm2s_tlast_i_axis_dw_conv              : std_logic := '0';

signal              s_axis_s2mm_tdata_i           :   std_logic_vector                                      --
                                        (C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED-1 downto 0) := (others => '0');                 --
signal              s_axis_s2mm_tkeep_i           :   std_logic_vector                                      --
                                        ((C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED/8)-1 downto 0) := (others => '0');             --
signal              s_axis_s2mm_tuser_i           :   std_logic_vector                                      --
                                        (C_S_AXIS_S2MM_TUSER_BITS-1 downto 0) := (others => '0');                  --
signal              s_axis_s2mm_tvalid_i          :   std_logic                         ;                   --
signal              s_axis_s2mm_tlast_i           :   std_logic ;            


signal         m_axis_mm2s_tdata_i           : std_logic_vector                                      --
                                        (C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED-1 downto 0) := (others => '0');                 --
signal         m_axis_mm2s_tkeep_i           : std_logic_vector                                      --
                                        ((C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED/8)-1 downto 0) := (others => '0');             --
signal         m_axis_mm2s_tuser_i           : std_logic_vector                                      --
                                        (C_M_AXIS_MM2S_TUSER_BITS-1 downto 0) := (others => '0');                  --
signal         m_axis_mm2s_tready_i          : std_logic                         ;                   --
-- S2MM Register Module Signals
signal s2mm_stop                        : std_logic := '0';
signal s2mm_halted_clr                  : std_logic := '0';
signal s2mm_halted_set                  : std_logic := '0';
signal s2mm_idle_set                    : std_logic := '0';
signal s2mm_idle_clr                    : std_logic := '0';
signal s2mm_dma_interr_set              : std_logic := '0';
signal s2mm_dma_slverr_set              : std_logic := '0';
signal s2mm_dma_decerr_set              : std_logic := '0';
signal s2mm_ioc_irq_set                 : std_logic := '0';
signal s2mm_dly_irq_set                 : std_logic := '0';
signal s2mm_irqdelay_status             : std_logic_vector(7 downto 0) := (others => '0');
signal s2mm_irqthresh_status            : std_logic_vector(7 downto 0) := (others => '0');
signal s2mm_new_curdesc_wren            : std_logic := '0';
signal s2mm_new_curdesc                 : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0)    := (others => '0');
signal s2mm_tailpntr_updated            : std_logic := '0';
signal s2mm_dmacr                       : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal s2mm_dmasr                       : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal s2mm_curdesc                     : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0)    := (others => '0');
signal s2mm_taildesc                    : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0)    := (others => '0');
signal s2mm_num_frame_store             : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0)      := (others => '0');
signal s2mm_linebuf_threshold           : std_logic_vector(THRESH_MSB_BIT downto 0)           := (others => '0');
signal s2mm_packet_sof                  : std_logic := '0';
signal s2mm_all_idle                    : std_logic := '0';
signal s2mm_cmdsts_idle                 : std_logic := '0';
signal s2mm_frame_number                : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_dlyirq_dsble                : std_logic := '0';
signal s2mm_irqthresh_rstdsbl           : std_logic := '0';
signal s2mm_valid_video_prmtrs          : std_logic := '0';
signal s2mm_crnt_vsize                  : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');-- CR575884
signal s2mm_update_frmstore             : std_logic := '0'; --CR582182
signal s2mm_frmstr_error_addr           : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0'); --CR582182
signal s2mm_all_lines_xfred             : std_logic := '0'; -- CR591965
signal all_lasts_rcvd                   : std_logic := '0';


signal s2mm_fsize_mismatch_err          : std_logic := '0'; -- CR591965
signal s2mm_tuser_fsync                 : std_logic := '0';
signal s2mm_frame_ptr_out_i             : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0) := (others => '0');
signal s2mm_to_mm2s_fsync               : std_logic := '0';

-- S2MM Register Direct Support
signal s2mm_regdir_idle                 : std_logic := '0';
signal s2mm_prmtr_updt_complete         : std_logic := '0';
signal s2mm_reg_module_vsize            : std_logic_vector(VSIZE_DWIDTH-1 downto 0);
signal s2mm_reg_module_hsize            : std_logic_vector(HSIZE_DWIDTH-1 downto 0);
signal s2mm_reg_module_stride           : std_logic_vector(STRIDE_DWIDTH-1 downto 0);
signal s2mm_reg_module_frmdly           : std_logic_vector(FRMDLY_DWIDTH-1 downto 0);
signal s2mm_reg_module_strt_addr        : STARTADDR_ARRAY_TYPE(0 to C_NUM_FSTORES - 1);

-- S2MM Register Interface Signals
signal s2mm_axi2ip_wrce                 : std_logic_vector(TOTAL_NUM_REGISTER-1 downto 0)       := (others => '0');
signal s2mm_axi2ip_wrdata               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal s2mm_axi2ip_rdaddr               : std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)  := (others => '0');
signal s2mm_axi2ip_rden                 : std_logic := '0';
signal s2mm_ip2axi_rddata               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal s2mm_ip2axi_rddata_valid         : std_logic := '0';
signal s2mm_ip2axi_frame_ptr_ref        : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_ip2axi_frame_store          : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_ip2axi_introut              : std_logic := '0';

-- S2MM Scatter Gather clock domain crossing signals
signal s2mm_cdc2sg_run_stop             : std_logic := '0';
signal s2mm_cdc2sg_stop                 : std_logic := '0';
signal s2mm_cdc2sg_taildesc_wren        : std_logic := '0';
signal s2mm_cdc2sg_taildesc             : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal s2mm_cdc2sg_curdesc              : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal s2mm_sg2cdc_ftch_idle            : std_logic := '0';
signal s2mm_sg2cdc_ftch_interr_set      : std_logic := '0';
signal s2mm_sg2cdc_ftch_slverr_set      : std_logic := '0';
signal s2mm_sg2cdc_ftch_decerr_set      : std_logic := '0';

-- S2MM DMA Controller Signals
signal s2mm_desc_flush                  : std_logic := '0';
signal s2mm_ftch_idle                   : std_logic := '0';
signal s2mm_irqthresh_wren              : std_logic := '0';
signal s2mm_irqdelay_wren               : std_logic := '0';
signal s2mm_ftchcmdsts_idle             : std_logic := '0';

-- SG S2MM Descriptor Fetch AXI Stream IN
signal m_axis_s2mm_ftch_tdata           : std_logic_vector(M_AXIS_SG_TDATA_WIDTH-1 downto 0) := (others => '0');
signal m_axis_s2mm_ftch_tvalid          : std_logic := '0';
signal m_axis_s2mm_ftch_tready          : std_logic := '0';
signal m_axis_s2mm_ftch_tlast           : std_logic := '0';

-- DataMover S2MM Command Stream Signals
signal s_axis_s2mm_cmd_tvalid           : std_logic := '0';
signal s_axis_s2mm_cmd_tready           : std_logic := '0';
signal s_axis_s2mm_cmd_tdata            : std_logic_vector
                                        ((C_M_AXI_S2MM_ADDR_WIDTH+CMD_BASE_WIDTH)-1 downto 0) := (others => '0');
-- DataMover S2MM Status Stream Signals
signal m_axis_s2mm_sts_tvalid           : std_logic := '0';
signal m_axis_s2mm_sts_tready           : std_logic := '0';
signal m_axis_s2mm_sts_tdata            : std_logic_vector(S2MM_DM_STATUS_WIDTH - 1 downto 0) := (others => '0');   -- CR608521
signal m_axis_s2mm_sts_tkeep            : std_logic_vector((S2MM_DM_STATUS_WIDTH/8)-1 downto 0) := (others => '0'); -- CR608521
signal s2mm_err                         : std_logic := '0';
signal s2mm_halt                        : std_logic := '0';
signal s2mm_halt_cmplt                  : std_logic := '0';

-- Line Buffer To DataMover AXI Stream Signals
signal linebuf2dm_s2mm_tdata            : std_logic_vector(C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED-1 downto 0);
signal linebuf2dm_s2mm_tkeep            : std_logic_vector((C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED/8)-1 downto 0);
signal linebuf2dm_s2mm_tlast            : std_logic := '0';
signal linebuf2dm_s2mm_tvalid           : std_logic := '0';
signal dm2linebuf_s2mm_tready           : std_logic := '0';

-- S2MM Error Status Control
signal s2mm_ftch_interr_set             : std_logic := '0';
signal s2mm_ftch_slverr_set             : std_logic := '0';
signal s2mm_ftch_decerr_set             : std_logic := '0';

-- S2MM Soft Reset support
signal s2mm_soft_reset                  : std_logic := '0';
signal s2mm_soft_reset_clr              : std_logic := '0';

-- S2MM SOF generation support
signal s_axis_s2mm_tready_i             : std_logic := '0';
signal s_axis_s2mm_tready_i_axis_dw_conv             : std_logic := '0';




-- Video specific
signal s2mm_frame_sync                  : std_logic := '0';
signal mm2s_frame_sync                  : std_logic := '0';
signal mm2s_parameter_update            : std_logic := '0';
signal s2mm_parameter_update            : std_logic := '0';

-- Line Buffer Support
signal mm2s_allbuffer_empty             : std_logic := '0';

-- Video CDC support
signal mm2s_cdc2dmac_fsync              : std_logic := '0';
signal mm2s_dmac2cdc_fsync_out          : std_logic := '0';
signal mm2s_dmac2cdc_prmtr_update       : std_logic := '0';
signal mm2s_vid2cdc_packet_sof          : std_logic := '0';

signal s2mm_cdc2dmac_fsync              : std_logic := '0';
signal s2mm_dmac2cdc_fsync_out          : std_logic := '0';
signal s2mm_dmac2cdc_prmtr_update       : std_logic := '0';
signal s2mm_vid2cdc_packet_sof          : std_logic := '0';

-- fsync qualified by valid parameters for frame count
-- decrement
signal mm2s_valid_frame_sync            : std_logic := '0';
signal s2mm_valid_frame_sync            : std_logic := '0';
signal mm2s_valid_frame_sync_cmb        : std_logic := '0';
signal s2mm_valid_frame_sync_cmb        : std_logic := '0';

--signal for test bench and for output
signal s2mm_tstvect_error               : std_logic := '0';
signal mm2s_tstvect_error               : std_logic := '0';
signal s2mm_tstvect_fsync               : std_logic := '0';
signal mm2s_tstvect_fsync               : std_logic := '0';
signal s2mm_tstvect_frame               : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal mm2s_tstvect_frame               : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_fsync_out_i                 : std_logic := '0';
signal mm2s_fsync_out_i                 : std_logic := '0';
signal mm2s_mask_fsync_out              : std_logic := '0';
signal s2mm_mask_fsync_out              : std_logic := '0';

signal mm2s_mstrfrm_tstsync_out         : std_logic := '0';
signal s2mm_mstrfrm_tstsync_out         : std_logic := '0';

-- Genlock pointer signals
signal mm2s_mstrfrm_tstsync             : std_logic := '0';
signal mm2s_s_frame_ptr_in              : std_logic_vector(MM2S_GENLOCK_SLVE_PTR_DWIDTH-1 downto 0) := (others => '0');
signal mm2s_m_frame_ptr_out             : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0) := (others => '0');

signal s2mm_mstrfrm_tstsync             : std_logic := '0';
signal s2mm_s_frame_ptr_in              : std_logic_vector(S2MM_GENLOCK_SLVE_PTR_DWIDTH-1 downto 0) := (others => '0');
signal s2mm_m_frame_ptr_out             : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0) := (others => '0');

signal mm2s_tstvect_frm_ptr_out         : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_tstvect_frm_ptr_out         : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');

signal  sg2cdc_ftch_error_addr          : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal  sg2cdc_ftch_error               : std_logic := '0';

signal  mm2s_ftch_error_addr            : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal  mm2s_ftch_error                 : std_logic := '0';
signal  s2mm_ftch_error_addr            : std_logic_vector(C_M_AXI_SG_ADDR_WIDTH-1 downto 0) := (others => '0');
signal  s2mm_ftch_error                 : std_logic := '0';

-- Internal GenLock bus support
signal s2mm_to_mm2s_frame_ptr_in        : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0) := (others => '0');
signal mm2s_to_s2mm_frame_ptr_in        : std_logic_vector(NUM_FRM_STORE_WIDTH-1 downto 0) := (others => '0');
signal mm2s_reg_index               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');

signal s2mm_reg_index               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin

-- AXI DMA Test Vector (For Xilinx Internal Use Only)
axi_vdma_tstvec(63 downto 59)   		<= s2mm_tstvect_frm_ptr_out;		---
axi_vdma_tstvec(58 downto 54)   		<= mm2s_tstvect_frm_ptr_out;		---
axi_vdma_tstvec(53 downto 49)   		<= s2mm_tstvect_frame;		---
axi_vdma_tstvec(48 downto 44)   		<= mm2s_tstvect_frame;		---
axi_vdma_tstvec(43 downto 32) <= (others => '0');


axi_vdma_tstvec(31 downto 30) <= (others => '0');
axi_vdma_tstvec(29)             <= s2mm_tstvect_error;
axi_vdma_tstvec(28)             <= mm2s_tstvect_error;
axi_vdma_tstvec(27 downto 24)   <= s2mm_tstvect_frm_ptr_out(3 downto 0);		--
axi_vdma_tstvec(23 downto 20)   <= mm2s_tstvect_frm_ptr_out(3 downto 0);		--
axi_vdma_tstvec(19)             <= s2mm_mstrfrm_tstsync_out;
axi_vdma_tstvec(18)             <= mm2s_mstrfrm_tstsync_out;
axi_vdma_tstvec(17)             <= s2mm_dmasr(DMASR_HALTED_BIT);
axi_vdma_tstvec(16)             <= mm2s_dmasr(DMASR_HALTED_BIT);
axi_vdma_tstvec(15 downto 12)   <= s2mm_tstvect_frame(3 downto 0);			--
axi_vdma_tstvec(11 downto 8)    <= mm2s_tstvect_frame(3 downto 0);			--
axi_vdma_tstvec(7)              <= s2mm_tstvect_fsync
                                    and not s2mm_mask_fsync_out;
axi_vdma_tstvec(6)              <= mm2s_tstvect_fsync
                                    and not mm2s_mask_fsync_out;
axi_vdma_tstvec(5)              <= s2mm_tstvect_fsync;
axi_vdma_tstvec(4)              <= mm2s_tstvect_fsync;
axi_vdma_tstvec(3)              <= '0';
axi_vdma_tstvec(2)              <= s2mm_packet_sof;
axi_vdma_tstvec(1)              <= '0';
axi_vdma_tstvec(0)              <= mm2s_packet_sof;






s_axis_s2mm_tready              <= s_axis_s2mm_tready_i_axis_dw_conv;
m_axis_mm2s_tvalid              <= m_axis_mm2s_tvalid_i_axis_dw_conv;
m_axis_mm2s_tlast               <= m_axis_mm2s_tlast_i_axis_dw_conv;


mm2s_frame_ptr_out  <= mm2s_frame_ptr_out_i ;
s2mm_frame_ptr_out  <= s2mm_frame_ptr_out_i ;


--*****************************************************************************
--**                             RESET MODULE                                **
--*****************************************************************************
I_RST_MODULE : entity  axi_vdma_v5_00_a.axi_vdma_rst_module
    generic map(
        C_INCLUDE_MM2S              => C_INCLUDE_MM2S                       ,
        C_INCLUDE_S2MM              => C_INCLUDE_S2MM                       ,
        C_INCLUDE_SG                => C_INCLUDE_SG                         ,
        C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC
    )
    port map(
        -----------------------------------------------------------------------
        -- Clock Sources
        -----------------------------------------------------------------------
        s_axi_lite_aclk             => s_axi_lite_aclk                      ,
        m_axi_sg_aclk               => m_axi_sg_aclk                        ,
        m_axi_mm2s_aclk             => m_axi_mm2s_aclk                      ,
        m_axis_mm2s_aclk            => m_axis_mm2s_aclk                     ,
        m_axi_s2mm_aclk             => m_axi_s2mm_aclk                      ,
        s_axis_s2mm_aclk            => s_axis_s2mm_aclk                     ,

        -----------------------------------------------------------------------
        -- Hard Reset
        -----------------------------------------------------------------------
        axi_resetn                  => axi_resetn                           ,

        -----------------------------------------------------------------------
        -- MM2S Soft Reset Support
        -----------------------------------------------------------------------
        mm2s_soft_reset             => mm2s_soft_reset                      ,
        mm2s_soft_reset_clr         => mm2s_soft_reset_clr                  ,
        mm2s_stop                   => mm2s_stop                            ,
        mm2s_all_idle               => mm2s_ftchcmdsts_idle                 ,
        mm2s_fsize_mismatch_err     => mm2s_fsize_mismatch_err              , -- CR591965
        mm2s_halt                   => mm2s_halt                            ,
        mm2s_halt_cmplt             => mm2s_halt_cmplt                      ,
        mm2s_run_stop               => mm2s_dmacr(DMACR_RS_BIT)             ,

        -----------------------------------------------------------------------
        -- MM2S Soft Reset Support
        -----------------------------------------------------------------------
        s2mm_soft_reset             => s2mm_soft_reset                      ,
        s2mm_soft_reset_clr         => s2mm_soft_reset_clr                  ,
        s2mm_stop                   => s2mm_stop                            ,
        s2mm_all_idle               => s2mm_ftchcmdsts_idle                 ,
        s2mm_fsize_mismatch_err     => s2mm_fsize_mismatch_err              , -- CR591965
        s2mm_halt                   => s2mm_halt                            ,
        s2mm_halt_cmplt             => s2mm_halt_cmplt                      ,
        s2mm_run_stop               => s2mm_dmacr(DMACR_RS_BIT)             ,

        -----------------------------------------------------------------------
        -- SG Status
        -----------------------------------------------------------------------
        ftch_error                  => sg2cdc_ftch_error                    ,

        -----------------------------------------------------------------------
        -- MM2S Distributed Reset Out
        -----------------------------------------------------------------------
        -- AXI Upsizer and Line Buffer
        mm2s_prmry_resetn           => mm2s_prmry_resetn                    ,
        -- AXI DataMover Primary Reset (Raw)
        mm2s_dm_prmry_resetn        => mm2s_dm_prmry_resetn                 ,
        -- AXI Stream Logic Reset
        mm2s_axis_resetn            => mm2s_axis_resetn                     ,
        -- AXI Stream Reset Outputs
        mm2s_axis_reset_out_n       => mm2s_prmry_reset_out_n               ,

        -----------------------------------------------------------------------
        -- S2MM Distributed Reset Out
        -----------------------------------------------------------------------
        s2mm_prmry_resetn           => s2mm_prmry_resetn                    ,
        -- AXI DataMover Primary Reset (Raw)
        s2mm_dm_prmry_resetn        => s2mm_dm_prmry_resetn                 ,
        -- AXI Stream Logic Reset
        s2mm_axis_resetn            => s2mm_axis_resetn                     ,
        -- AXI Stream Reset Outputs
        s2mm_axis_reset_out_n       => s2mm_prmry_reset_out_n               ,

        -----------------------------------------------------------------------
        -- Scatter Gather Distributed Reset Out
        -----------------------------------------------------------------------
        m_axi_sg_resetn             => m_axi_sg_resetn                      ,
        m_axi_dm_sg_resetn          => m_axi_dm_sg_resetn                   ,

        -----------------------------------------------------------------------
        -- AXI Lite Interface Reset Out (Hard Only)
        -----------------------------------------------------------------------
        s_axi_lite_resetn           => s_axi_lite_resetn                    ,
        mm2s_hrd_resetn             => mm2s_hrd_resetn                      ,
        s2mm_hrd_resetn             => s2mm_hrd_resetn
    );


--*****************************************************************************
--**                      AXI LITE REGISTER INTERFACE                        **
--*****************************************************************************
-------------------------------------------------------------------------------
-- Provides the s_axi_lite inteface and clock domain crossing between
-- axi lite and mm2s/s2mm register modules
-------------------------------------------------------------------------------
AXI_LITE_REG_INTERFACE_I :  entity axi_vdma_v5_00_a.axi_vdma_reg_if
    generic map(
        C_INCLUDE_MM2S              => C_INCLUDE_MM2S                       ,
        C_INCLUDE_S2MM              => C_INCLUDE_S2MM                       ,
        C_INCLUDE_SG                => C_INCLUDE_SG                         ,
        C_ENABLE_VIDPRMTR_READS     => C_ENABLE_VIDPRMTR_READS              ,
        C_TOTAL_NUM_REGISTER        => TOTAL_NUM_REGISTER                   ,
        C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC                ,
        C_S_AXI_LITE_ADDR_WIDTH     => C_S_AXI_LITE_ADDR_WIDTH              ,
        C_S_AXI_LITE_DATA_WIDTH     => C_S_AXI_LITE_DATA_WIDTH              ,
        C_VERSION_MAJOR             => VERSION_MAJOR                        ,
        C_VERSION_MINOR             => VERSION_MINOR                        ,
        C_VERSION_REVISION          => VERSION_REVISION                     ,
        C_REVISION_NUMBER           => REVISION_NUMBER
    )
    port map(
        -----------------------------------------------------------------------
        -- AXI Lite Control Interface
        -----------------------------------------------------------------------
        s_axi_lite_aclk             => s_axi_lite_aclk                      ,
        s_axi_lite_reset_n          => s_axi_lite_resetn                    ,
        s_axi_lite_awvalid          => s_axi_lite_awvalid                   ,
        s_axi_lite_awready          => s_axi_lite_awready                   ,
        s_axi_lite_awaddr           => s_axi_lite_awaddr                    ,
        s_axi_lite_wvalid           => s_axi_lite_wvalid                    ,
        s_axi_lite_wready           => s_axi_lite_wready                    ,
        s_axi_lite_wdata            => s_axi_lite_wdata                     ,
        s_axi_lite_bresp            => s_axi_lite_bresp                     ,
        s_axi_lite_bvalid           => s_axi_lite_bvalid                    ,
        s_axi_lite_bready           => s_axi_lite_bready                    ,
        s_axi_lite_arvalid          => s_axi_lite_arvalid                   ,
        s_axi_lite_arready          => s_axi_lite_arready                   ,
        s_axi_lite_araddr           => s_axi_lite_araddr                    ,
        s_axi_lite_rvalid           => s_axi_lite_rvalid                    ,
        s_axi_lite_rready           => s_axi_lite_rready                    ,
        s_axi_lite_rdata            => s_axi_lite_rdata                     ,
        s_axi_lite_rresp            => s_axi_lite_rresp                     ,

        -- MM2S Register Interface
        m_axi_mm2s_aclk             => m_axi_mm2s_aclk                      ,
        mm2s_hrd_resetn             => mm2s_hrd_resetn                      ,
        mm2s_axi2ip_wrce            => mm2s_axi2ip_wrce                     ,
        mm2s_axi2ip_wrdata          => mm2s_axi2ip_wrdata                   ,
        mm2s_axi2ip_rdaddr          => mm2s_axi2ip_rdaddr                   ,
        mm2s_axi2ip_rden            => mm2s_axi2ip_rden                     ,
        mm2s_ip2axi_rddata          => mm2s_ip2axi_rddata                   ,
        mm2s_ip2axi_rddata_valid    => mm2s_ip2axi_rddata_valid             ,
        mm2s_ip2axi_frame_ptr_ref   => mm2s_ip2axi_frame_ptr_ref            ,
        mm2s_ip2axi_frame_store     => mm2s_ip2axi_frame_store              ,
        mm2s_ip2axi_introut         => mm2s_ip2axi_introut                  ,
        mm2s_introut                => mm2s_introut                         ,

        -- S2MM Register Interface
        m_axi_s2mm_aclk             => m_axi_s2mm_aclk                      ,
        s2mm_hrd_resetn             => s2mm_hrd_resetn                      ,
        s2mm_axi2ip_wrce            => s2mm_axi2ip_wrce                     ,
        s2mm_axi2ip_wrdata          => s2mm_axi2ip_wrdata                   ,
        s2mm_axi2ip_rden            => s2mm_axi2ip_rden                     ,
        s2mm_axi2ip_rdaddr          => s2mm_axi2ip_rdaddr                   ,
        s2mm_ip2axi_rddata          => s2mm_ip2axi_rddata                   ,
        s2mm_ip2axi_rddata_valid    => s2mm_ip2axi_rddata_valid             ,
        s2mm_ip2axi_frame_ptr_ref   => s2mm_ip2axi_frame_ptr_ref            ,
        s2mm_ip2axi_frame_store     => s2mm_ip2axi_frame_store              ,
        s2mm_ip2axi_introut         => s2mm_ip2axi_introut                  ,
        s2mm_introut                => s2mm_introut
    );

--*****************************************************************************
--**                       INTERRUPT CONTROLLER                              **
--*****************************************************************************
I_AXI_DMA_INTRPT : entity  axi_vdma_v5_00_a.axi_vdma_intrpt
    generic map(

        C_INCLUDE_CH1              => C_INCLUDE_MM2S                            ,
        C_INCLUDE_CH2              => C_INCLUDE_S2MM                            ,
        C_INCLUDE_DLYTMR           => INCLUDE_DLYTMR                            ,
        C_DLYTMR_RESOLUTION        => C_DLYTMR_RESOLUTION
    )
    port map(
        m_axi_ch1_aclk              => m_axi_mm2s_aclk                          ,
        m_axi_ch1_aresetn           => mm2s_prmry_resetn                        ,
        m_axi_ch2_aclk              => m_axi_s2mm_aclk                          ,
        m_axi_ch2_aresetn           => s2mm_prmry_resetn                        ,

        ch1_irqthresh_decr          => mm2s_tstvect_fsync                       ,
        ch1_irqthresh_rstdsbl       => mm2s_irqthresh_rstdsbl                   ,
        ch1_dlyirq_dsble            => mm2s_dlyirq_dsble                        ,
        ch1_irqdelay_wren           => mm2s_irqdelay_wren                       ,
        ch1_irqdelay                => mm2s_dmacr(DMACR_IRQDELAY_MSB_BIT
                                           downto DMACR_IRQDELAY_LSB_BIT)       ,
        ch1_irqthresh_wren          => mm2s_irqthresh_wren                      ,
        ch1_irqthresh               => mm2s_dmacr(DMACR_IRQTHRESH_MSB_BIT
                                           downto DMACR_IRQTHRESH_LSB_BIT)      ,
        ch1_packet_sof              => mm2s_packet_sof                          ,
        ch1_packet_eof              => mm2s_tstvect_fsync                       ,
        ch1_ioc_irq_set             => mm2s_ioc_irq_set                         ,
        ch1_dly_irq_set             => mm2s_dly_irq_set                         ,
        ch1_irqdelay_status         => mm2s_irqdelay_status                     ,
        ch1_irqthresh_status        => mm2s_irqthresh_status                    ,

        ch2_irqthresh_decr          => s2mm_tstvect_fsync                       ,
        ch2_irqthresh_rstdsbl       => s2mm_irqthresh_rstdsbl                   ,
        ch2_dlyirq_dsble            => s2mm_dlyirq_dsble                        ,
        ch2_irqdelay_wren           => s2mm_irqdelay_wren                       ,
        ch2_irqdelay                => s2mm_dmacr(DMACR_IRQDELAY_MSB_BIT
                                           downto DMACR_IRQDELAY_LSB_BIT)       ,
        ch2_irqthresh_wren          => s2mm_irqthresh_wren                      ,
        ch2_irqthresh               => s2mm_dmacr(DMACR_IRQTHRESH_MSB_BIT
                                           downto DMACR_IRQTHRESH_LSB_BIT)      ,
        ch2_packet_sof              => s2mm_packet_sof                          ,
        ch2_packet_eof              => s2mm_tstvect_fsync                       ,
        ch2_ioc_irq_set             => s2mm_ioc_irq_set                         ,
        ch2_dly_irq_set             => s2mm_dly_irq_set                         ,
        ch2_irqdelay_status         => s2mm_irqdelay_status                     ,
        ch2_irqthresh_status        => s2mm_irqthresh_status
    );


--*****************************************************************************
--**                       SCATTER GATHER ENGINE                             **
--*****************************************************************************

-- If Scatter Gather Engine is included the instantiate axi_sg
GEN_SG_ENGINE : if C_INCLUDE_SG = 1 generate
    -------------------------------------------------------------------------------
    -- Scatter Gather Engine
    -------------------------------------------------------------------------------
    I_SG_ENGINE : entity  axi_sg_v3_00_a.axi_sg
        generic map(
            C_M_AXI_SG_ADDR_WIDTH       => C_M_AXI_SG_ADDR_WIDTH            ,
            C_M_AXI_SG_DATA_WIDTH       => C_M_AXI_SG_DATA_WIDTH            ,
            C_M_AXIS_SG_TDATA_WIDTH     => M_AXIS_SG_TDATA_WIDTH            ,
            C_S_AXIS_UPDPTR_TDATA_WIDTH => S_AXIS_UPDPTR_TDATA_WIDTH        ,
            C_S_AXIS_UPDSTS_TDATA_WIDTH => S_AXIS_UPDSTS_TDATA_WIDTH        ,
            C_SG_FTCH_DESC2QUEUE        => SG_FTCH_DESC2QUEUE               ,
            C_SG_UPDT_DESC2QUEUE        => SG_UPDT_DESC2QUEUE               ,
            C_SG_CH1_WORDS_TO_FETCH     => SG_CH1_WORDS_TO_FETCH            ,
            C_SG_CH1_WORDS_TO_UPDATE    => SG_CH1_WORDS_TO_UPDATE           ,
            C_SG_CH1_FIRST_UPDATE_WORD  => SG_CH1_FIRST_UPDATE_WORD         ,
            C_SG_CH1_ENBL_STALE_ERROR   => SG_CH1_ENBL_STALE_ERROR          ,
            C_SG_CH2_WORDS_TO_FETCH     => SG_CH2_WORDS_TO_FETCH            ,
            C_SG_CH2_WORDS_TO_UPDATE    => SG_CH2_WORDS_TO_UPDATE           ,
            C_SG_CH2_FIRST_UPDATE_WORD  => SG_CH2_FIRST_UPDATE_WORD         ,
            C_SG_CH2_ENBL_STALE_ERROR   => SG_CH2_ENBL_STALE_ERROR          ,
            C_INCLUDE_CH1               => C_INCLUDE_MM2S                   ,
            C_INCLUDE_CH2               => C_INCLUDE_S2MM                   ,
            C_INCLUDE_DESC_UPDATE       => EXCLUDE_DESC_UPDATE              ,
            C_INCLUDE_INTRPT            => EXCLUDE_INTRPT                   ,
            C_INCLUDE_DLYTMR            => EXCLUDE_DLYTMR                   ,
            C_DLYTMR_RESOLUTION         => C_DLYTMR_RESOLUTION              ,
            C_AXIS_IS_ASYNC             => C_PRMRY_IS_ACLK_ASYNC            ,
            C_FAMILY                    => C_FAMILY
        )
        port map(
            -----------------------------------------------------------------------
            -- AXI Scatter Gather Interface
            -----------------------------------------------------------------------
            m_axi_sg_aclk               => m_axi_sg_aclk                    ,
            m_axi_sg_aresetn            => m_axi_sg_resetn                  ,
            dm_resetn                   => m_axi_dm_sg_resetn               ,

            -- Scatter Gather Write Address Channel
            m_axi_sg_awaddr             => open                             ,
            m_axi_sg_awlen              => open                             ,
            m_axi_sg_awsize             => open                             ,
            m_axi_sg_awburst            => open                             ,
            m_axi_sg_awprot             => open                             ,
            m_axi_sg_awcache            => open                             ,
            m_axi_sg_awvalid            => open                             ,
            m_axi_sg_awready            => '0'                              ,

            -- Scatter Gather Write Data Channel
            m_axi_sg_wdata              => open                             ,
            m_axi_sg_wstrb              => open                             ,
            m_axi_sg_wlast              => open                             ,
            m_axi_sg_wvalid             => open                             ,
            m_axi_sg_wready             => '0'                              ,

            -- Scatter Gather Write Response Channel
            m_axi_sg_bresp              => "00"                             ,
            m_axi_sg_bvalid             => '0'                              ,
            m_axi_sg_bready             => open                             ,

            -- Scatter Gather Read Address Channel
            m_axi_sg_araddr             => m_axi_sg_araddr                  ,
            m_axi_sg_arlen              => m_axi_sg_arlen                   ,
            m_axi_sg_arsize             => m_axi_sg_arsize                  ,
            m_axi_sg_arburst            => m_axi_sg_arburst                 ,
            m_axi_sg_arprot             => m_axi_sg_arprot                  ,
            m_axi_sg_arcache            => m_axi_sg_arcache                 ,
            m_axi_sg_arvalid            => m_axi_sg_arvalid                 ,
            m_axi_sg_arready            => m_axi_sg_arready                 ,

            -- Memory Map to Stream Scatter Gather Read Data Channel
            m_axi_sg_rdata              => m_axi_sg_rdata                   ,
            m_axi_sg_rresp              => m_axi_sg_rresp                   ,
            m_axi_sg_rlast              => m_axi_sg_rlast                   ,
            m_axi_sg_rvalid             => m_axi_sg_rvalid                  ,
            m_axi_sg_rready             => m_axi_sg_rready                  ,

            -- Channel 1 Control and Status
            ch1_run_stop                => mm2s_cdc2sg_run_stop             ,
            ch1_desc_flush              => mm2s_cdc2sg_stop                 ,
            ch1_ftch_idle               => mm2s_sg2cdc_ftch_idle            ,
            ch1_ftch_interr_set         => mm2s_sg2cdc_ftch_interr_set      ,
            ch1_ftch_slverr_set         => mm2s_sg2cdc_ftch_slverr_set      ,
            ch1_ftch_decerr_set         => mm2s_sg2cdc_ftch_decerr_set      ,
            ch1_ftch_err_early          => open                             ,
            ch1_ftch_stale_desc         => open                             ,
            ch1_updt_idle               => open                             ,
            ch1_updt_ioc_irq_set        => open                             ,
            ch1_updt_interr_set         => open                             ,
            ch1_updt_slverr_set         => open                             ,
            ch1_updt_decerr_set         => open                             ,
            ch1_dma_interr_set          => open                             ,
            ch1_dma_slverr_set          => open                             ,
            ch1_dma_decerr_set          => open                             ,
            ch1_tailpntr_enabled        => '1'                              ,
            ch1_taildesc_wren           => mm2s_cdc2sg_taildesc_wren        ,
            ch1_taildesc                => mm2s_cdc2sg_taildesc             ,
            ch1_curdesc                 => mm2s_cdc2sg_curdesc              ,

            -- Channel 1 Interrupt Coalescing Signals
            ch1_dlyirq_dsble            => '0'                              ,
            ch1_irqthresh_rstdsbl       => '0'                              ,
            ch1_irqdelay_wren           => '0'                              ,
            ch1_irqdelay                => ZERO_VALUE(7 downto 0)           ,
            ch1_irqthresh_wren          => '0'                              ,
            ch1_irqthresh               => ZERO_VALUE(7 downto 0)           ,
            ch1_packet_sof              => '0'                              ,
            ch1_packet_eof              => '0'                              ,
            ch1_ioc_irq_set             => open                             ,
            ch1_dly_irq_set             => open                             ,
            ch1_irqdelay_status         => open                             ,
            ch1_irqthresh_status        => open                             ,

            -- Channel 1 AXI Fetch Stream Out
            m_axis_ch1_ftch_aclk        => m_axi_mm2s_aclk                  ,
            m_axis_ch1_ftch_tdata       => m_axis_mm2s_ftch_tdata           ,
            m_axis_ch1_ftch_tvalid      => m_axis_mm2s_ftch_tvalid          ,
            m_axis_ch1_ftch_tready      => m_axis_mm2s_ftch_tready          ,
            m_axis_ch1_ftch_tlast       => m_axis_mm2s_ftch_tlast           ,

            -- Channel 1 AXI Update Stream In
            s_axis_ch1_updt_aclk        => '0'                              ,
            s_axis_ch1_updtptr_tdata    => ZERO_VALUE(S_AXIS_UPDPTR_TDATA_WIDTH-1 downto 0),
            s_axis_ch1_updtptr_tvalid   => '0'                              ,
            s_axis_ch1_updtptr_tready   => open                             ,
            s_axis_ch1_updtptr_tlast    => '0'                              ,

            s_axis_ch1_updtsts_tdata    => ZERO_VALUE(S_AXIS_UPDSTS_TDATA_WIDTH-1 downto 0),
            s_axis_ch1_updtsts_tvalid   => '0'                              ,
            s_axis_ch1_updtsts_tready   => open                             ,
            s_axis_ch1_updtsts_tlast    => '0'                              ,

            -- Channel 2 Control and Status
            ch2_run_stop                => s2mm_cdc2sg_run_stop             ,
            ch2_desc_flush              => s2mm_cdc2sg_stop                 ,
            ch2_ftch_idle               => s2mm_sg2cdc_ftch_idle            ,
            ch2_ftch_interr_set         => s2mm_sg2cdc_ftch_interr_set      ,
            ch2_ftch_slverr_set         => s2mm_sg2cdc_ftch_slverr_set      ,
            ch2_ftch_decerr_set         => s2mm_sg2cdc_ftch_decerr_set      ,
            ch2_ftch_err_early          => open                             ,
            ch2_ftch_stale_desc         => open                             ,
            ch2_updt_idle               => open                             ,
            ch2_updt_ioc_irq_set        => open                             ,
            ch2_updt_interr_set         => open                             ,
            ch2_updt_slverr_set         => open                             ,
            ch2_updt_decerr_set         => open                             ,
            ch2_dma_interr_set          => open                             ,
            ch2_dma_slverr_set          => open                             ,
            ch2_dma_decerr_set          => open                             ,
            ch2_tailpntr_enabled        => '1'                              ,
            ch2_taildesc_wren           => s2mm_cdc2sg_taildesc_wren        ,
            ch2_taildesc                => s2mm_cdc2sg_taildesc             ,
            ch2_curdesc                 => s2mm_cdc2sg_curdesc              ,

            -- Channel 2 Interrupt Coalescing Signals
            ch2_dlyirq_dsble            => '0'                              ,
            ch2_irqthresh_rstdsbl       => '0'                              ,
            ch2_irqdelay_wren           => '0'                              ,
            ch2_irqdelay                => ZERO_VALUE(7 downto 0)           ,
            ch2_irqthresh_wren          => '0'                              ,
            ch2_irqthresh               => ZERO_VALUE(7 downto 0)           ,
            ch2_packet_sof              => '0'                              ,
            ch2_packet_eof              => '0'                              ,
            ch2_ioc_irq_set             => open                             ,
            ch2_dly_irq_set             => open                             ,
            ch2_irqdelay_status         => open                             ,
            ch2_irqthresh_status        => open                             ,

            -- Channel 2 AXI Fetch Stream Out
            m_axis_ch2_ftch_aclk        => m_axi_s2mm_aclk                  ,
            m_axis_ch2_ftch_tdata       => m_axis_s2mm_ftch_tdata           ,
            m_axis_ch2_ftch_tvalid      => m_axis_s2mm_ftch_tvalid          ,
            m_axis_ch2_ftch_tready      => m_axis_s2mm_ftch_tready          ,
            m_axis_ch2_ftch_tlast       => m_axis_s2mm_ftch_tlast           ,

            -- Channel 2 AXI Update Stream In
            s_axis_ch2_updt_aclk        => '0'                  ,
            s_axis_ch2_updtptr_tdata    => ZERO_VALUE(S_AXIS_UPDPTR_TDATA_WIDTH-1 downto 0),
            s_axis_ch2_updtptr_tvalid   => '0'                              ,
            s_axis_ch2_updtptr_tready   => open                             ,
            s_axis_ch2_updtptr_tlast    => '0'                              ,

            s_axis_ch2_updtsts_tdata    => ZERO_VALUE(S_AXIS_UPDSTS_TDATA_WIDTH-1 downto 0),
            s_axis_ch2_updtsts_tvalid   => '0'                              ,
            s_axis_ch2_updtsts_tready   => open                             ,
            s_axis_ch2_updtsts_tlast    => '0'                              ,

            -- Error addresses
            ftch_error_addr             => sg2cdc_ftch_error_addr           ,
            ftch_error                  => sg2cdc_ftch_error                ,
            updt_error                  => open                             ,
            updt_error_addr             => open
        );

    --*********************************************************************
    --** MM2S Clock Domain To/From Scatter Gather Clock Domain           **
    --*********************************************************************
    MM2S_SG_CDC_I : entity  axi_vdma_v5_00_a.axi_vdma_sg_cdc
        generic map(
            C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC            ,
            C_M_AXI_SG_ADDR_WIDTH       => C_M_AXI_SG_ADDR_WIDTH
        )
        port map(
            prmry_aclk                  => m_axi_mm2s_aclk                  ,
            prmry_resetn                => mm2s_prmry_resetn                ,

            scndry_aclk                 => m_axi_sg_aclk                    ,
            scndry_resetn               => m_axi_sg_resetn                  ,

            -- From Register Module (Primary Clk Domain)
            reg2cdc_run_stop            => mm2s_dmacr(DMACR_RS_BIT)         ,
            reg2cdc_stop                => mm2s_stop                        ,
            reg2cdc_taildesc_wren       => mm2s_tailpntr_updated            ,
            reg2cdc_taildesc            => mm2s_taildesc                    ,
            reg2cdc_curdesc             => mm2s_curdesc                     ,

            -- To Scatter Gather Engine (Secondary Clk Domain)
            cdc2sg_run_stop             => mm2s_cdc2sg_run_stop             ,
            cdc2sg_stop                 => mm2s_cdc2sg_stop                 ,
            cdc2sg_taildesc_wren        => mm2s_cdc2sg_taildesc_wren        ,
            cdc2sg_taildesc             => mm2s_cdc2sg_taildesc             ,
            cdc2sg_curdesc              => mm2s_cdc2sg_curdesc              ,

            -- From Scatter Gather Engine (Secondary Clk Domain)
            sg2cdc_ftch_idle            => mm2s_sg2cdc_ftch_idle            ,
            sg2cdc_ftch_interr_set      => mm2s_sg2cdc_ftch_interr_set      ,
            sg2cdc_ftch_slverr_set      => mm2s_sg2cdc_ftch_slverr_set      ,
            sg2cdc_ftch_decerr_set      => mm2s_sg2cdc_ftch_decerr_set      ,
            sg2cdc_ftch_error_addr      => sg2cdc_ftch_error_addr           ,
            sg2cdc_ftch_error           => sg2cdc_ftch_error                ,

            -- To DMA Controller
            cdc2dmac_ftch_idle          => mm2s_ftch_idle                   ,

            -- To Register Module
            cdc2reg_ftch_interr_set     => mm2s_ftch_interr_set             ,
            cdc2reg_ftch_slverr_set     => mm2s_ftch_slverr_set             ,
            cdc2reg_ftch_decerr_set     => mm2s_ftch_decerr_set             ,
            cdc2reg_ftch_error_addr     => mm2s_ftch_error_addr             ,
            cdc2reg_ftch_error          => mm2s_ftch_error
        );

    --*********************************************************************
    --** S2MM Clock Domain To/From Scatter Gather Clock Domain           **
    --*********************************************************************
    S2MM_SG_CDC_I : entity  axi_vdma_v5_00_a.axi_vdma_sg_cdc
        generic map(
            C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC            ,
            C_M_AXI_SG_ADDR_WIDTH       => C_M_AXI_SG_ADDR_WIDTH
        )
        port map(
            prmry_aclk                  => m_axi_s2mm_aclk                  ,
            prmry_resetn                => s2mm_prmry_resetn                ,

            scndry_aclk                 => m_axi_sg_aclk                    ,
            scndry_resetn               => m_axi_sg_resetn                  ,

            -- From Register Module (Primary Clk Domain)
            reg2cdc_run_stop            => s2mm_dmacr(DMACR_RS_BIT)         ,
            reg2cdc_stop                => s2mm_stop                        ,
            reg2cdc_taildesc_wren       => s2mm_tailpntr_updated            ,
            reg2cdc_taildesc            => s2mm_taildesc                    ,
            reg2cdc_curdesc             => s2mm_curdesc                     ,

            -- To Scatter Gather Engine (Secondary Clk Domain)
            cdc2sg_run_stop             => s2mm_cdc2sg_run_stop             ,
            cdc2sg_stop                 => s2mm_cdc2sg_stop                 ,
            cdc2sg_taildesc_wren        => s2mm_cdc2sg_taildesc_wren        ,
            cdc2sg_taildesc             => s2mm_cdc2sg_taildesc             ,
            cdc2sg_curdesc              => s2mm_cdc2sg_curdesc              ,

            -- From Scatter Gather Engine (Secondary Clk Domain)
            sg2cdc_ftch_idle            => s2mm_sg2cdc_ftch_idle            ,
            sg2cdc_ftch_interr_set      => s2mm_sg2cdc_ftch_interr_set      ,
            sg2cdc_ftch_slverr_set      => s2mm_sg2cdc_ftch_slverr_set      ,
            sg2cdc_ftch_decerr_set      => s2mm_sg2cdc_ftch_decerr_set      ,
            sg2cdc_ftch_error_addr      => sg2cdc_ftch_error_addr           ,
            sg2cdc_ftch_error           => sg2cdc_ftch_error                ,

            -- To DMA Controller
            cdc2dmac_ftch_idle          => s2mm_ftch_idle                   ,

            -- To Register Module
            cdc2reg_ftch_interr_set     => s2mm_ftch_interr_set             ,
            cdc2reg_ftch_slverr_set     => s2mm_ftch_slverr_set             ,
            cdc2reg_ftch_decerr_set     => s2mm_ftch_decerr_set             ,
            cdc2reg_ftch_error_addr     => s2mm_ftch_error_addr             ,
            cdc2reg_ftch_error          => s2mm_ftch_error
        );

end generate GEN_SG_ENGINE;

-- No scatter gather engine therefore tie off unused signals
GEN_NO_SG_ENGINE : if C_INCLUDE_SG = 0 generate
begin
    m_axi_sg_araddr             <= (others => '0');
    m_axi_sg_arlen              <= (others => '0');
    m_axi_sg_arsize             <= (others => '0');
    m_axi_sg_arburst            <= (others => '0');
    m_axi_sg_arcache            <= (others => '0');
    m_axi_sg_arprot             <= (others => '0');
    m_axi_sg_arvalid            <= '0';
    m_axi_sg_rready             <= '0';
    mm2s_ftch_idle              <= '1';
    mm2s_ftch_interr_set        <= '0';
    mm2s_ftch_slverr_set        <= '0';
    mm2s_ftch_decerr_set        <= '0';
    m_axis_mm2s_ftch_tdata      <= (others => '0');
    m_axis_mm2s_ftch_tvalid     <= '0';
    m_axis_mm2s_ftch_tlast      <= '0';
    s2mm_ftch_idle              <= '1';
    s2mm_ftch_interr_set        <= '0';
    s2mm_ftch_slverr_set        <= '0';
    s2mm_ftch_decerr_set        <= '0';
    m_axis_s2mm_ftch_tdata      <= (others => '0');
    m_axis_s2mm_ftch_tvalid     <= '0';
    m_axis_s2mm_ftch_tlast      <= '0';
    mm2s_ftch_error_addr        <= (others => '0');
    mm2s_ftch_error             <= '0';
    s2mm_ftch_error_addr        <= (others => '0');
    s2mm_ftch_error             <= '0';

end generate GEN_NO_SG_ENGINE;


--*****************************************************************************
--**                            MM2S CHANNEL                                 **
--*****************************************************************************

-- Generate support logic for MM2S
GEN_SPRT_FOR_MM2S : if C_INCLUDE_MM2S = 1 generate
begin

  GEN_AXIS_MM2S_DWIDTH_CONV : if (C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED /=  C_M_AXIS_MM2S_TDATA_WIDTH) generate
  begin

    AXIS_MM2S_DWIDTH_CONVERTER_I: entity  axi_vdma_v5_00_a.axi_vdma_mm2s_axis_dwidth_converter
        generic map(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED =>	C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED		, 
 		C_M_AXIS_MM2S_TDATA_WIDTH         	 =>	C_M_AXIS_MM2S_TDATA_WIDTH		, 
 		C_M_AXIS_MM2S_TUSER_BITS         	 =>	C_M_AXIS_MM2S_TUSER_BITS		, 
 		C_AXIS_TID_WIDTH             		 =>	1		, 
 		C_AXIS_TDEST_WIDTH           		 =>	1		, 
        	C_FAMILY                     		 =>	C_FAMILY		   ) 
        port map( 
      		ACLK                         =>	m_axis_mm2s_aclk                 			, 
      		ARESETN                      =>	mm2s_axis_resetn              			, 
      		ACLKEN                       =>	'1'               			, 
      		S_AXIS_TVALID                =>	m_axis_mm2s_tvalid_i        			, 
      		S_AXIS_TREADY                =>	m_axis_mm2s_tready_i        			, 
      		S_AXIS_TDATA                 =>	m_axis_mm2s_tdata_i(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED-1 downto 0)         			, 
      		S_AXIS_TSTRB                 =>	ZERO_VALUE(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED/8-1 downto 0)         			, 
      		S_AXIS_TKEEP                 =>	m_axis_mm2s_tkeep_i(C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED/8-1 downto 0)         			, 
      		S_AXIS_TLAST                 =>	m_axis_mm2s_tlast_i         			, 
      		S_AXIS_TID                   =>	ZERO_VALUE(0 downto 0)           			, 
      		S_AXIS_TDEST                 =>	ZERO_VALUE(0 downto 0)         			, 
      		S_AXIS_TUSER                 =>	m_axis_mm2s_tuser_i(C_M_AXIS_MM2S_TUSER_BITS-1 downto 0)         			, 
      		M_AXIS_TVALID                =>	m_axis_mm2s_tvalid_i_axis_dw_conv        			, 
      		M_AXIS_TREADY                =>	m_axis_mm2s_tready        			, 
      		M_AXIS_TDATA                 =>	m_axis_mm2s_tdata(C_M_AXIS_MM2S_TDATA_WIDTH-1 downto 0)         			, 
      		M_AXIS_TSTRB                 =>	open         			, 
      		M_AXIS_TKEEP                 =>	m_axis_mm2s_tkeep(C_M_AXIS_MM2S_TDATA_WIDTH/8-1 downto 0)         			, 
      		M_AXIS_TLAST                 =>	m_axis_mm2s_tlast_i_axis_dw_conv         			, 
      		M_AXIS_TID                   =>	open           			, 
      		M_AXIS_TDEST                 =>	open         			, 
      		M_AXIS_TUSER                 =>	m_axis_mm2s_tuser(C_M_AXIS_MM2S_TUSER_BITS-1 downto 0)         			
  ) ;


  end generate GEN_AXIS_MM2S_DWIDTH_CONV;


  GEN_NO_AXIS_MM2S_DWIDTH_CONV : if (C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED =  C_M_AXIS_MM2S_TDATA_WIDTH) generate
  begin


		m_axis_mm2s_tvalid_i_axis_dw_conv<= m_axis_mm2s_tvalid_i;
		m_axis_mm2s_tdata<= m_axis_mm2s_tdata_i;
		m_axis_mm2s_tkeep<= m_axis_mm2s_tkeep_i;
		m_axis_mm2s_tlast_i_axis_dw_conv<= m_axis_mm2s_tlast_i;
		m_axis_mm2s_tuser<= m_axis_mm2s_tuser_i;
		m_axis_mm2s_tready_i<= m_axis_mm2s_tready;



  end generate GEN_NO_AXIS_MM2S_DWIDTH_CONV;





    --*************************************************************************
    --** MM2S AXI4 Clock Domain - (m_axi_mm2s_aclk)
    --*************************************************************************
    ---------------------------------------------------------------------------
    -- MM2S Register Module
    ---------------------------------------------------------------------------
    MM2S_REGISTER_MODULE_I : entity  axi_vdma_v5_00_a.axi_vdma_reg_module
        generic map(
            C_TOTAL_NUM_REGISTER    => TOTAL_NUM_REGISTER                   ,
            C_INCLUDE_SG            => C_INCLUDE_SG                         ,
            C_CHANNEL_IS_MM2S       => CHANNEL_IS_MM2S                      ,
            C_ENABLE_FLUSH_ON_FSYNC => ENABLE_FLUSH_ON_FSYNC                , -- CR591965
            C_ENABLE_VIDPRMTR_READS => C_ENABLE_VIDPRMTR_READS              ,
            C_LINEBUFFER_THRESH     => C_MM2S_LINEBUFFER_THRESH             ,
            C_NUM_FSTORES           => C_NUM_FSTORES                        ,
            C_GENLOCK_MODE          => C_MM2S_GENLOCK_MODE                  ,
            C_S_AXI_LITE_ADDR_WIDTH => C_S_AXI_LITE_ADDR_WIDTH              ,
            C_S_AXI_LITE_DATA_WIDTH => C_S_AXI_LITE_DATA_WIDTH              ,
            C_M_AXI_SG_ADDR_WIDTH   => C_M_AXI_SG_ADDR_WIDTH                ,
            C_M_AXI_ADDR_WIDTH      => C_M_AXI_MM2S_ADDR_WIDTH
        )
        port map(
            prmry_aclk                  => m_axi_mm2s_aclk                  ,
            prmry_resetn                => mm2s_prmry_resetn                ,

            -- Register to AXI Lite Interface
            axi2ip_wrce                 => mm2s_axi2ip_wrce                 ,
            axi2ip_wrdata               => mm2s_axi2ip_wrdata               ,
            axi2ip_rdaddr               => mm2s_axi2ip_rdaddr               ,
            axi2ip_rden                 => mm2s_axi2ip_rden                 ,
            ip2axi_rddata               => mm2s_ip2axi_rddata               ,
            ip2axi_rddata_valid         => mm2s_ip2axi_rddata_valid         ,
            ip2axi_frame_ptr_ref        => mm2s_ip2axi_frame_ptr_ref        ,
            ip2axi_frame_store          => mm2s_ip2axi_frame_store          ,
            ip2axi_introut              => mm2s_ip2axi_introut              ,

            -- Soft Reset
            soft_reset                  => mm2s_soft_reset                  ,
            soft_reset_clr              => mm2s_soft_reset_clr              ,

            -- DMA Control / Status Register Signals
            halted_clr                  => mm2s_halted_clr                  ,
            halted_set                  => mm2s_halted_set                  ,
            idle_set                    => mm2s_idle_set                    ,
            idle_clr                    => mm2s_idle_clr                    ,
            ioc_irq_set                 => mm2s_ioc_irq_set                 ,
            dly_irq_set                 => mm2s_dly_irq_set                 ,
            irqdelay_status             => mm2s_irqdelay_status             ,
            irqthresh_status            => mm2s_irqthresh_status            ,
            frame_sync                  => mm2s_frame_sync                  ,
            fsync_mask                  => mm2s_mask_fsync_out              ,
            new_curdesc_wren            => mm2s_new_curdesc_wren            ,
            new_curdesc                 => mm2s_new_curdesc                 ,
            update_frmstore             => '1'                              , -- Always Update
            new_frmstr                  => mm2s_frame_number                ,
            tstvect_fsync               => mm2s_tstvect_fsync               ,
            valid_frame_sync            => mm2s_valid_frame_sync            ,
            irqthresh_rstdsbl           => mm2s_irqthresh_rstdsbl           ,
            dlyirq_dsble                => mm2s_dlyirq_dsble                ,
            irqthresh_wren              => mm2s_irqthresh_wren              ,
            irqdelay_wren               => mm2s_irqdelay_wren               ,
            tailpntr_updated            => mm2s_tailpntr_updated            ,

            -- Error Detection Control
            stop                        => mm2s_stop                        ,
            dma_interr_set              => mm2s_dma_interr_set              ,
            dma_slverr_set              => mm2s_dma_slverr_set              ,
            dma_decerr_set              => mm2s_dma_decerr_set              ,
            ftch_slverr_set             => mm2s_ftch_slverr_set             ,
            ftch_decerr_set             => mm2s_ftch_decerr_set             ,

            -- VDMA Base Registers
    	reg_index                	=> mm2s_reg_index           ,

            dmacr                       => mm2s_dmacr                       ,
            dmasr                       => mm2s_dmasr                       ,
            curdesc                     => mm2s_curdesc                     ,
            taildesc                    => mm2s_taildesc                    ,
            num_frame_store             => mm2s_num_frame_store             ,
            linebuf_threshold           => mm2s_linebuf_threshold           ,

            -- Register Direct Support
            regdir_idle                 => mm2s_regdir_idle                 ,
            prmtr_updt_complete         => mm2s_prmtr_updt_complete         ,
            reg_module_vsize            => mm2s_reg_module_vsize            ,
            reg_module_hsize            => mm2s_reg_module_hsize            ,
            reg_module_stride           => mm2s_reg_module_stride           ,
            reg_module_frmdly           => mm2s_reg_module_frmdly           ,
            reg_module_strt_addr        => mm2s_reg_module_strt_addr        ,

            -- Fetch/Update error addresses
            frmstr_error_addr           => mm2s_frame_number                ,
            ftch_error_addr             => mm2s_ftch_error_addr
        );

    ---------------------------------------------------------------------------
    -- MM2S DMA Controller
    ---------------------------------------------------------------------------
    I_MM2S_DMA_MNGR : entity  axi_vdma_v5_00_a.axi_vdma_mngr
        generic map(
            C_PRMY_CMDFIFO_DEPTH        => DM_CMDSTS_FIFO_DEPTH             ,
            C_INCLUDE_SF                => DM_MM2S_INCLUDE_SF               ,
            C_USE_FSYNC                 => C_USE_FSYNC                      , -- CR582182
            C_ENABLE_FLUSH_ON_FSYNC     => ENABLE_FLUSH_ON_FSYNC            , -- CR591965
            C_NUM_FSTORES               => C_NUM_FSTORES                    ,
            C_GENLOCK_MODE              => C_MM2S_GENLOCK_MODE              ,
            C_GENLOCK_NUM_MASTERS       => C_MM2S_GENLOCK_NUM_MASTERS       ,
            C_GENLOCK_REPEAT_EN         => C_MM2S_GENLOCK_REPEAT_EN         , -- CR591965
            C_INTERNAL_GENLOCK_ENABLE   => INTERNAL_GENLOCK_ENABLE          ,
            C_INCLUDE_SG                => C_INCLUDE_SG                     , -- CR581800
            C_M_AXI_SG_ADDR_WIDTH       => C_M_AXI_SG_ADDR_WIDTH            ,
            C_M_AXIS_SG_TDATA_WIDTH     => M_AXIS_SG_TDATA_WIDTH            ,
            C_M_AXI_ADDR_WIDTH          => C_M_AXI_MM2S_ADDR_WIDTH          ,
            C_DM_STATUS_WIDTH           => MM2S_DM_STATUS_WIDTH             , -- CR608521
            C_EXTEND_DM_COMMAND         => MM2S_DM_CMD_NOT_EXTENDED         ,
            C_INCLUDE_MM2S              => C_INCLUDE_MM2S                   ,
            C_INCLUDE_S2MM              => 0                  ,
            C_FAMILY                    => C_FAMILY
        )
        port map(

            -- Secondary Clock and Reset
            prmry_aclk                  => m_axi_mm2s_aclk                  ,
            prmry_resetn                => mm2s_prmry_resetn                ,
            soft_reset                  => mm2s_soft_reset                  ,

            -- MM2S Control and Status
            run_stop                    => mm2s_dmacr(DMACR_RS_BIT)         ,
            dmasr_halt                  => mm2s_dmasr(DMASR_HALTED_BIT)     ,
            sync_enable                 => mm2s_dmacr(DMACR_SYNCEN_BIT)     ,
            regdir_idle                 => mm2s_regdir_idle                 ,
            ftch_idle                   => mm2s_ftch_idle                   ,
            halt                        => mm2s_halt                        ,
            halt_cmplt                  => mm2s_halt_cmplt                  ,
            halted_clr                  => mm2s_halted_clr                  ,
            halted_set                  => mm2s_halted_set                  ,
            idle_set                    => mm2s_idle_set                    ,
            idle_clr                    => mm2s_idle_clr                    ,
            stop                        => mm2s_stop                        ,
            all_idle                    => mm2s_all_idle                    ,
            cmdsts_idle                 => mm2s_cmdsts_idle                 ,
            ftchcmdsts_idle             => mm2s_ftchcmdsts_idle             ,
            frame_sync                  => mm2s_frame_sync                  ,
            update_frmstore             => open                             ,   -- Not Needed for MM2S channel
            frmstr_error_addr           => open                             ,   -- Not Needed for MM2S channel
            frame_ptr_ref               => mm2s_ip2axi_frame_ptr_ref        ,
            frame_ptr_in                => mm2s_s_frame_ptr_in              ,
            frame_ptr_out               => mm2s_m_frame_ptr_out             ,
            internal_frame_ptr_in       => s2mm_to_mm2s_frame_ptr_in        ,
            valid_frame_sync            => mm2s_valid_frame_sync            ,
            valid_frame_sync_cmb        => mm2s_valid_frame_sync_cmb        ,
            valid_video_prmtrs          => mm2s_valid_video_prmtrs          ,
            parameter_update            => mm2s_parameter_update            ,
            circular_prk_mode           => mm2s_dmacr(DMACR_CRCLPRK_BIT)    ,
            mstr_pntr_ref               => mm2s_dmacr(DMACR_PNTR_NUM_MSB
                                               downto DMACR_PNTR_NUM_LSB)   ,
            genlock_select              => mm2s_dmacr(DMACR_GENLOCK_SEL_BIT),
            line_buffer_empty           => mm2s_allbuffer_empty             ,
            crnt_vsize                  => mm2s_crnt_vsize                  ,   -- CR616211
            num_frame_store             => mm2s_num_frame_store             ,
            all_lines_xfred             => mm2s_all_lines_xfred             ,   -- CR616211
            all_lasts_rcvd             => all_lasts_rcvd             ,   -- 
            fsize_mismatch_err          => mm2s_fsize_mismatch_err          ,   -- CR591965


            -- Register Direct Support
            prmtr_updt_complete         => mm2s_prmtr_updt_complete         ,
            reg_module_vsize            => mm2s_reg_module_vsize            ,
            reg_module_hsize            => mm2s_reg_module_hsize            ,
            reg_module_stride           => mm2s_reg_module_stride           ,
            reg_module_frmdly           => mm2s_reg_module_frmdly           ,
            reg_module_strt_addr        => mm2s_reg_module_strt_addr        ,

            -- Fsync signals and Genlock for test vector
            tstvect_error               => mm2s_tstvect_error               ,
            tstvect_fsync               => mm2s_tstvect_fsync               ,
            tstvect_frame               => mm2s_tstvect_frame               ,
            tstvect_frm_ptr_out         => mm2s_tstvect_frm_ptr_out         ,
            mstrfrm_tstsync_out         => mm2s_mstrfrm_tstsync             ,

            -- AXI Stream Timing
            packet_sof                  => '1'                              ,  -- NOT Used for MM2S

            -- Primary DMA Errors
            dma_interr_set              => mm2s_dma_interr_set              ,
            dma_slverr_set              => mm2s_dma_slverr_set              ,
            dma_decerr_set              => mm2s_dma_decerr_set              ,


            -- SG MM2S Descriptor Fetch AXI Stream In
            m_axis_ftch_tdata           => m_axis_mm2s_ftch_tdata           ,
            m_axis_ftch_tvalid          => m_axis_mm2s_ftch_tvalid          ,
            m_axis_ftch_tready          => m_axis_mm2s_ftch_tready          ,
            m_axis_ftch_tlast           => m_axis_mm2s_ftch_tlast           ,

            -- Currently Being Processed Descriptor/Frame
            frame_number                => mm2s_frame_number                ,
            new_curdesc                 => mm2s_new_curdesc                 ,
            new_curdesc_wren            => mm2s_new_curdesc_wren            ,
            tailpntr_updated            => mm2s_tailpntr_updated            ,

            -- User Command Interface Ports (AXI Stream)
            s_axis_cmd_tvalid           => s_axis_mm2s_cmd_tvalid           ,
            s_axis_cmd_tready           => s_axis_mm2s_cmd_tready           ,
            s_axis_cmd_tdata            => s_axis_mm2s_cmd_tdata            ,

            -- User Status Interface Ports (AXI Stream)
            m_axis_sts_tvalid           => m_axis_mm2s_sts_tvalid           ,
            m_axis_sts_tready           => m_axis_mm2s_sts_tready           ,
            m_axis_sts_tdata            => m_axis_mm2s_sts_tdata            ,
            m_axis_sts_tkeep            => m_axis_mm2s_sts_tkeep            ,
            err                         => mm2s_err                         ,
            ftch_error                  => mm2s_ftch_error
        );

    ---------------------------------------------------------------------------
    -- MM2S Frame sync generator
    ---------------------------------------------------------------------------
    MM2S_FSYNC_I : entity  axi_vdma_v5_00_a.axi_vdma_fsync_gen
        generic map(
            C_USE_FSYNC                 => C_USE_FSYNC                      ,
            C_SOF_ENABLE                => 0                                    -- Always disabled
        )
        port map(
            prmry_aclk                  => m_axi_mm2s_aclk                  ,
            prmry_resetn                => mm2s_prmry_resetn                ,

            -- Frame Count Enable Support
            valid_frame_sync_cmb        => mm2s_valid_frame_sync_cmb        ,
            valid_video_prmtrs          => mm2s_valid_video_prmtrs          ,
            frmcnt_ioc                  => mm2s_ioc_irq_set                 ,
            dmacr_frmcnt_enbl           => mm2s_dmacr(DMACR_FRMCNTEN_BIT)   ,
            dmasr_frmcnt_status         => mm2s_irqthresh_status            ,
            mask_fsync_out              => mm2s_mask_fsync_out              ,

            -- VDMA process status
            run_stop                    => mm2s_dmacr(DMACR_RS_BIT)         ,
            all_idle                    => mm2s_all_idle                    ,
            parameter_update            => mm2s_parameter_update            ,

            -- VDMA Frame Sync Sources
            fsync                       => mm2s_cdc2dmac_fsync              ,
            tuser_fsync                 => '0'                              ,   -- Not used by MM2S
            othrchnl_fsync              => s2mm_to_mm2s_fsync               ,

            fsync_src_select            => mm2s_dmacr(DMACR_FSYNCSEL_MSB
                                            downto DMACR_FSYNCSEL_LSB)      ,

            -- VDMA frame sync output to core
            frame_sync                  => mm2s_frame_sync                  ,

            -- VDMA frame sync output to ports
            frame_sync_out              => mm2s_dmac2cdc_fsync_out          ,
            prmtr_update                => mm2s_dmac2cdc_prmtr_update
        );

    -- Clock Domain Crossing between m_axi_mm2s_aclk and m_axis_mm2s_aclk
    MM2S_VID_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_vid_cdc
        generic map(
            C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC            ,
            C_GENLOCK_MSTR_PTR_DWIDTH   => NUM_FRM_STORE_WIDTH          ,
            C_GENLOCK_SLVE_PTR_DWIDTH   => MM2S_GENLOCK_SLVE_PTR_DWIDTH     ,
            C_INTERNAL_GENLOCK_ENABLE   => INTERNAL_GENLOCK_ENABLE
        )
        port map(
            prmry_aclk                  => m_axi_mm2s_aclk                  ,
            prmry_resetn                => mm2s_prmry_resetn                ,

            scndry_aclk                 => m_axis_mm2s_aclk                 ,
            scndry_resetn               => mm2s_axis_resetn                 ,

            -- Genlock internal bus cdc
            othrchnl_aclk               => m_axi_s2mm_aclk                  ,
            othrchnl_resetn             => s2mm_prmry_resetn                ,
            othrchnl2cdc_frame_ptr_out  => s2mm_frame_ptr_out_i             ,
            cdc2othrchnl_frame_ptr_in   => s2mm_to_mm2s_frame_ptr_in        ,

            cdc2othrchnl_fsync          => mm2s_to_s2mm_fsync               ,

            -- GenLock Clock Domain Crossing
            dmac2cdc_frame_ptr_out      => mm2s_m_frame_ptr_out             ,
            cdc2top_frame_ptr_out       => mm2s_frame_ptr_out_i             ,
            top2cdc_frame_ptr_in        => mm2s_frame_ptr_in                ,
            cdc2dmac_frame_ptr_in       => mm2s_s_frame_ptr_in              ,
            dmac2cdc_mstrfrm_tstsync    => mm2s_mstrfrm_tstsync             ,
            cdc2dmac_mstrfrm_tstsync    => mm2s_mstrfrm_tstsync_out         ,

            -- SOF Detection Domain Crossing
            vid2cdc_packet_sof          => mm2s_vid2cdc_packet_sof          ,
            cdc2dmac_packet_sof         => mm2s_packet_sof                  ,

            -- Frame Sync Generation Domain Crossing
            vid2cdc_fsync               => mm2s_fsync                       ,
            cdc2dmac_fsync              => mm2s_cdc2dmac_fsync              ,

            dmac2cdc_fsync_out          => mm2s_dmac2cdc_fsync_out          ,
            dmac2cdc_prmtr_update       => mm2s_dmac2cdc_prmtr_update       ,

            cdc2vid_fsync_out           => mm2s_fsync_out_i                 ,
            cdc2vid_prmtr_update        => mm2s_prmtr_update
        );

    mm2s_fsync_out  <= mm2s_fsync_out_i;

    -- Start of Frame Detection - used for interrupt coalescing
    MM2S_SOF_I : entity  axi_vdma_v5_00_a.axi_vdma_sof_gen
        port map(
            scndry_aclk                 => m_axis_mm2s_aclk                 ,
            scndry_resetn               => mm2s_axis_resetn                 ,

            axis_tready                 => m_axis_mm2s_tready               ,
            axis_tvalid                 => m_axis_mm2s_tvalid_i             ,

            fsync                       => mm2s_fsync_out_i                 , -- CR622884

            packet_sof                  => mm2s_vid2cdc_packet_sof
        );

    ---------------------------------------------------------------------------
    -- Primary MM2S Line Buffer
    ---------------------------------------------------------------------------
    MM2S_LINEBUFFER_I : entity  axi_vdma_v5_00_a.axi_vdma_mm2s_linebuf
        generic map(
            C_DATA_WIDTH                => C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED        ,
            C_INCLUDE_MM2S_SF           => C_INCLUDE_MM2S_SF                ,
            C_MM2S_SOF_ENABLE           => MM2S_SOF_ENABLE                  ,
            C_M_AXIS_MM2S_TUSER_BITS    => C_M_AXIS_MM2S_TUSER_BITS         ,
            C_TOPLVL_LINEBUFFER_DEPTH   => C_MM2S_LINEBUFFER_DEPTH          , -- CR625142
            C_LINEBUFFER_DEPTH          => MM2S_LINEBUFFER_DEPTH            ,
            C_LINEBUFFER_AE_THRESH      => C_MM2S_LINEBUFFER_THRESH         ,
            C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC            ,
            C_FAMILY                    => C_FAMILY
        )
        port map(
            -------------------------------------------------------------------
            -- AXI Scatter Gather Interface
            -------------------------------------------------------------------
            -- MM2S AXIS Datamover side
            s_axis_aclk                 => m_axi_mm2s_aclk                  ,
            s_axis_resetn               => mm2s_prmry_resetn                ,

            -- MM2S AXIS Out side
            m_axis_aclk                 => m_axis_mm2s_aclk                 ,
            m_axis_resetn               => mm2s_axis_resetn                 ,

            -- Graceful shut down control
            cmdsts_idle                 => mm2s_cmdsts_idle                 ,
            dm_halt                     => mm2s_halt                        ,
            stop                        => mm2s_stop                        ,   -- CR623291

            -- Vertical Line Count control
            crnt_vsize                  => mm2s_crnt_vsize                  ,   -- CR616211
            fsync_out                   => mm2s_fsync_out_i                 ,   -- CR616211
            frame_sync                  => mm2s_frame_sync                  ,   -- CR616211

            -- Threshold
            linebuf_threshold           => mm2s_linebuf_threshold           ,


            -- Stream In (Datamover to Linebuffer)
            s_axis_tdata                => dm2linebuf_mm2s_tdata            ,
            s_axis_tkeep                => dm2linebuf_mm2s_tkeep            ,
            s_axis_tlast                => dm2linebuf_mm2s_tlast            ,
            s_axis_tvalid               => dm2linebuf_mm2s_tvalid           ,
            s_axis_tready               => linebuf2dm_mm2s_tready           ,

            -- Stream Out (Linebuffer to AXIS Out)
            m_axis_tdata                => m_axis_mm2s_tdata_i                ,
            m_axis_tkeep                => m_axis_mm2s_tkeep_i                ,
            m_axis_tlast                => m_axis_mm2s_tlast_i              ,
            m_axis_tvalid               => m_axis_mm2s_tvalid_i             ,
            m_axis_tready               => m_axis_mm2s_tready_i               ,
            m_axis_tuser                => m_axis_mm2s_tuser_i                ,

            -- Fifo Status Flags
            mm2s_fifo_pipe_empty        => mm2s_allbuffer_empty             ,
            mm2s_fifo_empty             => mm2s_buffer_empty                ,
            mm2s_fifo_almost_empty      => mm2s_buffer_almost_empty         ,
            mm2s_all_lines_xfred        => mm2s_all_lines_xfred                 -- CR616211
        );


end generate GEN_SPRT_FOR_MM2S;


-- Do not generate support logic for MM2S
GEN_NO_SPRT_FOR_MM2S : if C_INCLUDE_MM2S = 0 generate
begin
    -- Register Module Tie-Offs
    mm2s_ip2axi_rddata              <= (others => '0');
    mm2s_ip2axi_rddata_valid        <= '0';
    mm2s_ip2axi_frame_ptr_ref       <= (others => '0');
    mm2s_ip2axi_frame_store         <= (others => '0');
    mm2s_ip2axi_introut             <= '0';
    mm2s_soft_reset                 <= '0';
    mm2s_irqthresh_rstdsbl          <= '0';
    mm2s_dlyirq_dsble               <= '0';
    mm2s_irqthresh_wren             <= '0';
    mm2s_irqdelay_wren              <= '0';
    mm2s_tailpntr_updated           <= '0';
    mm2s_dmacr                      <= (others => '0');
    mm2s_dmasr                      <= (others => '0');
    mm2s_curdesc                    <= (others => '0');
    mm2s_taildesc                   <= (others => '0');

    --internal to mm2s generate (dont really need to tie off)
    mm2s_num_frame_store            <= (others => '0');
    mm2s_linebuf_threshold          <= (others => '0');
    mm2s_regdir_idle                <= '0';
    mm2s_prmtr_updt_complete        <= '0';
    mm2s_reg_module_vsize           <= (others => '0');
    mm2s_reg_module_hsize           <= (others => '0');
    mm2s_reg_module_stride          <= (others => '0');
    mm2s_reg_module_frmdly          <= (others => '0');

    -- Must zero each element of an array of vectors to zero
    -- all vectors.
    GEN_MM2S_ZERO_STRT : for i in 0 to C_NUM_FSTORES-1 generate
        begin
            mm2s_reg_module_strt_addr(i)   <= (others => '0');
    end generate GEN_MM2S_ZERO_STRT;

    -- Line Buffer Tie-Offs
    linebuf2dm_mm2s_tready          <= '0';
    m_axis_mm2s_tdata               <= (others => '0');
    m_axis_mm2s_tdata_i               <= (others => '0');
    m_axis_mm2s_tkeep               <= (others => '0');
    m_axis_mm2s_tkeep_i               <= (others => '0');
    m_axis_mm2s_tlast_i             <= '0';
    m_axis_mm2s_tlast_i_axis_dw_conv             <= '0';
    m_axis_mm2s_tuser               <= (others => '0');
    m_axis_mm2s_tuser_i               <= (others => '0');
    m_axis_mm2s_tvalid_i            <= '0';
    m_axis_mm2s_tvalid_i_axis_dw_conv            <= '0';
    mm2s_allbuffer_empty            <= '0';
    mm2s_buffer_empty               <= '0';
    mm2s_buffer_almost_empty        <= '0';
    mm2s_all_lines_xfred            <= '0';

    -- SOF generator
    mm2s_packet_sof                 <= '0';

    -- DMA Controller
    mm2s_halted_clr                 <= '0';
    mm2s_halted_set                 <= '0';
    mm2s_idle_set                   <= '0';
    mm2s_idle_clr                   <= '0';
    mm2s_frame_number               <= (others => '0');
    mm2s_new_curdesc                <= (others => '0');
    mm2s_new_curdesc_wren           <= '0';
    mm2s_stop                       <= '0';
    mm2s_all_idle                   <= '1';
    mm2s_cmdsts_idle                <= '1';
    mm2s_ftchcmdsts_idle            <= '1';
    m_axis_mm2s_ftch_tready         <= '0';
    s_axis_mm2s_cmd_tvalid          <= '0';
    s_axis_mm2s_cmd_tdata           <= (others => '0');
    m_axis_mm2s_sts_tready          <= '0';
    mm2s_m_frame_ptr_out            <= (others => '0');
    mm2s_frame_ptr_out_i            <= (others => '0');
    s2mm_to_mm2s_frame_ptr_in       <= (others => '0');
    mm2s_valid_frame_sync           <= '0';
    mm2s_valid_frame_sync_cmb       <= '0';
    mm2s_valid_video_prmtrs         <= '0';
    mm2s_parameter_update           <= '0';
    mm2s_tstvect_error              <= '0';
    mm2s_tstvect_fsync              <= '0';
    mm2s_tstvect_frame              <= (others => '0');
    mm2s_dma_interr_set             <= '0';
    mm2s_dma_slverr_set             <= '0';
    mm2s_dma_decerr_set             <= '0';
    mm2s_crnt_vsize                 <= (others => '0');
    mm2s_fsize_mismatch_err         <= '0';

    -- Frame Sync generator
    mm2s_frame_sync                 <= '0';
    mm2s_fsync_out                  <= '0';
    mm2s_prmtr_update               <= '0';
    mm2s_mask_fsync_out             <= '0';
    mm2s_mstrfrm_tstsync            <= '0';
    mm2s_mstrfrm_tstsync_out        <= '0';
    mm2s_tstvect_frm_ptr_out        <= (others => '0');
    mm2s_to_s2mm_fsync              <= '0';


end generate GEN_NO_SPRT_FOR_MM2S;

--*****************************************************************************
--**                            S2MM CHANNEL                                 **
--*****************************************************************************

-- Generate support logic for S2MM
GEN_SPRT_FOR_S2MM : if C_INCLUDE_S2MM = 1 generate
begin

  GEN_AXIS_S2MM_DWIDTH_CONV : if C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED /=  C_S_AXIS_S2MM_TDATA_WIDTH generate
  begin

    AXIS_S2MM_DWIDTH_CONVERTER_I: entity  axi_vdma_v5_00_a.axi_vdma_s2mm_axis_dwidth_converter
        generic map(C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED =>	C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED		, 
 		C_S_AXIS_S2MM_TDATA_WIDTH         	 =>	C_S_AXIS_S2MM_TDATA_WIDTH		, 
 		C_S_AXIS_S2MM_TUSER_BITS         	 =>	C_S_AXIS_S2MM_TUSER_BITS		, 
 		C_AXIS_TID_WIDTH             		 =>	1		, 
 		C_AXIS_TDEST_WIDTH           		 =>	1		, 
        	C_FAMILY                     		 =>	C_FAMILY		   ) 
        port map( 
      		ACLK                         =>	s_axis_s2mm_aclk                 			, 
      		ARESETN                      =>	s2mm_axis_resetn              			, 
      		ACLKEN                       =>	'1'               			, 
      		S_AXIS_TVALID                =>	s_axis_s2mm_tvalid        			, 
      		S_AXIS_TREADY                =>	s_axis_s2mm_tready_i_axis_dw_conv        			, 
      		S_AXIS_TDATA                 =>	s_axis_s2mm_tdata(C_S_AXIS_S2MM_TDATA_WIDTH-1 downto 0)         			, 
      		S_AXIS_TSTRB                 =>	ZERO_VALUE(C_S_AXIS_S2MM_TDATA_WIDTH/8-1 downto 0)         			, 
      		S_AXIS_TKEEP                 =>	s_axis_s2mm_tkeep(C_S_AXIS_S2MM_TDATA_WIDTH/8-1 downto 0)         			, 
      		S_AXIS_TLAST                 =>	s_axis_s2mm_tlast         			, 
      		S_AXIS_TID                   =>	ZERO_VALUE(0 downto 0)           			, 
      		S_AXIS_TDEST                 =>	ZERO_VALUE(0 downto 0)         			, 
      		S_AXIS_TUSER                 =>	s_axis_s2mm_tuser(C_S_AXIS_S2MM_TUSER_BITS-1 downto 0)         			, 
      		M_AXIS_TVALID                =>	s_axis_s2mm_tvalid_i        			, 
      		M_AXIS_TREADY                =>	s_axis_s2mm_tready_i        			, 
      		M_AXIS_TDATA                 =>	s_axis_s2mm_tdata_i(C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED-1 downto 0)         			, 
      		M_AXIS_TSTRB                 =>	open         			, 
      		M_AXIS_TKEEP                 =>	s_axis_s2mm_tkeep_i(C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED/8-1 downto 0)         			, 
      		M_AXIS_TLAST                 =>	s_axis_s2mm_tlast_i         			, 
      		M_AXIS_TID                   =>	open           			, 
      		M_AXIS_TDEST                 =>	open         			, 
      		M_AXIS_TUSER                 =>	s_axis_s2mm_tuser_i(C_S_AXIS_S2MM_TUSER_BITS-1 downto 0)         			
  ) ;


  end generate GEN_AXIS_S2MM_DWIDTH_CONV;

  GEN_NO_AXIS_S2MM_DWIDTH_CONV : if C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED =  C_S_AXIS_S2MM_TDATA_WIDTH generate
  begin


 		s_axis_s2mm_tvalid_i<= s_axis_s2mm_tvalid;
 		s_axis_s2mm_tdata_i<= s_axis_s2mm_tdata;
 		s_axis_s2mm_tkeep_i<= s_axis_s2mm_tkeep;
 		s_axis_s2mm_tlast_i<= s_axis_s2mm_tlast;
 		s_axis_s2mm_tuser_i<= s_axis_s2mm_tuser;
 		s_axis_s2mm_tready_i_axis_dw_conv<= s_axis_s2mm_tready_i;



  end generate GEN_NO_AXIS_S2MM_DWIDTH_CONV;





    ---------------------------------------------------------------------------
    -- S2MM Register Module
    ---------------------------------------------------------------------------
    S2MM_REGISTER_MODULE_I : entity  axi_vdma_v5_00_a.axi_vdma_reg_module
        generic map(
            C_TOTAL_NUM_REGISTER    => TOTAL_NUM_REGISTER                   ,
            C_INCLUDE_SG            => C_INCLUDE_SG                         ,
            C_CHANNEL_IS_MM2S       => CHANNEL_IS_S2MM                      ,
            C_ENABLE_FLUSH_ON_FSYNC => ENABLE_FLUSH_ON_FSYNC                , -- CR591965
            C_ENABLE_VIDPRMTR_READS => C_ENABLE_VIDPRMTR_READS              ,
            C_NUM_FSTORES           => C_NUM_FSTORES                        ,
            C_LINEBUFFER_THRESH     => C_S2MM_LINEBUFFER_THRESH             ,
            C_GENLOCK_MODE          => C_S2MM_GENLOCK_MODE                  ,
            C_S_AXI_LITE_ADDR_WIDTH => C_S_AXI_LITE_ADDR_WIDTH              ,
            C_S_AXI_LITE_DATA_WIDTH => C_S_AXI_LITE_DATA_WIDTH              ,
            C_M_AXI_SG_ADDR_WIDTH   => C_M_AXI_SG_ADDR_WIDTH                ,
            C_M_AXI_ADDR_WIDTH      => C_M_AXI_S2MM_ADDR_WIDTH
        )
        port map(
            prmry_aclk                  => m_axi_s2mm_aclk                  ,
            prmry_resetn                => s2mm_prmry_resetn                ,

            -- Register to AXI Lite Interface
            axi2ip_wrce                 => s2mm_axi2ip_wrce                 ,
            axi2ip_wrdata               => s2mm_axi2ip_wrdata               ,
            axi2ip_rdaddr               => s2mm_axi2ip_rdaddr               ,
            axi2ip_rden                 => s2mm_axi2ip_rden                 ,
            ip2axi_rddata               => s2mm_ip2axi_rddata               ,
            ip2axi_rddata_valid         => s2mm_ip2axi_rddata_valid         ,
            ip2axi_frame_ptr_ref        => s2mm_ip2axi_frame_ptr_ref        ,
            ip2axi_frame_store          => s2mm_ip2axi_frame_store          ,
            ip2axi_introut              => s2mm_ip2axi_introut              ,

            -- Soft Reset
            soft_reset                  => s2mm_soft_reset                  ,
            soft_reset_clr              => s2mm_soft_reset_clr              ,

            -- DMA Control / Status Register Signals
            halted_clr                  => s2mm_halted_clr                  ,
            halted_set                  => s2mm_halted_set                  ,
            idle_set                    => s2mm_idle_set                    ,
            idle_clr                    => s2mm_idle_clr                    ,
            ioc_irq_set                 => s2mm_ioc_irq_set                 ,
            dly_irq_set                 => s2mm_dly_irq_set                 ,
            irqdelay_status             => s2mm_irqdelay_status             ,
            irqthresh_status            => s2mm_irqthresh_status            ,
            frame_sync                  => s2mm_frame_sync                  ,
            fsync_mask                  => s2mm_mask_fsync_out              ,
            new_curdesc_wren            => s2mm_new_curdesc_wren            ,
            new_curdesc                 => s2mm_new_curdesc                 ,
            update_frmstore             => s2mm_update_frmstore             ,
            new_frmstr                  => s2mm_frame_number                ,
            tstvect_fsync               => s2mm_tstvect_fsync               ,
            valid_frame_sync            => s2mm_valid_frame_sync            ,
            irqthresh_rstdsbl           => s2mm_irqthresh_rstdsbl           ,
            dlyirq_dsble                => s2mm_dlyirq_dsble                ,
            irqthresh_wren              => s2mm_irqthresh_wren              ,
            irqdelay_wren               => s2mm_irqdelay_wren               ,
            tailpntr_updated            => s2mm_tailpntr_updated            ,

            -- Error Detection Control
            stop                        => s2mm_stop                        ,
            dma_interr_set              => s2mm_dma_interr_set              ,
            dma_slverr_set              => s2mm_dma_slverr_set              ,
            dma_decerr_set              => s2mm_dma_decerr_set              ,
            ftch_slverr_set             => s2mm_ftch_slverr_set             ,
            ftch_decerr_set             => s2mm_ftch_decerr_set             ,

            -- VDMA Base Registers
    	reg_index                	=> s2mm_reg_index           ,
            dmacr                       => s2mm_dmacr                       ,
            dmasr                       => s2mm_dmasr                       ,
            curdesc                     => s2mm_curdesc                     ,
            taildesc                    => s2mm_taildesc                    ,
            num_frame_store             => s2mm_num_frame_store             ,
            linebuf_threshold           => s2mm_linebuf_threshold           ,

            -- Register Direct Support
            regdir_idle                 => s2mm_regdir_idle                 ,
            prmtr_updt_complete         => s2mm_prmtr_updt_complete         ,
            reg_module_vsize            => s2mm_reg_module_vsize            ,
            reg_module_hsize            => s2mm_reg_module_hsize            ,
            reg_module_stride           => s2mm_reg_module_stride           ,
            reg_module_frmdly           => s2mm_reg_module_frmdly           ,
            reg_module_strt_addr        => s2mm_reg_module_strt_addr        ,

            -- Fetch/Update error addresses
            frmstr_error_addr           => s2mm_frmstr_error_addr           ,
            ftch_error_addr             => s2mm_ftch_error_addr
        );

    ---------------------------------------------------------------------------
    -- S2MM DMA Controller
    ---------------------------------------------------------------------------
    I_S2MM_DMA_MNGR : entity  axi_vdma_v5_00_a.axi_vdma_mngr
        generic map(
            C_PRMY_CMDFIFO_DEPTH        => DM_CMDSTS_FIFO_DEPTH             ,
            C_INCLUDE_SF                => DM_S2MM_INCLUDE_SF               ,
            C_USE_FSYNC                 => C_USE_FSYNC                      ,   -- CR582182
            C_ENABLE_FLUSH_ON_FSYNC     => ENABLE_FLUSH_ON_FSYNC            ,   -- CR591965
            C_NUM_FSTORES               => C_NUM_FSTORES                    ,
            C_GENLOCK_MODE              => C_S2MM_GENLOCK_MODE              ,
            C_GENLOCK_NUM_MASTERS       => C_S2MM_GENLOCK_NUM_MASTERS       ,
            C_GENLOCK_REPEAT_EN         => C_S2MM_GENLOCK_REPEAT_EN         ,   -- CR591965
            C_INTERNAL_GENLOCK_ENABLE   => INTERNAL_GENLOCK_ENABLE          ,
            C_INCLUDE_SG                => C_INCLUDE_SG                     ,   -- CR581800
            C_M_AXI_SG_ADDR_WIDTH       => C_M_AXI_SG_ADDR_WIDTH            ,
            C_M_AXIS_SG_TDATA_WIDTH     => M_AXIS_SG_TDATA_WIDTH            ,
            C_M_AXI_ADDR_WIDTH          => C_M_AXI_S2MM_ADDR_WIDTH          ,
            C_DM_STATUS_WIDTH           => S2MM_DM_STATUS_WIDTH             ,   -- CR608521
            C_EXTEND_DM_COMMAND         => S2MM_DM_CMD_EXTENDED             ,
            C_INCLUDE_MM2S              => 0                   ,
            C_INCLUDE_S2MM              => C_INCLUDE_S2MM                   ,
            C_FAMILY                    => C_FAMILY
        )
        port map(
            -- Secondary Clock and Reset
            prmry_aclk                  => m_axi_s2mm_aclk                  ,
            prmry_resetn                => s2mm_prmry_resetn                ,
            soft_reset                  => s2mm_soft_reset                  ,

            -- MM2S Control and Status
            run_stop                    => s2mm_dmacr(DMACR_RS_BIT)         ,
            dmasr_halt                  => s2mm_dmasr(DMASR_HALTED_BIT)     ,
            sync_enable                 => s2mm_dmacr(DMACR_SYNCEN_BIT)     ,
            regdir_idle                 => s2mm_regdir_idle                 ,
            ftch_idle                   => s2mm_ftch_idle                   ,
            halt                        => s2mm_halt                        ,
            halt_cmplt                  => s2mm_halt_cmplt                  ,
            halted_clr                  => s2mm_halted_clr                  ,
            halted_set                  => s2mm_halted_set                  ,
            idle_set                    => s2mm_idle_set                    ,
            idle_clr                    => s2mm_idle_clr                    ,
            stop                        => s2mm_stop                        ,
            all_idle                    => s2mm_all_idle                    ,
            cmdsts_idle                 => s2mm_cmdsts_idle                 ,
            ftchcmdsts_idle             => s2mm_ftchcmdsts_idle             ,
            frame_sync                  => s2mm_frame_sync                  ,
            update_frmstore             => s2mm_update_frmstore             ,   -- CR582182
            frmstr_error_addr           => s2mm_frmstr_error_addr           ,   -- CR582182
            frame_ptr_ref               => s2mm_ip2axi_frame_ptr_ref        ,
            frame_ptr_in                => s2mm_s_frame_ptr_in              ,
            frame_ptr_out               => s2mm_m_frame_ptr_out             ,
            internal_frame_ptr_in       => mm2s_to_s2mm_frame_ptr_in        ,
            valid_frame_sync            => s2mm_valid_frame_sync            ,
            valid_frame_sync_cmb        => s2mm_valid_frame_sync_cmb        ,
            valid_video_prmtrs          => s2mm_valid_video_prmtrs          ,
            parameter_update            => s2mm_parameter_update            ,
            circular_prk_mode           => s2mm_dmacr(DMACR_CRCLPRK_BIT)    ,
            mstr_pntr_ref               => s2mm_dmacr(DMACR_PNTR_NUM_MSB
                                               downto DMACR_PNTR_NUM_LSB)   ,
            genlock_select              => mm2s_dmacr(DMACR_GENLOCK_SEL_BIT),
            line_buffer_empty           => '1'                              ,   -- NOT Used by S2MM therefore tie off
            crnt_vsize                  => s2mm_crnt_vsize                  ,   -- CR575884
            num_frame_store             => s2mm_num_frame_store             ,
            all_lines_xfred             => s2mm_all_lines_xfred             ,   -- CR591965
            all_lasts_rcvd              => all_lasts_rcvd             ,   
            fsize_mismatch_err          => s2mm_fsize_mismatch_err          ,   -- CR591965

            -- Register Direct Support
            prmtr_updt_complete         => s2mm_prmtr_updt_complete         ,
            reg_module_vsize            => s2mm_reg_module_vsize            ,
            reg_module_hsize            => s2mm_reg_module_hsize            ,
            reg_module_stride           => s2mm_reg_module_stride           ,
            reg_module_frmdly           => s2mm_reg_module_frmdly           ,
            reg_module_strt_addr        => s2mm_reg_module_strt_addr        ,

            -- Test vector signals
            tstvect_error               => s2mm_tstvect_error               ,
            tstvect_fsync               => s2mm_tstvect_fsync               ,
            tstvect_frame               => s2mm_tstvect_frame               ,
            tstvect_frm_ptr_out         => s2mm_tstvect_frm_ptr_out         ,
            mstrfrm_tstsync_out         => s2mm_mstrfrm_tstsync             ,

            -- AXI Stream Timing
            packet_sof                  => s2mm_packet_sof                  ,


            -- Primary DMA Errors
            dma_interr_set              => s2mm_dma_interr_set              ,
            dma_slverr_set              => s2mm_dma_slverr_set              ,
            dma_decerr_set              => s2mm_dma_decerr_set              ,

            -- SG MM2S Descriptor Fetch AXI Stream In
            m_axis_ftch_tdata           => m_axis_s2mm_ftch_tdata           ,
            m_axis_ftch_tvalid          => m_axis_s2mm_ftch_tvalid          ,
            m_axis_ftch_tready          => m_axis_s2mm_ftch_tready          ,
            m_axis_ftch_tlast           => m_axis_s2mm_ftch_tlast           ,

            -- Currently Being Processed Descriptor/Frame
            frame_number                => s2mm_frame_number                ,
            new_curdesc                 => s2mm_new_curdesc                 ,
            new_curdesc_wren            => s2mm_new_curdesc_wren            ,
            tailpntr_updated            => s2mm_tailpntr_updated            ,

            -- User Command Interface Ports (AXI Stream)
            s_axis_cmd_tvalid           => s_axis_s2mm_cmd_tvalid           ,
            s_axis_cmd_tready           => s_axis_s2mm_cmd_tready           ,
            s_axis_cmd_tdata            => s_axis_s2mm_cmd_tdata            ,

            -- User Status Interface Ports (AXI Stream)
            m_axis_sts_tvalid           => m_axis_s2mm_sts_tvalid           ,
            m_axis_sts_tready           => m_axis_s2mm_sts_tready           ,
            m_axis_sts_tdata            => m_axis_s2mm_sts_tdata            ,
            m_axis_sts_tkeep            => m_axis_s2mm_sts_tkeep       ,
            err                         => s2mm_err                         ,
            ftch_error                  => s2mm_ftch_error
        );



    ---------------------------------------------------------------------------
    -- MM2S Frame sync generator
    ---------------------------------------------------------------------------
    S2MM_FSYNC_I : entity  axi_vdma_v5_00_a.axi_vdma_fsync_gen
        generic map(
            C_USE_FSYNC                 => C_USE_FSYNC                      ,
            C_SOF_ENABLE                => S2MM_SOF_ENABLE
        )
        port map(
            prmry_aclk                  => m_axi_s2mm_aclk                  ,
            prmry_resetn                => s2mm_prmry_resetn                ,

            -- Frame Count Enable Support
            valid_frame_sync_cmb        => s2mm_valid_frame_sync_cmb        ,
            valid_video_prmtrs          => s2mm_valid_video_prmtrs          ,
            frmcnt_ioc                  => s2mm_ioc_irq_set                 ,
            dmacr_frmcnt_enbl           => s2mm_dmacr(DMACR_FRMCNTEN_BIT)   ,
            dmasr_frmcnt_status         => s2mm_irqthresh_status            ,
            mask_fsync_out              => s2mm_mask_fsync_out              ,

            -- VDMA process status
            run_stop                    => s2mm_dmacr(DMACR_RS_BIT)         ,
            all_idle                    => s2mm_all_idle                    ,
            parameter_update            => s2mm_parameter_update            ,

            -- VDMA Frame Sync sources
            fsync                       => s2mm_cdc2dmac_fsync              ,
            tuser_fsync                 => s2mm_tuser_fsync                 ,
            othrchnl_fsync              => mm2s_to_s2mm_fsync               ,

            fsync_src_select            => s2mm_dmacr(DMACR_FSYNCSEL_MSB
                                            downto DMACR_FSYNCSEL_LSB)      ,

            -- VDMA frame sync output to core
            frame_sync                  => s2mm_frame_sync                  ,

            -- VDMA Frame Sync Output to ports
            frame_sync_out              => s2mm_dmac2cdc_fsync_out          ,
            prmtr_update                => s2mm_dmac2cdc_prmtr_update
        );

    -- Clock Domain Crossing between m_axi_s2mm_aclk and s_axis_s2mm_aclk
    S2MM_VID_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_vid_cdc
        generic map(
            C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC            ,
            C_GENLOCK_MSTR_PTR_DWIDTH   => NUM_FRM_STORE_WIDTH          ,
            C_GENLOCK_SLVE_PTR_DWIDTH   => S2MM_GENLOCK_SLVE_PTR_DWIDTH     ,
            C_INTERNAL_GENLOCK_ENABLE   => INTERNAL_GENLOCK_ENABLE
        )
        port map(
            prmry_aclk                  => m_axi_s2mm_aclk                  ,
            prmry_resetn                => s2mm_prmry_resetn                ,

            scndry_aclk                 => s_axis_s2mm_aclk                 ,
            scndry_resetn               => s2mm_axis_resetn                 ,

            -- Genlock internal bus cdc
            othrchnl_aclk               => m_axi_mm2s_aclk                  ,
            othrchnl_resetn             => mm2s_prmry_resetn                ,
            othrchnl2cdc_frame_ptr_out  => mm2s_frame_ptr_out_i             ,
            cdc2othrchnl_frame_ptr_in   => mm2s_to_s2mm_frame_ptr_in        ,
            cdc2othrchnl_fsync          => s2mm_to_mm2s_fsync               ,

            -- GenLock Clock Domain Crossing
            dmac2cdc_frame_ptr_out      => s2mm_m_frame_ptr_out             ,
            cdc2top_frame_ptr_out       => s2mm_frame_ptr_out_i             ,
            top2cdc_frame_ptr_in        => s2mm_frame_ptr_in                ,
            cdc2dmac_frame_ptr_in       => s2mm_s_frame_ptr_in              ,
            dmac2cdc_mstrfrm_tstsync    => s2mm_mstrfrm_tstsync             ,
            cdc2dmac_mstrfrm_tstsync    => s2mm_mstrfrm_tstsync_out         ,

            -- SOF Detection Domain Crossing
            vid2cdc_packet_sof          => s2mm_vid2cdc_packet_sof          ,
            cdc2dmac_packet_sof         => s2mm_packet_sof                  ,

            -- Frame Sync Generation Domain Crossing
            vid2cdc_fsync               => s2mm_fsync                       ,
            cdc2dmac_fsync              => s2mm_cdc2dmac_fsync              ,

            dmac2cdc_fsync_out          => s2mm_dmac2cdc_fsync_out          ,
            dmac2cdc_prmtr_update       => s2mm_dmac2cdc_prmtr_update       ,

            cdc2vid_fsync_out           => s2mm_fsync_out_i                 ,
            cdc2vid_prmtr_update        => s2mm_prmtr_update
        );

    s2mm_fsync_out  <= s2mm_fsync_out_i;

    -- Start of Frame Detection - used for interrupt coalescing
    S2MM_SOF_I : entity  axi_vdma_v5_00_a.axi_vdma_sof_gen
        port map(
            scndry_aclk                 => s_axis_s2mm_aclk                 ,
            scndry_resetn               => s2mm_axis_resetn                 ,

            axis_tready                 => s_axis_s2mm_tready_i             ,
            axis_tvalid                 => s_axis_s2mm_tvalid_i               ,

            fsync                       => s2mm_fsync_out_i                 , -- CR622884

            packet_sof                  => s2mm_vid2cdc_packet_sof
        );

    -------------------------------------------------------------------------------
    -- Primary S2MM Line Buffer
    -------------------------------------------------------------------------------
    S2MM_LINEBUFFER_I : entity  axi_vdma_v5_00_a.axi_vdma_s2mm_linebuf
        generic map(
            C_DATA_WIDTH                => C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED            ,
            C_S2MM_SOF_ENABLE           => S2MM_SOF_ENABLE                      ,
            C_S_AXIS_S2MM_TUSER_BITS    => C_S_AXIS_S2MM_TUSER_BITS             ,
            C_TOPLVL_LINEBUFFER_DEPTH   => C_S2MM_LINEBUFFER_DEPTH              , -- CR625142
            C_LINEBUFFER_DEPTH          => S2MM_LINEBUFFER_DEPTH                ,
            C_LINEBUFFER_AF_THRESH      => C_S2MM_LINEBUFFER_THRESH             ,
            C_PRMRY_IS_ACLK_ASYNC       => C_PRMRY_IS_ACLK_ASYNC                ,
            ENABLE_FLUSH_ON_FSYNC       => ENABLE_FLUSH_ON_FSYNC,
            C_FAMILY                    => C_FAMILY
        )
        port map(
            -----------------------------------------------------------------------
            -- AXI Scatter Gather Interface
            -----------------------------------------------------------------------
            s_axis_aclk                 => s_axis_s2mm_aclk                     ,
            s_axis_resetn               => s2mm_axis_resetn                     ,
            m_axis_aclk                 => m_axi_s2mm_aclk                      ,
            m_axis_resetn               => s2mm_prmry_resetn                    ,

            -- Graceful shut down control
            run_stop                    => s2mm_dmacr(DMACR_RS_BIT)             ,
            dm_halt                     => s2mm_halt                            , -- CR591965

            -- Line Tracking Control
            crnt_vsize                  => s2mm_crnt_vsize                      ,
            fsync_out                   => s2mm_fsync_out_i                     ,
            frame_sync                  => s2mm_frame_sync                      ,

            -- Threshold
            linebuf_threshold           => s2mm_linebuf_threshold               ,

            -- Stream In
            s_axis_tdata                => s_axis_s2mm_tdata_i                    ,
            s_axis_tkeep                => s_axis_s2mm_tkeep_i                    ,
            s_axis_tlast                => s_axis_s2mm_tlast_i                    ,
            s_axis_tvalid               => s_axis_s2mm_tvalid_i                   ,
            s_axis_tready               => s_axis_s2mm_tready_i                 ,
            s_axis_tuser                => s_axis_s2mm_tuser_i                    ,

            -- Stream Out
            m_axis_tdata                => linebuf2dm_s2mm_tdata                ,
            m_axis_tkeep                => linebuf2dm_s2mm_tkeep                ,
            m_axis_tlast                => linebuf2dm_s2mm_tlast                ,
            m_axis_tvalid               => linebuf2dm_s2mm_tvalid               ,
            m_axis_tready               => dm2linebuf_s2mm_tready               ,

            -- Fifo Status Flags
            s2mm_fifo_full              => s2mm_buffer_full                     ,
            s2mm_fifo_almost_full       => s2mm_buffer_almost_full              ,
            s2mm_all_lines_xfred        => s2mm_all_lines_xfred                 ,   -- CR591965
            all_lasts_rcvd              => all_lasts_rcvd                       ,
            s2mm_tuser_fsync            => s2mm_tuser_fsync
        );

end generate GEN_SPRT_FOR_S2MM;

-- Do not generate support logic for S2MM
GEN_NO_SPRT_FOR_S2MM : if C_INCLUDE_S2MM = 0 generate
begin

    -- Register Module Tie-Offs
    s2mm_ip2axi_rddata               <= (others => '0');
    s2mm_ip2axi_rddata_valid         <= '0';
    s2mm_ip2axi_frame_ptr_ref        <= (others => '0');
    s2mm_ip2axi_frame_store          <= (others => '0');
    s2mm_ip2axi_introut              <= '0';
    s2mm_soft_reset                  <= '0';
    s2mm_irqthresh_rstdsbl           <= '0';
    s2mm_dlyirq_dsble                <= '0';
    s2mm_irqthresh_wren              <= '0';
    s2mm_irqdelay_wren               <= '0';
    s2mm_tailpntr_updated            <= '0';
    s2mm_dmacr                       <= (others => '0');
    s2mm_dmasr                       <= (others => '0');
    s2mm_curdesc                     <= (others => '0');
    s2mm_taildesc                    <= (others => '0');
    s2mm_num_frame_store             <= (others => '0');
    s2mm_linebuf_threshold           <= (others => '0');
    s2mm_regdir_idle                 <= '0';
    s2mm_prmtr_updt_complete         <= '0';
    s2mm_reg_module_vsize            <= (others => '0');
    s2mm_reg_module_hsize            <= (others => '0');
    s2mm_reg_module_stride           <= (others => '0');
    s2mm_reg_module_frmdly           <= (others => '0');

    -- Must zero each element of an array of vectors to zero
    -- all vectors.
    GEN_S2MM_ZERO_STRT : for i in 0 to C_NUM_FSTORES-1 generate
        begin
            s2mm_reg_module_strt_addr(i)   <= (others => '0');
    end generate GEN_S2MM_ZERO_STRT;

    -- Line buffer Tie-Offs
    s_axis_s2mm_tready_i_axis_dw_conv            <= '0';
    s_axis_s2mm_tready_i            <= '0';
    linebuf2dm_s2mm_tdata           <= (others => '0');
    linebuf2dm_s2mm_tkeep           <= (others => '0');
    linebuf2dm_s2mm_tlast           <= '0';
    linebuf2dm_s2mm_tvalid          <= '0';
    s2mm_buffer_full                <= '0';
    s2mm_buffer_almost_full         <= '0';
    s2mm_all_lines_xfred            <= '0'; -- CR591965
    s2mm_tuser_fsync                <= '0';

    -- Frame sync generator
    s2mm_frame_sync                 <= '0';
    -- SOF/EOF generator
    s2mm_packet_sof                 <= '0';
    -- DMA Controller
    s2mm_halted_clr                 <= '0';
    s2mm_halted_set                 <= '1';
    s2mm_idle_set                   <= '0';
    s2mm_idle_clr                   <= '0';
    s2mm_frame_number               <= (others => '0');
    s2mm_new_curdesc_wren           <= '0';
    s2mm_new_curdesc                <= (others => '0');
    s2mm_stop                       <= '0';
    s2mm_all_idle                   <= '1';
    s2mm_cmdsts_idle                <= '1';
    s2mm_ftchcmdsts_idle            <= '1';
    m_axis_s2mm_ftch_tready         <= '0';
    s_axis_s2mm_cmd_tvalid          <= '0';
    s_axis_s2mm_cmd_tdata           <= (others => '0');
    m_axis_s2mm_sts_tready          <= '0';
    s2mm_frame_ptr_out_i            <= (others => '0');
    s2mm_m_frame_ptr_out            <= (others => '0');
    mm2s_to_s2mm_frame_ptr_in       <= (others => '0');
    s2mm_valid_frame_sync           <= '0';
    s2mm_valid_frame_sync_cmb       <= '0';
    s2mm_valid_video_prmtrs         <= '0';
    s2mm_parameter_update           <= '0';
    s2mm_tstvect_error              <= '0';
    s2mm_tstvect_fsync              <= '0';
    s2mm_tstvect_frame              <= (others => '0');
    s2mm_dma_interr_set             <= '0';
    s2mm_dma_slverr_set             <= '0';
    s2mm_dma_decerr_set             <= '0';
    s2mm_fsize_mismatch_err         <= '0';

    -- Frame Sync generator
    s2mm_fsync_out                  <= '0';
    s2mm_prmtr_update               <= '0';
    s2mm_crnt_vsize                 <= (others => '0'); -- CR575884
    s2mm_mask_fsync_out             <= '0';
    s2mm_mstrfrm_tstsync            <= '0';
    s2mm_mstrfrm_tstsync_out        <= '0';
    s2mm_tstvect_frm_ptr_out        <= (others => '0');
    s2mm_frmstr_error_addr          <= (others => '0');
    s2mm_to_mm2s_fsync              <= '0';

end generate GEN_NO_SPRT_FOR_S2MM;


-------------------------------------------------------------------------------
-- Primary MM2S and S2MM DataMover
-------------------------------------------------------------------------------
I_PRMRY_DATAMOVER : entity axi_datamover_v3_00_a.axi_datamover
    generic map(
        C_INCLUDE_MM2S              => MM2S_AXI_FULL_MODE                   ,
        C_M_AXI_MM2S_ADDR_WIDTH     => C_M_AXI_MM2S_ADDR_WIDTH              ,
        C_M_AXI_MM2S_DATA_WIDTH     => C_M_AXI_MM2S_DATA_WIDTH              ,
        C_M_AXIS_MM2S_TDATA_WIDTH   => C_M_AXIS_MM2S_TDATA_WIDTH_CALCULATED            ,
        C_INCLUDE_MM2S_STSFIFO      => DM_INCLUDE_STS_FIFO                  ,
        C_MM2S_STSCMD_FIFO_DEPTH    => DM_CMDSTS_FIFO_DEPTH                 ,
        C_MM2S_STSCMD_IS_ASYNC      => DM_CLOCK_SYNC                        ,
        C_INCLUDE_MM2S_DRE          => C_INCLUDE_MM2S_DRE                   ,
        C_MM2S_BURST_SIZE           => C_MM2S_MAX_BURST_LENGTH              ,
        C_MM2S_BTT_USED             => MM2S_DM_BTT_LENGTH_WIDTH             ,
        C_MM2S_ADDR_PIPE_DEPTH      => DM_ADDR_PIPE_DEPTH                   ,
        C_MM2S_INCLUDE_SF           => DM_MM2S_INCLUDE_SF                   ,

        C_INCLUDE_S2MM              => S2MM_AXI_FULL_MODE                   ,
        C_M_AXI_S2MM_ADDR_WIDTH     => C_M_AXI_S2MM_ADDR_WIDTH              ,
        C_M_AXI_S2MM_DATA_WIDTH     => C_M_AXI_S2MM_DATA_WIDTH              ,
        C_S_AXIS_S2MM_TDATA_WIDTH   => C_S_AXIS_S2MM_TDATA_WIDTH_CALCULATED            ,
        C_INCLUDE_S2MM_STSFIFO      => DM_INCLUDE_STS_FIFO                  ,
        C_S2MM_STSCMD_FIFO_DEPTH    => DM_CMDSTS_FIFO_DEPTH                 ,
        C_S2MM_STSCMD_IS_ASYNC      => DM_CLOCK_SYNC                        ,
        C_INCLUDE_S2MM_DRE          => C_INCLUDE_S2MM_DRE                   ,
        C_S2MM_BURST_SIZE           => C_S2MM_MAX_BURST_LENGTH              ,
        C_S2MM_BTT_USED             => S2MM_DM_BTT_LENGTH_WIDTH             ,
        C_S2MM_SUPPORT_INDET_BTT    => DM_SUPPORT_INDET_BTT                 ,
        C_S2MM_ADDR_PIPE_DEPTH      => DM_ADDR_PIPE_DEPTH                   ,
        C_S2MM_INCLUDE_SF           => DM_S2MM_INCLUDE_SF                   ,
        C_FAMILY                    => C_FAMILY
    )
    port map(
        -- MM2S Primary Clock / Reset input
        m_axi_mm2s_aclk             => m_axi_mm2s_aclk                      ,
        m_axi_mm2s_aresetn          => mm2s_dm_prmry_resetn                 ,
        mm2s_halt                   => mm2s_halt                            ,
        mm2s_halt_cmplt             => mm2s_halt_cmplt                      ,
        mm2s_err                    => mm2s_err                             ,
        mm2s_allow_addr_req         => ALWAYS_ALLOW                         ,
        mm2s_addr_req_posted        => open                                 ,
        mm2s_rd_xfer_cmplt          => open                                 ,

        -- Memory Map to Stream Command FIFO and Status FIFO I/O --------------
        m_axis_mm2s_cmdsts_aclk     => m_axi_mm2s_aclk                      ,
        m_axis_mm2s_cmdsts_aresetn  => mm2s_dm_prmry_resetn                 ,

        -- User Command Interface Ports (AXI Stream)
        s_axis_mm2s_cmd_tvalid      => s_axis_mm2s_cmd_tvalid               ,
        s_axis_mm2s_cmd_tready      => s_axis_mm2s_cmd_tready               ,
        s_axis_mm2s_cmd_tdata       => s_axis_mm2s_cmd_tdata                ,

        -- User Status Interface Ports (AXI Stream)
        m_axis_mm2s_sts_tvalid      => m_axis_mm2s_sts_tvalid               ,
        m_axis_mm2s_sts_tready      => m_axis_mm2s_sts_tready               ,
        m_axis_mm2s_sts_tdata       => m_axis_mm2s_sts_tdata                ,
        m_axis_mm2s_sts_tkeep       => m_axis_mm2s_sts_tkeep                ,
        m_axis_mm2s_sts_tlast       => open                                 ,

        -- MM2S AXI Address Channel I/O  --------------------------------------
        m_axi_mm2s_arid             => open                                 ,
        m_axi_mm2s_araddr           => m_axi_mm2s_araddr                    ,
        m_axi_mm2s_arlen            => m_axi_mm2s_arlen                     ,
        m_axi_mm2s_arsize           => m_axi_mm2s_arsize                    ,
        m_axi_mm2s_arburst          => m_axi_mm2s_arburst                   ,
        m_axi_mm2s_arprot           => m_axi_mm2s_arprot                    ,
        m_axi_mm2s_arcache          => m_axi_mm2s_arcache                   ,
        m_axi_mm2s_arvalid          => m_axi_mm2s_arvalid                   ,
        m_axi_mm2s_arready          => m_axi_mm2s_arready                   ,

        -- MM2S AXI MMap Read Data Channel I/O  -------------------------------
        m_axi_mm2s_rdata            => m_axi_mm2s_rdata                     ,
        m_axi_mm2s_rresp            => m_axi_mm2s_rresp                     ,
        m_axi_mm2s_rlast            => m_axi_mm2s_rlast                     ,
        m_axi_mm2s_rvalid           => m_axi_mm2s_rvalid                    ,
        m_axi_mm2s_rready           => m_axi_mm2s_rready                    ,

        -- MM2S AXI Master Stream Channel I/O  --------------------------------
        m_axis_mm2s_tdata           => dm2linebuf_mm2s_tdata                ,
        m_axis_mm2s_tkeep           => dm2linebuf_mm2s_tkeep                ,
        m_axis_mm2s_tlast           => dm2linebuf_mm2s_tlast                ,
        m_axis_mm2s_tvalid          => dm2linebuf_mm2s_tvalid               ,
        m_axis_mm2s_tready          => linebuf2dm_mm2s_tready               ,

        -- Testing Support I/O
        mm2s_dbg_sel                => (others => '0')                      ,
        mm2s_dbg_data               => open                                 ,

        -- S2MM Primary Clock/Reset input
        m_axi_s2mm_aclk             => m_axi_s2mm_aclk                      ,
        m_axi_s2mm_aresetn          => s2mm_dm_prmry_resetn                 ,
        s2mm_halt                   => s2mm_halt                            ,
        s2mm_halt_cmplt             => s2mm_halt_cmplt                      ,
        s2mm_err                    => s2mm_err                             ,
        s2mm_allow_addr_req         => ALWAYS_ALLOW                         ,
        s2mm_addr_req_posted        => open                                 ,
        s2mm_wr_xfer_cmplt          => open                                 ,
        s2mm_ld_nxt_len             => open                                 ,
        s2mm_wr_len                 => open                                 ,

        -- Stream to Memory Map Command FIFO and Status FIFO I/O --------------
        m_axis_s2mm_cmdsts_awclk    => m_axi_s2mm_aclk                      ,
        m_axis_s2mm_cmdsts_aresetn  => s2mm_dm_prmry_resetn                 ,

        -- User Command Interface Ports (AXI Stream)
        s_axis_s2mm_cmd_tvalid      => s_axis_s2mm_cmd_tvalid               ,
        s_axis_s2mm_cmd_tready      => s_axis_s2mm_cmd_tready               ,
        s_axis_s2mm_cmd_tdata       => s_axis_s2mm_cmd_tdata                ,

        -- User Status Interface Ports (AXI Stream)
        m_axis_s2mm_sts_tvalid      => m_axis_s2mm_sts_tvalid               ,
        m_axis_s2mm_sts_tready      => m_axis_s2mm_sts_tready               ,
        m_axis_s2mm_sts_tdata       => m_axis_s2mm_sts_tdata                ,
        m_axis_s2mm_sts_tkeep       => m_axis_s2mm_sts_tkeep                ,
        m_axis_s2mm_sts_tlast       => open                                 ,


        -- S2MM AXI Address Channel I/O  --------------------------------------
        m_axi_s2mm_awid             => open                                 ,
        m_axi_s2mm_awaddr           => m_axi_s2mm_awaddr                    ,
        m_axi_s2mm_awlen            => m_axi_s2mm_awlen                     ,
        m_axi_s2mm_awsize           => m_axi_s2mm_awsize                    ,
        m_axi_s2mm_awburst          => m_axi_s2mm_awburst                   ,
        m_axi_s2mm_awprot           => m_axi_s2mm_awprot                    ,
        m_axi_s2mm_awcache          => m_axi_s2mm_awcache                   ,
        m_axi_s2mm_awvalid          => m_axi_s2mm_awvalid                   ,
        m_axi_s2mm_awready          => m_axi_s2mm_awready                   ,

        -- S2MM AXI MMap Write Data Channel I/O  ------------------------------
        m_axi_s2mm_wdata            => m_axi_s2mm_wdata                     ,
        m_axi_s2mm_wstrb            => m_axi_s2mm_wstrb                     ,
        m_axi_s2mm_wlast            => m_axi_s2mm_wlast                     ,
        m_axi_s2mm_wvalid           => m_axi_s2mm_wvalid                    ,
        m_axi_s2mm_wready           => m_axi_s2mm_wready                    ,

        -- S2MM AXI MMap Write response Channel I/O  --------------------------
        m_axi_s2mm_bresp            => m_axi_s2mm_bresp                     ,
        m_axi_s2mm_bvalid           => m_axi_s2mm_bvalid                    ,
        m_axi_s2mm_bready           => m_axi_s2mm_bready                    ,


        -- S2MM AXI Slave Stream Channel I/O  ---------------------------------
        s_axis_s2mm_tdata           => linebuf2dm_s2mm_tdata                ,
        s_axis_s2mm_tkeep           => linebuf2dm_s2mm_tkeep                ,
        s_axis_s2mm_tlast           => linebuf2dm_s2mm_tlast                ,
        s_axis_s2mm_tvalid          => linebuf2dm_s2mm_tvalid               ,
        s_axis_s2mm_tready          => dm2linebuf_s2mm_tready               ,

        -- Testing Support I/O
        s2mm_dbg_sel                => (others => '0')                      ,
        s2mm_dbg_data               => open
    );

end implementation;
