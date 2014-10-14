-------------------------------------------------------------------------------
-- axi_vdma_s2mm_linebuf
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
-- Filename:          axi_vdma_s2mm_linebuf.vhd
-- Description: This entity encompases the line buffer logic
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
--  - Initial Release
-- ~~~~~~
--  GAB     7/6/11    v4_00_a
-- ^^^^^^
-- CR591965 - Flush on Frame Sync support requires flag indicating when
-- all lines have been transferred for determining frame size mismatch.
-- ~~~~~~
--  GAB     8/19/11     v5_00_a
-- ^^^^^^
--  Intial release of v5_00_a
--  Added fsync on tuser(0) feature
--  Added fsync crossbar feature
--  Increased Frame Stores to 32
--  Added internal GenLock Option
-- ~~~~~~
--  GAB     8/30/11    v5_00_a
-- ^^^^^^
-- CR623449 - transfer done flag deasserted too soon because it was based
--            on slave AXIS completion.  Should have been done based
--            on AXI clock domain or master side completion of reading
--            out data from fifo.
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
use proc_common_v3_00_a.sync_fifo_fg;
use proc_common_v3_00_a.proc_common_pkg.all;

library axi_vdma_v5_00_a;
use axi_vdma_v5_00_a.axi_vdma_pkg.all;

-------------------------------------------------------------------------------
entity  axi_vdma_s2mm_linebuf is
    generic (
        C_DATA_WIDTH                : integer range 8 to 1024           := 32;
            -- Line Buffer Data Width

        C_S2MM_SOF_ENABLE               : integer range 0 to 1      := 0;
            -- Enable/Disable start of frame generation on tuser(0). This
            -- is only valid for external frame sync (C_USE_FSYNC = 1)
            -- 0 = disable SOF
            -- 1 = enable SOF

        C_S_AXIS_S2MM_TUSER_BITS        : integer range 1 to 1      := 1;
            -- Slave AXI Stream User Width for S2MM Channel

        C_TOPLVL_LINEBUFFER_DEPTH   : integer range 0 to 65536          := 128; -- CR625142
            -- Depth as set by user at top level parameter

        C_LINEBUFFER_DEPTH          : integer range 0 to 65536          := 128;
            -- Linebuffer depth in Bytes. Must be a power of 2

        C_LINEBUFFER_AF_THRESH       : integer range 1 to 65536         := 1;
            -- Linebuffer almost full threshold in Bytes. Must be a power of 2

        C_PRMRY_IS_ACLK_ASYNC       : integer range 0 to 1              := 0 ;
            -- Primary MM2S/S2MM sync/async mode
            -- 0 = synchronous mode     - all clocks are synchronous
            -- 1 = asynchronous mode    - Primary data path channels (MM2S and S2MM)
            --                            run asynchronous to AXI Lite, DMA Control,
            --                            and SG.
        ENABLE_FLUSH_ON_FSYNC       : integer range 0 to 1        := 0      ;
        

        C_FAMILY                    : string            := "virtex6"
            -- Device family used for proper BRAM selection
    );
    port (
        s_axis_aclk                 : in  std_logic                         ;       --
        s_axis_resetn               : in  std_logic                         ;       --
                                                                                    --
        m_axis_aclk                 : in  std_logic                         ;       --
        m_axis_resetn               : in  std_logic                         ;       --
                                                                                    --
                                                                                    --
        -- Graceful shut down control                                               --
        run_stop                    : in  std_logic                         ;       --
        dm_halt                     : in  std_logic                         ;       -- CR591965
                                                                                    --
        -- Line Tracking Control                                                    --
        crnt_vsize                  : in  std_logic_vector                          -- CR575884
                                        (VSIZE_DWIDTH-1 downto 0)           ;       -- CR575884
        fsync_out                   : in  std_logic                         ;       -- CR575884
        frame_sync                  : in  std_logic                         ;       -- CR575884
                                                                                    --
        -- Line Buffer Threshold                                                    --
        linebuf_threshold           : in  std_logic_vector                          --
                                        (LINEBUFFER_THRESH_WIDTH-1 downto 0);       --
        -- Stream In                                                                --
        s_axis_tdata                : in  std_logic_vector                          --
                                        (C_DATA_WIDTH-1 downto 0)           ;       --
        s_axis_tkeep                : in  std_logic_vector                          --
                                        ((C_DATA_WIDTH/8)-1 downto 0)       ;       --
        s_axis_tlast                : in  std_logic                         ;       --
        s_axis_tvalid               : in  std_logic                         ;       --
        s_axis_tready               : out std_logic                         ;       --
        s_axis_tuser                : in  std_logic_vector                          --
                                        (C_S_AXIS_S2MM_TUSER_BITS-1 downto 0);      --
                                                                                    --
        -- Stream Out                                                               --
        m_axis_tdata                : out std_logic_vector                          --
                                        (C_DATA_WIDTH-1 downto 0)           ;       --
        m_axis_tkeep                : out std_logic_vector                          --
                                        ((C_DATA_WIDTH/8)-1 downto 0)       ;       --
        m_axis_tlast                : out std_logic                         ;       --
        m_axis_tvalid               : out std_logic                         ;       --
        m_axis_tready               : in  std_logic                         ;       --
                                                                                    --
        -- Fifo Status Flags                                                        --
        s2mm_fifo_full              : out std_logic                         ;       --
        s2mm_fifo_almost_full       : out std_logic                         ;       --
        s2mm_all_lines_xfred        : out std_logic                         ;       -- CR591965
        all_lasts_rcvd              : out std_logic			    ;	
        s2mm_tuser_fsync            : out std_logic
    );

end axi_vdma_s2mm_linebuf;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma_s2mm_linebuf is

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
constant BUFFER_WIDTH           : integer := C_DATA_WIDTH + (C_DATA_WIDTH/8) + 1;
-- Buffer data count width
constant DATACOUNT_WIDTH        : integer := clog2(BUFFER_DEPTH+1);


constant USE_BRAM_FIFOS             : integer   := 1; -- Use BRAM FIFOs

-- Constants for line tracking logic
constant VSIZE_ONE_VALUE            : std_logic_vector(VSIZE_DWIDTH-1 downto 0)
                                        := std_logic_vector(to_unsigned(1,VSIZE_DWIDTH));
constant VSIZE_TWO_VALUE            : std_logic_vector(VSIZE_DWIDTH-1 downto 0)
                                        := std_logic_vector(to_unsigned(2,VSIZE_DWIDTH));


constant VSIZE_ZERO_VALUE           : std_logic_vector(VSIZE_DWIDTH-1 downto 0)
                                        := (others => '0');

constant ZERO_VALUE_VECT            : std_logic_vector(255 downto 0) := (others => '0');


-- Linebuffer threshold support
constant THRESHOLD_LSB_INDEX        : integer := clog2((C_DATA_WIDTH/8));

-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
signal fifo_din                     : std_logic_vector(BUFFER_WIDTH - 1 downto 0) := (others => '0');
signal fifo_dout                    : std_logic_vector(BUFFER_WIDTH - 1 downto 0):= (others => '0');
signal fifo_wren                    : std_logic := '0';
signal fifo_rden                    : std_logic := '0';
signal fifo_empty_i                 : std_logic := '0';
signal fifo_full_i                  : std_logic := '0';
signal fifo_ainit                   : std_logic := '0';
signal fifo_wrcount                 : std_logic_vector(DATACOUNT_WIDTH-1 downto 0);
signal fifo_almost_full_i           : std_logic := '0'; -- CR604273/CR604272

signal s_axis_tready_i              : std_logic := '0';
signal s_axis_tvalid_i              : std_logic := '0';
signal s_axis_tlast_i               : std_logic := '0';
signal s_axis_tdata_i               : std_logic_vector(C_DATA_WIDTH-1 downto 0):= (others => '0');
signal s_axis_tkeep_i               : std_logic_vector((C_DATA_WIDTH/8)-1 downto 0) := (others => '0');
signal s_axis_tuser_i               : std_logic_vector(C_S_AXIS_S2MM_TUSER_BITS-1 downto 0) := (others => '0');

signal crnt_vsize_d2                : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');
signal vsize_counter                : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0');
signal decr_vcount                  : std_logic := '0';
signal chnl_ready                   : std_logic := '0';

signal frame_sync_d1                : std_logic := '0';
signal frame_sync_d2                : std_logic := '0';

signal s_axis_tready_out            : std_logic := '0';
signal slv2skid_s_axis_tvalid       : std_logic := '0';
signal fifo_empty_d1                : std_logic := '0';
signal fifo_empty_fe                : std_logic := '0';
signal data_count_af_threshold      : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');
signal s_data_count_af_thresh   : std_logic_vector(DATACOUNT_WIDTH-1 downto 0) := (others => '0');
signal dm_halt_reg                  : std_logic := '0'; -- CR591965

signal s_axis_fifo_ainit            : std_logic := '0';
signal all_lines_xfred              : std_logic := '0'; -- CR591965
signal s_axis_tuser_d1              : std_logic := '0';
signal tuser_fsync                  : std_logic := '0';

signal m_axis_fifo_ainit        : std_logic := '0';                                             -- CR623449
signal done_vsize_counter       : std_logic_vector(VSIZE_DWIDTH-1 downto 0) := (others => '0'); -- CR623449
signal m_axis_tlast_i           : std_logic := '0';                                             -- CR623449
signal m_axis_tvalid_i          : std_logic := '0';                                             -- CR623449
signal done_decr_vcount         : std_logic := '0';                                             -- CR623449
signal p_fsync_out              : std_logic := '0';
-- Added for CR626585
signal s2mm_all_lines_xfred_i   : std_logic := '0';
signal s_axis_fifo_ainit_nosync : std_logic := '0';
signal m_axis_fifo_ainit_nosync : std_logic := '0';



-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin


-- fifo ainit in the S_AXIS clock domain
s_axis_fifo_ainit <= '1' when (s_axis_resetn = '0')
                           or (fsync_out = '1')                            -- CR591965
                           or (dm_halt_reg = '1')                          -- CR591965
                else '0';

m_axis_fifo_ainit <= '1' when (m_axis_resetn = '0')
                           or (frame_sync = '1')                                                -- CR623449
                           or (dm_halt = '1')                                                   -- CR623449
                else '0';                                                                       -- CR623449

--*****************************************************************************--
--**              USE FSYNC MODE                         **--
--*****************************************************************************--
GEN_FSYNC_LOGIC : if ENABLE_FLUSH_ON_FSYNC = 1 generate


    type  STRM_WR_SM_TYPE is (STRM_WR_IDLE,
                              STRM_WR_START,
                              STRM_WR_RUNNING,
                              STRM_WR_LAST
                             );


    signal strm_write_ns            : STRM_WR_SM_TYPE;
    signal strm_write_cs            : STRM_WR_SM_TYPE;

    type  FIFO_RD_SM_TYPE is (FIFO_RD_IDLE,
                       --   FIFO_RD_START,
                              FIFO_RD_RUNNING,
                              FIFO_RD_FSYNC,
                              FIFO_RD_FSYNC_LAST,
                               FIFO_RD_LAST
                             );
    signal fifo_read_ns             : FIFO_RD_SM_TYPE;
    signal fifo_read_cs             : FIFO_RD_SM_TYPE;
    
    signal load_counter             : std_logic := '0';
    signal load_counter_sm          : std_logic := '0';
    signal strm_write_pending_sm    : std_logic := '0';
    signal strm_write_pending       : std_logic := '0';
    signal fifo_rd_pending_sm       : std_logic := '0';
    signal fifo_rd_pending          : std_logic := '0';
    signal stop_tready_sm           : std_logic := '0';
    signal stop_tready              : std_logic := '0';
    signal strm_write_pending_m_axi : std_logic := '0';
    signal stop_tready_s_axi        : std_logic := '0';
    signal dm_halt_frame            : std_logic := '0';    

begin



s_axis_fifo_ainit_nosync <= '1' when (s_axis_resetn = '0')
                           or (dm_halt_reg = '1')                          
                else '0';

m_axis_fifo_ainit_nosync <= '1' when (m_axis_resetn = '0')
                                or (dm_halt = '1')                                            
                else '0';                                                                     

s2mm_all_lines_xfred <=            s2mm_all_lines_xfred_i;



--*****************************************************************************--
--**              LINE BUFFER MODE (Sync or Async)                           **--
--*****************************************************************************--
GEN_LINEBUFFER : if C_LINEBUFFER_DEPTH /= 0 generate
begin

    -- Divide by number bytes per data beat and add padding to dynamic
    -- threshold setting
    data_count_af_threshold <= linebuf_threshold((DATACOUNT_WIDTH-1) + THRESHOLD_LSB_INDEX
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
                 SFIFO_Sinit             => s_axis_fifo_ainit_nosync   ,
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
                 SFIFO_Rd_count          => open                ,
                 SFIFO_Rd_count_minus1   => open                ,
                 SFIFO_Wr_count          => fifo_wrcount        ,
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
                 AFIFO_Ainit                => s_axis_fifo_ainit_nosync    ,
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
                 AFIFO_Wr_count             => fifo_wrcount         ,
                 AFIFO_Rd_count             => open                 ,
                 AFIFO_Corr_Rd_count        => open                 ,
                 AFIFO_Corr_Rd_count_minus1 => open                 ,
                 AFIFO_Rd_ack               => open
            );

     end generate GEN_ASYNC_FIFO;

    -- AXI Slave Side of FIFO
    fifo_din            <= s_axis_tlast_i & s_axis_tkeep_i & s_axis_tdata_i;
    fifo_wren           <= s_axis_tvalid_i and  s_axis_tready_i and not fifo_full_i;
    s_axis_tready_i     <= not fifo_full_i and not s_axis_fifo_ainit  ;

    -- AXI Master Side of FIFO
    fifo_rden           <= m_axis_tready and not fifo_empty_i;
    m_axis_tvalid_i     <= not fifo_empty_i;
    m_axis_tdata        <= fifo_dout(C_DATA_WIDTH-1 downto 0);
    m_axis_tkeep        <= fifo_dout(BUFFER_WIDTH-2 downto (BUFFER_WIDTH-2) - (C_DATA_WIDTH/8) + 1);
    m_axis_tlast_i      <= not fifo_empty_i and fifo_dout(BUFFER_WIDTH-1);


    m_axis_tlast    <= m_axis_tlast_i;
    m_axis_tvalid   <= m_axis_tvalid_i;

    -- Top level line buffer depth not equal to zero therefore gererate threshold
    -- flags. (CR625142)
    GEN_THRESHOLD_ENABLED : if C_TOPLVL_LINEBUFFER_DEPTH /= 0 generate
    begin
        -- Almost full flag
        -- This flag is only used by S2MM and the threshold has been adjusted to allow registering
        -- of the flag for timing and also to assert and deassert from an outside S2MM perspective
        REG_ALMST_FULL : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1')then
                        fifo_almost_full_i <= '0';
                    -- write count greater than or equal to threshold value therefore assert thresold flag
                    elsif(fifo_wrcount >= s_data_count_af_thresh or fifo_full_i='1') then
                        fifo_almost_full_i <= '1';
                    -- In all other cases de-assert flag
                    else
                        fifo_almost_full_i <= '0';
                    end if;
                end if;
            end process REG_ALMST_FULL;

        -- Drive fifo flags out if Linebuffer included
        s2mm_fifo_almost_full   <= fifo_almost_full_i or fifo_full_i;
        s2mm_fifo_full          <= fifo_full_i;

    end generate GEN_THRESHOLD_ENABLED;

    -- Top level line buffer depth is zero therefore turn off threshold logic.
    -- this occurs for async operation where the async fifo is needed for CDC (CR625142)
    GEN_THRESHOLD_DISABLED  : if C_TOPLVL_LINEBUFFER_DEPTH = 0 generate
    begin
        fifo_almost_full_i      <= '0';
        s2mm_fifo_almost_full   <= '0';
        s2mm_fifo_full          <= '0';
    end generate GEN_THRESHOLD_DISABLED;

    --*********************************************************--
    --**               S2MM SLAVE SKID BUFFER                **--
    --*********************************************************--
    I_MSTR_SKID : entity axi_vdma_v5_00_a.axi_vdma_skid_buf
        generic map(
            C_WDATA_WIDTH           => C_DATA_WIDTH		,
            C_TUSER_WIDTH           => C_S_AXIS_S2MM_TUSER_BITS

        )
        port map(
            -- System Ports
            ACLK                   => s_axis_aclk              ,
            ARST                   => s_axis_fifo_ainit        ,

            -- Shutdown control (assert for 1 clk pulse)
            skid_stop              => '0'                      ,

            -- Slave Side (Stream Data Input)
            S_VALID                => slv2skid_s_axis_tvalid   ,
            S_READY                => s_axis_tready_out        ,
            S_Data                 => s_axis_tdata             ,
            S_STRB                 => s_axis_tkeep             ,
            S_Last                 => s_axis_tlast             ,
            S_User                 => s_axis_tuser             ,

            -- Master Side (Stream Data Output)
            M_VALID                => s_axis_tvalid_i          ,
            M_READY                => s_axis_tready_i          ,
            M_Data                 => s_axis_tdata_i           ,
            M_STRB                 => s_axis_tkeep_i           ,
            M_Last                 => s_axis_tlast_i           ,
            M_User                 => s_axis_tuser_i
        );

    -- Pass out top level
    -- Qualify with channel ready to 'turn off' ready
    -- at end of video frame
    --s_axis_tready   <= s_axis_tready_out and not chnl_fsync ;
    s_axis_tready   <= s_axis_tready_out and chnl_ready and 
                       not stop_tready_s_axi ;

    -- Qualify with channel ready to 'turn off' writes to
    -- fifo at end of video frame
    slv2skid_s_axis_tvalid <= s_axis_tvalid and chnl_ready and 
                              not stop_tready_s_axi ;

    -- Generate start of frame fsync
    GEN_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 1 generate
    begin

        TUSER_RE_PROCESS : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1')then
                        s_axis_tuser_d1 <= '0';
                    else
                        s_axis_tuser_d1 <= s_axis_tuser_i(0) and s_axis_tvalid_i;
                    end if;
                end if;
            end process TUSER_RE_PROCESS;

        tuser_fsync <= s_axis_tuser_i(0) and s_axis_tvalid_i and not s_axis_tuser_d1;

    end generate GEN_SOF_FSYNC;

    -- Do not generate start of frame fsync
    GEN_NO_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 0 generate
    begin
        tuser_fsync <= '0';
    end generate GEN_NO_SOF_FSYNC;



end generate GEN_LINEBUFFER;

--*****************************************************************************--
--**               NO LINE BUFFER MODE (Sync Only)                           **--
--*****************************************************************************--
GEN_NO_LINEBUFFER : if (C_LINEBUFFER_DEPTH = 0) generate
begin

    m_axis_tdata        <= s_axis_tdata;
    m_axis_tkeep        <= s_axis_tkeep;
    m_axis_tvalid_i     <= s_axis_tvalid and chnl_ready and 
                           not stop_tready_s_axi;
    m_axis_tlast_i      <= s_axis_tlast;


    m_axis_tvalid       <= m_axis_tvalid_i;
    m_axis_tlast        <= m_axis_tlast_i;


    s_axis_tready_i     <= m_axis_tready and chnl_ready and 
                           not stop_tready_s_axi;
    s_axis_tready_out   <= m_axis_tready and chnl_ready and 
                           not stop_tready_s_axi;
    s_axis_tready       <= s_axis_tready_i;

    -- fifo signals not used
    s2mm_fifo_full          <= '0';
    s2mm_fifo_almost_full   <= '0';

    -- Generate start of frame fsync
    GEN_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 1 generate
    begin

        TUSER_RE_PROCESS : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1')then
                        s_axis_tuser_d1 <= '0';
                    else
                        s_axis_tuser_d1 <= s_axis_tuser_i(0) and s_axis_tvalid_i;
                    end if;
                end if;
            end process TUSER_RE_PROCESS;

        tuser_fsync <= s_axis_tuser_i(0) and s_axis_tvalid_i and not s_axis_tuser_d1;

    end generate GEN_SOF_FSYNC;

    -- Do not generate start of frame fsync
    GEN_NO_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 0 generate
    begin
        tuser_fsync <= '0';
    end generate GEN_NO_SOF_FSYNC;



end generate GEN_NO_LINEBUFFER;


-- Instantiate Clock Domain Crossing for Asynchronous clock
GEN_FOR_ASYNC : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
begin

    --*************************************************************************
    --** Line Tracking Logic
    --*************************************************************************
    -- Current VSIZE CDC
    PIPE_EMPTY_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
        generic map(
            C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,   -- CR591965
            C_VECTOR_WIDTH          => VSIZE_DWIDTH
        )
        port map (
            prmry_aclk              => m_axis_aclk                              ,
            prmry_resetn            => m_axis_resetn                            ,
            scndry_aclk             => s_axis_aclk                              ,
            scndry_resetn           => s_axis_resetn                            ,
            scndry_in               => '0'                                      ,   -- CR623449
            prmry_out               => open                                     ,   -- CR623449
            prmry_in                => '0'                                      ,
            scndry_out              => open                                     ,
            scndry_vect_s_h         => '0'                                      ,
            scndry_vect_in          => ZERO_VALUE_VECT(VSIZE_DWIDTH-1 downto 0) ,
            prmry_vect_out          => open                                     ,
            prmry_vect_s_h          => '1'                                      ,
            prmry_vect_in           => crnt_vsize                               ,
            scndry_vect_out         => crnt_vsize_d2
        );


        -- Cross datamover halt and fifo threshold to secondary for reset use
        STRM_WR_HALT_AND_THRESH_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => DATACOUNT_WIDTH
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => dm_halt                                  , -- CR591965
                scndry_out              => dm_halt_reg                              , -- CR591965
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(DATACOUNT_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => data_count_af_threshold                  ,
                scndry_vect_out         => s_data_count_af_thresh
            );


        -- CR623449 cross fsync_out back to primary
        FSYNC_OUT_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                scndry_in               => fsync_out                                ,
                prmry_out               => p_fsync_out                              ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );









        -- Cross tuser fsync to primary
        TUSER_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                scndry_in               => tuser_fsync                              ,
                prmry_out               => s2mm_tuser_fsync                         ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

 

       WR_PENDING_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => DATACOUNT_WIDTH
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                scndry_in               => strm_write_pending                       ,
                prmry_out               => strm_write_pending_m_axi                 ,
                prmry_in                => stop_tready                              , 
                scndry_out              => stop_tready_s_axi                        , 
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(DATACOUNT_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(DATACOUNT_WIDTH-1 downto 0)                  ,
                scndry_vect_out         => open
            );

   FIFO_SIDE_DM_HALT_REG : process(m_axis_aclk) is
   begin
        if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
            if(m_axis_resetn = '0' and p_fsync_out = '0')then
               dm_halt_frame <= '0';
            elsif (p_fsync_out = '1') then
               dm_halt_frame <= '0';
            elsif (dm_halt = '1') then
               dm_halt_frame <= '1';
            end if;
      end if;
   end process FIFO_SIDE_DM_HALT_REG;




end generate GEN_FOR_ASYNC;

-- Synchronous clock therefore just map signals across
GEN_FOR_SYNC : if C_PRMRY_IS_ACLK_ASYNC = 0 generate
begin
    crnt_vsize_d2               <= crnt_vsize;
    dm_halt_reg                 <= dm_halt;
    dm_halt_frame               <= dm_halt;
    p_fsync_out                 <= fsync_out;
    --s2mm_all_lines_xfred        <= all_lines_xfred;   -- CR591965/CR623449
    s_data_count_af_thresh      <= data_count_af_threshold;
    strm_write_pending_m_axi    <= strm_write_pending;
    stop_tready_s_axi           <= stop_tready;

end generate GEN_FOR_SYNC;

--*****************************************************************************
--** Vertical Line Tracking
--*****************************************************************************
-- Decrement vertical count with each accept tlast
decr_vcount <= '1' when s_axis_tlast = '1'
                    and s_axis_tvalid = '1'
                    and s_axis_tready_out = '1'
          else '0';


STRM_SIDE_SM: process (strm_write_cs,
                       fsync_out,
                       decr_vcount,
                       vsize_counter)is
begin
    
    strm_write_pending_sm <= '0';
    strm_write_ns <= strm_write_cs;
    
    case strm_write_cs is
    
    when STRM_WR_IDLE => 
                          if(fsync_out = '1') then
                               strm_write_ns <= STRM_WR_RUNNING;
                               strm_write_pending_sm <= '1';
                          end if;

    when STRM_WR_RUNNING => 
                          if (decr_vcount = '1' and 
                              vsize_counter = VSIZE_ONE_VALUE) then
                               strm_write_ns <= STRM_WR_IDLE;
                               strm_write_pending_sm <= '0';                          
                          elsif (decr_vcount = '1' and 
                                 vsize_counter = VSIZE_TWO_VALUE) then
                               strm_write_ns <= STRM_WR_LAST;
                          end if;
                          strm_write_pending_sm <= '1';
                                   
    when STRM_WR_LAST =>                             
                           if (decr_vcount = '1' ) then
                               strm_write_ns <= STRM_WR_IDLE;
                               strm_write_pending_sm <= '0';
                           end if;
                           strm_write_pending_sm <= '1';
    -- coverage off
     when others =>
                           strm_write_ns <= STRM_WR_IDLE;
    -- coverage on
    
    end case;
    
end process STRM_SIDE_SM;


   STRM_SIDE_SM_REG : process(s_axis_aclk) is
   begin
        if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
            if(s_axis_fifo_ainit_nosync = '1' and fsync_out = '0')then
               strm_write_cs <= STRM_WR_IDLE;
               strm_write_pending <= '0';
            else
               strm_write_cs <= strm_write_ns;
               strm_write_pending <= strm_write_pending_sm;
         end if;
      end if;
   end process STRM_SIDE_SM_REG;   

-- Drive ready at fsync out then de-assert once all lines have
-- been accepted.
GEN_NO_SOF_VCOUNT : if C_S2MM_SOF_ENABLE = 0 generate
begin

VERT_COUNTER : process(s_axis_aclk)
    begin
        if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
            if(s_axis_fifo_ainit = '1' and fsync_out = '0')then
                vsize_counter   <= (others => '0');
                chnl_ready      <= '0';
            elsif(fsync_out = '1')then
                vsize_counter   <= crnt_vsize_d2;
                chnl_ready      <= '1';
            elsif(decr_vcount = '1' and vsize_counter = VSIZE_ONE_VALUE)then
                vsize_counter   <= (others => '0');
                chnl_ready      <= '0';
            elsif(decr_vcount = '1' and vsize_counter /= VSIZE_ZERO_VALUE)then
                vsize_counter   <= std_logic_vector(unsigned(vsize_counter) - 1);
                chnl_ready      <= '1';
            end if;
        end if;
    end process VERT_COUNTER;

end generate GEN_NO_SOF_VCOUNT; 

GEN_SOF_VCOUNT : if C_S2MM_SOF_ENABLE = 1 generate
begin

VERT_COUNTER : process(s_axis_aclk)
    begin
        if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
            if(s_axis_fifo_ainit = '1' and fsync_out = '0')then
                vsize_counter   <= (others => '0');
            elsif(fsync_out = '1')then
                vsize_counter   <= crnt_vsize_d2;
            elsif(decr_vcount = '1' and vsize_counter = VSIZE_ONE_VALUE)then
                vsize_counter   <= (others => '0');
            elsif(decr_vcount = '1' and vsize_counter /= VSIZE_ZERO_VALUE)then
                vsize_counter   <= std_logic_vector(unsigned(vsize_counter) - 1);
            end if;
        end if;
    end process VERT_COUNTER;

    chnl_ready <= run_stop;

end generate GEN_SOF_VCOUNT; 



 -- decrement based on master axis signals for determining done (CR623449)
done_decr_vcount <= '1' when m_axis_tlast_i = '1'
                         and m_axis_tvalid_i = '1'
                         and m_axis_tready = '1'
          else '0';

-- CR623449 - base done on master clock domain
DONE_VERT_COUNTER : process(m_axis_aclk)
    begin
        if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
            if(m_axis_fifo_ainit_nosync = '1' and p_fsync_out = '0')then
                done_vsize_counter   <= (others => '0');
            elsif(load_counter = '1')then
                done_vsize_counter   <= crnt_vsize;
            elsif(done_decr_vcount = '1' and done_vsize_counter = VSIZE_ONE_VALUE)then
                done_vsize_counter   <= (others => '0');
            elsif(done_decr_vcount = '1' and done_vsize_counter /= VSIZE_ZERO_VALUE)then
                done_vsize_counter   <= std_logic_vector(unsigned(done_vsize_counter) - 1);
            end if;
        end if;
    end process DONE_VERT_COUNTER;

FIFO_SIDE_SM: process (fifo_read_cs,
                       done_decr_vcount,
                       p_fsync_out,
                       done_vsize_counter,
                       strm_write_pending_m_axi,
                       crnt_vsize)is
begin

    fifo_read_ns <= fifo_read_cs;
    load_counter_sm <= '0';
    fifo_rd_pending_sm <= '0';
    stop_tready_sm <= '0';

    case fifo_read_cs is
    
         when FIFO_RD_IDLE => 
                                  if(p_fsync_out = '1') then
                                        fifo_rd_pending_sm <= '1';
                                        load_counter_sm <= '1';
                                        if (crnt_vsize = VSIZE_ONE_VALUE) then
                                          fifo_read_ns <= FIFO_RD_LAST;
                                        else
                                          fifo_read_ns <= FIFO_RD_RUNNING;
                                        end if;                                        
                                  end if;                                      
         
         when FIFO_RD_RUNNING =>                                    
                                  if (p_fsync_out = '1') then                                  
                                          if (strm_write_pending_m_axi = '0') then
                                              stop_tready_sm <= '1';
                                          end if;
                                          if (done_decr_vcount = '1' and 
                                              done_vsize_counter = VSIZE_ONE_VALUE) then
				               fifo_read_ns <= FIFO_RD_FSYNC_LAST;
				          else
                                               fifo_read_ns <= FIFO_RD_FSYNC;
				          end if; 
                                  else
                                      if (done_decr_vcount = '1' and 
                                          done_vsize_counter = VSIZE_TWO_VALUE) then
                                          fifo_read_ns <= FIFO_RD_LAST;
                                      end if;
                                  end if;
                                  fifo_rd_pending_sm <= '1';                                
         
         when FIFO_RD_FSYNC =>    
                                  if (done_decr_vcount = '1' and 
                                      done_vsize_counter = VSIZE_TWO_VALUE) then
                                     fifo_read_ns <= FIFO_RD_FSYNC_LAST;
                                  end if;
                                  fifo_rd_pending_sm <= '1';
                                  stop_tready_sm <= '1';
         
         when FIFO_RD_FSYNC_LAST =>
                                  if (done_decr_vcount = '1' ) then
                                     fifo_read_ns <= FIFO_RD_RUNNING;
                                     load_counter_sm <= '1';
                                     stop_tready_sm <= '0';
                                  end if;
                                  fifo_rd_pending_sm <= '1';
                                  stop_tready_sm <= '1';
         
         when FIFO_RD_LAST =>     
                                  if (p_fsync_out = '1') then                                  
                                      if (strm_write_pending_m_axi = '0') then
                                          stop_tready_sm <= '1';
                                      end if;
                                      if (done_decr_vcount = '1' ) then
                                         fifo_read_ns <= FIFO_RD_RUNNING;
                                         load_counter_sm <= '1';
                                      else                                             
                                         fifo_read_ns <= FIFO_RD_FSYNC_LAST;                                             
                                      end if;  
                                  else                                 
                                      if (done_decr_vcount = '1' ) then
                                         fifo_read_ns <= FIFO_RD_IDLE;
                                         fifo_rd_pending_sm <= '0';                                     
                                      end if;
                                  end if;
                                  fifo_rd_pending_sm <= '1';
         
         
         -- coverage off
          when others =>
                                 fifo_read_ns <= FIFO_RD_IDLE;
         -- coverage on
    end case;
        
 end process FIFO_SIDE_SM;


   FIFO_SIDE_SM_REG : process(m_axis_aclk) is
   begin
        if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
            if((m_axis_fifo_ainit_nosync = '1' and p_fsync_out = '0' ) or 
                dm_halt_frame = '1')then
             fifo_read_cs <= FIFO_RD_IDLE;
             load_counter <= '0';
             fifo_rd_pending <= '0';
             stop_tready <= '0';
         else
             fifo_read_cs <= fifo_read_ns;
             load_counter <= load_counter_sm;
             fifo_rd_pending <= fifo_rd_pending_sm;
             stop_tready <= stop_tready_sm;
         end if;
      end if;
   end process FIFO_SIDE_SM_REG;
   

DONE_XFER_SIG : process(m_axis_aclk)
    begin
        if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
            if(m_axis_fifo_ainit_nosync = '1' and p_fsync_out = '0')then
                s2mm_all_lines_xfred_i <= '1';
            elsif(load_counter = '1' )then
                s2mm_all_lines_xfred_i <= '0';
            elsif(done_decr_vcount = '1' and done_vsize_counter = VSIZE_ONE_VALUE)then
                s2mm_all_lines_xfred_i <= '1';
            elsif(done_decr_vcount = '1' and done_vsize_counter /= VSIZE_ZERO_VALUE)then
                s2mm_all_lines_xfred_i <= '0';
            end if;
        end if;
    end process DONE_XFER_SIG;

   all_lasts_rcvd <= not strm_write_pending_m_axi;

end generate GEN_FSYNC_LOGIC;


--*****************************************************************************--
--**              USE FSYNC MODE                         **--
--*****************************************************************************--
GEN_NO_FSYNC_LOGIC : if ENABLE_FLUSH_ON_FSYNC = 0 generate
begin


--*****************************************************************************--

--*****************************************************************************--
--**              LINE BUFFER MODE (Sync or Async)                           **--
--*****************************************************************************--
GEN_LINEBUFFER : if C_LINEBUFFER_DEPTH /= 0 generate
begin

    -- Divide by number bytes per data beat and add padding to dynamic
    -- threshold setting
    data_count_af_threshold <= linebuf_threshold((DATACOUNT_WIDTH-1) + THRESHOLD_LSB_INDEX
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
                 SFIFO_Rd_count          => open                ,
                 SFIFO_Rd_count_minus1   => open                ,
                 SFIFO_Wr_count          => fifo_wrcount        ,
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
                 AFIFO_Wr_count             => fifo_wrcount         ,
                 AFIFO_Rd_count             => open                 ,
                 AFIFO_Corr_Rd_count        => open                 ,
                 AFIFO_Corr_Rd_count_minus1 => open                 ,
                 AFIFO_Rd_ack               => open
            );

     end generate GEN_ASYNC_FIFO;

    -- AXI Slave Side of FIFO
    fifo_din            <= s_axis_tlast_i & s_axis_tkeep_i & s_axis_tdata_i;
    fifo_wren           <= s_axis_tvalid_i and not fifo_full_i;
    s_axis_tready_i     <= not fifo_full_i and not s_axis_fifo_ainit;

    -- AXI Master Side of FIFO
    fifo_rden           <= m_axis_tready and not fifo_empty_i;
    m_axis_tvalid_i     <= not fifo_empty_i;
    m_axis_tdata        <= fifo_dout(C_DATA_WIDTH-1 downto 0);
    m_axis_tkeep        <= fifo_dout(BUFFER_WIDTH-2 downto (BUFFER_WIDTH-2) - (C_DATA_WIDTH/8) + 1);
    m_axis_tlast_i      <= not fifo_empty_i and fifo_dout(BUFFER_WIDTH-1);


    m_axis_tlast    <= m_axis_tlast_i;
    m_axis_tvalid   <= m_axis_tvalid_i;

    -- Generate start of frame fsync
    GEN_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 1 generate
    begin

        TUSER_RE_PROCESS : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1')then
                        s_axis_tuser_d1 <= '0';
                    else
                        s_axis_tuser_d1 <= s_axis_tuser_i(0) and s_axis_tvalid_i;
                    end if;
                end if;
            end process TUSER_RE_PROCESS;

        tuser_fsync <= s_axis_tuser_i(0) and s_axis_tvalid_i and not s_axis_tuser_d1;

    end generate GEN_SOF_FSYNC;

    -- Do not generate start of frame fsync
    GEN_NO_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 0 generate
    begin
        tuser_fsync <= '0';
    end generate GEN_NO_SOF_FSYNC;

    -- Top level line buffer depth not equal to zero therefore gererate threshold
    -- flags. (CR625142)
    GEN_THRESHOLD_ENABLED : if C_TOPLVL_LINEBUFFER_DEPTH /= 0 generate
    begin
        -- Almost full flag
        -- This flag is only used by S2MM and the threshold has been adjusted to allow registering
        -- of the flag for timing and also to assert and deassert from an outside S2MM perspective
        REG_ALMST_FULL : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1')then
                        fifo_almost_full_i <= '0';
                    -- write count greater than or equal to threshold value therefore assert thresold flag
                    elsif(fifo_wrcount >= s_data_count_af_thresh or fifo_full_i='1') then
                        fifo_almost_full_i <= '1';
                    -- In all other cases de-assert flag
                    else
                        fifo_almost_full_i <= '0';
                    end if;
                end if;
            end process REG_ALMST_FULL;

        -- Drive fifo flags out if Linebuffer included
        s2mm_fifo_almost_full   <= fifo_almost_full_i or fifo_full_i;
        s2mm_fifo_full          <= fifo_full_i;

    end generate GEN_THRESHOLD_ENABLED;

    -- Top level line buffer depth is zero therefore turn off threshold logic.
    -- this occurs for async operation where the async fifo is needed for CDC (CR625142)
    GEN_THRESHOLD_DISABLED  : if C_TOPLVL_LINEBUFFER_DEPTH = 0 generate
    begin
        fifo_almost_full_i      <= '0';
        s2mm_fifo_almost_full   <= '0';
        s2mm_fifo_full          <= '0';
    end generate GEN_THRESHOLD_DISABLED;
    --*********************************************************--
    --**               S2MM SLAVE SKID BUFFER                **--
    --*********************************************************--
    I_MSTR_SKID : entity axi_vdma_v5_00_a.axi_vdma_skid_buf
        generic map(
            C_WDATA_WIDTH           => C_DATA_WIDTH             ,
            C_TUSER_WIDTH           => C_S_AXIS_S2MM_TUSER_BITS
        )
        port map(
            -- System Ports
            ACLK                   => s_axis_aclk              ,
            ARST                   => s_axis_fifo_ainit        ,

            -- Shutdown control (assert for 1 clk pulse)
            skid_stop              => '0'                      ,

            -- Slave Side (Stream Data Input)
            S_VALID                => slv2skid_s_axis_tvalid   ,
            S_READY                => s_axis_tready_out        ,
            S_Data                 => s_axis_tdata             ,
            S_STRB                 => s_axis_tkeep             ,
            S_Last                 => s_axis_tlast             ,
            S_User                 => s_axis_tuser             ,

            -- Master Side (Stream Data Output)
            M_VALID                => s_axis_tvalid_i          ,
            M_READY                => s_axis_tready_i          ,
            M_Data                 => s_axis_tdata_i           ,
            M_STRB                 => s_axis_tkeep_i           ,
            M_Last                 => s_axis_tlast_i           ,
            M_User                 => s_axis_tuser_i
        );

    -- Pass out top level
    -- Qualify with channel ready to 'turn off' ready
    -- at end of video frame
    s_axis_tready   <= s_axis_tready_out and chnl_ready;


    -- Qualify with channel ready to 'turn off' writes to
    -- fifo at end of video frame
    slv2skid_s_axis_tvalid <= s_axis_tvalid and chnl_ready;


end generate GEN_LINEBUFFER;

--*****************************************************************************--
--**               NO LINE BUFFER MODE (Sync Only)                           **--
--*****************************************************************************--
GEN_NO_LINEBUFFER : if (C_LINEBUFFER_DEPTH = 0) generate
begin

    m_axis_tdata        <= s_axis_tdata;
    m_axis_tkeep        <= s_axis_tkeep;
    m_axis_tvalid_i     <= s_axis_tvalid and chnl_ready;
    m_axis_tlast_i      <= s_axis_tlast;


    m_axis_tvalid   <= m_axis_tvalid_i;
    m_axis_tlast    <= m_axis_tlast_i;


    s_axis_tready_i     <= m_axis_tready and chnl_ready;
    s_axis_tready_out   <= m_axis_tready and chnl_ready;
    s_axis_tready       <= s_axis_tready_i;

    -- fifo signals not used
    s2mm_fifo_full          <= '0';
    s2mm_fifo_almost_full   <= '0';


    -- Generate start of frame fsync
    GEN_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 1 generate
    begin

        TUSER_RE_PROCESS : process(s_axis_aclk)
            begin
                if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
                    if(s_axis_fifo_ainit = '1')then
                        s_axis_tuser_d1 <= '0';
                    else
                        s_axis_tuser_d1 <= s_axis_tuser_i(0) and s_axis_tvalid_i;
                    end if;
                end if;
            end process TUSER_RE_PROCESS;

        tuser_fsync <= s_axis_tuser_i(0) and s_axis_tvalid_i and not s_axis_tuser_d1;

    end generate GEN_SOF_FSYNC;

    -- Do not generate start of frame fsync
    GEN_NO_SOF_FSYNC : if C_S2MM_SOF_ENABLE = 0 generate
    begin
        tuser_fsync <= '0';
    end generate GEN_NO_SOF_FSYNC;


end generate GEN_NO_LINEBUFFER;


-- Instantiate Clock Domain Crossing for Asynchronous clock
GEN_FOR_ASYNC : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
begin

    --*************************************************************************
    --** Line Tracking Logic
    --*************************************************************************
    -- Current VSIZE CDC
    PIPE_EMPTY_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
        generic map(
            C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,   -- CR591965
            C_VECTOR_WIDTH          => VSIZE_DWIDTH
        )
        port map (
            prmry_aclk              => m_axis_aclk                              ,
            prmry_resetn            => m_axis_resetn                            ,
            scndry_aclk             => s_axis_aclk                              ,
            scndry_resetn           => s_axis_resetn                            ,
            scndry_in               => '0'                                      ,   -- CR623449
            prmry_out               => open                                     ,   -- CR623449
            prmry_in                => '0'                                      ,
            scndry_out              => open                                     ,
            scndry_vect_s_h         => '0'                                      ,
            scndry_vect_in          => ZERO_VALUE_VECT(VSIZE_DWIDTH-1 downto 0) ,
            prmry_vect_out          => open                                     ,
            prmry_vect_s_h          => '1'                                      ,
            prmry_vect_in           => crnt_vsize                               ,
            scndry_vect_out         => crnt_vsize_d2
        );


        -- Cross datamover halt and fifo threshold to secondary for reset use
        DM_HALT_AND_THRESH_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => DATACOUNT_WIDTH
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                --scndry_in               => fsync_out                                ,
                scndry_in               => '0'                                ,
                --prmry_out               => p_fsync_out                              ,
                prmry_out               => open                              ,
                prmry_in                => dm_halt                                  , -- CR591965
                scndry_out              => dm_halt_reg                              , -- CR591965
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(DATACOUNT_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => data_count_af_threshold                  ,
                scndry_vect_out         => s_data_count_af_thresh
            );


        -- CR623449 cross fsync_out back to primary
        FSYNC_OUT_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                scndry_in               => fsync_out                                ,
                prmry_out               => p_fsync_out                              ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- Cross tuser fsync to primary
        TUSER_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axis_aclk                              ,
                prmry_resetn            => m_axis_resetn                            ,
                scndry_aclk             => s_axis_aclk                              ,
                scndry_resetn           => s_axis_resetn                            ,
                scndry_in               => tuser_fsync                              ,
                prmry_out               => s2mm_tuser_fsync                         ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

end generate GEN_FOR_ASYNC;

-- Synchronous clock therefore just map signals across
GEN_FOR_SYNC : if C_PRMRY_IS_ACLK_ASYNC = 0 generate
begin
    crnt_vsize_d2               <= crnt_vsize;
    dm_halt_reg                 <= dm_halt;
    p_fsync_out                 <= fsync_out;
    s2mm_tuser_fsync            <= tuser_fsync;
    s_data_count_af_thresh      <= data_count_af_threshold;

end generate GEN_FOR_SYNC;

--*****************************************************************************
--** Vertical Line Tracking
--*****************************************************************************

-- Generate vertical size counter for case when SOF not used
GEN_NO_SOF_VCOUNT : if C_S2MM_SOF_ENABLE = 0 generate
begin

    -- Decrement vertical count with each accept tlast
    decr_vcount <= '1' when s_axis_tlast = '1'
                        and s_axis_tvalid = '1'
                        and s_axis_tready_out = '1'
              else '0';

    -- Drive ready at fsync out then de-assert once all lines have
    -- been accepted.
    VERT_COUNTER : process(s_axis_aclk)
        begin
            if(s_axis_aclk'EVENT and s_axis_aclk = '1')then
            if(s_axis_fifo_ainit = '1' and fsync_out = '0')then
                    vsize_counter   <= (others => '0');
                    chnl_ready      <= '0';
                elsif(fsync_out = '1')then
                    vsize_counter   <= crnt_vsize_d2;
                    chnl_ready      <= '1';
                elsif(decr_vcount = '1' and vsize_counter = VSIZE_ONE_VALUE)then
                    vsize_counter   <= (others => '0');
                    chnl_ready      <= '0';
                elsif(decr_vcount = '1' and vsize_counter /= VSIZE_ZERO_VALUE)then
                    vsize_counter   <= std_logic_vector(unsigned(vsize_counter) - 1);
                    chnl_ready      <= '1';
                end if;
            end if;
        end process VERT_COUNTER;

    -- decrement based on master axis signals for determining done (CR623449)
    done_decr_vcount <= '1' when m_axis_tlast_i = '1'
                             and m_axis_tvalid_i = '1'
                             and m_axis_tready = '1'
              else '0';


    -- CR623449 - base done on master clock domain
    DONE_VERT_COUNTER : process(m_axis_aclk)
        begin
            if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
                if(m_axis_fifo_ainit = '1' and p_fsync_out = '0')then
                    done_vsize_counter   <= (others => '0');
                    s2mm_all_lines_xfred_i <= '1';
                elsif(p_fsync_out = '1')then
                    done_vsize_counter   <= crnt_vsize;
                    s2mm_all_lines_xfred_i <= '0';

                elsif(done_decr_vcount = '1' and done_vsize_counter = VSIZE_ONE_VALUE)then
                    done_vsize_counter   <= (others => '0');
                    s2mm_all_lines_xfred_i <= '1';

                elsif(done_decr_vcount = '1' and done_vsize_counter /= VSIZE_ZERO_VALUE)then
                    done_vsize_counter   <= std_logic_vector(unsigned(done_vsize_counter) - 1);
                    s2mm_all_lines_xfred_i <= '0';

                end if;
            end if;
        end process DONE_VERT_COUNTER;



end generate GEN_NO_SOF_VCOUNT;



-- Generate vertical size counter for case when SOF is used
GEN_SOF_VCOUNT : if C_S2MM_SOF_ENABLE = 1 generate
begin

    chnl_ready <= run_stop;

    -- decrement based on master axis signals for determining done (CR623449)
    done_decr_vcount <= '1' when m_axis_tlast_i = '1'
                             and m_axis_tvalid_i = '1'
                             and m_axis_tready = '1'
              else '0';


    -- CR623449 - base done on master clock domain
    DONE_VERT_COUNTER : process(m_axis_aclk)
        begin
            if(m_axis_aclk'EVENT and m_axis_aclk = '1')then
                if(m_axis_fifo_ainit = '1' and p_fsync_out = '0')then
                    done_vsize_counter   <= (others => '0');
                    s2mm_all_lines_xfred_i <= '1';
                elsif(p_fsync_out = '1')then
                    done_vsize_counter   <= crnt_vsize;
                    s2mm_all_lines_xfred_i <= '0';

                elsif(done_decr_vcount = '1' and done_vsize_counter = VSIZE_ONE_VALUE)then
                    done_vsize_counter   <= (others => '0');
                    s2mm_all_lines_xfred_i <= '1';

                elsif(done_decr_vcount = '1' and done_vsize_counter /= VSIZE_ZERO_VALUE)then
                    done_vsize_counter   <= std_logic_vector(unsigned(done_vsize_counter) - 1);
                    s2mm_all_lines_xfred_i <= '0';

                end if;
            end if;
        end process DONE_VERT_COUNTER;


end generate GEN_SOF_VCOUNT;



s2mm_all_lines_xfred <= s2mm_all_lines_xfred_i;
all_lasts_rcvd <= s2mm_all_lines_xfred_i;

end generate GEN_NO_FSYNC_LOGIC;






end implementation;
