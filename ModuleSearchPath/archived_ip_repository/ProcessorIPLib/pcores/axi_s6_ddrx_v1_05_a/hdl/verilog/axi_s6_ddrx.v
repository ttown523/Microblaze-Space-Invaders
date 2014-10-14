//*****************************************************************************
// (c) Copyright 2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//Device: Spartan6
//Design Name: DDR/DDR2/DDR3/LPDDR
//Purpose:
//Reference:
//   This module instantiates the AXI bridges
//
//*****************************************************************************
`timescale 1ps / 1ps

module axi_s6_ddrx #
   (
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
  // Raw Wrapper Parameters
  parameter         C_MEMCLK_PERIOD           = 2500,
  parameter         C_MEM_ADDR_ORDER          = "BANK_ROW_COLUMN",
  parameter         C_ARB_ALGORITHM           = 0,
  parameter         C_ARB_NUM_TIME_SLOTS      = 12,
  parameter         C_ARB_TIME_SLOT_0         = 18'o012345,
  parameter         C_ARB_TIME_SLOT_1         = 18'o123450,
  parameter         C_ARB_TIME_SLOT_2         = 18'o234501,
  parameter         C_ARB_TIME_SLOT_3         = 18'o345012,
  parameter         C_ARB_TIME_SLOT_4         = 18'o450123,
  parameter         C_ARB_TIME_SLOT_5         = 18'o501234,
  parameter         C_ARB_TIME_SLOT_6         = 18'o012345,
  parameter         C_ARB_TIME_SLOT_7         = 18'o123450,
  parameter         C_ARB_TIME_SLOT_8         = 18'o234501,
  parameter         C_ARB_TIME_SLOT_9         = 18'o345012,
  parameter         C_ARB_TIME_SLOT_10        = 18'o450123,
  parameter         C_ARB_TIME_SLOT_11        = 18'o501234,
  parameter         C_PORT_CONFIG             = "B128",
  parameter         C_MEM_TRAS                = 45000,
  parameter         C_MEM_TRCD                = 12500,
  parameter         C_MEM_TREFI               = 7800,
  parameter         C_MEM_TRFC                = 127500,
  parameter         C_MEM_TRP                 = 12500,
  parameter         C_MEM_TWR                 = 15000,
  parameter         C_MEM_TRTP                = 7500,
  parameter         C_MEM_TWTR                = 7500,
  parameter         C_NUM_DQ_PINS             = 8,
  parameter         C_MEM_TYPE                = "DDR3",
  parameter         C_MEM_CAS_LATENCY         = 4,
  parameter         C_MEM_ADDR_WIDTH          = 13,
  parameter         C_MEM_BANKADDR_WIDTH      = 3,
  parameter         C_MEM_NUM_COL_BITS        = 11,
  parameter         C_MEM_DDR3_CAS_LATENCY    = 7,
  parameter         C_MEM_MOBILE_PA_SR        = "FULL",
  parameter         C_MEM_DDR1_2_ODS          = "FULL",
  parameter         C_MEM_DDR3_ODS            = "DIV6",
  parameter         C_MEM_DDR2_RTT            = "50OHMS",
  parameter         C_MEM_DDR3_RTT            = "DIV2",
  parameter         C_MEM_MDDR_ODS            = "FULL",
  parameter         C_MEM_DDR2_DIFF_DQS_EN    = "YES",
  parameter         C_MEM_DDR2_3_PA_SR        = "OFF",
  parameter         C_MEM_DDR3_CAS_WR_LATENCY = 5,
  parameter         C_MEM_DDR3_AUTO_SR        = "ENABLED",
  parameter         C_MEM_DDR2_3_HIGH_TEMP_SR = "NORMAL",
  parameter         C_MEM_TZQINIT_MAXCNT      = 10'd512,
  parameter         C_SKIP_IN_TERM_CAL        = 1'b0,
  parameter integer C_MCB_USE_EXTERNAL_BUFPLL = 1,
  parameter integer C_SYS_RST_PRESENT         = 0,
  parameter         C_SIMULATION              = "FALSE",
  // AXI Parameters
  parameter         C_S0_AXI_BASEADDR         = 32'h00000000,
  parameter         C_S0_AXI_HIGHADDR         = 32'h00000000,
  parameter integer C_S0_AXI_ENABLE           = 0,
  parameter integer C_S0_AXI_ID_WIDTH         = 4,
  parameter integer C_S0_AXI_ADDR_WIDTH       = 64,
  parameter integer C_S0_AXI_DATA_WIDTH       = 32,
  parameter integer C_S0_AXI_SUPPORTS_READ    = 1,
  parameter integer C_S0_AXI_SUPPORTS_WRITE   = 1,
  parameter integer C_S0_AXI_SUPPORTS_NARROW_BURST  = 1,
  parameter         C_S0_AXI_REG_EN0          = 20'h00000,
  parameter         C_S0_AXI_REG_EN1          = 20'h01000,
  parameter integer C_S0_AXI_STRICT_COHERENCY = 1,
  parameter integer C_S0_AXI_ENABLE_AP        = 0,
  parameter         C_S1_AXI_BASEADDR         = 32'h00000000,
  parameter         C_S1_AXI_HIGHADDR         = 32'h00000000,
  parameter integer C_S1_AXI_ENABLE           = 0,
  parameter integer C_S1_AXI_ID_WIDTH         = 4,
  parameter integer C_S1_AXI_ADDR_WIDTH       = 64,
  parameter integer C_S1_AXI_DATA_WIDTH       = 32,
  parameter integer C_S1_AXI_SUPPORTS_READ    = 1,
  parameter integer C_S1_AXI_SUPPORTS_WRITE   = 1,
  parameter integer C_S1_AXI_SUPPORTS_NARROW_BURST  = 1,
  parameter         C_S1_AXI_REG_EN0          = 20'h00000,
  parameter         C_S1_AXI_REG_EN1          = 20'h01000,
  parameter integer C_S1_AXI_STRICT_COHERENCY = 1,
  parameter integer C_S1_AXI_ENABLE_AP        = 0,
  parameter         C_S2_AXI_BASEADDR         = 32'h00000000,
  parameter         C_S2_AXI_HIGHADDR         = 32'h00000000,
  parameter integer C_S2_AXI_ENABLE           = 0,
  parameter integer C_S2_AXI_ID_WIDTH         = 4,
  parameter integer C_S2_AXI_ADDR_WIDTH       = 64,
  parameter integer C_S2_AXI_DATA_WIDTH       = 32,
  parameter integer C_S2_AXI_SUPPORTS_READ    = 1,
  parameter integer C_S2_AXI_SUPPORTS_WRITE   = 1,
  parameter integer C_S2_AXI_SUPPORTS_NARROW_BURST  = 1,
  parameter         C_S2_AXI_REG_EN0          = 20'h00000,
  parameter         C_S2_AXI_REG_EN1          = 20'h01000,
  parameter integer C_S2_AXI_STRICT_COHERENCY = 1,
  parameter integer C_S2_AXI_ENABLE_AP        = 0,
  parameter         C_S3_AXI_BASEADDR         = 32'h00000000,
  parameter         C_S3_AXI_HIGHADDR         = 32'h00000000,
  parameter integer C_S3_AXI_ENABLE           = 0,
  parameter integer C_S3_AXI_ID_WIDTH         = 4,
  parameter integer C_S3_AXI_ADDR_WIDTH       = 64,
  parameter integer C_S3_AXI_DATA_WIDTH       = 32,
  parameter integer C_S3_AXI_SUPPORTS_READ    = 1,
  parameter integer C_S3_AXI_SUPPORTS_WRITE   = 1,
  parameter integer C_S3_AXI_SUPPORTS_NARROW_BURST  = 1,
  parameter         C_S3_AXI_REG_EN0          = 20'h00000,
  parameter         C_S3_AXI_REG_EN1          = 20'h01000,
  parameter integer C_S3_AXI_STRICT_COHERENCY = 1,
  parameter integer C_S3_AXI_ENABLE_AP        = 0,
  parameter         C_S4_AXI_BASEADDR         = 32'h00000000,
  parameter         C_S4_AXI_HIGHADDR         = 32'h00000000,
  parameter integer C_S4_AXI_ENABLE           = 0,
  parameter integer C_S4_AXI_ID_WIDTH         = 4,
  parameter integer C_S4_AXI_ADDR_WIDTH       = 64,
  parameter integer C_S4_AXI_DATA_WIDTH       = 32,
  parameter integer C_S4_AXI_SUPPORTS_READ    = 1,
  parameter integer C_S4_AXI_SUPPORTS_WRITE   = 1,
  parameter integer C_S4_AXI_SUPPORTS_NARROW_BURST  = 1,
  parameter         C_S4_AXI_REG_EN0          = 20'h00000,
  parameter         C_S4_AXI_REG_EN1          = 20'h01000,
  parameter integer C_S4_AXI_STRICT_COHERENCY = 1,
  parameter integer C_S4_AXI_ENABLE_AP        = 0,
  parameter         C_S5_AXI_BASEADDR         = 32'h00000000,
  parameter         C_S5_AXI_HIGHADDR         = 32'h00000000,
  parameter integer C_S5_AXI_ENABLE           = 0,
  parameter integer C_S5_AXI_ID_WIDTH         = 4,
  parameter integer C_S5_AXI_ADDR_WIDTH       = 64,
  parameter integer C_S5_AXI_DATA_WIDTH       = 32,
  parameter integer C_S5_AXI_SUPPORTS_READ    = 1,
  parameter integer C_S5_AXI_SUPPORTS_WRITE   = 1,
  parameter integer C_S5_AXI_SUPPORTS_NARROW_BURST  = 1,
  parameter         C_S5_AXI_REG_EN0          = 20'h00000,
  parameter         C_S5_AXI_REG_EN1          = 20'h01000,
  parameter integer C_S5_AXI_STRICT_COHERENCY = 1,
  parameter integer C_S5_AXI_ENABLE_AP        = 0
  )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
  // Raw Wrapper Signals
  input  wire                               sysclk_2x          ,
  input  wire                               sysclk_2x_180      ,
  input  wire                               pll_ce_0           ,
  input  wire                               pll_ce_90          ,
  output wire                               sysclk_2x_bufpll_o ,
  output wire                               sysclk_2x_180_bufpll_o,
  output wire                               pll_ce_0_bufpll_o  ,
  output wire                               pll_ce_90_bufpll_o ,
  output wire                               pll_lock_bufpll_o  ,
  input  wire                               pll_lock           ,
  input  wire                               sys_rst            ,
  output wire [C_MEM_ADDR_WIDTH-1:0]        mcbx_dram_addr     ,
  output wire [C_MEM_BANKADDR_WIDTH-1:0]    mcbx_dram_ba       ,
  output wire                               mcbx_dram_ras_n    ,
  output wire                               mcbx_dram_cas_n    ,
  output wire                               mcbx_dram_we_n     ,
  output wire                               mcbx_dram_cke      ,
  output wire                               mcbx_dram_clk      ,
  output wire                               mcbx_dram_clk_n    ,
  inout  wire [C_NUM_DQ_PINS-1:0]           mcbx_dram_dq       ,
  inout  wire                               mcbx_dram_dqs      ,
  inout  wire                               mcbx_dram_dqs_n    ,
  inout  wire                               mcbx_dram_udqs     ,
  inout  wire                               mcbx_dram_udqs_n   ,
  output wire                               mcbx_dram_udm      ,
  output wire                               mcbx_dram_ldm      ,
  output wire                               mcbx_dram_odt      ,
  output wire                               mcbx_dram_ddr3_rst ,
  inout  wire                               rzq                ,
  inout  wire                               zio                ,
  input  wire                               ui_clk             ,
  output wire                               uo_done_cal        ,
  // AXI Signals
  input  wire                               s0_axi_aclk        ,
  input  wire                               s0_axi_aresetn     ,
  input  wire [C_S0_AXI_ID_WIDTH-1:0]       s0_axi_awid        ,
  input  wire [C_S0_AXI_ADDR_WIDTH-1:0]     s0_axi_awaddr      ,
  input  wire [7:0]                         s0_axi_awlen       ,
  input  wire [2:0]                         s0_axi_awsize      ,
  input  wire [1:0]                         s0_axi_awburst     ,
  input  wire [0:0]                         s0_axi_awlock      ,
  input  wire [3:0]                         s0_axi_awcache     ,
  input  wire [2:0]                         s0_axi_awprot      ,
  input  wire [3:0]                         s0_axi_awqos       ,
  input  wire                               s0_axi_awvalid     ,
  output wire                               s0_axi_awready     ,
  input  wire [C_S0_AXI_DATA_WIDTH-1:0]     s0_axi_wdata       ,
  input  wire [C_S0_AXI_DATA_WIDTH/8-1:0]   s0_axi_wstrb       ,
  input  wire                               s0_axi_wlast       ,
  input  wire                               s0_axi_wvalid      ,
  output wire                               s0_axi_wready      ,
  output wire [C_S0_AXI_ID_WIDTH-1:0]       s0_axi_bid         ,
  output wire [1:0]                         s0_axi_bresp       ,
  output wire                               s0_axi_bvalid      ,
  input  wire                               s0_axi_bready      ,
  input  wire [C_S0_AXI_ID_WIDTH-1:0]       s0_axi_arid        ,
  input  wire [C_S0_AXI_ADDR_WIDTH-1:0]     s0_axi_araddr      ,
  input  wire [7:0]                         s0_axi_arlen       ,
  input  wire [2:0]                         s0_axi_arsize      ,
  input  wire [1:0]                         s0_axi_arburst     ,
  input  wire [0:0]                         s0_axi_arlock      ,
  input  wire [3:0]                         s0_axi_arcache     ,
  input  wire [2:0]                         s0_axi_arprot      ,
  input  wire [3:0]                         s0_axi_arqos       ,
  input  wire                               s0_axi_arvalid     ,
  output wire                               s0_axi_arready     ,
  output wire [C_S0_AXI_ID_WIDTH-1:0]       s0_axi_rid         ,
  output wire [C_S0_AXI_DATA_WIDTH-1:0]     s0_axi_rdata       ,
  output wire [1:0]                         s0_axi_rresp       ,
  output wire                               s0_axi_rlast       ,
  output wire                               s0_axi_rvalid      ,
  input  wire                               s0_axi_rready      ,

  input  wire                               s1_axi_aclk        ,
  input  wire                               s1_axi_aresetn     ,
  input  wire [C_S1_AXI_ID_WIDTH-1:0]       s1_axi_awid        ,
  input  wire [C_S1_AXI_ADDR_WIDTH-1:0]     s1_axi_awaddr      ,
  input  wire [7:0]                         s1_axi_awlen       ,
  input  wire [2:0]                         s1_axi_awsize      ,
  input  wire [1:0]                         s1_axi_awburst     ,
  input  wire [0:0]                         s1_axi_awlock      ,
  input  wire [3:0]                         s1_axi_awcache     ,
  input  wire [2:0]                         s1_axi_awprot      ,
  input  wire [3:0]                         s1_axi_awqos       ,
  input  wire                               s1_axi_awvalid     ,
  output wire                               s1_axi_awready     ,
  input  wire [C_S1_AXI_DATA_WIDTH-1:0]     s1_axi_wdata       ,
  input  wire [C_S1_AXI_DATA_WIDTH/8-1:0]   s1_axi_wstrb       ,
  input  wire                               s1_axi_wlast       ,
  input  wire                               s1_axi_wvalid      ,
  output wire                               s1_axi_wready      ,
  output wire [C_S1_AXI_ID_WIDTH-1:0]       s1_axi_bid         ,
  output wire [1:0]                         s1_axi_bresp       ,
  output wire                               s1_axi_bvalid      ,
  input  wire                               s1_axi_bready      ,
  input  wire [C_S1_AXI_ID_WIDTH-1:0]       s1_axi_arid        ,
  input  wire [C_S1_AXI_ADDR_WIDTH-1:0]     s1_axi_araddr      ,
  input  wire [7:0]                         s1_axi_arlen       ,
  input  wire [2:0]                         s1_axi_arsize      ,
  input  wire [1:0]                         s1_axi_arburst     ,
  input  wire [0:0]                         s1_axi_arlock      ,
  input  wire [3:0]                         s1_axi_arcache     ,
  input  wire [2:0]                         s1_axi_arprot      ,
  input  wire [3:0]                         s1_axi_arqos       ,
  input  wire                               s1_axi_arvalid     ,
  output wire                               s1_axi_arready     ,
  output wire [C_S1_AXI_ID_WIDTH-1:0]       s1_axi_rid         ,
  output wire [C_S1_AXI_DATA_WIDTH-1:0]     s1_axi_rdata       ,
  output wire [1:0]                         s1_axi_rresp       ,
  output wire                               s1_axi_rlast       ,
  output wire                               s1_axi_rvalid      ,
  input  wire                               s1_axi_rready      ,

  input  wire                               s2_axi_aclk        ,
  input  wire                               s2_axi_aresetn     ,
  input  wire [C_S2_AXI_ID_WIDTH-1:0]       s2_axi_awid        ,
  input  wire [C_S2_AXI_ADDR_WIDTH-1:0]     s2_axi_awaddr      ,
  input  wire [7:0]                         s2_axi_awlen       ,
  input  wire [2:0]                         s2_axi_awsize      ,
  input  wire [1:0]                         s2_axi_awburst     ,
  input  wire [0:0]                         s2_axi_awlock      ,
  input  wire [3:0]                         s2_axi_awcache     ,
  input  wire [2:0]                         s2_axi_awprot      ,
  input  wire [3:0]                         s2_axi_awqos       ,
  input  wire                               s2_axi_awvalid     ,
  output wire                               s2_axi_awready     ,
  input  wire [C_S2_AXI_DATA_WIDTH-1:0]     s2_axi_wdata       ,
  input  wire [C_S2_AXI_DATA_WIDTH/8-1:0]   s2_axi_wstrb       ,
  input  wire                               s2_axi_wlast       ,
  input  wire                               s2_axi_wvalid      ,
  output wire                               s2_axi_wready      ,
  output wire [C_S2_AXI_ID_WIDTH-1:0]       s2_axi_bid         ,
  output wire [1:0]                         s2_axi_bresp       ,
  output wire                               s2_axi_bvalid      ,
  input  wire                               s2_axi_bready      ,
  input  wire [C_S2_AXI_ID_WIDTH-1:0]       s2_axi_arid        ,
  input  wire [C_S2_AXI_ADDR_WIDTH-1:0]     s2_axi_araddr      ,
  input  wire [7:0]                         s2_axi_arlen       ,
  input  wire [2:0]                         s2_axi_arsize      ,
  input  wire [1:0]                         s2_axi_arburst     ,
  input  wire [0:0]                         s2_axi_arlock      ,
  input  wire [3:0]                         s2_axi_arcache     ,
  input  wire [2:0]                         s2_axi_arprot      ,
  input  wire [3:0]                         s2_axi_arqos       ,
  input  wire                               s2_axi_arvalid     ,
  output wire                               s2_axi_arready     ,
  output wire [C_S2_AXI_ID_WIDTH-1:0]       s2_axi_rid         ,
  output wire [C_S2_AXI_DATA_WIDTH-1:0]     s2_axi_rdata       ,
  output wire [1:0]                         s2_axi_rresp       ,
  output wire                               s2_axi_rlast       ,
  output wire                               s2_axi_rvalid      ,
  input  wire                               s2_axi_rready      ,

  input  wire                               s3_axi_aclk        ,
  input  wire                               s3_axi_aresetn     ,
  input  wire [C_S3_AXI_ID_WIDTH-1:0]       s3_axi_awid        ,
  input  wire [C_S3_AXI_ADDR_WIDTH-1:0]     s3_axi_awaddr      ,
  input  wire [7:0]                         s3_axi_awlen       ,
  input  wire [2:0]                         s3_axi_awsize      ,
  input  wire [1:0]                         s3_axi_awburst     ,
  input  wire [0:0]                         s3_axi_awlock      ,
  input  wire [3:0]                         s3_axi_awcache     ,
  input  wire [2:0]                         s3_axi_awprot      ,
  input  wire [3:0]                         s3_axi_awqos       ,
  input  wire                               s3_axi_awvalid     ,
  output wire                               s3_axi_awready     ,
  input  wire [C_S3_AXI_DATA_WIDTH-1:0]     s3_axi_wdata       ,
  input  wire [C_S3_AXI_DATA_WIDTH/8-1:0]   s3_axi_wstrb       ,
  input  wire                               s3_axi_wlast       ,
  input  wire                               s3_axi_wvalid      ,
  output wire                               s3_axi_wready      ,
  output wire [C_S3_AXI_ID_WIDTH-1:0]       s3_axi_bid         ,
  output wire [1:0]                         s3_axi_bresp       ,
  output wire                               s3_axi_bvalid      ,
  input  wire                               s3_axi_bready      ,
  input  wire [C_S3_AXI_ID_WIDTH-1:0]       s3_axi_arid        ,
  input  wire [C_S3_AXI_ADDR_WIDTH-1:0]     s3_axi_araddr      ,
  input  wire [7:0]                         s3_axi_arlen       ,
  input  wire [2:0]                         s3_axi_arsize      ,
  input  wire [1:0]                         s3_axi_arburst     ,
  input  wire [0:0]                         s3_axi_arlock      ,
  input  wire [3:0]                         s3_axi_arcache     ,
  input  wire [2:0]                         s3_axi_arprot      ,
  input  wire [3:0]                         s3_axi_arqos       ,
  input  wire                               s3_axi_arvalid     ,
  output wire                               s3_axi_arready     ,
  output wire [C_S3_AXI_ID_WIDTH-1:0]       s3_axi_rid         ,
  output wire [C_S3_AXI_DATA_WIDTH-1:0]     s3_axi_rdata       ,
  output wire [1:0]                         s3_axi_rresp       ,
  output wire                               s3_axi_rlast       ,
  output wire                               s3_axi_rvalid      ,
  input  wire                               s3_axi_rready      ,

  input  wire                               s4_axi_aclk        ,
  input  wire                               s4_axi_aresetn     ,
  input  wire [C_S4_AXI_ID_WIDTH-1:0]       s4_axi_awid        ,
  input  wire [C_S4_AXI_ADDR_WIDTH-1:0]     s4_axi_awaddr      ,
  input  wire [7:0]                         s4_axi_awlen       ,
  input  wire [2:0]                         s4_axi_awsize      ,
  input  wire [1:0]                         s4_axi_awburst     ,
  input  wire [0:0]                         s4_axi_awlock      ,
  input  wire [3:0]                         s4_axi_awcache     ,
  input  wire [2:0]                         s4_axi_awprot      ,
  input  wire [3:0]                         s4_axi_awqos       ,
  input  wire                               s4_axi_awvalid     ,
  output wire                               s4_axi_awready     ,
  input  wire [C_S4_AXI_DATA_WIDTH-1:0]     s4_axi_wdata       ,
  input  wire [C_S4_AXI_DATA_WIDTH/8-1:0]   s4_axi_wstrb       ,
  input  wire                               s4_axi_wlast       ,
  input  wire                               s4_axi_wvalid      ,
  output wire                               s4_axi_wready      ,
  output wire [C_S4_AXI_ID_WIDTH-1:0]       s4_axi_bid         ,
  output wire [1:0]                         s4_axi_bresp       ,
  output wire                               s4_axi_bvalid      ,
  input  wire                               s4_axi_bready      ,
  input  wire [C_S4_AXI_ID_WIDTH-1:0]       s4_axi_arid        ,
  input  wire [C_S4_AXI_ADDR_WIDTH-1:0]     s4_axi_araddr      ,
  input  wire [7:0]                         s4_axi_arlen       ,
  input  wire [2:0]                         s4_axi_arsize      ,
  input  wire [1:0]                         s4_axi_arburst     ,
  input  wire [0:0]                         s4_axi_arlock      ,
  input  wire [3:0]                         s4_axi_arcache     ,
  input  wire [2:0]                         s4_axi_arprot      ,
  input  wire [3:0]                         s4_axi_arqos       ,
  input  wire                               s4_axi_arvalid     ,
  output wire                               s4_axi_arready     ,
  output wire [C_S4_AXI_ID_WIDTH-1:0]       s4_axi_rid         ,
  output wire [C_S4_AXI_DATA_WIDTH-1:0]     s4_axi_rdata       ,
  output wire [1:0]                         s4_axi_rresp       ,
  output wire                               s4_axi_rlast       ,
  output wire                               s4_axi_rvalid      ,
  input  wire                               s4_axi_rready      ,

  input  wire                               s5_axi_aclk        ,
  input  wire                               s5_axi_aresetn     ,
  input  wire [C_S5_AXI_ID_WIDTH-1:0]       s5_axi_awid        ,
  input  wire [C_S5_AXI_ADDR_WIDTH-1:0]     s5_axi_awaddr      ,
  input  wire [7:0]                         s5_axi_awlen       ,
  input  wire [2:0]                         s5_axi_awsize      ,
  input  wire [1:0]                         s5_axi_awburst     ,
  input  wire [0:0]                         s5_axi_awlock      ,
  input  wire [3:0]                         s5_axi_awcache     ,
  input  wire [2:0]                         s5_axi_awprot      ,
  input  wire [3:0]                         s5_axi_awqos       ,
  input  wire                               s5_axi_awvalid     ,
  output wire                               s5_axi_awready     ,
  input  wire [C_S5_AXI_DATA_WIDTH-1:0]     s5_axi_wdata       ,
  input  wire [C_S5_AXI_DATA_WIDTH/8-1:0]   s5_axi_wstrb       ,
  input  wire                               s5_axi_wlast       ,
  input  wire                               s5_axi_wvalid      ,
  output wire                               s5_axi_wready      ,
  output wire [C_S5_AXI_ID_WIDTH-1:0]       s5_axi_bid         ,
  output wire [1:0]                         s5_axi_bresp       ,
  output wire                               s5_axi_bvalid      ,
  input  wire                               s5_axi_bready      ,
  input  wire [C_S5_AXI_ID_WIDTH-1:0]       s5_axi_arid        ,
  input  wire [C_S5_AXI_ADDR_WIDTH-1:0]     s5_axi_araddr      ,
  input  wire [7:0]                         s5_axi_arlen       ,
  input  wire [2:0]                         s5_axi_arsize      ,
  input  wire [1:0]                         s5_axi_arburst     ,
  input  wire [0:0]                         s5_axi_arlock      ,
  input  wire [3:0]                         s5_axi_arcache     ,
  input  wire [2:0]                         s5_axi_arprot      ,
  input  wire [3:0]                         s5_axi_arqos       ,
  input  wire                               s5_axi_arvalid     ,
  output wire                               s5_axi_arready     ,
  output wire [C_S5_AXI_ID_WIDTH-1:0]       s5_axi_rid         ,
  output wire [C_S5_AXI_DATA_WIDTH-1:0]     s5_axi_rdata       ,
  output wire [1:0]                         s5_axi_rresp       ,
  output wire                               s5_axi_rlast       ,
  output wire                               s5_axi_rvalid      ,
  input  wire                               s5_axi_rready
);
///////////////////////////////////////////////////////////////////////////////
// Local Parameters
///////////////////////////////////////////////////////////////////////////////
  localparam P_PORT_ENABLE             = { C_S5_AXI_ENABLE[0],
                                           C_S4_AXI_ENABLE[0],
                                           C_S3_AXI_ENABLE[0],
                                           C_S2_AXI_ENABLE[0],
                                           C_S1_AXI_ENABLE[0],
                                           C_S0_AXI_ENABLE[0] };
  localparam P_USR_INTERFACE_MODE      = "AXI";
  localparam P_MEM_DENSITY             = "2Gb";
  localparam P_MEM_BURST_LEN           = (C_MEM_TYPE == "DDR3") ? 8 : 4;
  localparam P_MC_CALIB_BYPASS         = "NO";
  localparam P_LDQSP_TAP_DELAY_VAL     = 0;
  localparam P_UDQSP_TAP_DELAY_VAL     = 0;
  localparam P_LDQSN_TAP_DELAY_VAL     = 0;
  localparam P_UDQSN_TAP_DELAY_VAL     = 0;
  localparam P_DQ0_TAP_DELAY_VAL       = 0;
  localparam P_DQ1_TAP_DELAY_VAL       = 0;
  localparam P_DQ2_TAP_DELAY_VAL       = 0;
  localparam P_DQ3_TAP_DELAY_VAL       = 0;
  localparam P_DQ4_TAP_DELAY_VAL       = 0;
  localparam P_DQ5_TAP_DELAY_VAL       = 0;
  localparam P_DQ6_TAP_DELAY_VAL       = 0;
  localparam P_DQ7_TAP_DELAY_VAL       = 0;
  localparam P_DQ8_TAP_DELAY_VAL       = 0;
  localparam P_DQ9_TAP_DELAY_VAL       = 0;
  localparam P_DQ10_TAP_DELAY_VAL      = 0;
  localparam P_DQ11_TAP_DELAY_VAL      = 0;
  localparam P_DQ12_TAP_DELAY_VAL      = 0;
  localparam P_DQ13_TAP_DELAY_VAL      = 0;
  localparam P_DQ14_TAP_DELAY_VAL      = 0;
  localparam P_DQ15_TAP_DELAY_VAL      = 0;
  localparam P_MC_CALIBRATION_CLK_DIV  = 1;
  localparam P_MC_CALIBRATION_MODE     = "CALIBRATION";
  localparam P_MC_CALIBRATION_DELAY    = "HALF";
  localparam P_MC_CALIBRATION_CA       = {C_MEM_NUM_COL_BITS{1'b1}};
  localparam P_MC_CALIBRATION_RA       = {C_MEM_ADDR_WIDTH{1'b1}};
  localparam P_MC_CALIBRATION_BA       = {C_MEM_BANKADDR_WIDTH{1'b1}};
  localparam P_P0_DATA_PORT_SIZE       = (C_PORT_CONFIG == "B128") ? 128 :
                                         (C_PORT_CONFIG == "B64_B64") ? 64 :
                                         (C_PORT_CONFIG == "B64_B32_B32") ? 64 :
                                         32;
  localparam P_P0_MASK_SIZE            = P_P0_DATA_PORT_SIZE/8;
  localparam P_P1_DATA_PORT_SIZE       = (C_PORT_CONFIG == "B64_B64") ? 64 : 32;
  localparam P_P1_MASK_SIZE            = P_P1_DATA_PORT_SIZE/8;
  localparam P_CALIB_SOFT_IP           = "TRUE";
  localparam P_SKIP_DYNAMIC_CAL        = 1'b0;
  localparam P_SKIP_DYN_IN_TERM        = 1'b1;
  localparam P_MEM_DDR3_DYN_WRT_ODT    = "OFF";


///////////////////////////////////////////////////////////////////////////////
// Wire/Reg Declarations
///////////////////////////////////////////////////////////////////////////////

   wire                               p0_arb_en          ;
   wire                               p0_cmd_clk         ;
   wire                               p0_cmd_en          ;
   wire [2:0]                         p0_cmd_instr       ;
   wire [5:0]                         p0_cmd_bl          ;
   wire [29:0]                        p0_cmd_byte_addr   ;
   wire                               p0_cmd_empty       ;
   wire                               p0_cmd_full        ;
   wire                               p0_wr_clk          ;
   wire                               p0_wr_en           ;
   wire [P_P0_MASK_SIZE-1:0]          p0_wr_mask         ;
   wire [P_P0_DATA_PORT_SIZE-1:0]     p0_wr_data         ;
   wire                               p0_wr_full         ;
   wire                               p0_wr_empty        ;
   wire [6:0]                         p0_wr_count        ;
   wire                               p0_wr_underrun     ;
   wire                               p0_wr_error        ;
   wire                               p0_rd_clk          ;
   wire                               p0_rd_en           ;
   wire [P_P0_DATA_PORT_SIZE-1:0]     p0_rd_data         ;
   wire                               p0_rd_full         ;
   wire                               p0_rd_empty        ;
   wire [6:0]                         p0_rd_count        ;
   wire                               p0_rd_overflow     ;
   wire                               p0_rd_error        ;
   wire                               p1_arb_en          ;
   wire                               p1_cmd_clk         ;
   wire                               p1_cmd_en          ;
   wire [2:0]                         p1_cmd_instr       ;
   wire [5:0]                         p1_cmd_bl          ;
   wire [29:0]                        p1_cmd_byte_addr   ;
   wire                               p1_cmd_empty       ;
   wire                               p1_cmd_full        ;
   wire                               p1_wr_clk          ;
   wire                               p1_wr_en           ;
   wire [P_P1_MASK_SIZE-1:0]          p1_wr_mask         ;
   wire [P_P1_DATA_PORT_SIZE-1:0]     p1_wr_data         ;
   wire                               p1_wr_full         ;
   wire                               p1_wr_empty        ;
   wire [6:0]                         p1_wr_count        ;
   wire                               p1_wr_underrun     ;
   wire                               p1_wr_error        ;
   wire                               p1_rd_clk          ;
   wire                               p1_rd_en           ;
   wire [P_P1_DATA_PORT_SIZE-1:0]     p1_rd_data         ;
   wire                               p1_rd_full         ;
   wire                               p1_rd_empty        ;
   wire [6:0]                         p1_rd_count        ;
   wire                               p1_rd_overflow     ;
   wire                               p1_rd_error        ;
   wire                               p2_arb_en          ;
   wire                               p2_cmd_clk         ;
   wire                               p2_cmd_en          ;
   wire [2:0]                         p2_cmd_instr       ;
   wire [5:0]                         p2_cmd_bl          ;
   wire [29:0]                        p2_cmd_byte_addr   ;
   wire                               p2_cmd_empty       ;
   wire                               p2_cmd_full        ;
   wire                               p2_wr_clk          ;
   wire                               p2_wr_en           ;
   wire [3:0]                         p2_wr_mask         ;
   wire [31:0]                        p2_wr_data         ;
   wire                               p2_wr_full         ;
   wire                               p2_wr_empty        ;
   wire [6:0]                         p2_wr_count        ;
   wire                               p2_wr_underrun     ;
   wire                               p2_wr_error        ;
   wire                               p2_rd_clk          ;
   wire                               p2_rd_en           ;
   wire [31:0]                        p2_rd_data         ;
   wire                               p2_rd_full         ;
   wire                               p2_rd_empty        ;
   wire [6:0]                         p2_rd_count        ;
   wire                               p2_rd_overflow     ;
   wire                               p2_rd_error        ;
   wire                               p3_arb_en          ;
   wire                               p3_cmd_clk         ;
   wire                               p3_cmd_en          ;
   wire [2:0]                         p3_cmd_instr       ;
   wire [5:0]                         p3_cmd_bl          ;
   wire [29:0]                        p3_cmd_byte_addr   ;
   wire                               p3_cmd_empty       ;
   wire                               p3_cmd_full        ;
   wire                               p3_wr_clk          ;
   wire                               p3_wr_en           ;
   wire [3:0]                         p3_wr_mask         ;
   wire [31:0]                        p3_wr_data         ;
   wire                               p3_wr_full         ;
   wire                               p3_wr_empty        ;
   wire [6:0]                         p3_wr_count        ;
   wire                               p3_wr_underrun     ;
   wire                               p3_wr_error        ;
   wire                               p3_rd_clk          ;
   wire                               p3_rd_en           ;
   wire [31:0]                        p3_rd_data         ;
   wire                               p3_rd_full         ;
   wire                               p3_rd_empty        ;
   wire [6:0]                         p3_rd_count        ;
   wire                               p3_rd_overflow     ;
   wire                               p3_rd_error        ;
   wire                               p4_arb_en          ;
   wire                               p4_cmd_clk         ;
   wire                               p4_cmd_en          ;
   wire [2:0]                         p4_cmd_instr       ;
   wire [5:0]                         p4_cmd_bl          ;
   wire [29:0]                        p4_cmd_byte_addr   ;
   wire                               p4_cmd_empty       ;
   wire                               p4_cmd_full        ;
   wire                               p4_wr_clk          ;
   wire                               p4_wr_en           ;
   wire [3:0]                         p4_wr_mask         ;
   wire [31:0]                        p4_wr_data         ;
   wire                               p4_wr_full         ;
   wire                               p4_wr_empty        ;
   wire [6:0]                         p4_wr_count        ;
   wire                               p4_wr_underrun     ;
   wire                               p4_wr_error        ;
   wire                               p4_rd_clk          ;
   wire                               p4_rd_en           ;
   wire [31:0]                        p4_rd_data         ;
   wire                               p4_rd_full         ;
   wire                               p4_rd_empty        ;
   wire [6:0]                         p4_rd_count        ;
   wire                               p4_rd_overflow     ;
   wire                               p4_rd_error        ;
   wire                               p5_arb_en          ;
   wire                               p5_cmd_clk         ;
   wire                               p5_cmd_en          ;
   wire [2:0]                         p5_cmd_instr       ;
   wire [5:0]                         p5_cmd_bl          ;
   wire [29:0]                        p5_cmd_byte_addr   ;
   wire                               p5_cmd_empty       ;
   wire                               p5_cmd_full        ;
   wire                               p5_wr_clk          ;
   wire                               p5_wr_en           ;
   wire [3:0]                         p5_wr_mask         ;
   wire [31:0]                        p5_wr_data         ;
   wire                               p5_wr_full         ;
   wire                               p5_wr_empty        ;
   wire [6:0]                         p5_wr_count        ;
   wire                               p5_wr_underrun     ;
   wire                               p5_wr_error        ;
   wire                               p5_rd_clk          ;
   wire                               p5_rd_en           ;
   wire [31:0]                        p5_rd_data         ;
   wire                               p5_rd_full         ;
   wire                               p5_rd_empty        ;
   wire [6:0]                         p5_rd_count        ;
   wire                               p5_rd_overflow     ;
   wire                               p5_rd_error        ;
  wire                               calib_recal        ;
  wire                               sys_rst_i          ;
  wire                               ui_rst             ;
  wire                               ui_read            ;
  wire                               ui_add             ;
  wire                               ui_cs              ;
  wire                               ui_sdi             ;
  wire [4:0]                         ui_addr            ;
  wire                               ui_broadcast       ;
  wire                               ui_drp_update      ;
  wire                               ui_done_cal        ;
  wire                               ui_cmd             ;
  wire                               ui_cmd_in          ;
  wire                               ui_cmd_en          ;
  wire [3:0]                         ui_dqcount         ;
  wire                               ui_dq_lower_dec    ;
  wire                               ui_dq_lower_inc    ;
  wire                               ui_dq_upper_dec    ;
  wire                               ui_dq_upper_inc    ;
  wire                               ui_udqs_inc        ;
  wire                               ui_udqs_dec        ;
  wire                               ui_ldqs_inc        ;
  wire                               ui_ldqs_dec        ;
  wire [7:0]                         uo_data            ;
  wire                               uo_data_valid      ;
  wire                               uo_cmd_ready_in    ;
  wire                               uo_refrsh_flag     ;
  wire                               uo_cal_start       ;
  wire                               uo_sdo             ;
  wire [31:0]                        status             ;
  wire                               selfrefresh_enter  ;
  wire                               selfrefresh_mode   ;

  // Tie off unused inputs to mcb_ui_top
  assign p0_arb_en         = 1'b1;
  assign p0_cmd_clk        = 1'b0;
  assign p0_cmd_en         = 1'b0;
  assign p0_cmd_instr      = 3'b0;
  assign p0_cmd_bl         = 6'b0;
  assign p0_cmd_byte_addr  = 30'b0;
  assign p0_wr_clk         = 1'b0;
  assign p0_wr_en          = 1'b0;
  assign p0_wr_mask        = {P_P0_MASK_SIZE{1'b0}};
  assign p0_wr_data        = {P_P0_DATA_PORT_SIZE{1'b0}};
  assign p0_rd_clk         = 1'b0;
  assign p0_rd_en          = 1'b0;
  assign p1_arb_en         = 1'b1;
  assign p1_cmd_clk        = 1'b0;
  assign p1_cmd_en         = 1'b0;
  assign p1_cmd_instr      = 3'b0;
  assign p1_cmd_bl         = 6'b0;
  assign p1_cmd_byte_addr  = 30'b0;
  assign p1_wr_clk         = 1'b0;
  assign p1_wr_en          = 1'b0;
  assign p1_wr_mask        = {P_P1_MASK_SIZE{1'b0}};
  assign p1_wr_data        = {P_P1_DATA_PORT_SIZE{1'b0}};
  assign p1_rd_clk         = 1'b0;
  assign p1_rd_en          = 1'b0;
  assign p2_arb_en         = 1'b1;
  assign p2_cmd_clk        = 1'b0;
  assign p2_cmd_en         = 1'b0;
  assign p2_cmd_instr      = 3'b0;
  assign p2_cmd_bl         = 6'b0;
  assign p2_cmd_byte_addr  = 30'b0;
  assign p2_wr_clk         = 1'b0;
  assign p2_wr_en          = 1'b0;
  assign p2_wr_mask        = 4'b0;
  assign p2_wr_data        = 32'b0;
  assign p2_rd_clk         = 1'b0;
  assign p2_rd_en          = 1'b0;
  assign p3_arb_en         = 1'b1;
  assign p3_cmd_clk        = 1'b0;
  assign p3_cmd_en         = 1'b0;
  assign p3_cmd_instr      = 3'b0;
  assign p3_cmd_bl         = 6'b0;
  assign p3_cmd_byte_addr  = 30'b0;
  assign p3_wr_clk         = 1'b0;
  assign p3_wr_en          = 1'b0;
  assign p3_wr_mask        = 4'b0;
  assign p3_wr_data        = 32'b0;
  assign p3_rd_clk         = 1'b0;
  assign p3_rd_en          = 1'b0;
  assign p4_arb_en         = 1'b1;
  assign p4_cmd_clk        = 1'b0;
  assign p4_cmd_en         = 1'b0;
  assign p4_cmd_instr      = 3'b0;
  assign p4_cmd_bl         = 6'b0;
  assign p4_cmd_byte_addr  = 30'b0;
  assign p4_wr_clk         = 1'b0;
  assign p4_wr_en          = 1'b0;
  assign p4_wr_mask        = 4'b0;
  assign p4_wr_data        = 32'b0;
  assign p4_rd_clk         = 1'b0;
  assign p4_rd_en          = 1'b0;
  assign p5_arb_en         = 1'b1;
  assign p5_cmd_clk        = 1'b0;
  assign p5_cmd_en         = 1'b0;
  assign p5_cmd_instr      = 3'b0;
  assign p5_cmd_bl         = 6'b0;
  assign p5_cmd_byte_addr  = 30'b0;
  assign p5_wr_clk         = 1'b0;
  assign p5_wr_en          = 1'b0;
  assign p5_wr_mask        = 4'b0;
  assign p5_wr_data        = 32'b0;
  assign p5_rd_clk         = 1'b0;
  assign p5_rd_en          = 1'b0;
  assign calib_recal       = 1'b0;
  assign ui_read           = 1'b0;
  assign ui_add            = 1'b0;
  assign ui_cs             = 1'b0;
  assign ui_sdi            = 1'b0;
  assign ui_addr           = 5'b0;
  assign ui_broadcast      = 1'b0;
  assign ui_drp_update     = 1'b0;
  assign ui_done_cal       = 1'b0;
  assign ui_cmd            = 1'b0;
  assign ui_cmd_in         = 1'b0;
  assign ui_cmd_en         = 1'b0;
  assign ui_dqcount        = 4'b0;
  assign ui_dq_lower_dec   = 1'b0;
  assign ui_dq_lower_inc   = 1'b0;
  assign ui_dq_upper_dec   = 1'b0;
  assign ui_dq_upper_inc   = 1'b0;
  assign ui_udqs_inc       = 1'b0;
  assign ui_udqs_dec       = 1'b0;
  assign ui_ldqs_inc       = 1'b0;
  assign ui_ldqs_dec       = 1'b0;
  assign selfrefresh_enter = 1'b0;

  generate
  if (C_SYS_RST_PRESENT) begin : USE_SYS_RST_TO_MCB
    assign ui_rst = sys_rst;
  end
  else if (C_S0_AXI_ENABLE) begin : USE_S0_AXI_ARESETN_TO_MCB
    assign ui_rst = ~s0_axi_aresetn;
  end
  else if (C_S1_AXI_ENABLE) begin : USE_S1_AXI_ARESETN_TO_MCB
    assign ui_rst = ~s1_axi_aresetn;
  end
  else if (C_S2_AXI_ENABLE) begin : USE_S2_AXI_ARESETN_TO_MCB
    assign ui_rst = ~s2_axi_aresetn;
  end
  else if (C_S3_AXI_ENABLE) begin : USE_S3_AXI_ARESETN_TO_MCB
    assign ui_rst = ~s3_axi_aresetn;
  end
  else if (C_S4_AXI_ENABLE) begin : USE_S4_AXI_ARESETN_TO_MCB
    assign ui_rst = ~s4_axi_aresetn;
  end
  else                      begin : USE_S5_AXI_ARESETN_TO_MCB
    assign ui_rst = ~s5_axi_aresetn;
  end
  endgenerate



      // Syncrhonize incoming reset to ui_clk domain
   mcb_ui_top_synch #(
     .C_SYNCH_WIDTH          ( 1 )
   )
   sys_rst_synch
   (
     .clk       ( ui_clk      ) ,
     .synch_in  ( ui_rst      ) ,
     .synch_out ( sys_rst_i   )
   );

   mcb_ui_top #
   (
   .C_MEMCLK_PERIOD            ( C_MEMCLK_PERIOD            ),
   .C_PORT_ENABLE              ( P_PORT_ENABLE              ),
   .C_MEM_ADDR_ORDER           ( C_MEM_ADDR_ORDER           ),
   .C_USR_INTERFACE_MODE       ( P_USR_INTERFACE_MODE       ),
   .C_ARB_ALGORITHM            ( C_ARB_ALGORITHM            ),
   .C_ARB_NUM_TIME_SLOTS       ( C_ARB_NUM_TIME_SLOTS       ),
   .C_ARB_TIME_SLOT_0          ( C_ARB_TIME_SLOT_0          ),
   .C_ARB_TIME_SLOT_1          ( C_ARB_TIME_SLOT_1          ),
   .C_ARB_TIME_SLOT_2          ( C_ARB_TIME_SLOT_2          ),
   .C_ARB_TIME_SLOT_3          ( C_ARB_TIME_SLOT_3          ),
   .C_ARB_TIME_SLOT_4          ( C_ARB_TIME_SLOT_4          ),
   .C_ARB_TIME_SLOT_5          ( C_ARB_TIME_SLOT_5          ),
   .C_ARB_TIME_SLOT_6          ( C_ARB_TIME_SLOT_6          ),
   .C_ARB_TIME_SLOT_7          ( C_ARB_TIME_SLOT_7          ),
   .C_ARB_TIME_SLOT_8          ( C_ARB_TIME_SLOT_8          ),
   .C_ARB_TIME_SLOT_9          ( C_ARB_TIME_SLOT_9          ),
   .C_ARB_TIME_SLOT_10         ( C_ARB_TIME_SLOT_10         ),
   .C_ARB_TIME_SLOT_11         ( C_ARB_TIME_SLOT_11         ),
   .C_PORT_CONFIG              ( C_PORT_CONFIG              ),
   .C_MEM_TRAS                 ( C_MEM_TRAS                 ),
   .C_MEM_TRCD                 ( C_MEM_TRCD                 ),
   .C_MEM_TREFI                ( C_MEM_TREFI                ),
   .C_MEM_TRFC                 ( C_MEM_TRFC                 ),
   .C_MEM_TRP                  ( C_MEM_TRP                  ),
   .C_MEM_TWR                  ( C_MEM_TWR                  ),
   .C_MEM_TRTP                 ( C_MEM_TRTP                 ),
   .C_MEM_TWTR                 ( C_MEM_TWTR                 ),
   .C_NUM_DQ_PINS              ( C_NUM_DQ_PINS              ),
   .C_MEM_TYPE                 ( C_MEM_TYPE                 ),
   .C_MEM_DENSITY              ( P_MEM_DENSITY              ),
   .C_MEM_BURST_LEN            ( P_MEM_BURST_LEN            ),
   .C_MEM_CAS_LATENCY          ( C_MEM_CAS_LATENCY          ),
   .C_MEM_ADDR_WIDTH           ( C_MEM_ADDR_WIDTH           ),
   .C_MEM_BANKADDR_WIDTH       ( C_MEM_BANKADDR_WIDTH       ),
   .C_MEM_NUM_COL_BITS         ( C_MEM_NUM_COL_BITS         ),
   .C_MEM_DDR3_CAS_LATENCY     ( C_MEM_DDR3_CAS_LATENCY     ),
   .C_MEM_MOBILE_PA_SR         ( C_MEM_MOBILE_PA_SR         ),
   .C_MEM_DDR1_2_ODS           ( C_MEM_DDR1_2_ODS           ),
   .C_MEM_DDR3_ODS             ( C_MEM_DDR3_ODS             ),
   .C_MEM_DDR2_RTT             ( C_MEM_DDR2_RTT             ),
   .C_MEM_DDR3_RTT             ( C_MEM_DDR3_RTT             ),
   .C_MEM_MDDR_ODS             ( C_MEM_MDDR_ODS             ),
   .C_MEM_DDR2_DIFF_DQS_EN     ( C_MEM_DDR2_DIFF_DQS_EN     ),
   .C_MEM_DDR2_3_PA_SR         ( C_MEM_DDR2_3_PA_SR         ),
   .C_MEM_DDR3_CAS_WR_LATENCY  ( C_MEM_DDR3_CAS_WR_LATENCY  ),
   .C_MEM_DDR3_AUTO_SR         ( C_MEM_DDR3_AUTO_SR         ),
   .C_MEM_DDR2_3_HIGH_TEMP_SR  ( C_MEM_DDR2_3_HIGH_TEMP_SR  ),
   .C_MEM_DDR3_DYN_WRT_ODT     ( P_MEM_DDR3_DYN_WRT_ODT     ),
   .C_MEM_TZQINIT_MAXCNT       ( C_MEM_TZQINIT_MAXCNT       ),
   .C_MC_CALIB_BYPASS          ( P_MC_CALIB_BYPASS          ),
   .C_MC_CALIBRATION_RA        ( P_MC_CALIBRATION_RA        ),
   .C_MC_CALIBRATION_BA        ( P_MC_CALIBRATION_BA        ),
   .C_CALIB_SOFT_IP            ( P_CALIB_SOFT_IP            ),
   .C_SKIP_IN_TERM_CAL         ( C_SKIP_IN_TERM_CAL         ),
   .C_SKIP_DYNAMIC_CAL         ( P_SKIP_DYNAMIC_CAL         ),
   .C_SKIP_DYN_IN_TERM         ( P_SKIP_DYN_IN_TERM         ),
   .LDQSP_TAP_DELAY_VAL        ( P_LDQSP_TAP_DELAY_VAL      ),
   .UDQSP_TAP_DELAY_VAL        ( P_UDQSP_TAP_DELAY_VAL      ),
   .LDQSN_TAP_DELAY_VAL        ( P_LDQSN_TAP_DELAY_VAL      ),
   .UDQSN_TAP_DELAY_VAL        ( P_UDQSN_TAP_DELAY_VAL      ),
   .DQ0_TAP_DELAY_VAL          ( P_DQ0_TAP_DELAY_VAL        ),
   .DQ1_TAP_DELAY_VAL          ( P_DQ1_TAP_DELAY_VAL        ),
   .DQ2_TAP_DELAY_VAL          ( P_DQ2_TAP_DELAY_VAL        ),
   .DQ3_TAP_DELAY_VAL          ( P_DQ3_TAP_DELAY_VAL        ),
   .DQ4_TAP_DELAY_VAL          ( P_DQ4_TAP_DELAY_VAL        ),
   .DQ5_TAP_DELAY_VAL          ( P_DQ5_TAP_DELAY_VAL        ),
   .DQ6_TAP_DELAY_VAL          ( P_DQ6_TAP_DELAY_VAL        ),
   .DQ7_TAP_DELAY_VAL          ( P_DQ7_TAP_DELAY_VAL        ),
   .DQ8_TAP_DELAY_VAL          ( P_DQ8_TAP_DELAY_VAL        ),
   .DQ9_TAP_DELAY_VAL          ( P_DQ9_TAP_DELAY_VAL        ),
   .DQ10_TAP_DELAY_VAL         ( P_DQ10_TAP_DELAY_VAL       ),
   .DQ11_TAP_DELAY_VAL         ( P_DQ11_TAP_DELAY_VAL       ),
   .DQ12_TAP_DELAY_VAL         ( P_DQ12_TAP_DELAY_VAL       ),
   .DQ13_TAP_DELAY_VAL         ( P_DQ13_TAP_DELAY_VAL       ),
   .DQ14_TAP_DELAY_VAL         ( P_DQ14_TAP_DELAY_VAL       ),
   .DQ15_TAP_DELAY_VAL         ( P_DQ15_TAP_DELAY_VAL       ),
   .C_MC_CALIBRATION_CA        ( P_MC_CALIBRATION_CA        ),
   .C_MC_CALIBRATION_CLK_DIV   ( P_MC_CALIBRATION_CLK_DIV   ),
   .C_MC_CALIBRATION_MODE      ( P_MC_CALIBRATION_MODE      ),
   .C_MC_CALIBRATION_DELAY     ( P_MC_CALIBRATION_DELAY     ),
   .C_SIMULATION               ( C_SIMULATION               ),
   .C_P0_MASK_SIZE             ( P_P0_MASK_SIZE             ),
   .C_P0_DATA_PORT_SIZE        ( P_P0_DATA_PORT_SIZE        ),
   .C_P1_MASK_SIZE             ( P_P1_MASK_SIZE             ),
   .C_P1_DATA_PORT_SIZE        ( P_P1_DATA_PORT_SIZE        ),
   .C_MCB_USE_EXTERNAL_BUFPLL  ( C_MCB_USE_EXTERNAL_BUFPLL  ),

   .C_S0_AXI_BASEADDR          ( C_S0_AXI_BASEADDR          ),
   .C_S0_AXI_HIGHADDR          ( C_S0_AXI_HIGHADDR          ),
   .C_S0_AXI_ENABLE            ( C_S0_AXI_ENABLE            ),
   .C_S0_AXI_ID_WIDTH          ( C_S0_AXI_ID_WIDTH          ),
   .C_S0_AXI_ADDR_WIDTH        ( C_S0_AXI_ADDR_WIDTH        ),
   .C_S0_AXI_DATA_WIDTH        ( C_S0_AXI_DATA_WIDTH        ),
   .C_S0_AXI_SUPPORTS_READ     ( C_S0_AXI_SUPPORTS_READ     ),
   .C_S0_AXI_SUPPORTS_WRITE    ( C_S0_AXI_SUPPORTS_WRITE    ),
   .C_S0_AXI_SUPPORTS_NARROW_BURST   ( C_S0_AXI_SUPPORTS_NARROW_BURST   ),
   .C_S0_AXI_REG_EN0           ( C_S0_AXI_REG_EN0           ),
   .C_S0_AXI_REG_EN1           ( C_S0_AXI_REG_EN1           ),
   .C_S0_AXI_STRICT_COHERENCY  ( C_S0_AXI_STRICT_COHERENCY  ),
   .C_S0_AXI_ENABLE_AP         ( C_S0_AXI_ENABLE_AP         ),
   .C_S1_AXI_BASEADDR          ( C_S1_AXI_BASEADDR          ),
   .C_S1_AXI_HIGHADDR          ( C_S1_AXI_HIGHADDR          ),
   .C_S1_AXI_ENABLE            ( C_S1_AXI_ENABLE            ),
   .C_S1_AXI_ID_WIDTH          ( C_S1_AXI_ID_WIDTH          ),
   .C_S1_AXI_ADDR_WIDTH        ( C_S1_AXI_ADDR_WIDTH        ),
   .C_S1_AXI_DATA_WIDTH        ( C_S1_AXI_DATA_WIDTH        ),
   .C_S1_AXI_SUPPORTS_READ     ( C_S1_AXI_SUPPORTS_READ     ),
   .C_S1_AXI_SUPPORTS_WRITE    ( C_S1_AXI_SUPPORTS_WRITE    ),
   .C_S1_AXI_SUPPORTS_NARROW_BURST   ( C_S1_AXI_SUPPORTS_NARROW_BURST   ),
   .C_S1_AXI_REG_EN0           ( C_S1_AXI_REG_EN0           ),
   .C_S1_AXI_REG_EN1           ( C_S1_AXI_REG_EN1           ),
   .C_S1_AXI_STRICT_COHERENCY  ( C_S1_AXI_STRICT_COHERENCY  ),
   .C_S1_AXI_ENABLE_AP         ( C_S1_AXI_ENABLE_AP         ),
   .C_S2_AXI_BASEADDR          ( C_S2_AXI_BASEADDR          ),
   .C_S2_AXI_HIGHADDR          ( C_S2_AXI_HIGHADDR          ),
   .C_S2_AXI_ENABLE            ( C_S2_AXI_ENABLE            ),
   .C_S2_AXI_ID_WIDTH          ( C_S2_AXI_ID_WIDTH          ),
   .C_S2_AXI_ADDR_WIDTH        ( C_S2_AXI_ADDR_WIDTH        ),
   .C_S2_AXI_DATA_WIDTH        ( C_S2_AXI_DATA_WIDTH        ),
   .C_S2_AXI_SUPPORTS_READ     ( C_S2_AXI_SUPPORTS_READ     ),
   .C_S2_AXI_SUPPORTS_WRITE    ( C_S2_AXI_SUPPORTS_WRITE    ),
   .C_S2_AXI_SUPPORTS_NARROW_BURST   ( C_S2_AXI_SUPPORTS_NARROW_BURST   ),
   .C_S2_AXI_REG_EN0           ( C_S2_AXI_REG_EN0           ),
   .C_S2_AXI_REG_EN1           ( C_S2_AXI_REG_EN1           ),
   .C_S2_AXI_STRICT_COHERENCY  ( C_S2_AXI_STRICT_COHERENCY  ),
   .C_S2_AXI_ENABLE_AP         ( C_S2_AXI_ENABLE_AP         ),
   .C_S3_AXI_BASEADDR          ( C_S3_AXI_BASEADDR          ),
   .C_S3_AXI_HIGHADDR          ( C_S3_AXI_HIGHADDR          ),
   .C_S3_AXI_ENABLE            ( C_S3_AXI_ENABLE            ),
   .C_S3_AXI_ID_WIDTH          ( C_S3_AXI_ID_WIDTH          ),
   .C_S3_AXI_ADDR_WIDTH        ( C_S3_AXI_ADDR_WIDTH        ),
   .C_S3_AXI_DATA_WIDTH        ( C_S3_AXI_DATA_WIDTH        ),
   .C_S3_AXI_SUPPORTS_READ     ( C_S3_AXI_SUPPORTS_READ     ),
   .C_S3_AXI_SUPPORTS_WRITE    ( C_S3_AXI_SUPPORTS_WRITE    ),
   .C_S3_AXI_SUPPORTS_NARROW_BURST   ( C_S3_AXI_SUPPORTS_NARROW_BURST   ),
   .C_S3_AXI_REG_EN0           ( C_S3_AXI_REG_EN0           ),
   .C_S3_AXI_REG_EN1           ( C_S3_AXI_REG_EN1           ),
   .C_S3_AXI_STRICT_COHERENCY  ( C_S3_AXI_STRICT_COHERENCY  ),
   .C_S3_AXI_ENABLE_AP         ( C_S3_AXI_ENABLE_AP         ),
   .C_S4_AXI_BASEADDR          ( C_S4_AXI_BASEADDR          ),
   .C_S4_AXI_HIGHADDR          ( C_S4_AXI_HIGHADDR          ),
   .C_S4_AXI_ENABLE            ( C_S4_AXI_ENABLE            ),
   .C_S4_AXI_ID_WIDTH          ( C_S4_AXI_ID_WIDTH          ),
   .C_S4_AXI_ADDR_WIDTH        ( C_S4_AXI_ADDR_WIDTH        ),
   .C_S4_AXI_DATA_WIDTH        ( C_S4_AXI_DATA_WIDTH        ),
   .C_S4_AXI_SUPPORTS_READ     ( C_S4_AXI_SUPPORTS_READ     ),
   .C_S4_AXI_SUPPORTS_WRITE    ( C_S4_AXI_SUPPORTS_WRITE    ),
   .C_S4_AXI_SUPPORTS_NARROW_BURST   ( C_S4_AXI_SUPPORTS_NARROW_BURST   ),
   .C_S4_AXI_REG_EN0           ( C_S4_AXI_REG_EN0           ),
   .C_S4_AXI_REG_EN1           ( C_S4_AXI_REG_EN1           ),
   .C_S4_AXI_STRICT_COHERENCY  ( C_S4_AXI_STRICT_COHERENCY  ),
   .C_S4_AXI_ENABLE_AP         ( C_S4_AXI_ENABLE_AP         ),
   .C_S5_AXI_BASEADDR          ( C_S5_AXI_BASEADDR          ),
   .C_S5_AXI_HIGHADDR          ( C_S5_AXI_HIGHADDR          ),
   .C_S5_AXI_ENABLE            ( C_S5_AXI_ENABLE            ),
   .C_S5_AXI_ID_WIDTH          ( C_S5_AXI_ID_WIDTH          ),
   .C_S5_AXI_ADDR_WIDTH        ( C_S5_AXI_ADDR_WIDTH        ),
   .C_S5_AXI_DATA_WIDTH        ( C_S5_AXI_DATA_WIDTH        ),
   .C_S5_AXI_SUPPORTS_READ     ( C_S5_AXI_SUPPORTS_READ     ),
   .C_S5_AXI_SUPPORTS_WRITE    ( C_S5_AXI_SUPPORTS_WRITE    ),
   .C_S5_AXI_SUPPORTS_NARROW_BURST   ( C_S5_AXI_SUPPORTS_NARROW_BURST   ),
   .C_S5_AXI_REG_EN0           ( C_S5_AXI_REG_EN0           ),
   .C_S5_AXI_REG_EN1           ( C_S5_AXI_REG_EN1           ),
   .C_S5_AXI_STRICT_COHERENCY  ( C_S5_AXI_STRICT_COHERENCY  ),
   .C_S5_AXI_ENABLE_AP         ( C_S5_AXI_ENABLE_AP         )
 ) mcb_ui_top_0
 (
    .sysclk_2x           ( sysclk_2x           ),
    .sysclk_2x_180       ( sysclk_2x_180       ),
    .pll_ce_0            ( pll_ce_0            ),
    .pll_ce_90           ( pll_ce_90           ),
    .sysclk_2x_bufpll_o  ( sysclk_2x_bufpll_o  ),
    .sysclk_2x_180_bufpll_o ( sysclk_2x_180_bufpll_o ),
    .pll_ce_0_bufpll_o   ( pll_ce_0_bufpll_o   ),
    .pll_ce_90_bufpll_o  ( pll_ce_90_bufpll_o  ),
    .pll_lock_bufpll_o   ( pll_lock_bufpll_o   ),
    .pll_lock            ( pll_lock            ),
    .sys_rst             ( sys_rst_i           ),
    .p0_arb_en           ( p0_arb_en           ),
    .p0_cmd_clk          ( p0_cmd_clk          ),
    .p0_cmd_en           ( p0_cmd_en           ),
    .p0_cmd_instr        ( p0_cmd_instr        ),
    .p0_cmd_bl           ( p0_cmd_bl           ),
    .p0_cmd_byte_addr    ( p0_cmd_byte_addr    ),
    .p0_cmd_empty        ( p0_cmd_empty        ),
    .p0_cmd_full         ( p0_cmd_full         ),
    .p0_wr_clk           ( p0_wr_clk           ),
    .p0_wr_en            ( p0_wr_en            ),
    .p0_wr_mask          ( p0_wr_mask          ),
    .p0_wr_data          ( p0_wr_data          ),
    .p0_wr_full          ( p0_wr_full          ),
    .p0_wr_empty         ( p0_wr_empty         ),
    .p0_wr_count         ( p0_wr_count         ),
    .p0_wr_underrun      ( p0_wr_underrun      ),
    .p0_wr_error         ( p0_wr_error         ),
    .p0_rd_clk           ( p0_rd_clk           ),
    .p0_rd_en            ( p0_rd_en            ),
    .p0_rd_data          ( p0_rd_data          ),
    .p0_rd_full          ( p0_rd_full          ),
    .p0_rd_empty         ( p0_rd_empty         ),
    .p0_rd_count         ( p0_rd_count         ),
    .p0_rd_overflow      ( p0_rd_overflow      ),
    .p0_rd_error         ( p0_rd_error         ),
    .p1_arb_en           ( p1_arb_en           ),
    .p1_cmd_clk          ( p1_cmd_clk          ),
    .p1_cmd_en           ( p1_cmd_en           ),
    .p1_cmd_instr        ( p1_cmd_instr        ),
    .p1_cmd_bl           ( p1_cmd_bl           ),
    .p1_cmd_byte_addr    ( p1_cmd_byte_addr    ),
    .p1_cmd_empty        ( p1_cmd_empty        ),
    .p1_cmd_full         ( p1_cmd_full         ),
    .p1_wr_clk           ( p1_wr_clk           ),
    .p1_wr_en            ( p1_wr_en            ),
    .p1_wr_mask          ( p1_wr_mask          ),
    .p1_wr_data          ( p1_wr_data          ),
    .p1_wr_full          ( p1_wr_full          ),
    .p1_wr_empty         ( p1_wr_empty         ),
    .p1_wr_count         ( p1_wr_count         ),
    .p1_wr_underrun      ( p1_wr_underrun      ),
    .p1_wr_error         ( p1_wr_error         ),
    .p1_rd_clk           ( p1_rd_clk           ),
    .p1_rd_en            ( p1_rd_en            ),
    .p1_rd_data          ( p1_rd_data          ),
    .p1_rd_full          ( p1_rd_full          ),
    .p1_rd_empty         ( p1_rd_empty         ),
    .p1_rd_count         ( p1_rd_count         ),
    .p1_rd_overflow      ( p1_rd_overflow      ),
    .p1_rd_error         ( p1_rd_error         ),
    .p2_arb_en           ( p2_arb_en           ),
    .p2_cmd_clk          ( p2_cmd_clk          ),
    .p2_cmd_en           ( p2_cmd_en           ),
    .p2_cmd_instr        ( p2_cmd_instr        ),
    .p2_cmd_bl           ( p2_cmd_bl           ),
    .p2_cmd_byte_addr    ( p2_cmd_byte_addr    ),
    .p2_cmd_empty        ( p2_cmd_empty        ),
    .p2_cmd_full         ( p2_cmd_full         ),
    .p2_wr_clk           ( p2_wr_clk           ),
    .p2_wr_en            ( p2_wr_en            ),
    .p2_wr_mask          ( p2_wr_mask          ),
    .p2_wr_data          ( p2_wr_data          ),
    .p2_wr_full          ( p2_wr_full          ),
    .p2_wr_empty         ( p2_wr_empty         ),
    .p2_wr_count         ( p2_wr_count         ),
    .p2_wr_underrun      ( p2_wr_underrun      ),
    .p2_wr_error         ( p2_wr_error         ),
    .p2_rd_clk           ( p2_rd_clk           ),
    .p2_rd_en            ( p2_rd_en            ),
    .p2_rd_data          ( p2_rd_data          ),
    .p2_rd_full          ( p2_rd_full          ),
    .p2_rd_empty         ( p2_rd_empty         ),
    .p2_rd_count         ( p2_rd_count         ),
    .p2_rd_overflow      ( p2_rd_overflow      ),
    .p2_rd_error         ( p2_rd_error         ),
    .p3_arb_en           ( p3_arb_en           ),
    .p3_cmd_clk          ( p3_cmd_clk          ),
    .p3_cmd_en           ( p3_cmd_en           ),
    .p3_cmd_instr        ( p3_cmd_instr        ),
    .p3_cmd_bl           ( p3_cmd_bl           ),
    .p3_cmd_byte_addr    ( p3_cmd_byte_addr    ),
    .p3_cmd_empty        ( p3_cmd_empty        ),
    .p3_cmd_full         ( p3_cmd_full         ),
    .p3_wr_clk           ( p3_wr_clk           ),
    .p3_wr_en            ( p3_wr_en            ),
    .p3_wr_mask          ( p3_wr_mask          ),
    .p3_wr_data          ( p3_wr_data          ),
    .p3_wr_full          ( p3_wr_full          ),
    .p3_wr_empty         ( p3_wr_empty         ),
    .p3_wr_count         ( p3_wr_count         ),
    .p3_wr_underrun      ( p3_wr_underrun      ),
    .p3_wr_error         ( p3_wr_error         ),
    .p3_rd_clk           ( p3_rd_clk           ),
    .p3_rd_en            ( p3_rd_en            ),
    .p3_rd_data          ( p3_rd_data          ),
    .p3_rd_full          ( p3_rd_full          ),
    .p3_rd_empty         ( p3_rd_empty         ),
    .p3_rd_count         ( p3_rd_count         ),
    .p3_rd_overflow      ( p3_rd_overflow      ),
    .p3_rd_error         ( p3_rd_error         ),
    .p4_arb_en           ( p4_arb_en           ),
    .p4_cmd_clk          ( p4_cmd_clk          ),
    .p4_cmd_en           ( p4_cmd_en           ),
    .p4_cmd_instr        ( p4_cmd_instr        ),
    .p4_cmd_bl           ( p4_cmd_bl           ),
    .p4_cmd_byte_addr    ( p4_cmd_byte_addr    ),
    .p4_cmd_empty        ( p4_cmd_empty        ),
    .p4_cmd_full         ( p4_cmd_full         ),
    .p4_wr_clk           ( p4_wr_clk           ),
    .p4_wr_en            ( p4_wr_en            ),
    .p4_wr_mask          ( p4_wr_mask          ),
    .p4_wr_data          ( p4_wr_data          ),
    .p4_wr_full          ( p4_wr_full          ),
    .p4_wr_empty         ( p4_wr_empty         ),
    .p4_wr_count         ( p4_wr_count         ),
    .p4_wr_underrun      ( p4_wr_underrun      ),
    .p4_wr_error         ( p4_wr_error         ),
    .p4_rd_clk           ( p4_rd_clk           ),
    .p4_rd_en            ( p4_rd_en            ),
    .p4_rd_data          ( p4_rd_data          ),
    .p4_rd_full          ( p4_rd_full          ),
    .p4_rd_empty         ( p4_rd_empty         ),
    .p4_rd_count         ( p4_rd_count         ),
    .p4_rd_overflow      ( p4_rd_overflow      ),
    .p4_rd_error         ( p4_rd_error         ),
    .p5_arb_en           ( p5_arb_en           ),
    .p5_cmd_clk          ( p5_cmd_clk          ),
    .p5_cmd_en           ( p5_cmd_en           ),
    .p5_cmd_instr        ( p5_cmd_instr        ),
    .p5_cmd_bl           ( p5_cmd_bl           ),
    .p5_cmd_byte_addr    ( p5_cmd_byte_addr    ),
    .p5_cmd_empty        ( p5_cmd_empty        ),
    .p5_cmd_full         ( p5_cmd_full         ),
    .p5_wr_clk           ( p5_wr_clk           ),
    .p5_wr_en            ( p5_wr_en            ),
    .p5_wr_mask          ( p5_wr_mask          ),
    .p5_wr_data          ( p5_wr_data          ),
    .p5_wr_full          ( p5_wr_full          ),
    .p5_wr_empty         ( p5_wr_empty         ),
    .p5_wr_count         ( p5_wr_count         ),
    .p5_wr_underrun      ( p5_wr_underrun      ),
    .p5_wr_error         ( p5_wr_error         ),
    .p5_rd_clk           ( p5_rd_clk           ),
    .p5_rd_en            ( p5_rd_en            ),
    .p5_rd_data          ( p5_rd_data          ),
    .p5_rd_full          ( p5_rd_full          ),
    .p5_rd_empty         ( p5_rd_empty         ),
    .p5_rd_count         ( p5_rd_count         ),
    .p5_rd_overflow      ( p5_rd_overflow      ),
    .p5_rd_error         ( p5_rd_error         ),
    .mcbx_dram_addr      ( mcbx_dram_addr      ),
    .mcbx_dram_ba        ( mcbx_dram_ba        ),
    .mcbx_dram_ras_n     ( mcbx_dram_ras_n     ),
    .mcbx_dram_cas_n     ( mcbx_dram_cas_n     ),
    .mcbx_dram_we_n      ( mcbx_dram_we_n      ),
    .mcbx_dram_cke       ( mcbx_dram_cke       ),
    .mcbx_dram_clk       ( mcbx_dram_clk       ),
    .mcbx_dram_clk_n     ( mcbx_dram_clk_n     ),
    .mcbx_dram_dq        ( mcbx_dram_dq        ),
    .mcbx_dram_dqs       ( mcbx_dram_dqs       ),
    .mcbx_dram_dqs_n     ( mcbx_dram_dqs_n     ),
    .mcbx_dram_udqs      ( mcbx_dram_udqs      ),
    .mcbx_dram_udqs_n    ( mcbx_dram_udqs_n    ),
    .mcbx_dram_udm       ( mcbx_dram_udm       ),
    .mcbx_dram_ldm       ( mcbx_dram_ldm       ),
    .mcbx_dram_odt       ( mcbx_dram_odt       ),
    .mcbx_dram_ddr3_rst  ( mcbx_dram_ddr3_rst  ),
    .calib_recal         ( calib_recal         ),
    .rzq                 ( rzq                 ),
    .zio                 ( zio                 ),
    .ui_read             ( ui_read             ),
    .ui_add              ( ui_add              ),
    .ui_cs               ( ui_cs               ),
    .ui_clk              ( ui_clk              ),
    .ui_sdi              ( ui_sdi              ),
    .ui_addr             ( ui_addr             ),
    .ui_broadcast        ( ui_broadcast        ),
    .ui_drp_update       ( ui_drp_update       ),
    .ui_done_cal         ( ui_done_cal         ),
    .ui_cmd              ( ui_cmd              ),
    .ui_cmd_in           ( ui_cmd_in           ),
    .ui_cmd_en           ( ui_cmd_en           ),
    .ui_dqcount          ( ui_dqcount          ),
    .ui_dq_lower_dec     ( ui_dq_lower_dec     ),
    .ui_dq_lower_inc     ( ui_dq_lower_inc     ),
    .ui_dq_upper_dec     ( ui_dq_upper_dec     ),
    .ui_dq_upper_inc     ( ui_dq_upper_inc     ),
    .ui_udqs_inc         ( ui_udqs_inc         ),
    .ui_udqs_dec         ( ui_udqs_dec         ),
    .ui_ldqs_inc         ( ui_ldqs_inc         ),
    .ui_ldqs_dec         ( ui_ldqs_dec         ),
    .uo_data             ( uo_data             ),
    .uo_data_valid       ( uo_data_valid       ),
    .uo_done_cal         ( uo_done_cal         ),
    .uo_cmd_ready_in     ( uo_cmd_ready_in     ),
    .uo_refrsh_flag      ( uo_refrsh_flag      ),
    .uo_cal_start        ( uo_cal_start        ),
    .uo_sdo              ( uo_sdo              ),
    .status              ( status              ),
    .selfrefresh_enter   ( selfrefresh_enter   ),
    .selfrefresh_mode    ( selfrefresh_mode    ),
       // AXI Signals
    .s0_axi_aclk         ( s0_axi_aclk         ),
    .s0_axi_aresetn      ( s0_axi_aresetn      ),
    .s0_axi_awid         ( s0_axi_awid         ),
    .s0_axi_awaddr       ( s0_axi_awaddr       ),
    .s0_axi_awlen        ( s0_axi_awlen        ),
    .s0_axi_awsize       ( s0_axi_awsize       ),
    .s0_axi_awburst      ( s0_axi_awburst      ),
    .s0_axi_awlock       ( s0_axi_awlock       ),
    .s0_axi_awcache      ( s0_axi_awcache      ),
    .s0_axi_awprot       ( s0_axi_awprot       ),
    .s0_axi_awqos        ( s0_axi_awqos        ),
    .s0_axi_awvalid      ( s0_axi_awvalid      ),
    .s0_axi_awready      ( s0_axi_awready      ),
    .s0_axi_wdata        ( s0_axi_wdata        ),
    .s0_axi_wstrb        ( s0_axi_wstrb        ),
    .s0_axi_wlast        ( s0_axi_wlast        ),
    .s0_axi_wvalid       ( s0_axi_wvalid       ),
    .s0_axi_wready       ( s0_axi_wready       ),
    .s0_axi_bid          ( s0_axi_bid          ),
    .s0_axi_bresp        ( s0_axi_bresp        ),
    .s0_axi_bvalid       ( s0_axi_bvalid       ),
    .s0_axi_bready       ( s0_axi_bready       ),
    .s0_axi_arid         ( s0_axi_arid         ),
    .s0_axi_araddr       ( s0_axi_araddr       ),
    .s0_axi_arlen        ( s0_axi_arlen        ),
    .s0_axi_arsize       ( s0_axi_arsize       ),
    .s0_axi_arburst      ( s0_axi_arburst      ),
    .s0_axi_arlock       ( s0_axi_arlock       ),
    .s0_axi_arcache      ( s0_axi_arcache      ),
    .s0_axi_arprot       ( s0_axi_arprot       ),
    .s0_axi_arqos        ( s0_axi_arqos        ),
    .s0_axi_arvalid      ( s0_axi_arvalid      ),
    .s0_axi_arready      ( s0_axi_arready      ),
    .s0_axi_rid          ( s0_axi_rid          ),
    .s0_axi_rdata        ( s0_axi_rdata        ),
    .s0_axi_rresp        ( s0_axi_rresp        ),
    .s0_axi_rlast        ( s0_axi_rlast        ),
    .s0_axi_rvalid       ( s0_axi_rvalid       ),
    .s0_axi_rready       ( s0_axi_rready       ),

    .s1_axi_aclk         ( s1_axi_aclk         ),
    .s1_axi_aresetn      ( s1_axi_aresetn      ),
    .s1_axi_awid         ( s1_axi_awid         ),
    .s1_axi_awaddr       ( s1_axi_awaddr       ),
    .s1_axi_awlen        ( s1_axi_awlen        ),
    .s1_axi_awsize       ( s1_axi_awsize       ),
    .s1_axi_awburst      ( s1_axi_awburst      ),
    .s1_axi_awlock       ( s1_axi_awlock       ),
    .s1_axi_awcache      ( s1_axi_awcache      ),
    .s1_axi_awprot       ( s1_axi_awprot       ),
    .s1_axi_awqos        ( s1_axi_awqos        ),
    .s1_axi_awvalid      ( s1_axi_awvalid      ),
    .s1_axi_awready      ( s1_axi_awready      ),
    .s1_axi_wdata        ( s1_axi_wdata        ),
    .s1_axi_wstrb        ( s1_axi_wstrb        ),
    .s1_axi_wlast        ( s1_axi_wlast        ),
    .s1_axi_wvalid       ( s1_axi_wvalid       ),
    .s1_axi_wready       ( s1_axi_wready       ),
    .s1_axi_bid          ( s1_axi_bid          ),
    .s1_axi_bresp        ( s1_axi_bresp        ),
    .s1_axi_bvalid       ( s1_axi_bvalid       ),
    .s1_axi_bready       ( s1_axi_bready       ),
    .s1_axi_arid         ( s1_axi_arid         ),
    .s1_axi_araddr       ( s1_axi_araddr       ),
    .s1_axi_arlen        ( s1_axi_arlen        ),
    .s1_axi_arsize       ( s1_axi_arsize       ),
    .s1_axi_arburst      ( s1_axi_arburst      ),
    .s1_axi_arlock       ( s1_axi_arlock       ),
    .s1_axi_arcache      ( s1_axi_arcache      ),
    .s1_axi_arprot       ( s1_axi_arprot       ),
    .s1_axi_arqos        ( s1_axi_arqos        ),
    .s1_axi_arvalid      ( s1_axi_arvalid      ),
    .s1_axi_arready      ( s1_axi_arready      ),
    .s1_axi_rid          ( s1_axi_rid          ),
    .s1_axi_rdata        ( s1_axi_rdata        ),
    .s1_axi_rresp        ( s1_axi_rresp        ),
    .s1_axi_rlast        ( s1_axi_rlast        ),
    .s1_axi_rvalid       ( s1_axi_rvalid       ),
    .s1_axi_rready       ( s1_axi_rready       ),

    .s2_axi_aclk         ( s2_axi_aclk         ),
    .s2_axi_aresetn      ( s2_axi_aresetn      ),
    .s2_axi_awid         ( s2_axi_awid         ),
    .s2_axi_awaddr       ( s2_axi_awaddr       ),
    .s2_axi_awlen        ( s2_axi_awlen        ),
    .s2_axi_awsize       ( s2_axi_awsize       ),
    .s2_axi_awburst      ( s2_axi_awburst      ),
    .s2_axi_awlock       ( s2_axi_awlock       ),
    .s2_axi_awcache      ( s2_axi_awcache      ),
    .s2_axi_awprot       ( s2_axi_awprot       ),
    .s2_axi_awqos        ( s2_axi_awqos        ),
    .s2_axi_awvalid      ( s2_axi_awvalid      ),
    .s2_axi_awready      ( s2_axi_awready      ),
    .s2_axi_wdata        ( s2_axi_wdata        ),
    .s2_axi_wstrb        ( s2_axi_wstrb        ),
    .s2_axi_wlast        ( s2_axi_wlast        ),
    .s2_axi_wvalid       ( s2_axi_wvalid       ),
    .s2_axi_wready       ( s2_axi_wready       ),
    .s2_axi_bid          ( s2_axi_bid          ),
    .s2_axi_bresp        ( s2_axi_bresp        ),
    .s2_axi_bvalid       ( s2_axi_bvalid       ),
    .s2_axi_bready       ( s2_axi_bready       ),
    .s2_axi_arid         ( s2_axi_arid         ),
    .s2_axi_araddr       ( s2_axi_araddr       ),
    .s2_axi_arlen        ( s2_axi_arlen        ),
    .s2_axi_arsize       ( s2_axi_arsize       ),
    .s2_axi_arburst      ( s2_axi_arburst      ),
    .s2_axi_arlock       ( s2_axi_arlock       ),
    .s2_axi_arcache      ( s2_axi_arcache      ),
    .s2_axi_arprot       ( s2_axi_arprot       ),
    .s2_axi_arqos        ( s2_axi_arqos        ),
    .s2_axi_arvalid      ( s2_axi_arvalid      ),
    .s2_axi_arready      ( s2_axi_arready      ),
    .s2_axi_rid          ( s2_axi_rid          ),
    .s2_axi_rdata        ( s2_axi_rdata        ),
    .s2_axi_rresp        ( s2_axi_rresp        ),
    .s2_axi_rlast        ( s2_axi_rlast        ),
    .s2_axi_rvalid       ( s2_axi_rvalid       ),
    .s2_axi_rready       ( s2_axi_rready       ),

    .s3_axi_aclk         ( s3_axi_aclk         ),
    .s3_axi_aresetn      ( s3_axi_aresetn      ),
    .s3_axi_awid         ( s3_axi_awid         ),
    .s3_axi_awaddr       ( s3_axi_awaddr       ),
    .s3_axi_awlen        ( s3_axi_awlen        ),
    .s3_axi_awsize       ( s3_axi_awsize       ),
    .s3_axi_awburst      ( s3_axi_awburst      ),
    .s3_axi_awlock       ( s3_axi_awlock       ),
    .s3_axi_awcache      ( s3_axi_awcache      ),
    .s3_axi_awprot       ( s3_axi_awprot       ),
    .s3_axi_awqos        ( s3_axi_awqos        ),
    .s3_axi_awvalid      ( s3_axi_awvalid      ),
    .s3_axi_awready      ( s3_axi_awready      ),
    .s3_axi_wdata        ( s3_axi_wdata        ),
    .s3_axi_wstrb        ( s3_axi_wstrb        ),
    .s3_axi_wlast        ( s3_axi_wlast        ),
    .s3_axi_wvalid       ( s3_axi_wvalid       ),
    .s3_axi_wready       ( s3_axi_wready       ),
    .s3_axi_bid          ( s3_axi_bid          ),
    .s3_axi_bresp        ( s3_axi_bresp        ),
    .s3_axi_bvalid       ( s3_axi_bvalid       ),
    .s3_axi_bready       ( s3_axi_bready       ),
    .s3_axi_arid         ( s3_axi_arid         ),
    .s3_axi_araddr       ( s3_axi_araddr       ),
    .s3_axi_arlen        ( s3_axi_arlen        ),
    .s3_axi_arsize       ( s3_axi_arsize       ),
    .s3_axi_arburst      ( s3_axi_arburst      ),
    .s3_axi_arlock       ( s3_axi_arlock       ),
    .s3_axi_arcache      ( s3_axi_arcache      ),
    .s3_axi_arprot       ( s3_axi_arprot       ),
    .s3_axi_arqos        ( s3_axi_arqos        ),
    .s3_axi_arvalid      ( s3_axi_arvalid      ),
    .s3_axi_arready      ( s3_axi_arready      ),
    .s3_axi_rid          ( s3_axi_rid          ),
    .s3_axi_rdata        ( s3_axi_rdata        ),
    .s3_axi_rresp        ( s3_axi_rresp        ),
    .s3_axi_rlast        ( s3_axi_rlast        ),
    .s3_axi_rvalid       ( s3_axi_rvalid       ),
    .s3_axi_rready       ( s3_axi_rready       ),

    .s4_axi_aclk         ( s4_axi_aclk         ),
    .s4_axi_aresetn      ( s4_axi_aresetn      ),
    .s4_axi_awid         ( s4_axi_awid         ),
    .s4_axi_awaddr       ( s4_axi_awaddr       ),
    .s4_axi_awlen        ( s4_axi_awlen        ),
    .s4_axi_awsize       ( s4_axi_awsize       ),
    .s4_axi_awburst      ( s4_axi_awburst      ),
    .s4_axi_awlock       ( s4_axi_awlock       ),
    .s4_axi_awcache      ( s4_axi_awcache      ),
    .s4_axi_awprot       ( s4_axi_awprot       ),
    .s4_axi_awqos        ( s4_axi_awqos        ),
    .s4_axi_awvalid      ( s4_axi_awvalid      ),
    .s4_axi_awready      ( s4_axi_awready      ),
    .s4_axi_wdata        ( s4_axi_wdata        ),
    .s4_axi_wstrb        ( s4_axi_wstrb        ),
    .s4_axi_wlast        ( s4_axi_wlast        ),
    .s4_axi_wvalid       ( s4_axi_wvalid       ),
    .s4_axi_wready       ( s4_axi_wready       ),
    .s4_axi_bid          ( s4_axi_bid          ),
    .s4_axi_bresp        ( s4_axi_bresp        ),
    .s4_axi_bvalid       ( s4_axi_bvalid       ),
    .s4_axi_bready       ( s4_axi_bready       ),
    .s4_axi_arid         ( s4_axi_arid         ),
    .s4_axi_araddr       ( s4_axi_araddr       ),
    .s4_axi_arlen        ( s4_axi_arlen        ),
    .s4_axi_arsize       ( s4_axi_arsize       ),
    .s4_axi_arburst      ( s4_axi_arburst      ),
    .s4_axi_arlock       ( s4_axi_arlock       ),
    .s4_axi_arcache      ( s4_axi_arcache      ),
    .s4_axi_arprot       ( s4_axi_arprot       ),
    .s4_axi_arqos        ( s4_axi_arqos        ),
    .s4_axi_arvalid      ( s4_axi_arvalid      ),
    .s4_axi_arready      ( s4_axi_arready      ),
    .s4_axi_rid          ( s4_axi_rid          ),
    .s4_axi_rdata        ( s4_axi_rdata        ),
    .s4_axi_rresp        ( s4_axi_rresp        ),
    .s4_axi_rlast        ( s4_axi_rlast        ),
    .s4_axi_rvalid       ( s4_axi_rvalid       ),
    .s4_axi_rready       ( s4_axi_rready       ),

    .s5_axi_aclk         ( s5_axi_aclk         ),
    .s5_axi_aresetn      ( s5_axi_aresetn      ),
    .s5_axi_awid         ( s5_axi_awid         ),
    .s5_axi_awaddr       ( s5_axi_awaddr       ),
    .s5_axi_awlen        ( s5_axi_awlen        ),
    .s5_axi_awsize       ( s5_axi_awsize       ),
    .s5_axi_awburst      ( s5_axi_awburst      ),
    .s5_axi_awlock       ( s5_axi_awlock       ),
    .s5_axi_awcache      ( s5_axi_awcache      ),
    .s5_axi_awprot       ( s5_axi_awprot       ),
    .s5_axi_awqos        ( s5_axi_awqos        ),
    .s5_axi_awvalid      ( s5_axi_awvalid      ),
    .s5_axi_awready      ( s5_axi_awready      ),
    .s5_axi_wdata        ( s5_axi_wdata        ),
    .s5_axi_wstrb        ( s5_axi_wstrb        ),
    .s5_axi_wlast        ( s5_axi_wlast        ),
    .s5_axi_wvalid       ( s5_axi_wvalid       ),
    .s5_axi_wready       ( s5_axi_wready       ),
    .s5_axi_bid          ( s5_axi_bid          ),
    .s5_axi_bresp        ( s5_axi_bresp        ),
    .s5_axi_bvalid       ( s5_axi_bvalid       ),
    .s5_axi_bready       ( s5_axi_bready       ),
    .s5_axi_arid         ( s5_axi_arid         ),
    .s5_axi_araddr       ( s5_axi_araddr       ),
    .s5_axi_arlen        ( s5_axi_arlen        ),
    .s5_axi_arsize       ( s5_axi_arsize       ),
    .s5_axi_arburst      ( s5_axi_arburst      ),
    .s5_axi_arlock       ( s5_axi_arlock       ),
    .s5_axi_arcache      ( s5_axi_arcache      ),
    .s5_axi_arprot       ( s5_axi_arprot       ),
    .s5_axi_arqos        ( s5_axi_arqos        ),
    .s5_axi_arvalid      ( s5_axi_arvalid      ),
    .s5_axi_arready      ( s5_axi_arready      ),
    .s5_axi_rid          ( s5_axi_rid          ),
    .s5_axi_rdata        ( s5_axi_rdata        ),
    .s5_axi_rresp        ( s5_axi_rresp        ),
    .s5_axi_rlast        ( s5_axi_rlast        ),
    .s5_axi_rvalid       ( s5_axi_rvalid       ),
    .s5_axi_rready       ( s5_axi_rready       )
   );

endmodule

