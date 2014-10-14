// -- (c) Copyright 2011 Xilinx, Inc. All rights reserved.
// --
// -- This file contains confidential and proprietary information
// -- of Xilinx, Inc. and is protected under U.S. and 
// -- international copyright and other intellectual property
// -- laws.
// --
// -- DISCLAIMER
// -- This disclaimer is not a license and does not grant any
// -- rights to the materials distributed herewith. Except as
// -- otherwise provided in a valid license issued to you by
// -- Xilinx, and to the maximum extent permitted by applicable
// -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// -- (2) Xilinx shall not be liable (whether in contract or tort,
// -- including negligence, or under any other theory of
// -- liability) for any loss or damage of any kind or nature
// -- related to, arising under or in connection with these
// -- materials, including for any direct, or any indirect,
// -- special, incidental, or consequential loss or damage
// -- (including loss of data, profits, goodwill, or any type of
// -- loss or damage suffered as a result of any action brought
// -- by a third party) even if such damage or loss was
// -- reasonably foreseeable or Xilinx had been advised of the
// -- possibility of the same.
// --
// -- CRITICAL APPLICATIONS
// -- Xilinx products are not designed or intended to be fail-
// -- safe, or for use in any application requiring fail-safe
// -- performance, such as life-support or safety devices or
// -- systems, Class III medical devices, nuclear facilities,
// -- applications related to the deployment of airbags, or any
// -- other applications that could lead to death, personal
// -- injury, or severe property or environmental damage
// -- (individually and collectively, "Critical
// -- Applications"). Customer assumes the sole risk and
// -- liability of any use of Xilinx products in Critical
// -- Applications, subject only to applicable laws and
// -- regulations governing limitations on product liability.
// --
// -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// -- PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------
//
// axisc_downsizer
//   Convert from SI data width < MI datawidth.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axisc_upsizer #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY             = "virtex6",
   parameter integer C_S_AXIS_TDATA_WIDTH = 32,
   parameter integer C_M_AXIS_TDATA_WIDTH = 96,
   parameter integer C_AXIS_TID_WIDTH     = 1,
   parameter integer C_AXIS_TDEST_WIDTH   = 1,
   parameter integer C_S_AXIS_TUSER_WIDTH = 1,
   parameter integer C_M_AXIS_TUSER_WIDTH = 3,
   parameter [31:0]  C_AXIS_SIGNAL_SET    = 32'hFF ,
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
   parameter integer C_RATIO = 3   // Should always be 1:C_RATIO (upsizer)
   )
  (
///////////////////////////////////////////////////////////////////////////////
// Port Declarations
///////////////////////////////////////////////////////////////////////////////
   // System Signals
   input wire ACLK,
   input wire ARESETN,
   input wire ACLKEN,

   // Slave side
   input  wire                              S_AXIS_TVALID,
   output wire                              S_AXIS_TREADY,
   input  wire [C_S_AXIS_TDATA_WIDTH-1:0]   S_AXIS_TDATA,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TSTRB,
   input  wire [C_S_AXIS_TDATA_WIDTH/8-1:0] S_AXIS_TKEEP,
   input  wire                              S_AXIS_TLAST,
   input  wire [C_AXIS_TID_WIDTH-1:0]       S_AXIS_TID,
   input  wire [C_AXIS_TDEST_WIDTH-1:0]     S_AXIS_TDEST,
   input  wire [C_S_AXIS_TUSER_WIDTH-1:0]   S_AXIS_TUSER,

   // Master side
   output wire                              M_AXIS_TVALID,
   input  wire                              M_AXIS_TREADY,
   output wire [C_M_AXIS_TDATA_WIDTH-1:0]   M_AXIS_TDATA,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TSTRB,
   output wire [C_M_AXIS_TDATA_WIDTH/8-1:0] M_AXIS_TKEEP,
   output wire                              M_AXIS_TLAST,
   output wire [C_AXIS_TID_WIDTH-1:0]       M_AXIS_TID,
   output wire [C_AXIS_TDEST_WIDTH-1:0]     M_AXIS_TDEST,
   output wire [C_M_AXIS_TUSER_WIDTH-1:0]   M_AXIS_TUSER
   );

////////////////////////////////////////////////////////////////////////////////
// Functions
////////////////////////////////////////////////////////////////////////////////
//`include "axis_infrastructure.v"
//--------------------------------------------------------------------------
///////////////////////////////////////////////////////////////////////////////
// BEGIN Global Parameters
///////////////////////////////////////////////////////////////////////////////
// Define Signal Set indices
localparam G_INDX_SS_READY = 0;
localparam G_INDX_SS_DATA  = 1;
localparam G_INDX_SS_STRB  = 2;
localparam G_INDX_SS_KEEP  = 3;
localparam G_INDX_SS_LAST  = 4;
localparam G_INDX_SS_ID    = 5;
localparam G_INDX_SS_DEST  = 6;
localparam G_INDX_SS_USER  = 7;

///////////////////////////////////////////////////////////////////////////////
// BEGIN Functions
///////////////////////////////////////////////////////////////////////////////
// ceiling logb2
  function integer f_clogb2 (input integer size);
    begin
      size = size - 1;
      for (f_clogb2=1; size>1; f_clogb2=f_clogb2+1)
            size = size >> 1;
    end
  endfunction // clogb2

  // Calculates the Greatest Common Divisor between two integers using the
  // euclidean algorithm.
  function integer f_gcd (
    input integer a,
    input integer b
    );
    begin : main
      if (a == 0) begin
        f_gcd = b;
      end else if (b == 0) begin
        f_gcd = a;
      end else if (a > b) begin
        f_gcd = f_gcd(a % b, b);
      end else begin
        f_gcd = f_gcd(a, b % a);
      end
    end
  endfunction

  // Calculates the Lowest Common Denominator between two integers
  function integer f_lcm (
    input integer a,
    input integer b
    );
    begin : main
      f_lcm = ( a / f_gcd(a, b)) * b; 
    end
  endfunction

  // Returns back the index to the TDATA portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tdata_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      f_get_tdata_indx = 0;
    end
  endfunction

  // Returns back the index to the tstrb portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tstrb_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tdata_indx(DAW, IDW, DEW, USW, SST);
      // If TDATA exists, then add its width to its base to get the tstrb index
      f_get_tstrb_indx = SST[G_INDX_SS_DATA] ? cur_indx + DAW : cur_indx;
    end
  endfunction

  // Returns back the index to the tkeep portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tkeep_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tstrb_indx(DAW, IDW, DEW, USW, SST);
      f_get_tkeep_indx = SST[G_INDX_SS_STRB] ? cur_indx + DAW/8 : cur_indx;
    end
  endfunction

  // Returns back the index to the tlast portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tlast_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tkeep_indx(DAW, IDW, DEW, USW, SST);
      f_get_tlast_indx = SST[G_INDX_SS_KEEP] ? cur_indx + DAW/8 : cur_indx;
    end
  endfunction

  // Returns back the index to the tid portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tid_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tlast_indx(DAW, IDW, DEW, USW, SST);
      f_get_tid_indx = SST[G_INDX_SS_LAST] ? cur_indx + 1 : cur_indx;
    end
  endfunction

  // Returns back the index to the tdest portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tdest_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tid_indx(DAW, IDW, DEW, USW, SST);
      f_get_tdest_indx = SST[G_INDX_SS_ID] ? cur_indx + IDW : cur_indx;
    end
  endfunction

  // Returns back the index to the tuser portion of TPAYLOAD, returns 0 if the
  // signal is not enabled.
  function integer f_get_tuser_indx (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tdest_indx(DAW, IDW, DEW, USW, SST);
      f_get_tuser_indx = SST[G_INDX_SS_DEST] ? cur_indx + DEW : cur_indx;
    end
  endfunction

  // Payload is the sum of all the AXIS signals present except for
  // TREADY/TVALID
  function integer f_payload_width (
    input integer DAW,  // TDATA Width
    input integer IDW,  // TID Width
    input integer DEW,  // TDEST Width
    input integer USW,  // TUSER Width
    input [31:0]  SST   // Signal Set
    );
    begin : main
      integer cur_indx;
      cur_indx = f_get_tuser_indx(DAW, IDW, DEW, USW, SST);
      f_payload_width = SST[G_INDX_SS_USER] ? cur_indx + USW : cur_indx;
      // Ensure that the return value is never less than 1
      f_payload_width = (f_payload_width < 1) ? 1 : f_payload_width;
    end
  endfunction
////////////////////////////////////////////////////////////////////////////////
// Local parameters
////////////////////////////////////////////////////////////////////////////////
localparam P_READY_EXIST = C_AXIS_SIGNAL_SET[0];
localparam P_DATA_EXIST  = C_AXIS_SIGNAL_SET[1];
localparam P_STRB_EXIST  = C_AXIS_SIGNAL_SET[2];
localparam P_KEEP_EXIST  = C_AXIS_SIGNAL_SET[3];
localparam P_LAST_EXIST  = C_AXIS_SIGNAL_SET[4];
localparam P_ID_EXIST    = C_AXIS_SIGNAL_SET[5];
localparam P_DEST_EXIST  = C_AXIS_SIGNAL_SET[6];
localparam P_USER_EXIST  = C_AXIS_SIGNAL_SET[7];
localparam P_S_AXIS_TSTRB_WIDTH = C_S_AXIS_TDATA_WIDTH/8;
localparam P_M_AXIS_TSTRB_WIDTH = C_M_AXIS_TDATA_WIDTH/8;

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////
wire                            ARESET;
reg  [C_M_AXIS_TDATA_WIDTH-1:0] acc_data;
reg  [P_M_AXIS_TSTRB_WIDTH-1:0] acc_strb;
reg  [P_M_AXIS_TSTRB_WIDTH-1:0] acc_keep;
reg                             acc_last;
reg  [C_AXIS_TID_WIDTH-1:0]     acc_id;
reg  [C_AXIS_TDEST_WIDTH-1:0]   acc_dest;
reg  [C_M_AXIS_TUSER_WIDTH-1:0] acc_user;
wire [P_M_AXIS_TSTRB_WIDTH-1:0] acc_strb_mux;
wire [P_M_AXIS_TSTRB_WIDTH-1:0] acc_keep_mux;
reg                             acc_valid;
wire                            acc_valid_ns;

wire                            acc_complete;
wire                            normal_completion;
wire                            last_completion;
wire                            id_dest_completion;
wire                            id_match;
wire                            dest_match;
                                
wire [C_RATIO-1:0]              acc_reg_en;
reg  [C_RATIO-1:0]              acc_reg_sel;
reg  [C_RATIO-1:0]              acc_reg_valid;
wire                            acc_reg_sel_reset;
wire                            acc_reg_sel_advance;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////

assign ARESET = ~ARESETN;
// Assign outputs

assign M_AXIS_TDATA = acc_data;
assign M_AXIS_TSTRB = acc_strb_mux;
assign M_AXIS_TKEEP = acc_keep_mux;
assign M_AXIS_TLAST = acc_last;
assign M_AXIS_TID   = acc_id;
assign M_AXIS_TDEST = acc_dest;
assign M_AXIS_TUSER = acc_user;
assign M_AXIS_TVALID = acc_valid;
assign S_AXIS_TREADY = (M_AXIS_TVALID & ~M_AXIS_TREADY) | (id_dest_completion ) ? 1'b0 : 1'b1;

always @(posedge ACLK) begin 
  if (ARESET) begin
    acc_valid <= 1'b0;
  end else if (ACLKEN) begin
    acc_valid <= acc_valid_ns;
  end
end

// acc_complete == 1 indicates the data is ready to be sent downstream.
// Assert acc_valid until M_AXIS_TREADY is received.
assign acc_valid_ns = (acc_valid & ~(M_AXIS_TREADY & M_AXIS_TVALID)) | acc_complete;

assign acc_complete = normal_completion | last_completion | id_dest_completion;

assign normal_completion = acc_reg_en[C_RATIO-1];

assign last_completion = P_LAST_EXIST ? S_AXIS_TLAST & S_AXIS_TVALID & S_AXIS_TREADY : 1'b0;

assign id_match = P_ID_EXIST ? acc_reg_sel[0] | (S_AXIS_TID == acc_id) : 1'b1;
assign dest_match = P_DEST_EXIST ? acc_reg_sel[0] | (S_AXIS_TDEST == acc_dest) : 1'b1;

assign id_dest_completion = (~id_match | ~dest_match) & S_AXIS_TVALID;

assign acc_reg_en = acc_reg_sel & {C_RATIO{S_AXIS_TREADY & S_AXIS_TVALID}};

generate 
 genvar i;
 // DATA/USER/STRB/KEEP accumulators
 for (i = 0; i < C_RATIO; i = i + 1) begin : gen_data_accumulator_
   always @(posedge ACLK) begin
     if (ACLKEN) begin
       acc_data[i*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH] = acc_reg_en[i] ? S_AXIS_TDATA : acc_data[i*C_S_AXIS_TDATA_WIDTH+:C_S_AXIS_TDATA_WIDTH];
       acc_user[i*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH] = acc_reg_en[i] ? S_AXIS_TUSER : acc_user[i*C_S_AXIS_TUSER_WIDTH+:C_S_AXIS_TUSER_WIDTH];
       acc_strb[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] = acc_reg_en[i] ? S_AXIS_TSTRB : acc_strb[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
       acc_keep[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] = acc_reg_en[i] ? S_AXIS_TKEEP : acc_keep[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH];
     end
   end
 end
 // last register is loaded on the first beat and then if any beat has
 // last asserted, it will assert the acc_last. 
 always @(posedge ACLK) begin
   if (ACLKEN) begin
     acc_last  <= (S_AXIS_TVALID & S_AXIS_TREADY) ? S_AXIS_TLAST : acc_last;
   end
 end

 // ID/DEST loaded on first beat. 
 always @(posedge ACLK) begin
   if (ACLKEN) begin
     acc_id <= acc_reg_en[0] ? S_AXIS_TID : acc_id;
     acc_dest <= acc_reg_en[0] ? S_AXIS_TDEST : acc_dest;
   end
 end
 // strb/keep have a muxed output.  If the data item is not yet assigned, then
 // tkeep/tstrb are assigned to be null bytes
 for (i = 0; i < C_RATIO; i = i + 1) begin : gen_strb_keep_sel
   assign acc_strb_mux[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] = acc_reg_valid[i] ? acc_strb[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] :
                                                                          {P_S_AXIS_TSTRB_WIDTH{1'b0}};
   assign acc_keep_mux[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] = acc_reg_valid[i] ? acc_keep[i*P_S_AXIS_TSTRB_WIDTH+:P_S_AXIS_TSTRB_WIDTH] :
                                                                          {P_S_AXIS_TSTRB_WIDTH{1'b0}};
 end

 // Reg valid determines whether the data subset has been loaded yet.  This is
 // used to determine if tkeep/tstrb need to be assigned from input or assign
 // 0.
 for (i = 0; i < C_RATIO; i = i + 1) begin : gen_acc_reg_valid 
   always @(posedge ACLK) begin
     if (ACLKEN) begin
       acc_reg_valid[i] <= (i == 0) ? 1'b1 : (acc_reg_en[i] | acc_reg_valid[i]) & ~acc_reg_en[0];
     end
   end
 end

endgenerate

assign acc_reg_sel_reset = acc_complete;
assign acc_reg_sel_advance = S_AXIS_TVALID & S_AXIS_TREADY;

// Accumulator selector (1 hot left barrel shifter)
always @(posedge ACLK) begin
  if (ARESET) begin
    acc_reg_sel <= {{(C_RATIO-1){1'b0}}, 1'b1};
  end else if (ACLKEN) begin
    acc_reg_sel[0]            <= acc_reg_sel_reset ? 1'b1 : acc_reg_sel_advance ? acc_reg_sel[C_RATIO-1]    : acc_reg_sel[0];
    acc_reg_sel[1+:C_RATIO-1] <= acc_reg_sel_reset ? {C_RATIO-1{1'b0}} : acc_reg_sel_advance ? acc_reg_sel[0+:C_RATIO-1] : acc_reg_sel[1+:C_RATIO-1];
  end
end

endmodule // axisc_upsizer

`default_nettype wire
