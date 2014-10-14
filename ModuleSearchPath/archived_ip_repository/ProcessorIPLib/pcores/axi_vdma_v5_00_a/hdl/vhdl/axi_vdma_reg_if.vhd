-------------------------------------------------------------------------------
-- axi_vdma_reg_if
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
-- Filename:          axi_vdma_reg_if.vhd
-- Description: This entity is AXI VDMA Register Interface Top Level
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
--  GAB     6/28/11    v4_00_a
-- ^^^^^^
--  - Initial Release
-- ~~~~~~
--  GAB     8/10/11    v4_00_a
-- ^^^^^^
--  CR620124 - fixed issue with wr timing
--  CR619743 - fixed issue with read valid not asserting on missed addresses
-- ~~~~~~
--  GAB     8/19/11     v5_00_a
-- ^^^^^^
--  Intial release of v5_00_a
--  Added fsync on tuser(0) feature
--  Added fsync crossbar feature
--  Increased Frame Stores to 32
--  Added internal GenLock Option
-- ~~~~~~
--  GAB     8/31/11    v5_00_a
-- ^^^^^^
--  CR623593 - needed a pipeline delay in each domain for mm2s only and s2mm
--             only cases for writes to prevent cdc pulse freq violations
-- ~~~~~~
--  GAB     9/9/11    v5_00_a
-- ^^^^^^
--  CR624739 - needed a pipeline delay in each domain for mm2s and s2mm case
--             for writes to prevent cdc pulse freq violations
-- ~~~~~~
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library axi_vdma_v5_00_a;
use axi_vdma_v5_00_a.axi_vdma_pkg.all;

-------------------------------------------------------------------------------
entity  axi_vdma_reg_if is
    generic(
        C_INCLUDE_MM2S              : integer range 0 to 1      := 1;
            -- Include or exclude MM2S channel
            -- 0 = exclude mm2s channel
            -- 1 = include mm2s channel

        C_INCLUDE_S2MM              : integer range 0 to 1      := 1;
            -- Include or exclude S2MM channel
            -- 0 = exclude s2mm channel
            -- 1 = include s2mm channel

        C_INCLUDE_SG                    : integer range 0 to 1   := 1;
            -- Include or Exclude Scatter Gather Engine
            -- 0 = Exclude Scatter Gather Engine (Enables Register Direct Mode)
            -- 1 = Include Scatter Gather Engine

        C_ENABLE_VIDPRMTR_READS         : integer range 0 to 1   := 1;
            -- Specifies whether video parameters are readable by axi_lite interface
            -- when configure for Register Direct Mode
            -- 0 = Disable Video Parameter Reads (Saves FPGA Resources)
            -- 1 = Enable Video Parameter Reads

        C_TOTAL_NUM_REGISTER            : integer                := 8;
            -- Number of register CE's

        C_PRMRY_IS_ACLK_ASYNC         : integer range 0 to 1     := 0;
            -- Specifies the AXI Lite clock is asynchronous
            -- 0 = AXI Clocks are Asynchronous
            -- 1 = AXI Clocks are Synchronous

        C_S_AXI_LITE_ADDR_WIDTH     : integer range 32 to 32    := 32;
            -- AXI Lite interface address width

        C_S_AXI_LITE_DATA_WIDTH     : integer range 32 to 32    := 32;
            -- AXI Lite interface data width

        C_VERSION_MAJOR             : std_logic_vector (3 downto 0) := X"1" ;
            -- Major Version number 0, 1, 2, 3 etc.

        C_VERSION_MINOR             : std_logic_vector (7 downto 0) := X"00";
            -- Minor Version Number 00, 01, 02, etc.

        C_VERSION_REVISION          : std_logic_vector (3 downto 0) := X"a" ;
            -- Version Revision character (EDK) a,b,c,etc

        C_REVISION_NUMBER           : string := "Build Number: 0000"
            -- Internal build number
    );
    port (
        -----------------------------------------------------------------------
        -- AXI Lite Control Interface
        -----------------------------------------------------------------------
        s_axi_lite_aclk             : in  std_logic                                 ;       --
        s_axi_lite_reset_n          : in  std_logic                                 ;       --
                                                                                            --
        -- AXI Lite Write Address Channel                                                   --
        s_axi_lite_awvalid          : in  std_logic                                 ;       --
        s_axi_lite_awready          : out std_logic                                 ;       --
        s_axi_lite_awaddr           : in  std_logic_vector                                  --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)        ;       --
                                                                                            --
        -- AXI Lite Write Data Channel                                                      --
        s_axi_lite_wvalid           : in  std_logic                                 ;       --
        s_axi_lite_wready           : out std_logic                                 ;       --
        s_axi_lite_wdata            : in  std_logic_vector                                  --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)        ;       --
                                                                                            --
        -- AXI Lite Write Response Channel                                                  --
        s_axi_lite_bresp            : out std_logic_vector(1 downto 0)              ;       --
        s_axi_lite_bvalid           : out std_logic                                 ;       --
        s_axi_lite_bready           : in  std_logic                                 ;       --
                                                                                            --
        -- AXI Lite Read Address Channel                                                    --
        s_axi_lite_arvalid          : in  std_logic                                 ;       --
        s_axi_lite_arready          : out std_logic                                 ;       --
        s_axi_lite_araddr           : in  std_logic_vector                                  --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)        ;       --
        s_axi_lite_rvalid           : out std_logic                                 ;       --
        s_axi_lite_rready           : in  std_logic                                 ;       --
        s_axi_lite_rdata            : out std_logic_vector                                  --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)        ;       --
        s_axi_lite_rresp            : out std_logic_vector(1 downto 0)              ;       --
                                                                                            --
                                                                                            --
        -- MM2S Register Interface                                                          --
        m_axi_mm2s_aclk             : in  std_logic                                 ;       --
        mm2s_hrd_resetn             : in  std_logic                                 ;       --
        mm2s_axi2ip_wrce            : out  std_logic_vector                                 --
                                        (C_TOTAL_NUM_REGISTER-1 downto 0)           ;       --
        mm2s_axi2ip_wrdata          : out  std_logic_vector                                 --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)        ;       --
        mm2s_axi2ip_rdaddr          : out std_logic_vector                                  --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)        ;       --
        mm2s_axi2ip_rden            : out std_logic                                 ;       --
        mm2s_ip2axi_rddata          : in  std_logic_vector                                  --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)        ;       --
        mm2s_ip2axi_rddata_valid    : in  std_logic                                 ;       --
        mm2s_ip2axi_frame_ptr_ref   : in  std_logic_vector                                  --
                                        (FRAME_NUMBER_WIDTH-1 downto 0)             ;       --
        mm2s_ip2axi_frame_store     : in  std_logic_vector                                  --
                                        (FRAME_NUMBER_WIDTH-1 downto 0)             ;       --
        mm2s_ip2axi_introut         : in  std_logic                                 ;       --
                                                                                            --
                                                                                            --
        -- S2MM Register Interface                                                          --
        m_axi_s2mm_aclk             : in  std_logic                                 ;       --
        s2mm_hrd_resetn             : in  std_logic                                 ;       --
        s2mm_axi2ip_wrce            : out std_logic_vector                                  --
                                        (C_TOTAL_NUM_REGISTER-1 downto 0)           ;       --
        s2mm_axi2ip_wrdata          : out std_logic_vector                                  --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)        ;       --
                                                                                            --
        s2mm_axi2ip_rden            : out std_logic                                 ;       --
        s2mm_axi2ip_rdaddr          : out std_logic_vector                                  --
                                        (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)        ;       --
        s2mm_ip2axi_rddata          : in  std_logic_vector                                  --
                                        (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)        ;       --
        s2mm_ip2axi_rddata_valid    : in  std_logic                                 ;       --
        s2mm_ip2axi_frame_ptr_ref   : in  std_logic_vector                                  --
                                        (FRAME_NUMBER_WIDTH-1 downto 0)             ;       --
        s2mm_ip2axi_frame_store     : in  std_logic_vector                                  --
                                        (FRAME_NUMBER_WIDTH-1 downto 0)             ;       --
        s2mm_ip2axi_introut         : in  std_logic                                 ;       --
                                                                                            --
        -- Interrupt Out                                                                    --
        mm2s_introut                : out std_logic                                 ;       --
        s2mm_introut                : out std_logic                                         --


    );
end axi_vdma_reg_if;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma_reg_if is

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------
constant AXI_LITE_SYNC      : integer := 0;

constant ZERO_VALUE_VECT    : std_logic_vector(128 downto 0) := (others => '0');

-- PARK_PTR_REF Register constants
constant PARK_PAD_WIDTH     : integer := (C_S_AXI_LITE_DATA_WIDTH - (FRAME_NUMBER_WIDTH * 4))/4;
constant PARK_REG_PAD       : std_logic_vector(PARK_PAD_WIDTH-1 downto 0) := (others => '0');




-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
signal axi2ip_wren                  : std_logic := '0';
signal axi2ip_wrce                  : std_logic_vector(C_TOTAL_NUM_REGISTER - 1 downto 0)   := (others => '0');
signal axi2ip_wrdata                : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal axi2ip_rden                  : std_logic := '0';
signal axi2ip_rdce                  : std_logic_vector(C_TOTAL_NUM_REGISTER - 1 downto 0)   := (others => '0');
signal axi2ip_rdaddr                : std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)  := (others => '0');
signal ip2axi_rddata                : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal ip2axi_rdata_valid           : std_logic := '0';
signal read_mux_select              : std_logic_vector(3 downto 0) := (others => '0');
signal axi2ip_wraddr                : std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0); -- CR620124
signal ip2axi_wrack                 : std_logic := '0'; -- CR620124

-- version signals
signal rev_num                      : integer := string2int(C_REVISION_NUMBER);
signal vdma_version_i               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0) := (others => '0');
signal park_ptr_ref_i               : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0) := (others => '0');

signal mm2s_rddata                  : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal mm2s_rddata_valid            : std_logic := '0';
signal mm2s_frame_ptr_ref           : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal mm2s_frame_store             : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal mm2s_axi2ip_rden_i           : std_logic := '0';

signal s2mm_rddata                  : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0)  := (others => '0');
signal s2mm_rddata_valid            : std_logic := '0';
signal s2mm_frame_ptr_ref           : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_frame_store             : std_logic_vector(FRAME_NUMBER_WIDTH-1 downto 0) := (others => '0');
signal s2mm_axi2ip_rden_i           : std_logic := '0';

-- missed rd wr support
signal delayed_s2mm_axi2ip_rden     : std_logic := '0';
signal delayed_mm2s_axi2ip_rden     : std_logic := '0';
signal delayed_lite_axi2ip_rden     : std_logic := '0';
signal delayed_rden                 : std_logic := '0';
signal delayed_s2mm_axi2ip_wren     : std_logic := '0';
signal delayed_mm2s_axi2ip_wren     : std_logic := '0';
signal delayed_wren                 : std_logic := '0';

signal delay_rden                   : std_logic := '0';
signal delay_wren                   : std_logic := '0';

signal s_h_mm2s_rddata_valid        : std_logic := '0';
signal s_h_s2mm_rddata_valid        : std_logic := '0';

signal delayed_mm2s_axi2ip_wren_d1  : std_logic := '0'; -- CR623593
signal delayed_s2mm_axi2ip_wren_d1  : std_logic := '0'; -- CR623593
signal delayed_lite_axi2ip_wren     : std_logic := '0'; -- CR623593


-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin

mm2s_axi2ip_rden    <= mm2s_axi2ip_rden_i;
s2mm_axi2ip_rden    <= s2mm_axi2ip_rden_i;

-------------------------------------------------------------------------------
-- Generate AXI Lite Inteface
-------------------------------------------------------------------------------
GEN_AXI_LITE_IF : if C_INCLUDE_MM2S = 1 or C_INCLUDE_S2MM = 1 generate
begin
    AXI_LITE_IF_I : entity axi_vdma_v5_00_a.axi_vdma_lite_if
        generic map(
            C_NUM_CE                    => C_TOTAL_NUM_REGISTER     ,
            C_S_AXI_LITE_ADDR_WIDTH     => C_S_AXI_LITE_ADDR_WIDTH  ,
            C_S_AXI_LITE_DATA_WIDTH     => C_S_AXI_LITE_DATA_WIDTH
        )
        port map(
            s_axi_lite_aclk             => s_axi_lite_aclk          ,
            s_axi_lite_aresetn          => s_axi_lite_reset_n       ,

            -- AXI Lite Write Address Channel
            s_axi_lite_awvalid          => s_axi_lite_awvalid       ,
            s_axi_lite_awready          => s_axi_lite_awready       ,
            s_axi_lite_awaddr           => s_axi_lite_awaddr        ,

            -- AXI Lite Write Data Channel
            s_axi_lite_wvalid           => s_axi_lite_wvalid        ,
            s_axi_lite_wready           => s_axi_lite_wready        ,
            s_axi_lite_wdata            => s_axi_lite_wdata         ,

            -- AXI Lite Write Response Channel
            s_axi_lite_bresp            => s_axi_lite_bresp         ,
            s_axi_lite_bvalid           => s_axi_lite_bvalid        ,
            s_axi_lite_bready           => s_axi_lite_bready        ,

            -- AXI Lite Read Address Channel
            s_axi_lite_arvalid          => s_axi_lite_arvalid       ,
            s_axi_lite_arready          => s_axi_lite_arready       ,
            s_axi_lite_araddr           => s_axi_lite_araddr        ,
            s_axi_lite_rvalid           => s_axi_lite_rvalid        ,
            s_axi_lite_rready           => s_axi_lite_rready        ,
            s_axi_lite_rdata            => s_axi_lite_rdata         ,
            s_axi_lite_rresp            => s_axi_lite_rresp         ,

            -- User IP Interface
            axi2ip_wren                 => axi2ip_wren              ,
            axi2ip_wrce                 => axi2ip_wrce              ,
            axi2ip_wrdata               => axi2ip_wrdata            ,
            axi2ip_wraddr               => axi2ip_wraddr            , -- CR620124
            ip2axi_wrack                => ip2axi_wrack             , -- CR620124
            axi2ip_rdce                 => axi2ip_rdce              ,
            axi2ip_rden                 => axi2ip_rden              ,
            axi2ip_rdaddr               => axi2ip_rdaddr            ,
            ip2axi_rdata_valid          => ip2axi_rdata_valid       ,
            ip2axi_rddata               => ip2axi_rddata

        );
end generate GEN_AXI_LITE_IF;

-------------------------------------------------------------------------------
-- No channels therefore do not generate an AXI Lite interface
-------------------------------------------------------------------------------
GEN_NO_AXI_LITE_IF : if C_INCLUDE_MM2S = 0 and C_INCLUDE_S2MM = 0 generate
begin
    s_axi_lite_awready          <= '0';
    s_axi_lite_wready           <= '0';
    s_axi_lite_bresp            <= (others => '0');
    s_axi_lite_bvalid           <= '0';
    s_axi_lite_arready          <= '0';
    s_axi_lite_rvalid           <= '0';
    s_axi_lite_rdata            <= (others => '0');
    s_axi_lite_rresp            <= (others => '0');

end generate GEN_NO_AXI_LITE_IF;

-------------------------------------------------------------------------------
-- Generate MM2S Registers if included
-------------------------------------------------------------------------------
GEN_MM2S_REGISTERS : if C_INCLUDE_MM2S = 1 generate
begin
    GEN_MM2S_REGIF_FOR_SYNC : if C_PRMRY_IS_ACLK_ASYNC = 0 generate

        -- To MM2S Register Module
        mm2s_axi2ip_wrce    <= axi2ip_wrce;
        mm2s_axi2ip_wrdata  <= axi2ip_wrdata;
        mm2s_axi2ip_rden_i  <= axi2ip_rden;
        mm2s_axi2ip_rdaddr  <= axi2ip_rdaddr;

        -- From MM2S Register Module
        mm2s_rddata_valid   <= mm2s_ip2axi_rddata_valid;
        mm2s_rddata         <= mm2s_ip2axi_rddata;
        mm2s_frame_ptr_ref  <= mm2s_ip2axi_frame_ptr_ref;
        mm2s_frame_store    <= mm2s_ip2axi_frame_store;

        mm2s_introut            <= mm2s_ip2axi_introut;
        s_h_mm2s_rddata_valid   <= mm2s_ip2axi_rddata_valid;

    end generate GEN_MM2S_REGIF_FOR_SYNC;

    GEN_MM2S_REGIF_FOR_ASYNC : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
    begin
        GEN_MM2S_WRITE_CE : for i in C_TOTAL_NUM_REGISTER-1 downto 0 generate
            MM2S_WRITE_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
                generic map(
                    C_CDC_TYPE              => CDC_TYPE_PULSE                       ,
                    C_VECTOR_WIDTH          => 1
                )
                port map (
                    prmry_aclk              => m_axi_mm2s_aclk                      ,
                    prmry_resetn            => mm2s_hrd_resetn                      ,
                    scndry_aclk             => s_axi_lite_aclk                      ,
                    scndry_resetn           => s_axi_lite_reset_n                   ,
                    scndry_in               => axi2ip_wrce(i)                       ,
                    prmry_out               => mm2s_axi2ip_wrce(i)                  ,
                    prmry_in                => '0'                                  ,
                    scndry_out              => open                                 ,
                    scndry_vect_s_h         => '0'                                  ,
                    scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)          ,
                    prmry_vect_out          => open                                 ,
                    prmry_vect_s_h          => '0'                                  ,
                    prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)          ,
                    scndry_vect_out         => open
                );
        end generate GEN_MM2S_WRITE_CE;


        MM2S_WRDATA_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => C_S_AXI_LITE_DATA_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => axi2ip_wren                              ,
                scndry_vect_in          => axi2ip_wrdata                            ,
                prmry_vect_out          => mm2s_axi2ip_wrdata                       ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT
                                            (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)    ,
                scndry_vect_out         => open
            );


        MM2S_RDADDR_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => C_S_AXI_LITE_ADDR_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => axi2ip_rden                              ,
                prmry_out               => mm2s_axi2ip_rden_i                       ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => axi2ip_rden                              ,
                scndry_vect_in          => axi2ip_rdaddr                            ,
                prmry_vect_out          => mm2s_axi2ip_rdaddr                       ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT
                                            (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)    ,
                scndry_vect_out         => open
            );

        MM2S_RDDATA_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => C_S_AXI_LITE_DATA_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => mm2s_ip2axi_rddata_valid                 ,
                scndry_out              => mm2s_rddata_valid                        ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT
                                            (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)    ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => mm2s_ip2axi_rddata_valid                  ,
                prmry_vect_in           => mm2s_ip2axi_rddata                       ,
                scndry_vect_out         => mm2s_rddata
            );

        MM2S_FRAME_PTR_CDC : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => FRAME_NUMBER_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => '1'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(FRAME_NUMBER_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => mm2s_ip2axi_frame_ptr_ref                ,
                scndry_vect_out         => mm2s_frame_ptr_ref
            );

        MM2S_FRAME_STORE_CDC : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => FRAME_NUMBER_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => mm2s_ip2axi_introut                      ,
                scndry_out              => mm2s_introut                             ,
                scndry_vect_s_h         => '1'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(FRAME_NUMBER_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => mm2s_ip2axi_frame_store                  ,
                scndry_vect_out         => mm2s_frame_store
            );

        -- Sample and Hold MM2S Data
        REG_MM2S_RDDATA : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n ='0' or delayed_rden = '1')then

                        s_h_mm2s_rddata_valid   <= '0';
                    elsif(mm2s_rddata_valid = '1')then
                        s_h_mm2s_rddata_valid   <= '1';
                    end if;
                end if;
            end process REG_MM2S_RDDATA;

    end generate GEN_MM2S_REGIF_FOR_ASYNC;


end generate GEN_MM2S_REGISTERS;

-------------------------------------------------------------------------------
-- Tie MM2S Register outputs to zero if excluded
-------------------------------------------------------------------------------
GEN_NO_MM2S_REGISTERS : if C_INCLUDE_MM2S = 0 generate
begin

    mm2s_axi2ip_wrce            <= (others => '0');
    mm2s_axi2ip_wrdata          <= (others => '0');
    mm2s_axi2ip_rdaddr          <= (others => '0');
    mm2s_axi2ip_rden_i          <= '0';
    mm2s_rddata_valid           <= '0';
    mm2s_introut                <= '0';
    s_h_mm2s_rddata_valid       <= '0';

end generate GEN_NO_MM2S_REGISTERS;


-------------------------------------------------------------------------------
-- Generate S2MM Registers if included
-------------------------------------------------------------------------------
GEN_S2MM_REGISTERS : if C_INCLUDE_S2MM = 1 generate
begin

    GEN_S2MM_REGIF_FOR_SYNC : if C_PRMRY_IS_ACLK_ASYNC = 0 generate

        -- To S2MM Register Module
        s2mm_axi2ip_wrce    <= axi2ip_wrce;
        s2mm_axi2ip_wrdata  <= axi2ip_wrdata;
        s2mm_axi2ip_rden_i  <= axi2ip_rden;
        s2mm_axi2ip_rdaddr  <= axi2ip_rdaddr;

        -- From S2MM Register Module
        s2mm_rddata_valid   <= s2mm_ip2axi_rddata_valid;
        s2mm_rddata         <= s2mm_ip2axi_rddata;
        s2mm_frame_ptr_ref  <= s2mm_ip2axi_frame_ptr_ref;
        s2mm_frame_store    <= s2mm_ip2axi_frame_store;

        s2mm_introut        <= s2mm_ip2axi_introut;

        s_h_s2mm_rddata_valid   <= s2mm_ip2axi_rddata_valid;

    end generate GEN_S2MM_REGIF_FOR_SYNC;

    GEN_S2MM_REGIF_FOR_ASYNC : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
    begin
        GEN_S2MM_WRITE_CE : for i in C_TOTAL_NUM_REGISTER-1 downto 0 generate
            S2MM_WRITE_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
                generic map(
                    C_CDC_TYPE              => CDC_TYPE_PULSE                       ,
                    C_VECTOR_WIDTH          => 1
                )
                port map (
                    prmry_aclk              => m_axi_s2mm_aclk                      ,
                    prmry_resetn            => s2mm_hrd_resetn                      ,
                    scndry_aclk             => s_axi_lite_aclk                      ,
                    scndry_resetn           => s_axi_lite_reset_n                   ,
                    scndry_in               => axi2ip_wrce(i)                       ,
                    prmry_out               => s2mm_axi2ip_wrce(i)                  ,
                    prmry_in                => '0'                                  ,
                    scndry_out              => open                                 ,
                    scndry_vect_s_h         => '0'                                  ,
                    scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)          ,
                    prmry_vect_out          => open                                 ,
                    prmry_vect_s_h          => '0'                                  ,
                    prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)          ,
                    scndry_vect_out         => open
                );
        end generate GEN_S2MM_WRITE_CE;


        S2MM_WRDATA_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => C_S_AXI_LITE_DATA_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => axi2ip_wren                              ,
                scndry_vect_in          => axi2ip_wrdata                            ,
                prmry_vect_out          => s2mm_axi2ip_wrdata                       ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT
                                            (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)    ,
                scndry_vect_out         => open
            );


        S2MM_RDADDR_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => C_S_AXI_LITE_ADDR_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => axi2ip_rden                              ,
                prmry_out               => s2mm_axi2ip_rden_i                       ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => axi2ip_rden                              ,
                scndry_vect_in          => axi2ip_rdaddr                            ,
                prmry_vect_out          => s2mm_axi2ip_rdaddr                       ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT
                                            (C_S_AXI_LITE_ADDR_WIDTH-1 downto 0)    ,
                scndry_vect_out         => open
            );

        S2MM_RDDATA_CDC_I : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => C_S_AXI_LITE_DATA_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => s2mm_ip2axi_rddata_valid                 ,
                scndry_out              => s2mm_rddata_valid                        ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT
                                            (C_S_AXI_LITE_DATA_WIDTH-1 downto 0)    ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => s2mm_ip2axi_rddata_valid                 ,
                prmry_vect_in           => s2mm_ip2axi_rddata                       ,
                scndry_vect_out         => s2mm_rddata
            );

        S2MM_FRAME_PTR_CDC : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => FRAME_NUMBER_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => '0'                                      ,
                scndry_out              => open                                     ,
                scndry_vect_s_h         => '1'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(FRAME_NUMBER_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => s2mm_ip2axi_frame_ptr_ref                ,
                scndry_vect_out         => s2mm_frame_ptr_ref
            );

        S2MM_FRAME_STORE_CDC : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_LEVEL                           ,
                C_VECTOR_WIDTH          => FRAME_NUMBER_WIDTH
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => s2mm_ip2axi_introut                      ,
                scndry_out              => s2mm_introut                             ,
                scndry_vect_s_h         => '1'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(FRAME_NUMBER_WIDTH-1 downto 0),
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '1'                                      ,
                prmry_vect_in           => s2mm_ip2axi_frame_store                  ,
                scndry_vect_out         => s2mm_frame_store
            );

        -- Sample and Hold S2MM Data
        REG_S2MM_RDDATA : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n ='0' or delayed_rden = '1')then

                        s_h_s2mm_rddata_valid   <= '0';
                    elsif(s2mm_rddata_valid = '1')then
                        s_h_s2mm_rddata_valid   <= '1';
                    end if;
                end if;
            end process REG_S2MM_RDDATA;

    end generate GEN_S2MM_REGIF_FOR_ASYNC;

end generate GEN_S2MM_REGISTERS;

-------------------------------------------------------------------------------
-- Tie S2MM Register outputs to zero if excluded
-------------------------------------------------------------------------------
GEN_NO_S2MM_REGISTERS : if C_INCLUDE_S2MM = 0 generate
begin

    s2mm_axi2ip_wrce            <= (others => '0');
    s2mm_axi2ip_wrdata          <= (others => '0');
    s2mm_axi2ip_rdaddr          <= (others => '0');
    s2mm_axi2ip_rden_i          <= '0';
    s2mm_rddata_valid           <= '0';
    s2mm_introut                <= '0';
    s_h_s2mm_rddata_valid       <= '0';

end generate GEN_NO_S2MM_REGISTERS;


--*****************************************************************************
-- Park Pointer Reference Register (located here because mm2s and s2mm are
-- combined into this one register)
--*****************************************************************************
park_ptr_ref_i <= PARK_REG_PAD
                & s2mm_frame_store
                & PARK_REG_PAD
                & mm2s_frame_store
                & PARK_REG_PAD
                & s2mm_frame_ptr_ref
                & PARK_REG_PAD
                & mm2s_frame_ptr_ref;


--*****************************************************************************
-- VDMA Version (located here because it is not unique to one particular
-- channel)
--*****************************************************************************
vdma_version_i(31 downto 16) <= (C_VERSION_MAJOR & C_VERSION_MINOR & C_VERSION_REVISION);
vdma_version_i(15 downto 0)  <= std_logic_vector(to_unsigned(rev_num,16));


--*****************************************************************************
-- MUX from S2MM and MM2S Read data as well as the two local registers
--*****************************************************************************
read_mux_select <= s_h_mm2s_rddata_valid
                 & s_h_s2mm_rddata_valid
                 & axi2ip_rdce(VDMA_PARKPTR_INDEX)
                 & axi2ip_rdce(VDMA_VERISON_INDEX);

FINAL_READ_MUX : process(read_mux_select,
                         mm2s_rddata,
                         s2mm_rddata,
                         delayed_rden,
                         park_ptr_ref_i,
                         vdma_version_i
                         )
    begin
        case read_mux_select is

            when "1000" => -- MM2S Read Data
                ip2axi_rddata       <= mm2s_rddata;
                ip2axi_rdata_valid  <= delayed_rden;

            when "0100" => -- S2MM Read Data
                ip2axi_rddata       <= s2mm_rddata;
                ip2axi_rdata_valid  <= delayed_rden;

            when "0010" => -- PART PTR
                ip2axi_rddata       <= park_ptr_ref_i;
                ip2axi_rdata_valid  <= delayed_rden;

            when "0001" => -- VERSION
                ip2axi_rddata       <= vdma_version_i;
                ip2axi_rdata_valid  <= delayed_rden;

            when others =>
                ip2axi_rddata       <= (others => '0');
                ip2axi_rdata_valid  <= delayed_rden;   -- CR619743

        end case;
    end process FINAL_READ_MUX;


-- Used to guarenttee proper minimum cycle times on read/write access that are to
-- reserved address space
GEN_MISS_TIME_DELAY : if C_PRMRY_IS_ACLK_ASYNC = 1 generate
begin


    GEN_MM2S_AND_S2MM : if C_INCLUDE_MM2S = 1 and C_INCLUDE_S2MM = 1 generate
    begin

        PIPE_DELAY_IN_S2MM : process(m_axi_s2mm_aclk)
            begin
                if(m_axi_s2mm_aclk'EVENT and m_axi_s2mm_aclk = '1')then
                    if(s2mm_hrd_resetn = '0')then
                        delay_rden <= '0';
                    else
                        delay_rden <= s2mm_axi2ip_rden_i;
                    end if;
                end if;
            end process PIPE_DELAY_IN_S2MM;

        delay_wren <= axi2ip_wren;

        S2MM_TO_MM2S_RDDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => m_axi_mm2s_aclk                          ,
                scndry_resetn           => mm2s_hrd_resetn                          ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delay_rden                               ,
                scndry_out              => delayed_s2mm_axi2ip_rden                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        PIPE_DELAY_IN_MM2S : process(m_axi_mm2s_aclk)
            begin
                if(m_axi_mm2s_aclk'EVENT and m_axi_mm2s_aclk = '1')then
                    if(mm2s_hrd_resetn = '0')then
                        delayed_mm2s_axi2ip_rden <= '0';
                    else
                        delayed_mm2s_axi2ip_rden <= delayed_s2mm_axi2ip_rden;
                    end if;
                end if;
            end process PIPE_DELAY_IN_MM2S;


        MM2S_TO_LITE_RDDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delayed_mm2s_axi2ip_rden                 ,
                scndry_out              => delayed_lite_axi2ip_rden                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        PIPE_DELAY_IN_LITE : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n = '0')then
                        delayed_rden <= '0';
                    else
                        delayed_rden <= delayed_lite_axi2ip_rden;
                    end if;
                end if;
            end process PIPE_DELAY_IN_LITE;

        LITE_TO_S2MM_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => s_axi_lite_aclk                          ,
                prmry_resetn            => s_axi_lite_reset_n                       ,
                scndry_aclk             => m_axi_s2mm_aclk                          ,
                scndry_resetn           => s2mm_hrd_resetn                          ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delay_wren                               ,
                scndry_out              => delayed_s2mm_axi2ip_wren                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR624739
        WRPIPE_DELAY_IN_S2MM : process(m_axi_s2mm_aclk)
            begin
                if(m_axi_s2mm_aclk'EVENT and m_axi_s2mm_aclk = '1')then
                    if(s2mm_hrd_resetn = '0')then
                        delayed_s2mm_axi2ip_wren_d1 <= '0';
                    else
                        delayed_s2mm_axi2ip_wren_d1 <= delayed_s2mm_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_S2MM;

        S2MM_TO_MM2S_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => m_axi_mm2s_aclk                          ,
                scndry_resetn           => mm2s_hrd_resetn                          ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delayed_s2mm_axi2ip_wren_d1              ,-- CR624739
                scndry_out              => delayed_mm2s_axi2ip_wren                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR624739
        WRPIPE_DELAY_IN_MM2S : process(m_axi_mm2s_aclk)
            begin
                if(m_axi_mm2s_aclk'EVENT and m_axi_mm2s_aclk = '1')then
                    if(mm2s_hrd_resetn = '0')then
                        delayed_mm2s_axi2ip_wren_d1 <= '0';
                    else
                        delayed_mm2s_axi2ip_wren_d1 <= delayed_mm2s_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_MM2S;

        MM2S_TO_LITE_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delayed_mm2s_axi2ip_wren_d1              ,-- CR624739
                scndry_out              => delayed_lite_axi2ip_wren                 ,-- CR624739
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR624739
        WRPIPE_DELAY_IN_LITE : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n = '0')then
                        delayed_wren <= '0';
                    else
                        delayed_wren <= delayed_lite_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_LITE;

    end generate GEN_MM2S_AND_S2MM;


    -- For MM2S only - cross from lite to mm2s and back to lite for correct delay on wren
    -- and cross s2mm rden back to lite for rden
    GEN_MM2S_ONLY : if C_INCLUDE_MM2S = 1 and C_INCLUDE_S2MM = 0 generate
    begin

        PIPE_DELAY_IN_MM2S : process(m_axi_mm2s_aclk)
            begin
                if(m_axi_mm2s_aclk'EVENT and m_axi_mm2s_aclk = '1')then
                    if(mm2s_hrd_resetn = '0')then
                        delay_rden <= '0';
                    else
                        delay_rden <= mm2s_axi2ip_rden_i;
                    end if;
                end if;
            end process PIPE_DELAY_IN_MM2S;

        delay_wren <= axi2ip_wren;

        MM2S_TO_LITE_RDDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delay_rden                               ,
                scndry_out              => delayed_mm2s_axi2ip_rden                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        PIPE_DELAY_IN_LITE : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n = '0')then
                        delayed_rden <= '0';
                    else
                        delayed_rden <= delayed_mm2s_axi2ip_rden;
                    end if;
                end if;
            end process PIPE_DELAY_IN_LITE;


        LITE_TO_MM2S_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => s_axi_lite_aclk                          ,
                prmry_resetn            => s_axi_lite_reset_n                       ,
                scndry_aclk             => m_axi_mm2s_aclk                          ,
                scndry_resetn           => mm2s_hrd_resetn                          ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delay_wren                               ,
                scndry_out              => delayed_mm2s_axi2ip_wren                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR623593 need to pipe delay in both domains to meet minimum cdc pulse
        -- frequency requirements
        WRPIPE_DELAY_IN_MM2S : process(m_axi_mm2s_aclk)
            begin
                if(m_axi_mm2s_aclk'EVENT and m_axi_mm2s_aclk = '1')then
                    if(mm2s_hrd_resetn = '0')then
                        delayed_mm2s_axi2ip_wren_d1 <= '0';
                    else
                        delayed_mm2s_axi2ip_wren_d1 <= delayed_mm2s_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_MM2S;

        MM2S_TO_LITE_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_mm2s_aclk                          ,
                prmry_resetn            => mm2s_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delayed_mm2s_axi2ip_wren_d1              ,
                scndry_out              => delayed_lite_axi2ip_wren                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR623593 need to pipe delay in both domains to meet minimum cdc pulse
        -- frequency requirements
        WRPIPE_DELAY_IN_LITE : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n = '0')then
                        delayed_wren <= '0';
                    else
                        delayed_wren <= delayed_lite_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_LITE;


    end generate GEN_MM2S_ONLY;


    -- For S2MM only - cross from lite to mm2s and back to lite for correct delay on wren
    -- and cross s2mm rden back to lite for rden
    GEN_S2MM_ONLY : if C_INCLUDE_MM2S = 0 and C_INCLUDE_S2MM = 1 generate
    begin

        PIPE_DELAY_IN_S2MM : process(m_axi_s2mm_aclk)
            begin
                if(m_axi_s2mm_aclk'EVENT and m_axi_s2mm_aclk = '1')then
                    if(s2mm_hrd_resetn = '0')then
                        delay_rden <= '0';
                    else
                        delay_rden <= s2mm_axi2ip_rden_i;
                    end if;
                end if;
            end process PIPE_DELAY_IN_S2MM;

        delay_wren <= axi2ip_wren;

        S2MM_TO_LITE_RDDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delay_rden                               ,
                scndry_out              => delayed_s2mm_axi2ip_rden                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        PIPE_DELAY_IN_LITE : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n = '0')then
                        delayed_rden <= '0';
                    else
                        delayed_rden <= delayed_s2mm_axi2ip_rden;
                    end if;
                end if;
            end process PIPE_DELAY_IN_LITE;

        LITE_TO_S2MM_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => s_axi_lite_aclk                          ,
                prmry_resetn            => s_axi_lite_reset_n                       ,
                scndry_aclk             => m_axi_s2mm_aclk                          ,
                scndry_resetn           => s2mm_hrd_resetn                          ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delay_wren                               ,
                scndry_out              => delayed_s2mm_axi2ip_wren                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR623593 need to pipe delay in both domains to meet minimum cdc pulse
        -- frequency requirements
        WRPIPE_DELAY_IN_S2MM : process(m_axi_s2mm_aclk)
            begin
                if(m_axi_s2mm_aclk'EVENT and m_axi_s2mm_aclk = '1')then
                    if(s2mm_hrd_resetn = '0')then
                        delayed_s2mm_axi2ip_wren_d1 <= '0';
                    else
                        delayed_s2mm_axi2ip_wren_d1 <= delayed_s2mm_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_S2MM;

        S2MM_TO_LITE_WRDELAY : entity axi_vdma_v5_00_a.axi_vdma_cdc
            generic map(
                C_CDC_TYPE              => CDC_TYPE_PULSE                           ,
                C_VECTOR_WIDTH          => 1
            )
            port map (
                prmry_aclk              => m_axi_s2mm_aclk                          ,
                prmry_resetn            => s2mm_hrd_resetn                          ,
                scndry_aclk             => s_axi_lite_aclk                          ,
                scndry_resetn           => s_axi_lite_reset_n                       ,
                scndry_in               => '0'                                      ,
                prmry_out               => open                                     ,
                prmry_in                => delayed_s2mm_axi2ip_wren_d1              ,
                scndry_out              => delayed_lite_axi2ip_wren                 ,
                scndry_vect_s_h         => '0'                                      ,
                scndry_vect_in          => ZERO_VALUE_VECT(0 downto 0)              ,
                prmry_vect_out          => open                                     ,
                prmry_vect_s_h          => '0'                                      ,
                prmry_vect_in           => ZERO_VALUE_VECT(0 downto 0)              ,
                scndry_vect_out         => open
            );

        -- CR623593 need to pipe delay in both domains to meet minimum cdc pulse
        -- frequency requirements
        WRPIPE_DELAY_IN_LITE : process(s_axi_lite_aclk)
            begin
                if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
                    if(s_axi_lite_reset_n = '0')then
                        delayed_wren <= '0';
                    else
                        delayed_wren <= delayed_lite_axi2ip_wren;
                    end if;
                end if;
            end process WRPIPE_DELAY_IN_LITE;

    end generate GEN_S2MM_ONLY;

end generate GEN_MISS_TIME_DELAY;

-- synchronous clock therefore no delay required
GEN_NO_MISS_TIME_DELAY : if C_PRMRY_IS_ACLK_ASYNC = 0 generate
begin
    delayed_rden <= axi2ip_rden;
    delayed_wren <= axi2ip_wren;

end generate GEN_NO_MISS_TIME_DELAY;

-- ack to complete write on axi_lite
WRITE_ACK : process(s_axi_lite_aclk)
    begin
        if(s_axi_lite_aclk'EVENT and s_axi_lite_aclk = '1')then
            if(s_axi_lite_reset_n ='0')then
                ip2axi_wrack <= '0';
            elsif(delayed_wren = '1')then
                ip2axi_wrack <= '1';
            else
                ip2axi_wrack <= '0';
            end if;
        end if;
    end process WRITE_ACK;

end implementation;
