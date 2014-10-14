###############################################################################
##
## (c) Copyright [2003] - [2011] Xilinx, Inc. All rights reserved.
## 
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and 
## international copyright and other intellectual property
## laws.
## 
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
## 
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
## 
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES
##
###############################################################################
##
## lmb_v10_v2_1_0.tcl
##
###############################################################################

proc check_iplevel_settings {mhsinst} {
    # check bus connectivity will be done in platgen
}

proc connected_lmb_source { mhsinst } {
    set mhs_handle [xget_hw_parent_handle $mhsinst]

    set mb ""
    set addrstrobe_con [xget_hw_port_value $mhsinst "M_AddrStrobe"] 
    if { [llength $addrstrobe_con] > 0} {
      set addrstrobe_source [xget_connected_ports_handle $mhs_handle $addrstrobe_con "SOURCE"]
      if {[llength $addrstrobe_source] != 0} {
        set mb [xget_hw_parent_handle $addrstrobe_source]
      }
    }

    if {$mb != ""} {
      return $mb
    }
    return ""
}

#***--------------------------------***-----------------------------------***
#
#			     CORE_LEVEL_CONSTRAINTS
#
#***--------------------------------***-----------------------------------***

proc generate_corelevel_ucf {mhsinst} {

   set  filePath [xget_ncf_dir $mhsinst]

   file mkdir    $filePath

   # specify file name
   set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
   set    name_lower [string 	  tolower    $instname]
   set    fileName   $name_lower
   append filePath   $fileName

   # Open UCF file for writing and delete XDC file (if any)
   set outputFileUcf [open "${filePath}_wrapper.ucf" "w"]
   file delete -force "${filePath}.xdc"

   # Add TIG constraints for SYS_Rst when AXI is used
   set mbmhsinst [connected_lmb_source $mhsinst]
   if {$mbmhsinst != ""} {
      set interconnect [xget_hw_parameter_value $mbmhsinst "C_INTERCONNECT"]
      if {$interconnect == 2} {
        puts "INFO: Setting timing constaints for ${instname}."

        puts $outputFileUcf "INST \"${name_lower}/POR_FF_I\" TNM = \"${name_lower}_POR_FF_I_dst\";"
        puts $outputFileUcf "TIMESPEC \"TS_TIG_${name_lower}_POR_FF_I\" = FROM FFS TO \"${name_lower}_POR_FF_I_dst\" TIG;"

	# Open XDC file for writing, write constraint, and close the file
        set outputFileXdc [open "${filePath}.xdc" "w"]
        puts $outputFileXdc "set_false_path -to \[get_pins \"POR_FF_I/S\"\]"
        close $outputFileXdc
      }
   }

   # Close the UCF file
   close  $outputFileUcf

   puts   [xget_ncf_loc_info $mhsinst]
}
