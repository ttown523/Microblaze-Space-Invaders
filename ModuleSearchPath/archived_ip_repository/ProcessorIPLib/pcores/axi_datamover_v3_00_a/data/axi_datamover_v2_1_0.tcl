############################################################################
## DISCLAIMER OF LIABILITY
##
## (c) Copyright 2010,2011 Xilinx, Inc. All rights reserved.
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
## PART OF THIS FILE AT ALL TIMES.
##
###############################################################################
##
## Name     : axi_datamover_v2_1_0.tcl
## Desc     : USF TCL File
##
###############################################################################
#########proc generate_corelevel_ucf {mhsinst} {
#########    set filePath [xget_ncf_dir $mhsinst]
#########    file mkdir $filePath
#########
#########    # specify file name
#########    set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
#########    set    name_lower [string   tolower   $instname]
#########
#########    set    fileName   $name_lower
#########    append fileName   "_wrapper.ucf"
#########    append filePath   $fileName
#########
#########    # Open a file for writing
#########    set outputFile [open $filePath "w"]
#########
#########    set prmry_is_async [xget_hw_parameter_value $mhsinst "C_PRMRY_IS_ACLK_ASYNC"]    
#########    set include_sg [xget_hw_parameter_value $mhsinst "C_INCLUDE_SG"]    
#########    set include_mm2s [xget_hw_parameter_value $mhsinst "C_INCLUDE_MM2S"]
#########    set include_s2mm [xget_hw_parameter_value $mhsinst "C_INCLUDE_S2MM"]
#########   
#########    set lite_aclk_freq [xget_hw_parameter_value $mhsinst "C_S_AXI_LITE_ACLK_FREQ_HZ"]    
#########    set lite_aclk_period_ps [expr 1000000000000 / $lite_aclk_freq]
#########
#########    set sg_aclk_freq [xget_hw_parameter_value $mhsinst "C_M_AXI_SG_ACLK_FREQ_HZ"]    
#########    set sg_aclk_period_ps [expr 1000000000000 / $sg_aclk_freq]
#########
#########    set mm2s_aclk_freq [xget_hw_parameter_value $mhsinst "C_M_AXI_MM2S_ACLK_FREQ_HZ"]    
#########    set mm2s_aclk_period_ps [expr 1000000000000 / $mm2s_aclk_freq]
#########
#########    set s2mm_aclk_freq [xget_hw_parameter_value $mhsinst "C_M_AXI_S2MM_ACLK_FREQ_HZ"]    
#########    set s2mm_aclk_period_ps [expr 1000000000000 / $s2mm_aclk_freq]
#########
#########    ## Create datapath only constraints depending on async or sync mode  
#########    if { $prmry_is_async == 0} {
#########   	puts $outputFile "## INFO: No clock crossing in ${instname}."
#########    } else {
#########	    if { $include_sg == 0} {
#########		puts $outputFile "NET \"s_axi_lite_aclk\" TNM_NET = \"s_axi_lite_aclk\";"
#########		if {$include_mm2s == 1} {
#########			puts $outputFile "NET \"m_axi_mm2s_aclk\" TNM_NET = \"m_axi_mm2s_aclk\";"
#########			puts $outputFile "TIMESPEC TS_${instname}_MM2S_AXIS_S2P = FROM \"s_axi_lite_aclk\" TO \"m_axi_mm2s_aclk\" ${mm2s_aclk_period_ps} PS DATAPATHONLY;"
#########			puts $outputFile "TIMESPEC TS_${instname}_MM2S_AXIS_P2S = FROM \"m_axi_mm2s_aclk\" TO \"s_axi_lite_aclk\" ${lite_aclk_period_ps} PS DATAPATHONLY;"
#########		}
#########		if {$include_s2mm == 1} {
#########			puts $outputFile "NET \"m_axi_s2mm_aclk\" TNM_NET = \"m_axi_s2mm_aclk\";"
#########			puts $outputFile "TIMESPEC TS_${instname}_S2MM_AXIS_S2P = FROM \"s_axi_lite_aclk\" TO \"m_axi_s2mm_aclk\" ${s2mm_aclk_period_ps} PS DATAPATHONLY;"
#########			puts $outputFile "TIMESPEC TS_${instname}_S2MM_AXIS_P2S = FROM \"m_axi_s2mm_aclk\" TO \"s_axi_lite_aclk\" ${lite_aclk_period_ps} PS DATAPATHONLY;"
#########		}
#########	    } else {
#########		puts $outputFile "NET \"s_axi_lite_aclk\" TNM_NET = \"s_axi_lite_aclk\";"
#########		puts $outputFile "NET \"m_axi_sg_aclk\" TNM_NET = \"m_axi_sg_aclk\";"
#########		puts $outputFile "TIMESPEC TS_${instname}_LITE_AXI_S2P = FROM \"s_axi_lite_aclk\" TO \"m_axi_sg_aclk\" ${sg_aclk_period_ps} PS DATAPATHONLY;"
#########		puts $outputFile "TIMESPEC TS_${instname}_LITE_AXI_P2S = FROM \"m_axi_sg_aclk\" TO \"s_axi_lite_aclk\" ${lite_aclk_period_ps} PS DATAPATHONLY;"
#########		if {$include_mm2s == 1} {
#########			puts $outputFile "NET \"m_axi_mm2s_aclk\" TNM_NET = \"m_axi_mm2s_aclk\";"
#########			puts $outputFile "TIMESPEC TS_${instname}_MM2S_AXIS_S2P = FROM \"m_axi_sg_aclk\" TO \"m_axi_mm2s_aclk\" ${mm2s_aclk_period_ps} PS DATAPATHONLY;"
#########			puts $outputFile "TIMESPEC TS_${instname}_MM2S_AXIS_P2S = FROM \"m_axi_mm2s_aclk\" TO \"m_axi_sg_aclk\" ${sg_aclk_period_ps} PS DATAPATHONLY;"
#########		}
#########		if {$include_s2mm == 1} {
#########			puts $outputFile "NET \"m_axi_s2mm_aclk\" TNM_NET = \"m_axi_s2mm_aclk\";"
#########			puts $outputFile "TIMESPEC TS_${instname}_S2MM_AXIS_S2P = FROM \"m_axi_sg_aclk\" TO \"m_axi_s2mm_aclk\" ${s2mm_aclk_period_ps} PS DATAPATHONLY;"
#########			puts $outputFile "TIMESPEC TS_${instname}_S2MM_AXIS_P2S = FROM \"m_axi_s2mm_aclk\" TO \"m_axi_sg_aclk\" ${sg_aclk_period_ps} PS DATAPATHONLY;"
#########		}
#########	    }
#########    }
#########    puts $outputFile "#"
#########    puts $outputFile "#"
#########    puts $outputFile "\n"       
#########
#########    # Close the file
#########    close $outputFile
#########}
#***--------------------------------***-----------------------------------***
#
#			     IPLEVEL_UPDATE_PROC
#
#***--------------------------------***-----------------------------------***
## This procedure sets the mm2s issuing based on burst size parameter
######proc iplevel_update_mm2s_issuing {param_handle} {
######  set mhsinst [xget_hw_parent_handle $param_handle]
######  set burst_size [xget_hw_parameter_value $mhsinst "C_MM2S_MAX_BURST_LENGTH"]
######  set sf_included [xget_hw_parameter_value $mhsinst "C_INCLUDE_MM2S_SF"]
######
######  if {$sf_included == 0} {
######	  if {$burst_size == 16} {
######	    return 4
######	  } elseif {$burst_size == 32} {
######	    return 4
######	  } elseif {$burst_size == 64} {
######	    return 4
######	  } elseif {$burst_size == 128} {
######	    return 2
######	  } else {
######	    return 1
######	  }
######   } else {
######     return 4
######   }
######}

## This procedure sets the s2mm issuing based on burst size parameter
######proc iplevel_update_s2mm_issuing {param_handle} {
######  set mhsinst [xget_hw_parent_handle $param_handle]
######  set burst_size [xget_hw_parameter_value $mhsinst "C_S2MM_MAX_BURST_LENGTH"]
######  set sf_included [xget_hw_parameter_value $mhsinst "C_INCLUDE_S2MM_SF"]
######
######  if {$sf_included == 0} {
######	  if {$burst_size == 16} {
######	    return 4
######	  } elseif {$burst_size == 32} {
######	    return 4
######	  } elseif {$burst_size == 64} {
######	    return 4
######	  } elseif {$burst_size == 128} {
######	    return 2
######	  } else {
######	    return 1
######	  }
######   } else {
######     return 4
######   }
######}

## This procedure sets the mm2s fifo depth to 512 if store and forward is turned off.
## users can overide this by explicitly setting fifo depth in the system.mhs
######proc iplevel_update_mm2s_fifo_depth {param_handle} {
######  set mhsinst [xget_hw_parent_handle $param_handle]
######  set sf_included [xget_hw_parameter_value $mhsinst "C_INCLUDE_MM2S_SF"]
######  if {$sf_included == 0} {
######      return 512
######  } else {
######      return 0
######  }
######}
######## This procedure sets the s2mm fifo depth to 512 if store and forward is turned off.
######## users can overide this by explicitly setting fifo depth in the system.mhs
######proc iplevel_update_s2mm_fifo_depth {param_handle} {
######  set mhsinst [xget_hw_parent_handle $param_handle]
######  set sf_included [xget_hw_parameter_value $mhsinst "C_INCLUDE_S2MM_SF"]
######  if {$sf_included == 0} {
######      return 512
######  } else {
######      return 0
######  }
######}

## This procedure sets the C_PRMRY_IS_ACLK_ASYNC parameter
##############proc iplevel_update_prmry_is_async { param_handle } {
##############    # Get mhs instance
##############    set mhsinst [xget_hw_parent_handle $param_handle]
##############
##############    # Get signal connected to the following clock ports
##############    set lite_clk [xget_hw_port_value   $mhsinst "s_axi_lite_aclk"]
##############    set sg_clk [xget_hw_port_value   $mhsinst "m_axi_sg_aclk"]
##############    set mm2s_clk [xget_hw_port_value   $mhsinst "m_axi_mm2s_aclk"]
##############    set s2mm_clk [xget_hw_port_value   $mhsinst "m_axi_s2mm_aclk"]
##############
##############    set mm2s_axis_clk [xget_hw_port_value   $mhsinst "m_axis_mm2s_aclk"]
##############    set s2mm_axis_clk [xget_hw_port_value   $mhsinst "s_axis_s2mm_aclk"]
##############
##############    
##############    set include_sg [xget_hw_parameter_value $mhsinst "C_INCLUDE_SG"]
##############    set include_mm2s [xget_hw_parameter_value $mhsinst "C_INCLUDE_MM2S"]
##############    set include_s2mm [xget_hw_parameter_value $mhsinst "C_INCLUDE_S2MM"]
##############
##############    ## If the same clock is connected to s_axi_lite_aclk, m_axi_sg_aclk, m_axi_mm2s_aclk, and m_axi_s2mm_aclk then set C_PRMRY_IS_ACLK_ASYNC = 0
##############    ## Otherwise set C_PRMRY_IS_ACLK_ASYNC = 1
##############    ## Note: comparisons depend on inclusion or exclusion of sg engine, mm2s channel, and s2mm channel
##############    if {$include_sg == 1} {
##############    	if {$include_mm2s == 1} {
##############    		if {$include_s2mm == 1} {
##############		    if {[string compare -nocase $lite_clk $sg_clk] == 0 && [string compare -nocase $lite_clk $mm2s_clk] == 0 && [string compare -nocase $lite_clk $s2mm_clk] == 0 && [string compare -nocase $lite_clk $mm2s_axis_clk] == 0 && [string compare -nocase $lite_clk $s2mm_axis_clk] == 0} {
##############			return 0
##############		    } else {
##############			return 1
##############		    }
##############		} else {
##############		    if {[string compare -nocase $lite_clk $sg_clk] == 0 && [string compare -nocase $lite_clk $mm2s_clk] == 0 && [string compare -nocase $lite_clk $mm2s_axis_clk] == 0} {
##############			return 0
##############		    } else {
##############			return 1
##############		    }
##############		}
##############	} else {
##############	    if {[string compare -nocase $lite_clk $sg_clk] == 0 && [string compare -nocase $lite_clk $s2mm_clk] == 0 && [string compare -nocase $lite_clk $s2mm_axis_clk] == 0} {
##############		return 0
##############	    } else {
##############		return 1
##############	    }
##############	}
##############    } else {
##############    	if {$include_mm2s == 1} {
##############    		if {$include_s2mm == 1} {
##############		    if {[string compare -nocase $lite_clk $mm2s_clk] == 0 && [string compare -nocase $lite_clk $s2mm_clk] == 0 && [string compare -nocase $lite_clk $mm2s_axis_clk] == 0 && [string compare -nocase $lite_clk $s2mm_axis_clk] == 0} {
##############			return 0
##############		    } else {
##############			return 1
##############		    }
##############		} else {
##############		    if {[string compare -nocase $lite_clk $mm2s_clk] == 0 && [string compare -nocase $lite_clk $mm2s_axis_clk] == 0} {
##############			return 0
##############		    } else {
##############			return 1
##############		    }
##############		}
##############	} else {
##############	    if {[string compare -nocase $lite_clk $s2mm_clk] == 0 && [string compare -nocase $lite_clk $s2mm_axis_clk] == 0} {
##############		return 0
##############	    } else {
##############		return 1
##############	    }
##############	}
##############    }
##############}

## This procedure issues error when the mm2s stream data width is greater than the memory map data width
proc iplevel_drc_mm2s_tdata_width {param_handle} {

  set mhsinst [xget_hw_parent_handle $param_handle]
  set data_width [xget_hw_parameter_value $mhsinst "C_M_AXI_MM2S_DATA_WIDTH"]
  set tdata_width [xget_hw_parameter_value $mhsinst "C_M_AXIS_MM2S_TDATA_WIDTH"]

  if {$tdata_width > $data_width} {
	error "\n C_M_AXIS_MM2S_TDATA_WIDTH should be less than or equal to C_M_AXI_MM2S_DATA_WIDTH.\n" 
  }
}

## This procedure issues error when the s2mm stream data width is greater than the memory map data width
proc iplevel_drc_s2mm_tdata_width {param_handle} {

  set mhsinst [xget_hw_parent_handle $param_handle]
  set data_width [xget_hw_parameter_value $mhsinst "C_M_AXI_S2MM_DATA_WIDTH"]
  set tdata_width [xget_hw_parameter_value $mhsinst "C_S_AXIS_S2MM_TDATA_WIDTH"]

  if {$tdata_width > $data_width} {
	error "\n C_S_AXIS_S2MM_TDATA_WIDTH should be less than or equal to C_M_AXI_S2MM_DATA_WIDTH.\n" 
  }
}
####
## This procedure issues error when the s2mm line buffer threshold is not multiple of 4, less than stream data width by 8
## or greater than the line buffer depth
##########proc iplevel_drc_s2mm_line_buffer_thresh {param_handle} {
##########
##########  set mhsinst [xget_hw_parent_handle $param_handle]
##########  set s2mm_line_depth [xget_hw_parameter_value $mhsinst "C_S2MM_LINEBUFFER_DEPTH"]
##########  set s2mm_line_thresh [xget_hw_parameter_value $mhsinst "C_S2MM_LINEBUFFER_THRESH"]
##########  set tdata_width [xget_hw_parameter_value $mhsinst "C_S_AXIS_S2MM_TDATA_WIDTH"]
##########
##########  if {$s2mm_line_depth > 0} {
##########     if {$s2mm_line_thresh > $s2mm_line_depth } {
########## 	error "\n C_S2MM_LINEBUFFER_THRESH should be less than or equal to C_MM2S_LINEBUFFER_DEPTH.\n"
##########     
##########     }  elseif {$s2mm_line_thresh < [expr {$tdata_width / 8}]} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be greater than or equal to (C_S_AXIS_S2MM_TDATA_WIDTH/8).\n"
##########     }  elseif {$tdata_width == 8 && $s2mm_line_thresh != 1  &&  [expr {$s2mm_line_thresh % 1}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 1.\n"            
##########     }  elseif {$tdata_width == 16 && $s2mm_line_thresh != 2  &&  [expr {$s2mm_line_thresh % 2}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 2.\n"            
##########     }  elseif {$tdata_width == 32 && $s2mm_line_thresh != 4  &&  [expr {$s2mm_line_thresh % 4}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 4.\n"            
##########     }  elseif {$tdata_width == 64 && $s2mm_line_thresh != 8  &&  [expr {$s2mm_line_thresh % 8}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 8.\n"            
##########     }  elseif {$tdata_width == 128 && $s2mm_line_thresh != 16  &&  [expr {$s2mm_line_thresh % 16}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 16.\n"            
##########     }  elseif {$tdata_width == 256 && $s2mm_line_thresh != 32  &&  [expr {$s2mm_line_thresh % 32}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 32.\n"            
##########     }  elseif {$tdata_width == 512 && $s2mm_line_thresh != 64  &&  [expr {$s2mm_line_thresh % 64}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 64.\n"            
##########     }  elseif {$tdata_width == 1024 && $s2mm_line_thresh != 128  &&  [expr {$s2mm_line_thresh % 128}] != 0} {
########## 	   error "\n C_S2MM_LINEBUFFER_THRESH should be multiple of 128.\n"            
##########     }
##########
##########  } 
##########}
##########
############ This procedure issues error when the mm2s line buffer threshold is not multiple of 4, less than stream data width by 8
############ or greater than the line buffer depth
##########proc iplevel_drc_mm2s_line_buffer_thresh {param_handle} {
##########
##########  set mhsinst [xget_hw_parent_handle $param_handle]
##########  set mm2s_line_depth [xget_hw_parameter_value $mhsinst "C_MM2S_LINEBUFFER_DEPTH"]
##########  set mm2s_line_thresh [xget_hw_parameter_value $mhsinst "C_MM2S_LINEBUFFER_THRESH"]
##########  set tdata_width [xget_hw_parameter_value $mhsinst "C_M_AXIS_MM2S_TDATA_WIDTH"]
##########
##########  if {$mm2s_line_depth > 0} {
##########     if {$mm2s_line_thresh > $mm2s_line_depth } {
########## 	error "\n C_MM2S_LINEBUFFER_THRESH should be less than or equal to C_MM2S_LINEBUFFER_DEPTH.\n"
##########     
##########     }  elseif {$mm2s_line_thresh < [expr {$tdata_width / 8}]} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be greater than or equal to (C_M_AXIS_MM2S_TDATA_WIDTH/8).\n"
##########     }   elseif {$tdata_width == 8 && $mm2s_line_thresh != 1  &&  [expr {$m2ss_line_thresh % 1}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 1.\n"            
##########     }  elseif {$tdata_width == 16 && $mm2s_line_thresh != 2  &&  [expr {$mm2s_line_thresh % 2}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 2.\n"            
##########     }  elseif {$tdata_width == 32 && $mm2s_line_thresh != 4  &&  [expr {$mm2s_line_thresh % 4}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 4.\n"            
##########     }  elseif {$tdata_width == 64 && $mm2s_line_thresh != 8  &&  [expr {$mm2s_line_thresh % 8}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 8.\n"            
##########     }  elseif {$tdata_width == 128 && $mm2s_line_thresh != 16  &&  [expr {$mm2s_line_thresh % 16}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 16.\n"            
##########     }  elseif {$tdata_width == 256 && $mm2s_line_thresh != 32  &&  [expr {$mm2s_line_thresh % 32}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 32.\n"            
##########     }  elseif {$tdata_width == 512 && $mm2s_line_thresh != 64  &&  [expr {$mm2s_line_thresh % 64}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 64.\n"            
##########     }  elseif {$tdata_width == 1024 && $mm2s_line_thresh != 128  &&  [expr {$mm2s_line_thresh % 128}] != 0} {
########## 	   error "\n C_MM2S_LINEBUFFER_THRESH should be multiple of 128.\n"            
##########     }
##########    
##########  } 
##########}

## This procedure issues error when the mm2s line buffer threshold is less than stream data width by 8
##############proc iplevel_drc_mm2s_line_buffer_depth {param_handle} {
##############
##############  set mhsinst [xget_hw_parent_handle $param_handle]
##############  set mm2s_line_depth [xget_hw_parameter_value $mhsinst "C_MM2S_LINEBUFFER_DEPTH"]
##############  set tdata_width [xget_hw_parameter_value $mhsinst "C_M_AXIS_MM2S_TDATA_WIDTH"]
##############
##############  if { $mm2s_line_depth > 0 && $mm2s_line_depth < [expr {$tdata_width / 8}]} {
##############	error "\n C_MM2S_LINEBUFFER_DEPTH should be greater than or equal to (C_M_AXIS_MM2S_TDATA_WIDTH/8).\n"
##############  } 
##############}
##############
################ This procedure issues error when the s2mm line buffer depth is less than stream data width by 8
##############proc iplevel_drc_s2mm_line_buffer_depth {param_handle} {
##############
##############  set mhsinst [xget_hw_parent_handle $param_handle]
##############  set s2mm_line_depth [xget_hw_parameter_value $mhsinst "C_S2MM_LINEBUFFER_DEPTH"]
##############  set tdata_width [xget_hw_parameter_value $mhsinst "C_S_AXIS_S2MM_TDATA_WIDTH"]
##############
##############  if {$s2mm_line_depth > 0 && $s2mm_line_depth < [expr {$tdata_width / 8}]} {
##############	error "\n C_S2MM_LINEBUFFER_DEPTH should be greater than or equal to (C_S_AXIS_S2MM_TDATA_WIDTH/8).\n"
##############  } 
##############}
##############
## This procedure issues error when DRE is enabled when mm2s stream data width is greater than 64
proc iplevel_drc_include_mm2s_dre {param_handle} {

  set mhsinst [xget_hw_parent_handle $param_handle]
  set mm2s_dre_value [xget_hw_parameter_value $mhsinst "C_INCLUDE_MM2S_DRE"]
  set mm2s_tdata_width [xget_hw_parameter_value $mhsinst "C_M_AXIS_MM2S_TDATA_WIDTH"]

  if { $mm2s_dre_value == 1 && $mm2s_tdata_width > 64 } {
 	error "\n C_INCLUDE_MM2S_DRE should be set to 0 as C_M_AXIS_MM2S_TDATA_WIDTH is greater than 64.\n" 
  } 
}

## This procedure issues error when DRE is enabled when s2mm stream data width is greater than 64
proc iplevel_drc_include_s2mm_dre {param_handle} {

  set mhsinst [xget_hw_parent_handle $param_handle]
  set s2mm_dre_value [xget_hw_parameter_value $mhsinst "C_INCLUDE_S2MM_DRE"]
  set s2mm_tdata_width [xget_hw_parameter_value $mhsinst "C_S_AXIS_S2MM_TDATA_WIDTH"]

  if { $s2mm_dre_value == 1 && $s2mm_tdata_width > 64 } {
 	error "\n C_INCLUDE_S2MM_DRE should be set to 0 as C_S_AXIS_S2MM_TDATA_WIDTH is greater than 64.\n" 
  } 
}

## This procedure issues error when both S2MM and MM2S are inactive
proc iplevel_drc_include_s2mm_mm2s {param_handle} {

  set mhsinst [xget_hw_parent_handle $param_handle]
  set s2mm_channel [xget_hw_parameter_value $mhsinst "C_INCLUDE_S2MM"]
  set mm2s_channel [xget_hw_parameter_value $mhsinst "C_INCLUDE_MM2S"]

  if { $s2mm_channel == 0 && $mm2s_channel == 0 } {
 	error "\n Both C_INCLUDE_S2MM and C_INCLUDE_MM2S are set to 0 (OMITTED), as least one should be chosen.\n" 
  } 
}
