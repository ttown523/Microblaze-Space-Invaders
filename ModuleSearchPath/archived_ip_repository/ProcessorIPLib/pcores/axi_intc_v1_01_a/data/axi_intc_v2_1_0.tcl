###############################################################################
## DISCLAIMER OF LIABILITY
##
## This file contains proprietary and confidential information of
## Xilinx, Inc. ("Xilinx"), that is distributed under a license
## from Xilinx, and may be used, copied and/or disclosed only
## pursuant to the terms of a valid license agreement with Xilinx.
##
## XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
## ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
## EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
## LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
## MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
## does not warrant that functions included in the Materials will
## meet the requirements of Licensee, or that the operation of the
## Materials will be uninterrupted or error-free, or that defects
## in the Materials will be corrected. Furthermore, Xilinx does
## not warrant or make any representations regarding use, or the
## results of the use, of the Materials in terms of correctness,
## accuracy, reliability or otherwise.
##
## Xilinx products are not designed or intended to be fail-safe,
## or for use in any application requiring fail-safe performance,
## such as life-support or safety devices or systems, Class III
## medical devices, nuclear facilities, applications related to
## the deployment of airbags, or any other applications that could
## lead to death, personal injury or severe property or
## environmental damage (individually and collectively, "critical
## applications"). Customer assumes the sole risk and liability
## of any use of Xilinx products in critical applications,
## subject only to applicable laws and regulations governing
## limitations on product liability.
##
## Copyright 2007, 2010 Xilinx, Inc.
## All rights reserved.
##
## This disclaimer and copyright notice must be retained as part
## of this file at all times.
##
###############################################################################
##
###############################################################################
##
## Filename : axi_intc_v2_1_0.tcl
##
## Description: Tcl File for axi_intc_v1_01_a
##
###############################################################################


###############################################################################
proc check_interrupt_sensitivity {intrport mhsinst} {

    set mergedmhs [xget_hw_parent_handle        $mhsinst]
    set connlist  [xget_hw_port_connectors_list $mhsinst $intrport]

    foreach conn $connlist {

        set connportlist [xget_hw_connected_ports_handle $mergedmhs $conn "SOURCE"]

	foreach connport $connportlist {
	    
	    
	    set cpname      [xget_hw_name $connport]
	    set vec         [xget_hw_subproperty_value $connport "VEC"];
	    set sensitivity [xget_hw_subproperty_value $connport "SENSITIVITY"];
	    
	    if {
		[string compare -nocase $sensitivity "EDGE_FALLING"] == 0 ||
	   	[string compare -nocase $sensitivity "EDGE_RISING"] == 0  ||
		[string compare -nocase $sensitivity "LEVEL_HIGH"] == 0 ||
	   	[string compare -nocase $sensitivity "LEVEL_LOW"] == 0
	    } { 
	    } else {
	  	error "Interrupt Port - '$cpname' cannot be without Sensitivity (SENSITIVITY=EDGE_RISING|EDGE_FALLING|LEVEL_LOW|LEVEL_HIGH)"
	    }
	}
    }
}
###################################################################################
proc syslevel_check_interrupt_sensitivity  {mhsinst} {

    xload_hw_library axi_intc_v1_01_a
    hw_axi_intc_v1_01_a::check_interrupt_sensitivity "Intr" $mhsinst

} 
###################################################################################
##
### compute C_check_interrupt_sensitivity
##proc syslevel_check_interrupt_sensitivity { param_handle } {
##
##
##    set mhsinst      [xget_hw_parent_handle $param_handle]
##    set mhs_handle   [xget_hw_parent_handle $mhsinst]
##
##    return [hw_axi_intc_v1_01_a::check_interrupt_sensitivity "Intr" $mhsinst]
####    hw_axi_intc_v1_01_a::check_interrupt_sensitivity "Intr" $mhsinst
##
##}


#################################################################################

proc update_num_intr_inputs {intrport mhsinst} {


    set num_intr_inputs 0

    set mergedmhs [xget_hw_parent_handle        $mhsinst]
    set connlist  [xget_hw_port_connectors_list $mhsinst $intrport]
    foreach conn $connlist {

        set connportlist [xget_hw_connected_ports_handle $mergedmhs $conn "SOURCE"]
        
        foreach connport $connportlist {
	    
            set cpname      [xget_hw_name $connport];
	    set vec         [xget_hw_subproperty_value $connport "VEC"];
	    set parentMPD   [xget_hw_parent_handle $connport];
            
        if {$vec != ""} {
	  
  		regexp {\[(.+):(.+)\]} $vec bvec tfvec tsvec;  		
  		set fvec [hw_axi_intc_v1_01_a::update_params $tfvec $parentMPD];
  		set svec [hw_axi_intc_v1_01_a::update_params $tsvec $parentMPD];
	  	set bwidth [expr {abs($svec - $fvec) + 1}];

	  	incr num_intr_inputs $bwidth;

	    } else { incr num_intr_inputs }

	} 
    }
    
    # compute the value to 1 even when there is no interrupt input connected
    # by users, and let platgen connect the signal to net_gnd
    if { $num_intr_inputs == 0 } {

        return 1
    }

    return $num_intr_inputs

}
###############################################################################

# compute C_NUM_INTR_INPUTS
proc syslevel_update_num_intr_inputs { param_handle } {

    set mhsinst      [xget_hw_parent_handle $param_handle]
    set mhs_handle   [xget_hw_parent_handle $mhsinst]

##    xload_hw_library axi_intc_v1_01_a

    return [hw_axi_intc_v1_01_a::update_num_intr_inputs "Intr" $mhsinst]

}


###############################################################################

proc update_kind_of_intr {intrport mhsinst} {

    set kindofintr "0b11111111111111111111111111111111"
    set kindof ""

    set mergedmhs [xget_hw_parent_handle        $mhsinst]
    set connlist  [xget_hw_port_connectors_list $mhsinst $intrport]

    foreach conn $connlist {

        set connportlist [xget_hw_connected_ports_handle $mergedmhs $conn "SOURCE"]

  	foreach connport $connportlist {
	
	    set cpname      [xget_hw_name $connport];
	    set vec         [xget_hw_subproperty_value $connport "VEC"];
	    set parentMPD   [xget_hw_parent_handle $connport];
	    set sensitivity [xget_hw_subproperty_value $connport "SENSITIVITY"];

	    # Default is 1 for EDGE_RISING, EDGE_FALLING
	    set sense 1
	
	    if {
		[string compare -nocase $sensitivity "LEVEL_HIGH"] == 0 ||
	   	[string compare -nocase $sensitivity "LEVEL_LOW"] == 0
	    } {
	  	set sense 0
	    }

	    if { $vec != "" } {
	  
  		regexp {\[(.+):(.+)\]} $vec bvec tfvec tsvec;  		
  		set fvec [hw_axi_intc_v1_01_a::update_params $tfvec $parentMPD];
  		set svec [hw_axi_intc_v1_01_a::update_params $tsvec $parentMPD];
	  	set bwidth [expr {abs($svec - $fvec) + 1}];
	  	
	  	for {set i 0} {$i < $bwidth} {incr i} { append kindof $sense }

	    } else { append kindof $sense; }

	} 
    }

    set len [string length $kindof];

    return [string replace $kindofintr end-[expr $len - 1] end $kindof]

}

###############################################################################

# compute C_KIND_OF_INTR
proc syslevel_update_kind_of_intr { param_handle } {

    set mhsinst      [xget_hw_parent_handle $param_handle]
    set mhs_handle   [xget_hw_parent_handle $mhsinst]

    return [hw_axi_intc_v1_01_a::update_kind_of_intr "Intr" $mhsinst]

}
###############################################################################

proc update_kind_of_edge {intrport mhsinst} {

    set kindofintr "0b11111111111111111111111111111111"
    set kindof ""

    set mergedmhs [xget_hw_parent_handle        $mhsinst]
    set connlist  [xget_hw_port_connectors_list $mhsinst $intrport]

    # if port Intr is unconnected or connected to a constant signal
    if { [llength $connlist] == 0 } {

	set kindof 1
    	return [string replace $kindofintr end end $kindof]

    } elseif { [llength $connlist] == 1 } {

  	set signal [lindex $connlist 0]

	if {[string compare -nocase "net_gnd" $signal] == 0 || [string compare -nocase "0b0" $signal] == 0 } {

	    set kindof 1
    	    return [string replace $kindofintr end end $kindof]

	} elseif {[string compare -nocase "net_vcc" $signal] == 0 || [string compare -nocase "0b1" $signal] == 0 } {

	    set kindof 0
    	    return [string replace $kindofintr end end $kindof]

	} 

    }

    foreach conn $connlist {

        set connportlist [xget_hw_connected_ports_handle $mergedmhs $conn "SOURCE"]

  	foreach connport $connportlist {
	
	    set cpname      [xget_hw_name $connport];
	    set vec         [xget_hw_subproperty_value $connport "VEC"];
	    set parentMPD   [xget_hw_parent_handle $connport];
	    set sensitivity [xget_hw_subproperty_value $connport "SENSITIVITY"];

	    # Default is 1 for EDGE_RISING
	    set sense 1

	    if { [string compare -nocase $sensitivity "EDGE_FALLING"] == 0 } {
	 
		set sense 0
	  
	    }

	    if { $vec != "" } {
	  
  		regexp {\[(.+):(.+)\]} $vec bvec tfvec tsvec;  		
  		set fvec [hw_axi_intc_v1_01_a::update_params $tfvec $parentMPD];
  		set svec [hw_axi_intc_v1_01_a::update_params $tsvec $parentMPD];
	  	set bwidth [expr {abs($svec - $fvec) + 1}];
	  	
	  	for {set i 0} {$i < $bwidth} {incr i} { append kindof $sense }

	    } else { append kindof $sense; }

	} 
    }

    set len [string length $kindof];

    return [string replace $kindofintr end-[expr $len - 1] end $kindof]

}

#################################################################################

# compute C_KIND_OF_EDGE
proc syslevel_update_kind_of_edge { param_handle } {

    set mhsinst      [xget_hw_parent_handle $param_handle]
    set mhs_handle   [xget_hw_parent_handle $mhsinst]

    return [hw_axi_intc_v1_01_a::update_kind_of_edge "Intr" $mhsinst]

}


##############################################################################

proc update_kind_of_lvl {intrport mhsinst} {

    set kindofintr "0b11111111111111111111111111111111"
    set kindof ""

    set mergedmhs [xget_hw_parent_handle        $mhsinst]
    set connlist  [xget_hw_port_connectors_list $mhsinst $intrport]

    # if port Intr is unconnected or connected to a constant signal
    if { [llength $connlist] == 0 } {

	set kindof 1
    	return [string replace $kindofintr end end $kindof]

    } elseif { [llength $connlist] == 1 } {

  	set signal [lindex $connlist 0]

	if {[string compare -nocase "net_gnd" $signal] == 0 || [string compare -nocase "0b0" $signal] == 0 } {

	    set kindof 1
    	    return [string replace $kindofintr end end $kindof]

	} elseif {[string compare -nocase "net_vcc" $signal] == 0 || [string compare -nocase "0b1" $signal] == 0 } {

	    set kindof 0
    	    return [string replace $kindofintr end end $kindof]

	} 

    }

    foreach conn $connlist {

  	set connportlist [xget_hw_connected_ports_handle $mergedmhs $conn "SOURCE"]

  	foreach connport $connportlist {

	    set cpname      [xget_hw_name $connport];
	    set vec         [xget_hw_subproperty_value $connport "VEC"];
	    set parentMPD   [xget_hw_parent_handle $connport];	    
	    set sensitivity [xget_hw_subproperty_value $connport "SENSITIVITY"];

	    # Default is 0 for LEVEL_HIGH
	    set sense 1
	
	    if { [string compare -nocase $sensitivity "LEVEL_LOW"] == 0 } {
	  
		set sense 0
	  
	    }

	    if { $vec != "" } {
	  	
  		regexp {\[(.+):(.+)\]} $vec bvec tfvec tsvec;  		
  		set fvec [hw_axi_intc_v1_01_a::update_params $tfvec $parentMPD];
  		set svec [hw_axi_intc_v1_01_a::update_params $tsvec $parentMPD];
	  	set bwidth [expr {abs($svec - $fvec) + 1}];
	  	
	  	for {set i 0} {$i < $bwidth} {incr i} { append kindof $sense }
	  
	    } else { append kindof $sense; }
	
	} 
    }

    set len [string length $kindof];

    return [string replace $kindofintr end-[expr $len - 1] end $kindof]

}


#################################################################################

# compute C_KIND_OF_LVL
proc syslevel_update_kind_of_lvl { param_handle } {

    set mhsinst      [xget_hw_parent_handle $param_handle]
    set mhs_handle   [xget_hw_parent_handle $mhsinst]

    return [hw_axi_intc_v1_01_a::update_kind_of_lvl "Intr" $mhsinst]

}

###############################################################################
# compute VEC
proc update_params { string mpdhandle } {

            if {[ regexp {[a-zA-Z]} $string match ] } {
	    
	       while { [regexp {([a-zA-Z]\w+)(.+)} $string match m1 m2] } {
	        set paramVAL [xget_hw_parameter_value $mpdhandle $m1];
	        regsub $m1 $string $paramVAL string;
	       }
	       return [expr $string];
	       
	    } else { return $string; }

}