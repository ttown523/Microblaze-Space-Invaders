-------------------------------------------------------------------------------
-- axi_vdma_mm2s_linebuf
-------------------------------------------------------------------------------
--
-- *************************************************************************
--
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
-- Copyright 2010 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
--
-- *************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:          axi_vdma_mm2s_linebuf.vhd
-- Description: This entity encompases the mm2s line buffer logic
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
--  GAB     7/6/11    v4_00_a
-- ^^^^^^
--  Initial Release
--  CR616211 - New DataMover (DM) Store-and-Forward allows DM status to be
--             returned long before MM2S stream completes causing core
--             synchronization to issues.
-- ~~~~~~
--  GAB    8/2/11    v4_00_a
-- ^^^^^^
--  CR619293 - Fixed issue with threshold met flag
-- ~~~~~~
--  GAB    8/19/11   v4_00_a
-- ^^^^^^
--  CR622179 - Qualified reset on fsync and dm_halt with fifo_pipeempty to
--  prevent axis protocol violation
-- ~~~~~~
--  GAB     8/19/11     v5_00_a
-- ^^^^^^
--  Intial release of v5_00_a
--  Added fsync on tuser(0) feature
--  Added fsync crossbar feature
--  Increased Frame Stores to 32
--  Added internal GenLock Option
-- ~~~~~~
--  GAB    8/30/11   v5_00_a
-- ^^^^^^
--  CR623088 - Wrong fsync used for dm_xfred_all_lines process causing
--             missed end of frame detection.
-- ~~~~~~
--  GAB    9/2/11   v5_00_a
-- ^^^^^^
--  CR623879 - fixed false fifo_pipe_assertions due to extreme AXI4 throttling
--             on mm2s reads causing fifo to go empty for extended periods of
--             time.  This then caused flase idles to be flagged and frame
--             syncs were then generated in free run mode.
-- ~~~~~~
--  GAB    9/13/11   v5_00_a
-- ^^^^^^
--  CR625142 - need to turn of threshold logic for case when user sets top
--             line buffer depth parameter to 0 but has configured the core
--             for asynchronous mode.
-- ~~~~~~
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

library axi_vdma_v5_00_a;
use axi_vdma_v5_00_a.axi_vdma_pkg.all;

-------------------------------------------------------------------------------
entity  axi_vdma_mm2s_linebuf is
    generic (
        C_DATA_WIDTH                : integer range 8 to 1024           := 32;
            -- Line Buffer Data Width

        C_INCLUDE_MM2S_SF           : integer range 0 to 1              := 0;
            -- Include or exclude MM2S Store And Forward Functionality
            -- 0 = Exclude MM2S Store and Forward
            -- 1 = Include MM2S Store and Forward

        C_MM2S_SOF_ENABLE               : integer range 0 to 1      := 0;
            -- Enable/Disable start of frame generation on tuser(0). This
            -- is only valid for external frame sync (C_USE_FSYNC = 1)
            -- 0 = disable SOF
            -- 1 = enable SOF

        C_M_AXIS_MM2S_TUSER_BITS        : integer range 1 to 1          := 1;
            -- Master AXI Stream User Width for MM2S Channel

        C_TOPLVL_LINEBUFFER_DEPTH   : integer range 0 to 65536          := 128; -- CR625142
            -- Depth as set by user at top level parameter

        C_LINEBUFFER_DEPTH          : integer range 0 to 65536          := 128;
            -- Linebuffer depth in Bytes. Must be a power of 2

        C_LINEBUFFER_AE_THRESH       : integer range 1 to 65536         := 1;
            -- Linebuffer almost empty threshold in Bytes. Must be a power of 2

        C_PRMRY_IS_ACLK_ASYNC       : integer range 0 to 1              := 0 ;
            -- Primary MM2S/S2MM sync/async mode
            -- 0 = synchronous mode     - all clocks are synchronous
            -- 1 = asynchronous mode    - Primary data path channels (MM2S and S2MM)
            --                            run asynchronous to AXI Lite, DMA Control,
            --                            and SG.

        C_FAMILY                    : string            := "virtex6"
            -- Device family used for proper BRAM selection
    );
    port (
        -- MM2S AXIS Input Side (i.e. Datamover side)
        s_axis_aclk                 : in  std_logic                         ;   --
        s_axis_resetn               : in  std_logic                         ;   --
                                                                                --
        -- MM2S AXIS Output Side                                                --
        m_axis_aclk                 : in  std_logic                         ;   --
        m_axis_resetn               : in  std_logic                         ;   --
                                                                                --
        -- Graceful shut down control                                           --
        dm_halt                     : in  std_logic                         ;   --
        cmdsts_idle                 : in  std_logic                         ;   --
        stop                        : in  std_logic                         ;   -- CR623291
                                                                                --
        -- Vertical Line Count control                                          --
        fsync_out                   : in  std_logic                         ;   -- CR616211
        frame_sync                  : in  std_logic                         ;   -- CR616211
        crnt_vsize                  : in  std_logic_vector                      --
                                        (VSIZE_DWIDTH-1 downto 0)           ;   -- CR616211
                                                                                --
        linebuf_threshold           : in  std_logic_vector                      --
                                        (LINEBUFFER_THRESH_WIDTH-1 downto 0);   --
                                                                                --
        -- Stream In (Datamover To Line Buffer)                                 --
        s_axis_tdata                : in  std_logic_vector                      --
                                        (C_DATA_WIDTH-1 downto 0)           ;   --
        s_axis_tkeep                : in  std_logic_vector                      --
                                        ((C_DATA_WIDTH/8)-1 downto 0)       ;   --
        s_axis_tlast                : in  std_logic                         ;   --
        s_axis_tvalid               : in  std_logic                         ;   --
        s_axis_tready               : out std_logic                         ;   --
                                                                                --
                                                                                --
        -- Stream Out (Line Buffer To MM2S AXIS)                                --
        m_axis_tdata                : out std_logic_vector                      --
                                        (C_DATA_WIDTH-1 downto 0)           ;   --
        m_axis_tkeep                : out std_logic_vector                      --
                                        ((C_DATA_WIDTH/8)-1 downto 0)       ;   --
        m_axis_tlast                : out std_logic                         ;   --
        m_axis_tvalid               : out std_logic                         ;   --
        m_axis_tready               : in  std_logic                         ;   --
        m_axis_tuser                : out std_logic_vector                      --
                                        (C_M_AXIS_MM2S_TUSER_BITS-1 downto 0);  --
                                                                                --
        -- Fifo Status Flags                                                    --
        mm2s_fifo_pipe_empty        : out std_logic                         ;   --
        mm2s_fifo_empty             : out std_logic                         ;   --
        mm2s_fifo_almost_empty      : out std_logic                         ;   --
        mm2s_all_lines_xfred        : out std_logic                             -- CR616211
    );

end axi_vdma_mm2s_linebuf;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma_mm2s_linebuf is

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------
-- Bufer depth
--constant BUFFER_DEPTH           : integer := max2(128,C_LINEBUFFER_DEPTH/(C_DATA_WIDTH/8));
constant BUFFER_DEPTH           : integer := C_LINEBUFFER_DEPTH;

-- Buffer width is data width + strobe width + 1 bit for tlast
-- Increase data width by 1 when tuser support included.
--constant BUFFER_WIDTH           : integer := C_DATA_WIDTH + (C_DATA_WIDTH/8) + 1;
constant BUFFER_WIDTH           : integer := C_DATA_WIDTH           -- tdata
                                          + (C_DATA_WIDTH/8)        -- tkeep
                                          + 1                       -- tlast
                                          + (C_MM2S_SOF_ENABLE      -- tuser
                                            *C_M_AXIS_MM2S_TUSER_BITS);






-- Buffer data count width
constant DATACOUNT_WIDTH        : integer := clog2(BUFFER_DEPTH+1);


constant DATA_COUNT_ZERO                : std_logic_vector(DATACOUNT_WIDTH-1 downto 0)
                                        := (others => '0');

constant USE_BRAM_FIFOS                 : integer   := 1; -- Use BRAM FIFOs


constant ZERO_VALUE_VECT                : std_logic_vector(255 downto 0) := (others => '0');

-- Constants for line tracking logic
constant VSIZE_ONE_VALUE            : std_logic_vector(VSIZE_DWIDTH-1 downto 0)
                                        := std_logic_vector(to_unsigned(1,VSIZE_DWIDTH));

constant VSIZE_ZERO_VALUE           : std_logic_vector(VSIZE_DWIDTH-1 downto 0)
                                        := (others => '0');

-- Linebuffer threshold support
constant THRESHOLD_LSB_INDEX        : integer := clog2((C_DATA_WIDTH/8));
constant THRESHOLD_PAD              : std_logic_vector(THRESHOLD_LSB_INDEX-1 downto 0)  := (others => '0');


-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
signal fifo_din                     : std_logic_vector(BUFFER_WIDTH - 1 downto 0) := (others => '0');
signal fifo_dout                    : std_logic_vector(BUFFER_WIDTH - 1 downto 0) := (others => '0');
signal fifo_wren                    : std_logic := '0';
signal fifo_rden                    : std_logic := '0';
signal fifo_empty_i                 : std_logic := '0';
signal fifo_full_i                  : std_logic := '0';
signal fifo_ainit                   : std_logic := '0';
signal fifo_rdcount                 : std_logic_vector(DATACOUNT_WIDTH downto 0) := (others => '0');
signal fifo_wrcount                 : std_logic_vector(DATACOUNT_WIDTH downto 0) := (others => '0'); --CR622702

signal s_axis_tready_i              : std_logic := '0'; -- CR619293
signal m_axis_tready_i              : std_logic := '0';
signal m_axis_tvalid_i              : std_logic := '0';
signal m_axis_tlast_i               : std_logic := '0';
signal m_axis_tdata_i               : std_logic_vector(C_DATA_WIDTH-1 downto 0):= (others => '0');
signal m_axis_tkeep_i               : std_logic_vector((C_DATA_WIDTH/8)-1 downto 0) := (others => '0');
signal m_axis_tuser_i               : std_logic_vector(C_M_AXIS_MM2S_TUSER_BITS - 1 downto 0) := (others => '0');

signal m_axis_tready_d1             : std_logic := '0';
signal m_axis_tlast_d1              : std_logic := '0';
signal m_axis_tvalid_d1             : std_logic := '0';

signal crnt_vsize_d2                : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');  -- CR575884
signal vsize_counter                : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');  -- CR575884
signal decr_vcount                  : std_logic := '0';                                              -- CR575884
signal all_lines_xfred              : std_logic := '0'; -- CR616211

signal m_axis_tvalid_out            : std_logic := '0'; -- CR576993
signal m_axis_tlast_out             : std_logic := '0'; -- CR616211
signal slv2skid_s_axis_tvalid       : std_logic := '0'; -- CR576993
signal fifo_empty_d1                : std_logic := '0'; -- CR576993

-- FIFO Pipe empty signals
signal fifo_pipe_empty              : std_logic := '0';
signal fifo_wren_d1                 : std_logic := '0'; -- CR579191
signal pot_empty                    : std_logic := '0'; -- CR579191

signal fifo_almost_empty_i          : std_logic := '1'; -- CR604273/CR604272
signal fifo_almost_empty_d1         : std_logic := '1';
signal fifo_almost_empty_fe         : std_logic := '0'; -- CR604273/CR604272

signal fifo_almost_empty_reg        : std_logic := '1';
signal data_count_ae_threshold      : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');
signal m_data_count_ae_thresh       : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');
signal sf_threshold_met             : std_logic := '0';

signal cmdsts_idle_d1               : std_logic := '0';
signal cmdsts_idle_fe               : std_logic := '0';
signal stop_reg                     : std_logic := '0'; --CR623291

signal s_axis_fifo_ainit            : std_logic := '0';
signal m_axis_fifo_ainit            : std_logic := '0';

signal rd_datacount                 : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');
signal wr_datacount                 : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');
signal p_wr_datacount               : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');


signal dm_decr_vcount               : std_logic := '0';                                                 -- CR619293
signal dm_xfred_all_lines           : std_logic := '0';                                                 -- CR619293
signal dm_vsize_counter             : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');     -- CR619293
signal dm_xfred_all_lines_reg       : std_logic := '0';                                                 -- CR619293

signal sof_flag                     : std_logic := '0';
signal mm2s_fifo_pipe_empty_i       : std_logic := '0';
signal frame_sync_d1                : std_logic := '0';

signal m_skid_reset                 : std_logic := '0';
signal dm_halt_reg                  : std_logic := '0';

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin
mm2s_fifo_pipe_empty <= mm2s_fifo_pipe_empty_i;


--*****************************************************************************--
--**              LINE BUFFER MODE (Sync or Async)                           **--
--*****************************************************************************--
GEN_LINEBUFFER : if C_LINEBUFFER_DEPTH /= 0 generate
begin

    -- Divide by number bytes per data beat and add padding to dynamic
    -- threshold setting
    data_count_ae_threshold <= linebuf_threshold((DATACOUNT_WIDTH-1) + THRESHOLD_LSB_INDEX
                                            downto THRESHOLD_LSB_INDEX);

    -- Synchronous clock therefore instantiate an Asynchronous FIFO
    GEN_SYNC_FIFO : if C_PRMRY_IS_ACLK_ASYNC = 0 generate
    begin

        I_LINEBUFFER_FIFO : entity axi_vdma_v5_00_a.axi_vdma_sfifo_autord
            generic map(
                 C_DWIDTH                => BUFFER_WIDTH        ,
                 C_DEPTH                 => BUFFER_DEPTH        ,
                 C_DATA_CNT_WIDTH        => DATACOUNT_WIDTH     ,
                 C_NEED_ALMOST_EMPTY     => 0                   ,
                 C_NEED_ALMOST_FULL      => 0                   ,
                 C_USE_BLKMEM            => USE_BRAM_FIFOS      ,
                 C_FAMILY                => C_FAMILY
            )
            port map(
                -- Inputs
                 SFIFO_Sinit             => s_axis_fifo_ainit   ,
                 SFIFO_Clk               => s_axis_aclk         ,
                 SFIFO_Wr_en             => fifo_wren           ,
                 SFIFO_Din               => fifo_din            ,
                 SFIFO_Rd_en             => fifo_rden           ,
                 SFIFO_Clr_Rd_Data_Valid => '0'                 ,

                -- Outputs
                 SFIFO_DValid            => open                ,
                 SFIFO_Dout              => fifo_dout           ,
                 SFIFO_Full              => fifo_full_i         ,
                 SFIFO_Empty             => fifo_empty_i        ,
                 SFIFO_Almost_full       => open                ,
                 SFIFO_Almost_empty      => open                ,
                 SFIFO_Rd_count          => fifo_rdcount(DATACOUNT_WIDTH-1 downto 0),
                 SFIFO_Rd_count_minus1   => open                ,
                 SFIFO_Wr_count          => fifo_wrcount(DATACOUNT_WIDTH-1 downto 0),
                 SFIFO_Rd_ack            => open
            );

    end generate GEN_SYNC_FIFO;

    -- Asynchronous clock therefore instantiate an Asynchronous FIFO
    GEN_ASYNC_FIFO : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
    begin
        I_LINEBUFFER_FIFO : entity axi_vdma_v5_00_a.axi_vdma_afifo_autord
            generic map(
                 C_DWIDTH        => BUFFER_WIDTH                    ,
                 C_DEPTH         => BUFFER_DEPTH                    ,
                 C_CNT_WIDTH     => DATACOUNT_WIDTH                 ,
                 C_USE_BLKMEM    => USE_BRAM_FIFOS                  ,
                 C_FAMILY        => C_FAMILY
            )
            port map(
                -- Inputs
                 AFIFO_Ainit                => s_axis_fifo_ainit    ,
                 AFIFO_Wr_clk               => s_axis_aclk          ,
                 AFIFO_Wr_en                => fifo_wren            ,
                 AFIFO_Din                  => fifo_din             ,
                 AFIFO_Rd_clk               => m_axis_aclk          ,
                 AFIFO_Rd_en                => fifo_rden            ,
                 AFIFO_Clr_Rd_Data_Valid    => '0'                  ,

                -- Outputs
                 AFIFO_DValid               => open                 ,
                 AFIFO_Dout                 => fifo_dout            ,
                 AFIFO_Full                 => fifo_full_i          ,
                 AFIFO_Empty                => fifo_empty_i         ,
                 AFIFO_Almost_full          => open                 ,
                 AFIFO_Almost_empty         => open                 ,
                 AFIFO_Wr_count             => fifo_wrcount(DATACOUNT_WIDTH-1 downto 0)         , --CR622702
                 AFIFO_Rd_count             => open                 ,
                 AFIFO_Corr_Rd_count        => fifo_rdcount         ,
                 AFIFO_Corr_Rd_count_minus1 => open                 ,
                 AFIFO_Rd_ack               => open
            );

     end generate GEN_ASYNC_FIFO;




    -- Generate an SOF on tuser(0). currently vdma only support 1 tuser bit that is set by
    -- frame sync and driven out on first data beat of mm2s packet.
    GEN_SOF : if C_MM2S_SOF_ENABLE = 1 generate
    signal sof_reset : std_logic := '0';
    begin
        sof_reset   <= '1' when (m_axis_resetn = '0')
                             or (dm_halt = '1')
                  else '0';

        -- On frame sync set flag and then clear flag when
        -- sof written to fifo.
        SOF_FLAG_PROCESS : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(sof_reset = '1' or (fifo_wren = '1' and fifo_full_i = '0'))then
                        sof_flag <= '0';
                    elsif(frame_sync = '1')then
                        sof_flag <= '1';
                    end if;
                end if;
            end process SOF_FLAG_PROCESS;

        -- AXI Slave Side of FIFO
        fifo_din            <= sof_flag & s_axis_tlast & s_axis_tkeep & s_axis_tdata;
        fifo_wren           <= s_axis_tvalid and not fifo_full_i and not s_axis_fifo_ainit;
        s_axis_tready_i     <= not fifo_full_i and not s_axis_fifo_ainit;
        s_axis_tready       <= s_axis_tready_i; -- CR619293

        -- AXI Master Side of FIFO
        fifo_rden           <= m_axis_tready_i and not fifo_empty_i and sf_threshold_met;
        m_axis_tvalid_i     <= not fifo_empty_i and sf_threshold_met;
        m_axis_tdata_i      <= fifo_dout(C_DATA_WIDTH-1 downto 0);
        m_axis_tkeep_i      <= fifo_dout(BUFFER_WIDTH-3 downto (BUFFER_WIDTH-3) - (C_DATA_WIDTH/8) + 1);
        m_axis_tlast_i      <= not fifo_empty_i and fifo_dout(BUFFER_WIDTH-2);
        m_axis_tuser_i(0)   <= m_axis_tvalid_i and fifo_dout(BUFFER_WIDTH-1);

    end generate GEN_SOF;


    -- SOF turned off therefore do not generate SOF on tuser
    GEN_NO_SOF : if C_MM2S_SOF_ENABLE = 0 generate
    begin

        sof_flag <= '0';

        -- AXI Slave Side of FIFO
        fifo_din            <= s_axis_tlast & s_axis_tkeep & s_axis_tdata;
        fifo_wren           <= s_axis_tvalid and not fifo_full_i and not s_axis_fifo_ainit;
        s_axis_tready_i     <= not fifo_full_i and not s_axis_fifo_ainit;
        s_axis_tready       <= s_axis_tready_i; -- CR619293

        -- AXI Master Side of FIFO
        fifo_rden           <= m_axis_tready_i and not fifo_empty_i and sf_threshold_met;
        m_axis_tvalid_i     <= not fifo_empty_i and sf_threshold_met;
        m_axis_tdata_i      <= fifo_dout(C_DATA_WIDTH-1 downto 0);
        m_axis_tkeep_i      <= fifo_dout(BUFFER_WIDTH-2 downto (BUFFER_WIDTH-2) - (C_DATA_WIDTH/8) + 1);
        m_axis_tlast_i      <= not fifo_empty_i and fifo_dout(BUFFER_WIDTH-1);
        m_axis_tuser_i      <= (others => '0');

    end generate GEN_NO_SOF;

    -- Top level line buffer depth not equal to zero therefore gererate threshold
    -- flags. (CR625142)
    GEN_THRESHOLD_ENABLED : if C_TOPLVL_LINEBUFFER_DEPTH /= 0 generate
    begin

        -- Almost empty flag (note: asserts when empty also)
        REG_ALMST_EMPTY : process(m_axis_aclk)
            begin
                if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
                    if(m_axis_fifo_ainit = '1')then
                        fifo_almost_empty_reg <= '1';
                    --elsif(fifo_rdcount(DATACOUNT_WIDTH-1 downto 0) <= DATA_COUNT_AE_THRESHOLD or fifo_empty_i = '1')then
                    elsif(fifo_rdcount(DATACOUNT_WIDTH-1 downto 0) <= m_data_count_ae_thresh
                      or fifo_empty_i = '1')then
                        fifo_almost_empty_reg <= '1';
                    else
                        fifo_almost_empty_reg <= '0';
                    end if;
                end if;
            end process REG_ALMST_EMPTY;


        mm2s_fifo_almost_empty  <= fifo_almost_empty_reg
                                or (not sf_threshold_met) -- CR622777
                                or (not m_axis_tvalid_out); -- CR625724

        mm2s_fifo_empty         <= not m_axis_tvalid_out;
    end generate GEN_THRESHOLD_ENABLED;

    -- Top level line buffer depth is zero therefore turn off threshold logic.
    -- this occurs for async operation where the async fifo is needed for CDC (CR625142)
    GEN_THRESHOLD_DISABLED  : if C_TOPLVL_LINEBUFFER_DEPTH = 0 generate
    begin
        mm2s_fifo_empty             <= '0';
        mm2s_fifo_almost_empty      <= '0';
        fifo_almost_empty_reg       <= '0';
    end generate GEN_THRESHOLD_DISABLED;

    -- CR#578903
    -- FIFO, FIFO Pipe, and Skid Buffer are all empty.  This is used to safely
    -- assert reset on shutdown and also used to safely generate fsync in free-run mode
    -- CR622702 - need to look at write side of fifo to prevent false empties due to async fifo
    --fifo_pipe_empty <= '1' when (fifo_wrcount(DATACOUNT_WIDTH-1 downto 0) = DATA_COUNT_ZERO -- Data count is 0
    --                                and m_axis_tvalid_out = '0')                            -- Skid Buffer is done
    --                        -- Forced stop and Threshold not met (CR623291)
    --                        or  (sf_threshold_met = '0' and stop_reg = '1')
    --              else '0';
    -- CR623879 fixed flase fifo_pipe_assertions due to extreme AXI4 throttling on
    -- mm2s reads causing fifo to go empty for extended periods of time.  This then
    -- caused flase idles to be flagged and frame syncs were then generated in free run mode
    fifo_pipe_empty <= '1' when (all_lines_xfred = '1' and m_axis_tvalid_out = '0') -- All data for frame transmitted
                            or  (sf_threshold_met = '0'              -- Or Threshold not met
                                and stop_reg = '1'                   -- Commanded to stop
                                and m_axis_tvalid_out = '0')         -- And NOT driving tvalid
                  else '0';


    -- If store and forward is turned on by user then gate tvalid with
    -- threshold met
    GEN_THRESH_MET_FOR_SNF : if C_INCLUDE_MM2S_SF = 1 generate
    begin
            -- Register fifo_almost empty in order to generate
            -- almost empty fall edge pulse
            REG_ALMST_EMPTY_FE : process(m_axis_aclk)
                begin
                    if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
                        if(m_axis_fifo_ainit = '1')then
                            fifo_almost_empty_d1 <= '1';
                        else
                            fifo_almost_empty_d1 <= fifo_almost_empty_reg;
                        end if;
                    end if;
                end process REG_ALMST_EMPTY_FE;

            -- Almost empty falling edge
            fifo_almost_empty_fe <= not fifo_almost_empty_reg and fifo_almost_empty_d1;

            -- Store and Forward threshold met
            THRESH_MET : process(m_axis_aclk)
                begin
                    if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
                        if(m_axis_fifo_ainit = '1')then
                            sf_threshold_met <= '0';
                        elsif(fsync_out = '1')then
                            sf_threshold_met <= '0';
                        -- Reached threshold or all reads done for the frame
                        elsif(fifo_almost_empty_fe = '1'
                          or (dm_xfred_all_lines_reg = '1'))then
                            sf_threshold_met <= '1';
                        end if;
                    end if;
                end process THRESH_MET;

    end generate GEN_THRESH_MET_FOR_SNF;

    -- Store and forward off therefore do not need to meet threshold
    GEN_NO_THRESH_MET_FOR_SNF : if C_INCLUDE_MM2S_SF = 0 generate
    begin
        sf_threshold_met <= '1';
    end generate GEN_NO_THRESH_MET_FOR_SNF;


    --*********************************************************--
    --**               MM2S MASTER SKID BUFFER               **--
    --*********************************************************--
    I_MSTR_SKID : entity axi_vdma_v5_00_a.axi_vdma_skid_buf
        generic map(
            C_WDATA_WIDTH           => C_DATA_WIDTH             ,
            C_TUSER_WIDTH           => C_M_AXIS_MM2S_TUSER_BITS
        )
        port map(
            -- System Ports
            ACLK                   => m_axis_aclk               ,
            ARST                   => m_skid_reset              ,

            -- Shutdown control (assert for 1 clk pulse)
            skid_stop              => '0'                       ,

            -- Slave Side (Stream Data Input)
            S_VALID                => m_axis_tvalid_i           ,
            S_READY                => m_axis_tready_i           ,
            S_Data                 => m_axis_tdata_i            ,
            S_STRB                 => m_axis_tkeep_i            ,
            S_Last                 => m_axis_tlast_i            ,
            S_User                 => m_axis_tuser_i            ,

            -- Master Side (Stream Data Output)
            M_VALID                => m_axis_tvalid_out         ,
            M_READY                => m_axis_tready             ,
            M_Data                 => m_axis_tdata              ,
            M_STRB                 => m_axis_tkeep              ,
            M_Last                 => m_axis_tlast_out          ,
            M_User                 => m_axis_tuser
        );

    -- Pass out of core
    m_axis_tvalid   <= m_axis_tvalid_out;
    m_axis_tlast    <= m_axis_tlast_out;

    -- Register to break long timing paths for use in
    -- transfer complete generation
    REG_STRM_SIGS : process(m_axis_aclk)
        begin
            if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
                if(m_axis_fifo_ainit = '1')then
                    m_axis_tlast_d1     <= '0';
                    m_axis_tvalid_d1    <= '0';
                    m_axis_tready_d1    <= '0';
                else
                    m_axis_tlast_d1     <= m_axis_tlast_out;
                    m_axis_tvalid_d1    <= m_axis_tvalid_out;
                    m_axis_tready_d1    <= m_axis_tready;
                end if;
            end if;
        end process REG_STRM_SIGS;


end generate GEN_LINEBUFFER;

--*****************************************************************************--
--**               NO LINE BUFFER MODE (Sync Only)                           **--
--*****************************************************************************--
-- LineBuffer forced on if asynchronous mode is enabled
GEN_NO_LINEBUFFER : if (C_LINEBUFFER_DEPTH = 0) generate     -- No Line Buffer
begin

    -- Map Datamover to AXIS Master Out
    m_axis_tdata        <= s_axis_tdata;
    m_axis_tkeep        <= s_axis_tkeep;
    m_axis_tvalid       <= s_axis_tvalid;
    m_axis_tlast        <= s_axis_tlast;

    s_axis_tready       <= m_axis_tready;

    -- Tie FIFO Flags off
    mm2s_fifo_empty          <= '0';
    mm2s_fifo_almost_empty   <= '0';


    -- Generate sof on tuser(0)
    GEN_SOF : if C_MM2S_SOF_ENABLE = 1 generate
    begin
        -- On frame sync set flag and then clear flag when
        -- sof written to fifo.
        SOF_FLAG_PROCESS : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1' or (s_axis_tvalid = '1' and m_axis_tready = '1'))then
                        sof_flag <= '0';
                    elsif(frame_sync = '1')then
                        sof_flag <= '1';
                    end if;
                end if;
            end process SOF_FLAG_PROCESS;

        m_axis_tuser(0) <= sof_flag;

    end generate GEN_SOF;

    -- Do not generate sof on tuser(0)
    GEN_NO_SOF : if C_MM2S_SOF_ENABLE = 0 generate
    begin
        sof_flag        <= '0';
        m_axis_tuser    <= (others => '0');
    end generate GEN_NO_SOF;


    -- CR#578903
    -- Register tvalid to break timing paths for use in
    -- psuedo fifo empty for channel idle generation and
    -- for xfer complete generation.
    REG_STRM_SIGS : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                if(s_axis_resetn = '0' or dm_halt = '1')then
                    m_axis_tvalid_d1        <= '0';
                    m_axis_tlast_d1         <= '0';
                    m_axis_tready_d1        <= '0';
                else
                    m_axis_tvalid_d1        <= s_axis_tvalid;
                    m_axis_tlast_d1         <= s_axis_tlast;
                    m_axis_tready_d1        <= m_axis_tready;
                end if;
            end if;
        end process REG_STRM_SIGS;

    -- CR#578903
    -- Psuedo FIFO, FIFO Pipe, and Skid Buffer are all empty.  This is used to safely
    -- assert reset on shutdown and also used to safely generate fsync in free-run mode
    -- This flag is looked at at the end of frames.
    -- Order of else-if is critical
    -- CR579191 modified method to prevent double fsync assertions
    REG_PIPE_EMPTY : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                if(s_axis_resetn = '0' or dm_halt = '1')then
                    fifo_pipe_empty <= '1';

                -- Command/Status not idle indicates pending datamover commands
                -- set psuedo fifo empty to NOT empty.
                elsif(cmdsts_idle_fe = '1')then
                    fifo_pipe_empty <= '0';

                -- On accepted tlast then clear psuedo empty flag back to being empty
                elsif(pot_empty = '1' and cmdsts_idle = '1')then
                    fifo_pipe_empty <= '1';
                end if;
            end if;
        end process REG_PIPE_EMPTY;

    REG_IDLE_FE : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                if(s_axis_resetn = '0' or dm_halt = '1')then
                    cmdsts_idle_d1 <= '1';
                else
                    cmdsts_idle_d1 <= cmdsts_idle;
                end if;
            end if;
        end process REG_IDLE_FE;

    -- CR579586 Use falling edge to set pfifo empty
    cmdsts_idle_fe  <= not cmdsts_idle and cmdsts_idle_d1;

    -- CR579191
    POTENTIAL_EMPTY_PROCESS : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                if(s_axis_resetn = '0' or dm_halt = '1')then
                    pot_empty <= '1';
                elsif(m_axis_tvalid_d1 = '1' and m_axis_tlast_d1 = '1' and m_axis_tready_d1 = '1')then
                    pot_empty <= '1';
                elsif(m_axis_tvalid_d1 = '1' and m_axis_tlast_d1 = '0')then
                    pot_empty <= '0';
                end if;
            end if;
        end process POTENTIAL_EMPTY_PROCESS;

end generate GEN_NO_LINEBUFFER;


--*****************************************************************************--
--**                    MM2S ASYNCH CLOCK SUPPORT                            **--
--*****************************************************************************--
-- Cross fifo pipe empty flag to secondary clock domain
GEN_FOR_ASYNC : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
begin

    -- Pipe Empty and Shutdown reset CDC
    SHUTDOWN_RST_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
        generic map(
            C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
            C_VECTOR_WIDTH          => 1
        )
        port map (
            prmry_aclk              => m_axis_aclk                              ,
            prmry_resetn            => m_axis_resetn                            ,
            scndry_aclk             => s_axis_aclk                              ,
            scndry_resetn           => s_axis_resetn                            ,
            scndry_in               => '0'                                      ,
            prmry_out               => open                                     ,
            prmry_in                => fifo_pipe_empty                          ,
            scndry_out              => mm2s_fifo_pipe_empty_i                   ,
            scndry_vect_s_h         => '0'                                      ,
            scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
            prmry_vect_out          => open                                     ,
            prmry_vect_s_h          => '0'                                      ,
            prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
            scndry_vect_out         => open
        );

    -- Vertical Count and All Lines Transferred CDC (CR616211)
    VERT_CNT_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
        generic map(
            C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
            C_VECTOR_WIDTH          => VSIZE_DWIDTH
        )
        port map (
            prmry_aclk              => m_axis_aclk                              ,
            prmry_resetn            => m_axis_resetn                            ,
            scndry_aclk             => s_axis_aclk                              ,
            scndry_resetn           => s_axis_resetn                            ,
            scndry_in               => dm_xfred_all_lines                       ,   -- CR619293
            prmry_out               => dm_xfred_all_lines_reg                   ,   -- CR619293
            prmry_in                => all_lines_xfred                          ,
            scndry_out              => mm2s_all_lines_xfred                     ,
            scndry_vect_s_h         => '1'                                      ,
            scndry_vect_in          => crnt_vsize                               ,
            prmry_vect_out          => crnt_vsize_d2                            ,
            prmry_vect_s_h          => '0'                                      ,
            prmry_vect_in           => ZERO_VALUE_VECT(VSIZE_DWIDTH-1 downto 0) ,
            scndry_vect_out         => open
        );

    -- Cross stop signal  (CR623291)
    STOP_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
        generic map(
            C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
            C_VECTOR_WIDTH          => 1
        )
        port map (
            prmry_aclk              => m_axis_aclk                              ,
            prmry_resetn            => m_axis_resetn                            ,
            scndry_aclk             => s_axis_aclk                              ,
            scndry_resetn           => s_axis_resetn                            ,
            scndry_in               => stop                                     ,
            prmry_out               => stop_reg                                 ,
            prmry_in                => '0'                                      ,
            scndry_out              => open                                     ,
            scndry_vect_s_h         => '0'                                      ,
            scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
            prmry_vect_out          => open                                     ,
            prmry_vect_s_h          => '0'                                      ,
            prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
            scndry_vect_out         => open
        );


    -- Cross datamover halt and threshold signals
    HALT_AND_THRESH_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
        generic map(
            C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
            C_VECTOR_WIDTH          => DATACOUNT_WIDTH
        )
        port map (
            prmry_aclk              => m_axis_aclk                              ,
            prmry_resetn            => m_axis_resetn                            ,
            scndry_aclk             => s_axis_aclk                              ,
            scndry_resetn           => s_axis_resetn                            ,
            scndry_in               => dm_halt                                  ,
            prmry_out               => dm_halt_reg                              ,
            prmry_in                => '0'                                      ,
            scndry_out              => open                                     ,
            scndry_vect_s_h         => '1'                                      ,
            scndry_vect_in          => data_count_ae_threshold                  ,
            prmry_vect_out          => m_data_count_ae_thresh                   ,
            prmry_vect_s_h          => '0'                                      ,
            prmry_vect_in           => ZERO_VALUE_VECT(DATACOUNT_WIDTH-1 downto 0),
            scndry_vect_out         => open
        );

end generate GEN_FOR_ASYNC;

--*****************************************************************************--
--**                    MM2S SYNCH CLOCK SUPPORT                             **--
--*****************************************************************************--
GEN_FOR_SYNC : if C_PRMRY_IS_ACLK_ASYNC = 0 generate
begin
    mm2s_fifo_pipe_empty_i      <= fifo_pipe_empty;
    crnt_vsize_d2               <= crnt_vsize;              -- CR616211
    mm2s_all_lines_xfred        <= all_lines_xfred;         -- CR616211
    dm_xfred_all_lines_reg      <= dm_xfred_all_lines;      -- CR619293
    stop_reg                    <= stop;                    -- CR623291
    dm_halt_reg                 <= dm_halt;
    m_data_count_ae_thresh      <= data_count_ae_threshold;

end generate GEN_FOR_SYNC;



--*****************************************************************************
--** Vertical Line Tracking (CR616211)
--*****************************************************************************
-- Decrement vertical count with each accept tlast
decr_vcount <= '1' when m_axis_tlast_d1 = '1'
                    and m_axis_tvalid_d1 = '1'
                    and m_axis_tready_d1 = '1'
          else '0';


-- Drive ready at fsync out then de-assert once all lines have
-- been accepted.
VERT_COUNTER : process(m_axis_aclk)
    begin
        if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
            if(m_axis_fifo_ainit = '1' and fsync_out = '0')then
                vsize_counter       <= (others => '0');
                all_lines_xfred     <= '1';
            elsif(fsync_out = '1')then
                vsize_counter       <= crnt_vsize_d2;
                all_lines_xfred     <= '0';
            elsif(decr_vcount = '1' and vsize_counter = VSIZE_ONE_VALUE)then
                vsize_counter       <= (others => '0');
                all_lines_xfred     <= '1';

            elsif(decr_vcount = '1' and vsize_counter /= VSIZE_ZERO_VALUE)then
                vsize_counter       <= std_logic_vector(unsigned(vsize_counter) - 1);
                all_lines_xfred     <= '0';

            end if;
        end if;
    end process VERT_COUNTER;

-- Store and forward or no line buffer (CR619293)
GEN_VCOUNT_FOR_SNF : if C_LINEBUFFER_DEPTH /= 0 and C_INCLUDE_MM2S_SF = 1 generate
begin
    dm_decr_vcount <= '1' when s_axis_tlast = '1'
                           and s_axis_tvalid = '1'
                           and s_axis_tready_i = '1'
              else '0';

    -- Delay 1 pipe to align with cnrt_vsize
    REG_FSYNC_TO_ALIGN : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                if(s_axis_fifo_ainit = '1' and frame_sync = '0')then
                    frame_sync_d1 <= '0';
                else
                    frame_sync_d1 <= frame_sync;
                end if;
            end if;
        end process REG_FSYNC_TO_ALIGN;

    -- Count lines to determine when datamover done.  Used for snf mode
    -- for threshold met (CR619293)
    DM_DONE     : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                if(s_axis_fifo_ainit = '1')then
                    dm_vsize_counter        <= (others => '0');
                    dm_xfred_all_lines      <= '0';
                --elsif(fsync_out = '1')then     -- CR623088
                elsif(frame_sync_d1 = '1')then     -- CR623088
                    dm_vsize_counter       <= crnt_vsize;
                    dm_xfred_all_lines     <= '0';
                elsif(dm_decr_vcount = '1' and dm_vsize_counter = VSIZE_ONE_VALUE)then
                    dm_vsize_counter       <= (others => '0');
                    dm_xfred_all_lines     <= '1';

                elsif(dm_decr_vcount = '1' and dm_vsize_counter /= VSIZE_ZERO_VALUE)then
                    dm_vsize_counter       <= std_logic_vector(unsigned(dm_vsize_counter) - 1);
                    dm_xfred_all_lines     <= '0';

                end if;
            end if;
        end process DM_DONE;

end generate GEN_VCOUNT_FOR_SNF;

-- Not store and forward or no line buffer (CR619293)
GEN_NO_VCOUNT_FOR_SNF : if C_LINEBUFFER_DEPTH = 0 or C_INCLUDE_MM2S_SF = 0 generate
begin
    dm_vsize_counter        <= (others => '0');
    dm_xfred_all_lines      <= '0';
    dm_decr_vcount          <= '0';
end generate GEN_NO_VCOUNT_FOR_SNF;


--*****************************************************************************--
--**                    SPECIAL RESET GENERATION                             **--
--*****************************************************************************--


-- Assert reset to skid buffer on hard reset or on shutdown when fifo pipe empty
-- Waiting for fifo_pipe_empty is required to prevent a AXIS protocol violation
-- when channel shut down early
REG_SKID_RESET : process(m_axis_aclk)
    begin
        if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
            if(m_axis_resetn = '0')then
                m_skid_reset <= '1';

            elsif(fifo_pipe_empty = '1')then
                if(fsync_out = '1' or dm_halt_reg = '1')then
                    m_skid_reset <= '1';
                else
                    m_skid_reset <= '0';
                end if;
            else
                m_skid_reset <= '0';
            end if;
        end if;
    end process REG_SKID_RESET;

-- Fifo/logic reset for slave side clock domain (m_axi_mm2s_aclk)
-- If error (dm_halt=1) then halt immediatly without protocol violation
s_axis_fifo_ainit <= '1' when s_axis_resetn = '0'
                           or frame_sync = '1'          -- Frame sync
                           or dm_halt = '1'             -- Datamover being halted (halt due to error)
                else '0';

-- Fifo/logic reset for master side clock domain (m_axis_mm2s_aclk)
m_axis_fifo_ainit <= '1' when m_axis_resetn = '0'
                           or fsync_out = '1'           -- Frame sync
                           or dm_halt_reg = '1'         -- Datamover being halted
                else '0';


end implementation;
