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
// axis_width_converter
//   Converts data when C_S_AXIS_TDATA_WIDTH != C_M_AXIS_TDATA_WIDTH.
//
// Verilog-standard:  Verilog 2001
//--------------------------------------------------------------------------
//
// Structure:
//   axis_dwidth_converter
//     register_slice (instantiated with upsizer)
//     axisc_upsizer
//     axisc_downsizer
//     register_slice (instantiated with downsizer)
//
//--------------------------------------------------------------------------

`timescale 1ps/1ps
`default_nettype none

module axis_dwidth_converter #
(
///////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
///////////////////////////////////////////////////////////////////////////////
   parameter         C_FAMILY           = "virtex6",
   parameter integer C_S_AXIS_TDATA_WIDTH = 32,
   parameter integer C_M_AXIS_TDATA_WIDTH = 32,
   parameter integer C_AXIS_TID_WIDTH   = 1,
   parameter integer C_AXIS_TDEST_WIDTH = 1,
//   parameter integer C_AXIS_TUSER_BITS_PER_BYTE = 1, // Must be > 0 for width converter
   parameter integer C_S_AXIS_TUSER_WIDTH = 1,
   parameter integer C_M_AXIS_TUSER_WIDTH = 1,
   parameter [31:0]  C_AXIS_SIGNAL_SET  = 32'hFF
   // C_AXIS_SIGNAL_SET: each bit if enabled specifies which axis optional signals are present
   //   [0] => TREADY present
   //   [1] => TDATA present
   //   [2] => TSTRB present, TDATA must be present
   //   [3] => TKEEP present, TDATA must be present
   //   [4] => TLAST present
   //   [5] => TID present
   //   [6] => TDEST present
   //   [7] => TUSER present
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
localparam P_S_RATIO = f_lcm(C_S_AXIS_TDATA_WIDTH, C_M_AXIS_TDATA_WIDTH) / C_S_AXIS_TDATA_WIDTH;
localparam P_M_RATIO = f_lcm(C_S_AXIS_TDATA_WIDTH, C_M_AXIS_TDATA_WIDTH) / C_M_AXIS_TDATA_WIDTH;
localparam P_D2_TDATA_WIDTH = C_S_AXIS_TDATA_WIDTH * P_S_RATIO;
localparam P_D2_TUSER_WIDTH = C_S_AXIS_TUSER_WIDTH * P_S_RATIO;

localparam P_D0_REG_CONFIG = (P_S_RATIO > 1) ? 1 : 0;
localparam P_D3_REG_CONFIG = (P_M_RATIO > 1) ? 1 : 0;

////////////////////////////////////////////////////////////////////////////////
// Wires/Reg declarations
////////////////////////////////////////////////////////////////////////////////

// Output of first register stage
wire                              valid_d1;
wire                              ready_d1;
wire [C_S_AXIS_TDATA_WIDTH-1:0]   data_d1;
wire [C_S_AXIS_TDATA_WIDTH/8-1:0] strb_d1;
wire [C_S_AXIS_TDATA_WIDTH/8-1:0] keep_d1;
wire                              last_d1;
wire [C_AXIS_TID_WIDTH-1:0]       id_d1;
wire [C_AXIS_TDEST_WIDTH-1:0]     dest_d1;
wire [C_S_AXIS_TUSER_WIDTH-1:0]   user_d1;

// Output of upsizer stage
wire                              valid_d2;
wire                              ready_d2;
wire [P_D2_TDATA_WIDTH-1:0]       data_d2;
wire [P_D2_TDATA_WIDTH/8-1:0]     strb_d2;
wire [P_D2_TDATA_WIDTH/8-1:0]     keep_d2;
wire                              last_d2;
wire [C_AXIS_TID_WIDTH-1:0]       id_d2;
wire [C_AXIS_TDEST_WIDTH-1:0]     dest_d2;
wire [P_D2_TUSER_WIDTH-1:0]       user_d2;

// Output of downsizer stage
wire                              valid_d3;
wire                              ready_d3;
wire [C_M_AXIS_TDATA_WIDTH-1:0]   data_d3;
wire [C_M_AXIS_TDATA_WIDTH/8-1:0] strb_d3;
wire [C_M_AXIS_TDATA_WIDTH/8-1:0] keep_d3;
wire                              last_d3;
wire [C_AXIS_TID_WIDTH-1:0]       id_d3;
wire [C_AXIS_TDEST_WIDTH-1:0]     dest_d3;
wire [C_M_AXIS_TUSER_WIDTH-1:0]   user_d3;

////////////////////////////////////////////////////////////////////////////////
// BEGIN RTL
////////////////////////////////////////////////////////////////////////////////
axis_register_slice #(
  .C_FAMILY           ( C_FAMILY               ) ,
  .C_AXIS_TDATA_WIDTH ( C_S_AXIS_TDATA_WIDTH   ) ,
  .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH       ) ,
  .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH     ) ,
  .C_AXIS_TUSER_WIDTH ( C_S_AXIS_TUSER_WIDTH   ) ,
  .C_AXIS_SIGNAL_SET  ( C_AXIS_SIGNAL_SET      ) ,
  .C_REG_CONFIG       ( P_D0_REG_CONFIG        )
)
axis_register_slice_0
(
  .ACLK          ( ACLK          ) ,
  .ACLKEN        ( ACLKEN        ) ,
  .ARESETN       ( ARESETN       ) ,
  .S_AXIS_TVALID ( S_AXIS_TVALID ) ,
  .S_AXIS_TREADY ( S_AXIS_TREADY ) ,
  .S_AXIS_TDATA  ( S_AXIS_TDATA  ) ,
  .S_AXIS_TSTRB  ( S_AXIS_TSTRB  ) ,
  .S_AXIS_TKEEP  ( S_AXIS_TKEEP  ) ,
  .S_AXIS_TLAST  ( S_AXIS_TLAST  ) ,
  .S_AXIS_TID    ( S_AXIS_TID    ) ,
  .S_AXIS_TDEST  ( S_AXIS_TDEST  ) ,
  .S_AXIS_TUSER  ( S_AXIS_TUSER  ) ,
  .M_AXIS_TVALID ( valid_d1      ) ,
  .M_AXIS_TREADY ( ready_d1      ) ,
  .M_AXIS_TDATA  ( data_d1       ) ,
  .M_AXIS_TSTRB  ( strb_d1       ) ,
  .M_AXIS_TKEEP  ( keep_d1       ) ,
  .M_AXIS_TLAST  ( last_d1       ) ,
  .M_AXIS_TID    ( id_d1         ) ,
  .M_AXIS_TDEST  ( dest_d1       ) ,
  .M_AXIS_TUSER  ( user_d1       ) 
);


generate
  if (P_S_RATIO > 1) begin : gen_upsizer_conversion
    axisc_upsizer #(
      .C_FAMILY             ( C_FAMILY             ) ,
      .C_S_AXIS_TDATA_WIDTH ( C_S_AXIS_TDATA_WIDTH ) ,
      .C_M_AXIS_TDATA_WIDTH ( P_D2_TDATA_WIDTH     ) ,
      .C_AXIS_TID_WIDTH     ( C_AXIS_TID_WIDTH     ) ,
      .C_AXIS_TDEST_WIDTH   ( C_AXIS_TDEST_WIDTH   ) ,
      .C_S_AXIS_TUSER_WIDTH  ( C_S_AXIS_TUSER_WIDTH ) ,
      .C_M_AXIS_TUSER_WIDTH  ( P_D2_TUSER_WIDTH     ) ,
      .C_AXIS_SIGNAL_SET    ( C_AXIS_SIGNAL_SET    ) ,
      .C_RATIO              ( P_S_RATIO            ) 
    )
    axisc_upsizer_0 (
      .ACLK          ( ACLK     ) ,
      .ARESETN       ( ARESETN  ) ,
      .ACLKEN        ( ACLKEN   ) ,
      .S_AXIS_TVALID ( valid_d1 ) ,
      .S_AXIS_TREADY ( ready_d1 ) ,
      .S_AXIS_TDATA  ( data_d1  ) ,
      .S_AXIS_TSTRB  ( strb_d1  ) ,
      .S_AXIS_TKEEP  ( keep_d1  ) ,
      .S_AXIS_TLAST  ( last_d1  ) ,
      .S_AXIS_TID    ( id_d1    ) ,
      .S_AXIS_TDEST  ( dest_d1  ) ,
      .S_AXIS_TUSER  ( user_d1  ) ,
      .M_AXIS_TVALID ( valid_d2 ) ,
      .M_AXIS_TREADY ( ready_d2 ) ,
      .M_AXIS_TDATA  ( data_d2  ) ,
      .M_AXIS_TSTRB  ( strb_d2  ) ,
      .M_AXIS_TKEEP  ( keep_d2  ) ,
      .M_AXIS_TLAST  ( last_d2  ) ,
      .M_AXIS_TID    ( id_d2    ) ,
      .M_AXIS_TDEST  ( dest_d2  ) ,
      .M_AXIS_TUSER  ( user_d2  ) 
    );
  end
  else begin : gen_no_upsizer_passthru
    assign valid_d2 = valid_d1;
    assign ready_d1 = ready_d2;
    assign data_d2  = data_d1;
    assign strb_d2  = strb_d1;
    assign keep_d2  = keep_d1;
    assign last_d2  = last_d1;
    assign id_d2    = id_d1;
    assign dest_d2  = dest_d1;
    assign user_d2  = user_d1;
  end
  if (P_M_RATIO > 1) begin : gen_downsizer_conversion
    axisc_downsizer #(
      .C_FAMILY             ( C_FAMILY             ) ,
      .C_S_AXIS_TDATA_WIDTH ( P_D2_TDATA_WIDTH     ) ,
      .C_M_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH ) ,
      .C_AXIS_TID_WIDTH     ( C_AXIS_TID_WIDTH     ) ,
      .C_AXIS_TDEST_WIDTH   ( C_AXIS_TDEST_WIDTH   ) ,
      .C_S_AXIS_TUSER_WIDTH  ( P_D2_TUSER_WIDTH     ) ,
      .C_M_AXIS_TUSER_WIDTH  ( C_M_AXIS_TUSER_WIDTH ) ,
      .C_AXIS_SIGNAL_SET    ( C_AXIS_SIGNAL_SET    ) ,
      .C_RATIO              ( P_M_RATIO            ) 
    )
    axisc_downsizer_0 (
      .ACLK          ( ACLK     ) ,
      .ARESETN       ( ARESETN  ) ,
      .ACLKEN        ( ACLKEN   ) ,
      .S_AXIS_TVALID ( valid_d2 ) ,
      .S_AXIS_TREADY ( ready_d2 ) ,
      .S_AXIS_TDATA  ( data_d2  ) ,
      .S_AXIS_TSTRB  ( strb_d2  ) ,
      .S_AXIS_TKEEP  ( keep_d2  ) ,
      .S_AXIS_TLAST  ( last_d2  ) ,
      .S_AXIS_TID    ( id_d2    ) ,
      .S_AXIS_TDEST  ( dest_d2  ) ,
      .S_AXIS_TUSER  ( user_d2  ) ,
      .M_AXIS_TVALID ( valid_d3 ) ,
      .M_AXIS_TREADY ( ready_d3 ) ,
      .M_AXIS_TDATA  ( data_d3  ) ,
      .M_AXIS_TSTRB  ( strb_d3  ) ,
      .M_AXIS_TKEEP  ( keep_d3  ) ,
      .M_AXIS_TLAST  ( last_d3  ) ,
      .M_AXIS_TID    ( id_d3    ) ,
      .M_AXIS_TDEST  ( dest_d3  ) ,
      .M_AXIS_TUSER  ( user_d3  ) 
    );
  end
  else begin : gen_no_downsizer_passthru
    assign valid_d3 = valid_d2;
    assign ready_d2 = ready_d3;
    assign data_d3  = data_d2;
    assign strb_d3  = strb_d2;
    assign keep_d3  = keep_d2;
    assign last_d3  = last_d2;
    assign id_d3    = id_d2;
    assign dest_d3  = dest_d2;
    assign user_d3  = user_d2;
  end
endgenerate

axis_register_slice #(
  .C_FAMILY           ( C_FAMILY             ) ,
  .C_AXIS_TDATA_WIDTH ( C_M_AXIS_TDATA_WIDTH ) ,
  .C_AXIS_TID_WIDTH   ( C_AXIS_TID_WIDTH     ) ,
  .C_AXIS_TDEST_WIDTH ( C_AXIS_TDEST_WIDTH   ) ,
  .C_AXIS_TUSER_WIDTH ( C_M_AXIS_TUSER_WIDTH ) ,
  .C_AXIS_SIGNAL_SET  ( C_AXIS_SIGNAL_SET    ) ,
  .C_REG_CONFIG       ( P_D3_REG_CONFIG      )
)
axis_register_slice_1
(
  .ACLK          ( ACLK          ) ,
  .ACLKEN        ( ACLKEN        ) ,
  .ARESETN       ( ARESETN       ) ,
  .S_AXIS_TVALID ( valid_d3      ) ,
  .S_AXIS_TREADY ( ready_d3      ) ,
  .S_AXIS_TDATA  ( data_d3       ) ,
  .S_AXIS_TSTRB  ( strb_d3       ) ,
  .S_AXIS_TKEEP  ( keep_d3       ) ,
  .S_AXIS_TLAST  ( last_d3       ) ,
  .S_AXIS_TID    ( id_d3         ) ,
  .S_AXIS_TDEST  ( dest_d3       ) ,
  .S_AXIS_TUSER  ( user_d3       ) ,
  .M_AXIS_TVALID ( M_AXIS_TVALID ) ,
  .M_AXIS_TREADY ( M_AXIS_TREADY ) ,
  .M_AXIS_TDATA  ( M_AXIS_TDATA  ) ,
  .M_AXIS_TSTRB  ( M_AXIS_TSTRB  ) ,
  .M_AXIS_TKEEP  ( M_AXIS_TKEEP  ) ,
  .M_AXIS_TLAST  ( M_AXIS_TLAST  ) ,
  .M_AXIS_TID    ( M_AXIS_TID    ) ,
  .M_AXIS_TDEST  ( M_AXIS_TDEST  ) ,
  .M_AXIS_TUSER  ( M_AXIS_TUSER  ) 
);

endmodule // axis_dwidth_converter

`default_nettype wire
