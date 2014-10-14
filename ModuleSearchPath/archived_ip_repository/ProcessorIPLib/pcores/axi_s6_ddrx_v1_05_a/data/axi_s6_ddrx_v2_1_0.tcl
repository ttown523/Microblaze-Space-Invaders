##-----------------------------------------------------------------------------
##-- (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
##--
##-- This file contains confidential and proprietary information
##-- of Xilinx, Inc. and is protected under U.S. and
##-- international copyright and other intellectual property
##-- laws.
##--
##-- DISCLAIMER
##-- This disclaimer is not a license and does not grant any
##-- rights to the materials distributed herewith. Except as
##-- otherwise provided in a valid license issued to you by
##-- Xilinx, and to the maximum extent permitted by applicable
##-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
##-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
##-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
##-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
##-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
##-- (2) Xilinx shall not be liable (whether in contract or tort,
##-- including negligence, or under any other theory of
##-- liability) for any loss or damage of any kind or nature
##-- related to, arising under or in connection with these
##-- materials, including for any direct, or any indirect,
##-- special, incidental, or consequential loss or damage
##-- (including loss of data, profits, goodwill, or any type of
##-- loss or damage suffered as a result of any action brought
##-- by a third party) even if such damage or loss was
##-- reasonably foreseeable or Xilinx had been advised of the
##-- possibility of the same.
##--
##-- CRITICAL APPLICATIONS
##-- Xilinx products are not designed or intended to be fail-
##-- safe, or for use in any application requiring fail-safe
##-- performance, such as life-support or safety devices or
##-- systems, Class III medical devices, nuclear facilities,
##-- applications related to the deployment of airbags, or any
##-- other applications that could lead to death, personal
##-- injury, or severe property or environmental damage
##-- (individually and collectively, "Critical
##-- Applications"). Customer assumes the sole risk and
##-- liability of any use of Xilinx products in Critical
##-- Applications, subject only to applicable laws and
##-- regulations governing limitations on product liability.
##--
##-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
##-- PART OF THIS FILE AT ALL TIMES.
##-----------------------------------------------------------------------------

## Common.tcl .. common axi_*_ddrx tcl functions

## Used to read back parameter XML from MIG.
xload_xilinx_library libmXMLTclIf

## This is for 13.4+
proc  mig_version             {} { return   "mig_v3_91" }

## TCL writes this file for MIG.
proc  mig_file_input          {} { return  "mig_input.txt" }

## MIG writes this file for TCL. has ERROR_CODE
proc  mig_file_output         {} { return  "mig_output.txt" }

## TCL writes parameters values in this file for MIG to read
proc  mig_file_param_input    {} { return   "param_input.xml" }

## MIG writes parameters values for TCL to read
proc  mig_file_param_output   {} { return   "param_output.xml"}

## MIG write error messages in this file. TCl should copy this to stdout
proc  mig_file_drc_messages   {} { return   "mpmclog.txt"}

## This prj is passed back to MIG.
proc  mig_file_prj_saved      {} { return   "mig_saved.prj"}

## MIG writes this, TCL renaems this to '_saved.prj'
proc  mig_file_prj_output     {} { return   "mig.prj"}

## MIG writes <component>.ucf, TCL renames it to this
proc  mig_file_ucf            {} { return   "mig.ucf"}

## Since EDK helps us by suppressing all the error messages, we need
## our own way to log them to a file...
## ASSUMPTION: mhsinst is correct in the caller ...
## ASSUMPTION: current directory is the project dir
global logfile

proc dbg args {
    global logfile
    puts $logfile $args
}

proc mkdirs args {
    foreach dir $args {
        if { ! [ file exists $dir ] } {
            file mkdir $dir
        }
    }
}

proc run_proc args {

    global logfile
    upvar mhsinst mhsinst
    mkdirs __xps __xps/[xget_hw_name $mhsinst]

    set  logfile [ open __xps/[xget_hw_name $mhsinst]/tcl.log a ]
    fconfigure $logfile -buffering none

    set ret_val 0
    global errorInfo
    global errorCode

    puts $logfile "========================================================================="
    puts $logfile "Time: [clock format [clock seconds]]"
    puts $logfile "Running: $args"
    set is_err  [ catch { set ret_val [uplevel $args ] } err ]
    if { $is_err } {
        puts $logfile "errorCode: $errorCode"
        puts $logfile "errorInfo: $errorInfo"
        puts $logfile "ERROR: $err"
  }
    puts $logfile "RETURN: $ret_val"
    
    close $logfile
    set logfile {}

    ## Rethrow if there was actually an error ...
    if { $is_err } {
        error $err $errorInfo $errorCode
    }
    
    return $ret_val
    

}

proc check_iplevel_drcs { mhsinst } { }

proc syslevel_update_proc { mhsinst } { 
    puts "Invoking MIG ..."
    if { [file exists __xps/[xget_hw_name $mhsinst]/tcl.log ] } {
        file delete __xps/[xget_hw_name $mhsinst]/tcl.log
    }
    run_proc run_batch_mode $mhsinst 
}

proc check_syslevel_drcs { mhsinst } { }

proc platgen_syslevel_update { mhsinst } {
    run_proc generate_corelevel_constraints $mhsinst
    update_simulation_parameter $mhsinst
}

## Always set C_SIMULATION value to FALSE for simulation
proc update_simulation_parameter { mhsinst } { 
  set sim_handle [xget_hw_parameter_handle $mhsinst "C_SIMULATION" ]
  set val [xget_hw_value $sim_handle]
  if {![string match {FALSE} $val]} { 
    xset_hw_parameter_value $sim_handle "FALSE"
    puts "INFO: Forcing parameter C_SIMULATION = \"FALSE\" in IP axi_s6_ddrx."
  }
}

proc xps_external_ipconfig { mhsinst } {
    if { [file exists __xps/[xget_hw_name $mhsinst]/tcl.log ] } {
        file delete __xps/[xget_hw_name $mhsinst]/tcl.log
    }

    return [run_proc run_gui_mode $mhsinst]
}

## Invoke MIG ( mig_invoke )
##  and either (1) report drcs (mig_drc_report )
##          or (2) import ucf (mig_ucf_import ) 
##          or (3) import params (mig_param_import )

### mig_errcode return value:
### -1 Mig binary not invoked , error has already been displayed .. do nothing.
###  0 Success
###  2 Cancel on GUI

global is_mig_batch 

proc run_gui_mode {mhsinst} {

    global is_mig_batch
    set is_mig_batch 0

    global imported_params
    array unset imported_params *

    set migstatus [mig_invoke $mhsinst { {FLOW SOCKETABLE }  {MODE INTERACTIVE } { DRCMODE WARN } } ]
    if { $migstatus !=  0 } { return $migstatus }
    mig_param_import $mhsinst
    ## Some PARAM are derived from UCF .. so we need this ..
    set  throw [ open __xps/[xget_hw_name $mhsinst]/temp.ucf w ]
    mig_ucf_import $mhsinst $throw
    close $throw
    file delete __xps/[xget_hw_name $mhsinst]/temp.ucf
    return 0
}

proc run_batch_mode {mhsinst} {

    global is_mig_batch
    set is_mig_batch 1

    global imported_params
    array unset imported_params *

    set migstatus [mig_invoke $mhsinst { {FLOW SOCKETABLE }  {MODE BATCH } { DRCMODE  ERROR } } ]
    if { $migstatus !=  0 } { return $migstatus }
    mig_param_import $mhsinst
    ## Some PARAM are derived from UCF .. so we need this ..
    set  throw [ open __xps/[xget_hw_name $mhsinst]/temp.ucf w ]
    mig_ucf_import $mhsinst $throw
    close $throw
    file delete __xps/[xget_hw_name $mhsinst]/temp.ucf
    return 0
}

## 
## Level 2 proc
##

proc mig_input_file { mhsinst   migflags} {
    
    set fd [ open [mig_file_input]  "w" ]
    
    foreach flag $migflags { 
        puts $fd "SET_FLAG $flag"

    } 

    puts $fd "SET_FLAG COMPONENT_NAME [xget_hw_name $mhsinst]"

    puts $fd "SET_PREFERENCE projectname [xget_hw_name $mhsinst]"

    
    puts $fd "SET_PREFERENCE devicefamily  [xget_hw_proj_setting fpga_family]"
    puts $fd "SET_PREFERENCE devicesubfamily  [xget_hw_proj_setting fpga_subfamily]"
    puts $fd "SET_PREFERENCE partname [xget_hw_proj_setting fpga_partname]"
    puts $fd "SET_PREFERENCE device  [string range [xget_hw_proj_setting fpga_partname] 0 1][xget_hw_proj_setting fpga_device]"
    puts $fd "SET_PREFERENCE package  [xget_hw_proj_setting fpga_package]"
    puts $fd "SET_PREFERENCE speedgrade [xget_hw_proj_setting fpga_speedgrade]"

    puts $fd "SET_PREFERENCE outputdirectory ./"
    puts $fd "SET_PREFERENCE workingdirectory ./"
    puts $fd "SET_PREFERENCE subworkingdirectory ./"

    puts $fd "SET_PREFERENCE InputParamsFile [mig_file_param_input]"
    puts $fd "SET_PREFERENCE OutputParamsFile [mig_file_param_output]"
    
    #if {  [ file exists [mig_file_prj_saved ] ]  } {
    #    puts $fd "SET_PARAMETER xml_input_file [mig_file_prj_saved]"
    #}
    close $fd

}

###
###  Stolen from MPMC tcl
###

proc get_mig_executable { } { 
    
    set host_os [xget_hostos_platform]
    set host_exec_suffix [xget_hostos_exec_suffix]
    set mig_ver [ mig_version ]
    set relative_mig_path "coregen/ip/xilinx/other/com/xilinx/ip/${mig_ver}/bin/${host_os}/mig"
    if {[string length $host_exec_suffix]} { 
        append relative_mig_path ".${host_exec_suffix}"
    }

    set mig_exec [xfind_file_in_xilinx_install $relative_mig_path]
    if {[file exists $mig_exec] == 0 || [file executable $mig_exec] == 0} { 
        error "The MIG executable does not exist or is not executable.  Please check that the relative path: '${relative_mig_path}' is in your\
               \$XILINX environment variable." "" "mdt_error"
    }
    return [file join $mig_exec]
}

## xget_hw_value in xps and platgen behaves differently
## so if MHS doesn't contain any value for OPTIONAL_UPDATE, we pick MPD value
## and avoid the TCL computed value.

proc param_collect { mhsinst params} {
    upvar $params paramValues

    set handles [ xget_hw_parameter_handle $mhsinst *]
    foreach ph $handles { 
        set param      [ xget_hw_name $ph ]
        set val        [ xget_hw_value $ph ] 
        set assignment [ xget_hw_subproperty_value $ph ASSIGNMENT ]
        set type       [ xget_hw_subproperty_value $ph DT ]  
        set mpdval     [ xget_hw_subproperty_value $ph MPD_VALUE ]
        set mhsval     [ xget_hw_subproperty_value $ph MHS_VALUE ]
        
        if { [string equal $assignment OPTIONAL_UPDATE ]  && [string equal $mhsval {} ] } {
            #dbg "$param trapped ... "
            set val $mpdval 
            if { [ string first  _SUPPORTS_NARROW_BURST $param ]  != -1 } {
                #dbg "set to Auto"
                set val Auto
            }
            
        }

        dbg "COLLECTING:  $param $val $assignment $type $mpdval $mhsval"
        set v [ list $val $type $assignment ]
        set paramValues($param) $v
    }    
}

##
## Dump parameters in ip-xact compliant format
##   dumps the stuff _inside_ <modelParameters>
##    Arguments: mhsinst OR mpdinst
##  also populate global paramValues
proc param_writexml { mhsinst  } {

    array set paramValues {}

    set name [xget_hw_name $mhsinst ]

    param_collect  $mhsinst paramValues

    # 3. Dump them all in an ip-xact format
    if { [catch { set fd [ open [mig_file_param_input]  w ] } err] } { 
        error  $err 
    } else { 
        puts $fd {<?xml version="1.0" encoding="UTF-8"?>
            <spirit:component xmlns:spirit="http://www.spiritconsortium.org/XMLSchema/SPIRIT/1.4" xmlns:xilinx="http://www.xilinx.com">
            <spirit:vendor/>
            <spirit:library/>
            <spirit:name/>
            <spirit:version/>
            
            <spirit:model>          
            <spirit:views/>
            <spirit:ports/>
            <spirit:modelParameters>
            
        }
        foreach key [lsort -dictionary [array names paramValues]] { 
            set value $paramValues($key)
            set val [lindex $value 0 ]
            set dt  [lindex $value 1 ]  
            set res [lindex $value 2 ]  
            if { [ string equal $val NOT_SET ] } { set val "" } 
            set val [ xml_quote $val ]
            puts $fd "      <spirit:modelParameter>"
            puts $fd "        <spirit:name>$key</spirit:name>"
            puts $fd "        <spirit:value spirit:format=\"$dt\" spirit:resolve=\"$res\" spirit:id=\"$name.$key\"> \"$val\" </spirit:value>"
            puts $fd "      </spirit:modelParameter>"   
            dbg  "SENDING PARAMETER: $key : $value"
        }
        puts $fd {</spirit:modelParameters>
            </spirit:model>               
            </spirit:component>
        }
        close $fd    
    }
    
    # 4. Done

}

proc xml_quote { str } {
    set str [ regsub -all {&} $str {\&amp;}  ]
    set str [ regsub -all {<} $str {\&lt;}  ]
    set str [ regsub -all {>} $str {\&gt;}  ]
    set str [ regsub -all {\"} $str {\&quot;}  ]
    set str [ regsub -all {\'} $str {\&apos;}  ]

    return $str

}

proc param_readxml { mhsinst  upv } {
    
    upvar $upv pv
    array unset pv *
    set  filename __xps/[xget_hw_name $mhsinst]/[mig_file_param_output]

    # TODO check here if mig error code is 0
    if { [ catch {  xxml_read_file $filename  } xmlRoot ] } { 
        error "Error in Executing MIG : $xmlRoot" 
        return
    }
    
    set phs [ xxml_get_sub_elements $xmlRoot  spirit:model/spirit:modelParameters/spirit:modelParameter ]
    foreach ph $phs {
        set h_name [ xxml_get_sub_elements $ph spirit:name ]
        set h_value [ xxml_get_sub_elements $ph spirit:value ]
        if { [ string length $h_name ] == 0 } {
            continue;
        }
        set param_name [ xxml_get_text $h_name ]
        set param_value [ xxml_get_text $h_value ]
        set param_value [ string trim $param_value "\" \t\f\n\r" ]

        set pv($param_name) $param_value
    }
    xxml_cleanup $xmlRoot
    

}

##
## This procedure actually carries all the weight of the punch
##
## For us, the ASSIGNMENT and various TCL functions are not enough.
## so we introduce two new parametes, EXT_ASSIGNMENT and EXT_NOVALUE
##
##     ASSIGNMENT      |  GUI Value  |   Batch Value
##       REQUIRE       |    Used     |    ignored, , DRC if EXT_ASSIGNMENT = CHECK
##       OPTIONAL      |    Used     |    ignored, DRC if EXT_ASSIGNMENT = CHECK
##       OPT_UPD       |    Used     |    Used when no MHS Value, else DRC if EXT_ASSIGNMENT = CHECK
##       UPDATE        |    Ignored  |    Used.
##
##
##    these can be used to override any ASSIGNMENT ...
##
##     EXT_ASSIGNMENT  |   GUI Value |  Batch Value
##       SKIP          |    ignored  |   ignored
##       SKIP_BATCH    |     used    |    ignored
##       SKIP_GUI      |     ignored |    skip
##    
##    
##    for OPTIONAL_ASSIGNMENT , we need a 'NOVALUE' value , to remove it from MHS
##      EXT_NOVALUE = Auto ... NOT IMPLEMENTED .. using NARROW_BURST in param name currently
##
##  OPTIONAL means GUI, and UPDATE means batch mode ... 

proc mig_set_param { mhsinst param_name param_handle param_value } {
    global imported_params
    global logfile
    global is_mig_batch
    
    
    set assignment [ xget_hw_subproperty_value $param_handle ASSIGNMENT ]
    set ext_assignment [ xget_hw_subproperty_value $param_handle EXT_ASSIGNMENT ]
    if { $is_mig_batch } {
        set batch BATCH
    } else { 
        set batch GUI
    }

    set no_value [xget_hw_subproperty_value $param_handle EXT_NOVALUE]
    set mpdval [ xget_hw_subproperty_value $param_handle MPD_VALUE ]
    if { ( [string equal $no_value $param_value ] ) } {
        set to DEFVAL
    } elseif { [string equal $mpdval $param_value ] }   { 
        set to MPDVAL
    } else { 
        set to COMPVAL
    }
    
    set mhs_value [xget_hw_subproperty_value $param_handle MHS_VALUE]
    if { [string equal $mhs_value {} ] == 0 } {
        set from MHS
    } else { 
        set from MPD
    }
    set do_ignore 0
    set do_update 0
    set do_remove 0
    set do_check 0
    set do_portchk 0
    set exp $batch:$assignment:$ext_assignment:$from:$to
    switch -glob $exp {
        COMMENT {  Anything constant is not be touched... }
        *:CONSTANT:*                      { set do_ignore 1  } 
        
        COMMENT {  GUI cannot update the UPDATE parmeters }
        GUI:UPDATE:*                      { set do_ignore 1 }
        COMMENT {  Batch mode will update, but ignore if SKIP_BATCH or SKIP }
        BATCH:UPDATE:SKIP_BATCH:*         { set do_ignore 1 }
        BATCH:UPDATE:SKIP:*               { set do_ignore 1 }
        BATCH:UPDATE:*DEFVAL              { set do_remove  1 }
        BATCH:UPDATE:*                    { set do_update  1 }
        
        COMMENT {  GUI Can update REQUIRED parameters. }
        GUI:REQUIRE:SKIP:*                { set do_ignore 1 }
        GUI:REQUIRE:SKIP_GUI:*            { set do_ignore 1 }
        GUI:REQUIRE:*:DEFVAL              { set do_remove 1 }
        GUI:REQUIRE:*                     { set do_update 1 }

        COMMENT {  Batch mode never updates REQUIRE }
        BATCH:REQUIRE:*                   {set do_ignore 1 }

        COMMENT {  GUI Can update OPTIONAL parameters. }
        GUI:OPTIONAL:SKIP:*               { set do_ignore 1 }
        GUI:OPTIONAL:SKIP_GUI:*           { set do_ignore 1 }
        GUI:OPTIONAL:*:DEFVAL             { set do_remove 1 }
        GUI:OPTIONAL:*                    { set do_update 1 }
        COMMENT {  Batch mode never updates OPTIONAL }
        BATCH:OPTIONAL:*                  {set do_ignore 1 }
        
        
        COMMENT {  GUI Can update OPTIONAL_UPDATE always... }
        GUI:OPTIONAL_UPDATE:SKIP:*        { set do_ignore 1 }
        GUI:OPTIONAL_UPDATE:SKIP_GUI:*    { set do_ignore 1 }
        GUI:OPTIONAL_UPDATE:CHECK:*       { set do_update 1 ; set do_portchk 1 }
        GUI:OPTIONAL_UPDATE:CHECK_GUI:*   { set do_update 1 ; set do_portchk 1 }
        GUI:OPTIONAL_UPDATE:*:DEFVAL      { set do_remove 1 }
        GUI:OPTIONAL_UPDATE:*             { set do_update 1 }

        COMMENT {  Batch mode update OPTIONAL_PARAMETER, only when no MHS value. }
        BATCH:OPTIONAL_UPDATE:SKIP:*      {set do_ignore 1 }
        BATCH:OPTIONAL_UPDATE:SKIP_BATCH:* {set do_ignore 1 }
        BATCH:OPTIONAL_UPDATE:CHECK:*     {set do_check 1 }
        BATCH:OPTIONAL_UPDATE:CHECK_BATCH:* {set do_check 1 }
        BATCH:OPTIONAL_UPDATE:*:MHS:*     {set do_ignore 1 }
        BATCH:OPTIONAL_UPDATE:*:DEFVAL     {set do_ignore 1 }
        BATCH:OPTIONAL_UPDATE:*           {set do_update 1 }
        
        default { error  "Internal Error: UNHANDLED $param_name  $exp" "" mdt_error }
    }
    
    if { $do_check } {
        set old_value [xget_hw_parameter_value $mhsinst $param_name ] 
        if { $param_value != $old_value } {
            error "Value of parameter $param_name is $old_value in MHS, but should be $param_value. When MHS parameters are manually changed, parameters can go out of sync. Please use 'IP Configure' to change the MHS parameters."  "" "mdt_error"
        }
        dbg "SET: CHECK $param_name = $param_value ($exp)"
    }
    if { $do_portchk } { 
        set old_value [xget_hw_parameter_value $mhsinst $param_name ] 
        if { $param_value != $old_value } {
            puts "**** The parameter $param_name has changed from $old_value to $param_value"
            puts "**** The size of some external ports may need to be updated to match the new widths."
        }
        dbg "SET: PORTC $param_name = $param_value ($exp)"
    }
    if { $do_update } {
        ## When updating .. if value is same as mpdval , actualy remove 
        xset_hw_parameter_value $param_handle $param_value
        set mpdval     [ xget_hw_subproperty_value $param_handle MPD_VALUE ]
        if { [ string equal $param_value $mpdval ] } {
            xadd_hw_subproperty $param_handle OPTIONAL_UPDATE_TOOL_COMPUTED true
            dbg "SET: UPDREM $param_name = $param_value ($exp)"
        } else {
            xadd_hw_subproperty $param_handle OPTIONAL_UPDATE_TOOL_COMPUTED false
            dbg "SET: UPDATE $param_name = $param_value ($exp)"
        }
    }
    if { $do_remove } {
        set mpdval     [ xget_hw_subproperty_value $param_handle MPD_VALUE ]
        xset_hw_parameter_value $param_handle $mpdval
        xadd_hw_subproperty $param_handle OPTIONAL_UPDATE_TOOL_COMPUTED true
        dbg "SET: REMOVE $param_name = $param_value ($exp)"
    }
    if { $do_ignore } {
        dbg "SET: IGNORE $param_name = $param_value ($exp)"

    }
    
    set imported_params($param_name)  $param_value
    
}

proc mig_param_import { mhsinst } {
    
    global logfile
    
    
    array set  xmlPV {}
    param_readxml $mhsinst xmlPV

    foreach param_name [ array names xmlPV ] {

        set param_value $xmlPV($param_name)
        
        set param_handle [ xget_hw_parameter_handle $mhsinst  $param_name]
        if { [string equal $param_handle {} ] } {
            #puts $logfile "NOT in MPD, but in XML :$param_name  Value: {$param_value}"        
            continue;
        }
        set oldval     [ xget_hw_value $param_handle ]
        set assignment [ xget_hw_subproperty_value $param_handle ASSIGNMENT ]
        set type       [ xget_hw_subproperty_value $param_handle DT ]  
        set mpdval     [ xget_hw_subproperty_value $param_handle MPD_VALUE ]
        set mhsval     [ xget_hw_subproperty_value $param_handle MHS_VALUE ]
        
        # std_logic_vector needs conversion form 1'bnnn to 0xnnn
        switch -exact [string tolower $type] {
            bit  {   }
            bit_vector {  }
            integer {  set param_value [regsub -all {[_()]} $param_value "" ] }
            real  {  }
            string {  }
            std_logic {    }
            std_logic_vector {  set param_value [conv_to_0x [regsub -all {[_()]} $param_value "" ]] }
            default {  }
        }
        #puts $logfile "UPDATING $param_name  OldValue: $oldval NewValue: $param_value "         
        mig_set_param  $mhsinst $param_name $param_handle $param_value
    }
    
    
    device_specific_parameter_handling $mhsinst xmlPV

}

proc conv_to_0x { val } {
    # 0'bfoo ==> 0xfoo
    if [ regexp {^[0-9]+'[Bb]([01]*)$} $val  d0 d1 ] {
        return "0b$d1"
    }
    if [ regexp {^[0-9]+'[Oo]([0-7]*)$} $val  d0 d1 ] {
        return [format 0x%x 0$d1 ] 
    }
    if [ regexp {^[0-9]+'[hH]([0-9a-fA-F]*)$} $val  d0 d1 ] {
        return 0x$d1
    }

    return $val
}

############################
##### UCF Handling
############################

## Sort by descending of length of first part of string.
proc comp_drxpin { a b } {
    set a [lindex $a 0 ]
    set b [lindex $b 0 ]
    set ret [expr [ string length $b ] - [string length $a  ] ]
    if { $ret != 0 } { return $ret }
    return [string compare $a $b ]
}

proc signal_to_drxpin  { sig } {

    set pinlist  {

        {  ddr3  ck }
        {  ddr3  ck_n }
        {  ddr3  cke }
        {  ddr3  cke }
        {  ddr3  cs_n }
        {  ddr3  odt }
        {  ddr3  ras_n }
        {  ddr3  cas_n }
        {  ddr3  we_n }
        {  ddr3  dm }
        {  ddr3  dmu }
        {  ddr3  dml }
        {  ddr3  ba }
        {  ddr3  a }
        {  ddr3  ap }
        {  ddr3  bc_n }
        {  ddr3  reset_n }
        {  ddr3  dq }
        {  ddr3  dqu }
        {  ddr3  dql }
        {  ddr3  dqs }
        {  ddr3  dqs_n }
        {  ddr3  dqsu }
        {  ddr3  dqsu_n }
        {  ddr3  dqsl }
        {  ddr3  dqsl_n }
        {  ddr3  tdqs }
        {  ddr3  tdqs_n }
        {  ddr3  zq }
        {  ddr3  parity }
        {  ddr  ck }
        {  ddr  ck_n }
        {  ddr  cke }
        {  ddr  cs_n }
        {  ddr  ras_n }
        {  ddr  cas_n }
        {  ddr  we_n }
        {  ddr  cm }
        {  ddr  udm }
        {  ddr  ldm }
        {  ddr  ba }
        {  ddr  a }
        {  ddr  dq }
        {  ddr  dqs }
        {  ddr  ldqs }
        {  ddr  udqs }
        {  ddr2  ck }
        {  ddr2  ck_n }
        {  ddr2  cke }
        {  ddr2  cs_n }
        {  ddr2  odt }
        {  ddr2  ras_n }
        {  ddr2  cas_n }
        {  ddr2  we_n }
        {  ddr2  dm }
        {  ddr2  udm }
        {  ddr2  ldm }
        {  ddr2  ba }
        {  ddr2  a }
        {  ddr2  dq }
        {  ddr2  dqs }
        {  ddr2  dqs_n }
        {  ddr2  udqs }
        {  ddr2  udqs_n }
        {  ddr2  ldqs }
        {  ddr2  ldqs_n }
        {  ddr2  rdqs }
        {  ddr2  rdqs_n }

        
        {  Xddr3  { addr a } }
        {  Xddr3  { clk ck  } }
        {  Xddr3  { clk_n ck_n } }
        {  Xddr3  { clk_p ck  } }
        {  Xddr3  { ldm dm } }
        {  Xddr3  { rst reset_n  } }
        {  Xddr3  { rst_n reset_n } }
        {  Xddr3  { reset reset_n } }
        {  Xddr3  { udm dmu } }
        {  Xddr3  { udqs dqsu } }
        {  Xddr3  { udqs_n dqsu_n } }
        {  Xddr3  { dqs_p dqs } }
        {  Xddr3  { ck_p ck } }
        {  Xddr3 rzq  }
        {  Xddr3 zio  }
        
    }
    
    
    
    ## Uniquify and sort ( sort by descending length of string )
    array set tmp { }
    foreach x  $pinlist { 
        set m [lindex $x 0 ]
        if { [string equal $m ddr3 ] || [ string equal $m Xddr3 ] } {
            set tmp([lindex $x 1]) 1 
        }
    }
    set std_signals [ lsort -command comp_drxpin  [array names tmp ] ]
    
    
    set signal $sig
    ## Elimiate [..] from end of signal
    if { [regexp {^(.*)\[.*\]$} $sig  a b] } {
        set sig $b
    }

    foreach kw $std_signals {
        ## Each entry can be  foo or {foo bar }
        set k [lindex $kw 0 ]
        set r [lindex $kw 1 ]
        if { [string match -nocase "*_$k" $sig ] || [string equal -nocase $k $sig ] } {
            if { [ string equal $r {} ] } {
                return $k 
            } else { 
                return $r
            }
        }
    }
    puts  "ERROR*** : Signal $signal can not be equated to a ddrx pin"
    return $sig
}

###
### Read the XIL_MEMORY_V1 pins from the MPD
### and populate hdl_xdrPinToPort hash.
###

array set mpd_xdrPinToPort { }
array unset mpd_xdrPinToPort *
global mpd_xdrPinToPort

proc mpd_make_xdrPinToPort  { mhsinst  } {

    global mpd_xdrPinToPort

    set mpdhand [ xget_hw_mpd_handle $mhsinst ]
    set ioifs [xget_hw_ioif_handle $mpdhand * ]

    ## What is the interface name for XIL_MEMORY_V1 .. (memory_0)
    foreach ioif $ioifs { 
        #puts [ xget_hw_subproperty_value $ioif IO_IF]
        if { [string equal [ xget_hw_subproperty_value $ioif IO_TYPE] hide_122_XIL_MEMORY_V1 ] } {
            set if_name [ xget_hw_name $ioif]
        }
    }
    
    ## Now find port 
    set ports [ xget_hw_port_handle $mpdhand * ]

    foreach port $ports {
        if { [string equal [xget_hw_subproperty_value $port IO_IF ] $if_name ] } {
            set pname [xget_hw_name $port]
            set xdrpin [ signal_to_drxpin $pname ]
            set mpd_xdrPinToPort($xdrpin) $pname
            #puts "UCFMAP: $pname ==> $xdrpin"
        }    
    }
}

##
## MIG writes errors in mig_file_drc_messages
## this proc just puts that file on stdout
proc mig_drc_report { fl } {

    if { [catch { set fd [ open $fl r ] } err] } { 
        return
    } else {
        puts   [ read $fd ]
        close $fd
        puts  " *******  MIG Reported errors"
    }
}

proc generate_corelevel_constraints { mhsinst } {

    set name [ xget_hw_name $mhsinst ]
    set filename __xps/[xget_hw_name $mhsinst]/[mig_file_ucf]

    ### open ncf file to write out ...
    if { [catch { set ncfout [ open [ncf_file $mhsinst] w ] } err] } { 
        error  $err 
    }

    ## Skip MIG specific constraints if C_BYPASS_CORE_UCF is not 0
    set bypass   [xget_hw_parameter_value $mhsinst "C_BYPASS_CORE_UCF"]
    if { $bypass == 0 } {
        mig_ucf_import $mhsinst $ncfout
    }

    generate_synch_constraints $mhsinst $ncfout
    generate_mcb_performance_constraints $mhsinst $ncfout
    close $ncfout
}

proc ncf_file { mhsinst } {

    # specify file name
    set  filePath [xget_ncf_dir $mhsinst]
    file mkdir    $filePath
    set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set    name_lower [string   tolower   $instname]
    set    fileName   $name_lower
    append fileName   "_wrapper.ucf"
    append filePath   $fileName

    # Open a file for writing
    return $filePath

}

##############################################################################
##############################################################################
## Calling MIG, and data exchange with MIG
##############################################################################
##############################################################################

#***--------------------------------***-----------------------------------***
# Invoke MIG binary, passing the correct parameters
#  return MIG return code, 0 means success
proc mig_invoke  { mhsinst migflags } {

    global is_mig_batch

    set name [ xget_hw_name $mhsinst ]

    file mkdir __xps 
    file mkdir __xps/$name 

    cd "__xps/$name"

    
    file delete -force [mig_file_output] [mig_file_input ] 
    file delete -force [mig_file_param_output ] [mig_file_param_input ]
    file delete -force [mig_file_ucf ] [mig_file_prj_output ]
    file delete -force [mig_file_drc_messages ] 

    param_writexml  $mhsinst 

    mig_input_file  $mhsinst  $migflags
    
    set mig_bin [ get_mig_executable ]

    dbg "Executing $mig_bin -cg_exc_inp [mig_file_input] -cg_exc_out [mig_file_output]"
    execpipe  "$mig_bin -cg_exc_inp [mig_file_input] -cg_exc_out [mig_file_output]"

    ## Create a test case for MIG ...
    global env
    if [info exists env(_MIG_SAVE_DIR)] {
        set outdir [clock format [clock seconds ] -format "$env(_MIG_SAVE_DIR)/%F/%T" ]
        file mkdir $outdir
        foreach f [ glob * ] {
            file copy -force $f $outdir
        }
    }
    

    set migcode -1

    if { [catch { set fd [ open [mig_file_output] r ] } err] } { 
        set migcode -1
    } else {
        while {[gets $fd line] >= 0} {
            set  sp [ split $line ]
            if { [string equal [lindex $sp 0 ] SET_ERROR_CODE ] } {
                set migcode [lindex $sp 1 ]
            }       
        }
        close $fd
    }
    
    #execpipe "ls -al"
    if {  [ file exists $name.ucf ] } { 
        file rename $name.ucf [mig_file_ucf ]
    }
    #execpipe "ls -al"
    cd "../.."
    
    ## Sometime MIG leaves mig_file_drc_messages in $name
    if { [ file exists __xps/$name/$name/[mig_file_drc_messages] ] } {
        file rename -force  __xps/$name/$name/[mig_file_drc_messages]  __xps/$name
    }

    if { ( $migcode != 0 ) } {
        if { [ file exists  __xps/$name/[mig_file_drc_messages ] ] } {
            mig_drc_report __xps/$name/[mig_file_drc_messages]
        }
        if {  $is_mig_batch == 1 } { 
            error "Batch mode invocation of MIG has failed with error code $migcode" "" "mdt_error"
            puts "Run 'Configure IP' for  $name to configure the core correctly"
        } else { 
            puts "Configuration of $name by MIG aborted. MIG returned code $migcode"
        }
    }
    puts "MIG returned $migcode"

    if { $migcode == -1 } {
        global env
        global tcl_platform
        if { [string equal $tcl_platform(os) Linux] == 1 } {
            if {  [info exists env(DISPLAY) ] == 0 } {
                puts "**** WARNING: The environment variable DISPLAY is not. MIG execution will fail if the X Windows Server mentioned in DISPLAY variable is not accessible"
            } else {
                puts "**** WARNING: The environment variable DISPLAY is set to $env(DISPLAY). MIG execution will fail if the X Windows Server mentioned in DISPLAY variable is not accessible. "
            }
        }
    }
    
    
    return $migcode
}

##############################################################################
##############################################################################
## Utility functions .. should be moved to seperate file
##############################################################################
##############################################################################

#***--------------------------------***-----------------------------------***
# Utility process to call a command and pipe it's output to screen.
# Used instead of Tcl's exec
proc execpipe COMMAND {

    if { [catch {open "| $COMMAND 2>@stdout"} FILEHANDLE] } {
        return "Can't open pipe for '$COMMAND'"
    }

    set PIPE $FILEHANDLE
    fconfigure $PIPE -buffering none
    
    set OUTPUT ""
    
    while { [gets $PIPE DATA] >= 0 } {
        puts $DATA
        append OUTPUT $DATA "\n"
    }
    
    if { [catch {close $PIPE} ERRORMSG] } {
        
        if { [string compare "$ERRORMSG" "child process exited abnormally"] == 0 } {
            # this error means there was nothing on stderr (which makes sense) and
            # there was a non-zero exit code - this is OK as we intentionally send
            # stderr to stdout, so we just do nothing here (and return the output)
        } else {
            return "Error '$ERRORMSG' on closing pipe for '$COMMAND'"
        }

    }

    regsub -all -- "\n$" $OUTPUT "" STRIPPED_STRING
    return "$STRIPPED_STRING"

}

### This is needed by BSB

proc set_param_value {mhsinst paramname paramvalue} {
    set param_handle [xget_hw_parameter_handle $mhsinst $paramname]
    if {[string length $param_handle] == 0} {
        xadd_hw_ipinst_parameter $mhsinst $paramname $paramvalue
    } else {
        xset_hw_parameter_value $param_handle $paramvalue
    }
}

# -end-of-common-

proc device_specific_parameter_handling { mhsinst xmlPV }  {

}

###############################################################################
## Generates constraints for clock cross domain crossing between axi and mcb
###############################################################################
proc generate_synch_constraints { mhsinst outputFile } {

    set instname        [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set INST            "$instname/mcb_ui_top_0/P?_UI_AXI.axi_mcb_synch/synch_d1*";
    set TNM             "TNM_TIG_${instname}_CALIB_DONE_SYNCH";
    set TS              "TS_TIG_${instname}_CALIB_DONE_SYNCH";
    puts $outputFile "";
    puts $outputFile "#########################################################################";
    puts $outputFile "# TIG synchronizer signals                                              #";
    puts $outputFile "#########################################################################";
    puts $outputFile "INST \"${INST}\" TNM=\"${TNM}\";";
    puts $outputFile "TIMESPEC \"${TS}\" = FROM FFS TO \"${TNM}\" TIG;";
    set INST            "$instname/sys_rst_synch/synch_d1*";
    set TNM             "TNM_TIG_${instname}_SYS_RST_SYNCH";
    set TS              "TS_TIG_${instname}_SYS_RST_SYNCH";
    puts $outputFile "";
    puts $outputFile "INST \"${INST}\" TNM=\"${TNM}\";";
    puts $outputFile "TIMESPEC \"${TS}\" = FROM FFS TO \"${TNM}\" TIG;";

}

###############################################################################
## Generates constraints for running at extended voltage for higher frequency
###############################################################################
proc generate_mcb_performance_constraints { mhsinst outputFile } {

    set mcb_perf    [xget_hw_parameter_value $mhsinst "C_MCB_PERFORMANCE"]
    if {[string match -nocase {extended} $mcb_perf]} { 
        puts $outputFile "";
        puts $outputFile "#########################################################################";
        puts $outputFile "# Config for Extended Performance                                       #";
        puts $outputFile "#########################################################################";
        puts $outputFile "CONFIG MCB_PERFORMANCE=EXTENDED;";
    } 
}

## Import mig ucf i<nto our own...
proc mig_ucf_import {  mhsinst ncfout } {

    set name [xget_hw_name $mhsinst ]
    set  filename __xps/[xget_hw_name $mhsinst]/[mig_file_ucf]
    ### ucfin is input ucf
    if { [catch { set ucfin [ open $filename r ] } err] } { 
        error "MIG didn't completed succesfully. The UCF from MIG is not generated" 
        error  $err     
    }

    ### get mpd ports
    global mpd_xdrPinToPort

    mpd_make_xdrPinToPort  $mhsinst
    
    ## TODO : For proper scanning of UCF, merge lines till ends with ';'
    ### Now scan the UCF for intersting things...
    while { [ gets $ucfin line ] >= 0 } {
        
        if       { [regexp -nocase {^\s*#.*$}  $line v0 ] } {
            # Pass lines that are comments straight through
            puts $ncfout $line
        } elseif { [regexp -nocase {SYS_CLK\d} $line v0 ] } {
            # Drop the c3_sys_** lines
        } elseif { [regexp -nocase {mcb\d_dram_sys_clk} $line v0 ] } {
            # Drop the mcbx_dram_sys_clk** lines
        } elseif { [regexp -nocase {^\s*NET\s+"(c\d_sys_[A-Za-z0-9_]+)(\[[0-9*]*\])?"\s+.*} $line v0 net arr] } {
            # Drop the c3_sys_** lines
        } elseif { [regexp -nocase {^\s*NET\s+"c._pll_lock"\s+.*} $line v0 ] } {
            # Drop NET "c?_pll_lock" TIG; line to be dropped
        } elseif { [regexp -nocase {^\s*$} $line v0 ] } {
            # Pass blanks or empty lines through
            puts $ncfout $line
        } elseif { [regexp -nocase {^\s*CONFIG.*$} $line v0 ] } {
            # Pass config lines through
            puts $ncfout $line
        } elseif { [regexp -nocase {^\s*TIMESPEC.*$} $line v0 ] } {
            # Pass Timespec Lines through
            puts $ncfout $line
        } elseif { [regexp -nocase {^\s*NET\s+".*(mcb_raw_wrapper_inst/.*)"(\s+.*)} $line v0 net rest] } {
            puts $ncfout "NET \"*/$net\" $rest"
        } elseif { [regexp -nocase {^\s*INST\s+".*(mcb_raw_wrapper_inst/.*)"(\s+.*)} $line v0 inst rest] } {
            puts $ncfout "INST \"*/$inst\" $rest"
# Delete the area between the ###### to revert back previous funciontiality
######## RZQ/ZIO TMP CODE START #############################################
        } elseif { [regexp -nocase {^\s*NET\s+"(mcb[A-Za-z0-9_]+)(\[[0-9*]*\])?"\s*((\w+)\s*=\s*"?(\w+)"?)?} $line v0 net arr full_attrib param value] } {
            ## xform net
            set sig [ signal_to_drxpin $net  ]
            if  { [ info exists mpd_xdrPinToPort($sig) ] } { 
                set newsig $mpd_xdrPinToPort($sig)
                #puts " UCF RENAME : $net ==> $newsig  ($sig) "
            } else {
                set newsig $net
                puts " UCF NOMATCH : $net ==> $newsig  ($sig) "
            }
            set new_loc $value
            # Update rzq/zio locations to use the parameter values if they are set
            if {[string match -nocase {rzq} $newsig] && [string match -nocase {loc} $param]} { 
                set new_loc [xget_hw_parameter_value $mhsinst C_MCB_RZQ_LOC]
                if {[string match -nocase {not_set} $new_loc]} { 
                    set new_loc $value
                }
            }
            # Update rzq/zio locations to use the parameter values if they are set
            if {[string match -nocase {zio} $newsig] && [string match -nocase {loc} $param]} { 
                set new_loc [xget_hw_parameter_value $mhsinst C_MCB_ZIO_LOC]
                if {[string match -nocase {not_set} $new_loc]} { 
                    set new_loc $value
                }
            }

            puts $ncfout [string map [list $net  $newsig $value $new_loc ] $line]
            #puts "NET:$net :$line"
######## RZQ/ZIO TMP CODE END ###############################################
        } elseif { [regexp -nocase {^\s*NET\s+"(mcb[A-Za-z0-9_]+)(\[[0-9*]*\])?"\s+.*} $line v0 net arr] } {
            ## xform net
            set sig [ signal_to_drxpin $net  ]
            if  { [ info exists mpd_xdrPinToPort($sig) ] } { 
                set newsig $mpd_xdrPinToPort($sig)
                #puts " UCF RENAME : $net ==> $newsig  ($sig) "
            } else {
                set newsig $net
                puts " UCF NOMATCH : $net ==> $newsig  ($sig) "
            }
            puts $ncfout [string map [list $net  $newsig  ] $line]
            #puts "NET:$net :$line"
            ## This is spartan6 ....
        } else {
            puts "****** Unhandled UCF line: $line"
            puts $ncfout $line
        }       
    }

    close $ucfin
}

proc syslevel_drc_mpmc_clk0_period_ps { param_handle } {

    set mhsinst [xget_hw_parent_handle $param_handle]
    set clock_port [xget_hw_port_handle $mhsinst "sysclk_2x"]
    set clock_frequency [xget_hw_subproperty_value $clock_port "CLK_FREQ_HZ"]
    set mpmc_clk0_period_ps [xget_hw_value $param_handle]

    if {$mpmc_clk0_period_ps == 1} { 
        error "Clock period is not set.  Please set the period of your memory clock in picoseconds with the parameter C_MPMC_CLK0_PERIOD_PS." "" "mdt_error"
    } elseif {$clock_frequency == ""} {
        set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
        set    ipname     [xget_hw_option_value    $mhsinst "IPNAME"]
        puts  "WARNING:  $instname ($ipname) - Could not determine clock frequency on input clock port MPMC_Clk0,\
               not performing clock DRCs."
    } else { 
        set clk_period [expr {pow(10,12) / $clock_frequency}]
        set clk_period_max [expr {pow(10,12) / ($clock_frequency - $clock_frequency * 0.001)}]
        set clk_period_min [expr {pow(10,12) / ($clock_frequency + $clock_frequency * 0.001)}]

        set mpmc_clk0_period_ps [xget_hw_value $param_handle]

        if { $mpmc_clk0_period_ps > $clk_period_max || $mpmc_clk0_period_ps < $clk_period_min } {
            error "The clock period specifed ($mpmc_clk0_period_ps ps) does not fall within 0.1% of the frequency\
                   $clock_frequency Hz reported on MPMC_Clk0.  Please check your clock frequency settings in your\
                   system." "" "mdt_error" 
        }
    }
}

## IPLEVEL TCL Procs ##
###############################################################################
# Set to 1 if sys_rst is connected
###############################################################################
proc iplevel_update_sys_rst_present { param_handle } { 
    set mhsinst     [xget_hw_parent_handle   $param_handle]
    set port_value  [xget_hw_port_value $mhsinst "sys_rst"]

    if {[llength $port_value] == 0} {
      return 0
    } else { 
      return 1
    }
}
###############################################################################
# Parses out the port number from the parameter name and checks the value
# to make sure it is valid
###############################################################################
proc util_get_port_number { param_handle } { 

    set param_name  [xget_hw_name $param_handle]
    # Get the port number from C_Sx_AXI...
    set x           [string index $param_name 3]
    # check the value is between 0 and 5 
    if {$x < 0 | $x > 5} { 
        error "Error parsing port number of $param_name." "" "mdt_error"
    }
    
    return $x
}

###############################################################################
# Parses the port_config parameter to return the maximum number of ports
###############################################################################
proc util_get_max_num_ports { mhsinst } { 

    set port_config [xget_hw_parameter_value $mhsinst "C_PORT_CONFIG"]
    set port_list   [split $port_config "_"]
    return [llength $port_list]
}

###############################################################################
# Parses the port_config parameter to return the port type of the number passed
# into the proc
###############################################################################
proc util_get_port_config { mhsinst port_num } { 

    set port_config [xget_hw_parameter_value $mhsinst "C_PORT_CONFIG"]
    set port_list   [split $port_config "_"]
    set port_count  [llength $port_list]

    # If the port number is valid in the port config return it, otherwise 
    # return default value of B32
    if {$port_num < $port_count} { 
        return [lindex $port_list $port_num]
    } else { 
        return "B32"
    }
    
}

###############################################################################
# Parse the data width out of the C_PORT_CONFIG parameter and return the value
###############################################################################
proc util_get_mcb_data_width { param_handle } { 
    set mhsinst     [xget_hw_parent_handle   $param_handle]
    set param_value [xget_hw_value           $param_handle]
    set x           [util_get_port_number    $param_handle]
    set port_x_config [util_get_port_config $mhsinst $x]
    set dwidth      [string range $port_x_config 1 end]
    if {[string is integer $dwidth]} { 
        if { $dwidth == 32 } { 
            return 32
        } elseif { $dwidth == 64 } {
            return 64
        } elseif { $dwidth == 128 } {
            return 128 
        }
    }

    error "Invalid port data width parsed from C_PORT_CONFIG: $port_x_config -> $dwidth" "" "mdt_error"
    return 32
}

###############################################################################
# Parse the data width out of the C_PORT_CONFIG parameter and return the value
###############################################################################
proc iplevel_update_axi_data_width  { param_handle } {
    return [util_get_mcb_data_width $param_handle]
}

###############################################################################
# Parse the data width out of the C_PORT_CONFIG parameter and return the value
###############################################################################
proc iplevel_update_data_port_size  { param_handle } {
    return [util_get_mcb_data_width $param_handle]
}

###############################################################################
# Parse the data width out of the C_PORT_CONFIG parameter and return the value
###############################################################################
proc iplevel_update_mask_size       { param_handle } {
    set data_width [util_get_mcb_data_width $param_handle]
    return [expr {$data_width/8}]
}

###############################################################################
# Parse the direction out of the C_PORT_CONFIG parameter and return the value
###############################################################################
proc iplevel_update_axi_supports_read { param_handle } { 
    set mhsinst     [xget_hw_parent_handle   $param_handle]
    set param_value [xget_hw_value           $param_handle]
    set x           [util_get_port_number    $param_handle]
    set port_x_config [util_get_port_config $mhsinst $x]
    set r_w_or_b    [string range $port_x_config 0 0]
    if {[string equal $r_w_or_b "B"]} {
        return 1
    } elseif {[string equal $r_w_or_b "R"]} {
        return 1
    } else {
        return 0
    }
}

###############################################################################
# Parse the direction out of the C_PORT_CONFIG parameter and return the value
###############################################################################
proc iplevel_update_axi_supports_write { param_handle } { 
    set mhsinst     [xget_hw_parent_handle   $param_handle]
    set param_value [xget_hw_value           $param_handle]
    set x           [util_get_port_number    $param_handle]
    set port_x_config [util_get_port_config $mhsinst $x]
    set r_w_or_b    [string range $port_x_config 0 0]
    if {[string equal $r_w_or_b "B"]} {
        return 1
    } elseif {[string equal $r_w_or_b "W"]} {
        return 1
    } else {
        return 0
    }
}

###############################################################################
# Set to 1 if Clock speed is < 120 on -1 if C_Sx_AXI_SUPPORTS_NARROW_BURST == 0
###############################################################################
proc syslevel_update_axi_reg_en0   { param_handle } {
    set mhsinst     [xget_hw_parent_handle   $param_handle]
    set x           [util_get_port_number $param_handle]

    set axi_enable  [xget_hw_port_handle $mhsinst "C_S${x}_AXI_ENABLE"]
    if {$axi_enable == 0} {
        return [xget_hw_value $param_handle]
    }
    set axi_clk_port  [xget_hw_port_handle $mhsinst "s${x}_axi_aclk"]
    set axi_clk_freq  [xget_hw_subproperty_value $axi_clk_port "CLK_FREQ_HZ"]
    set axi_use_upsizer [xget_hw_port_handle $mhsinst "C_S${x}_AXI_SUPPORTS_NARROW_BURST"]
    set fpga_speedgrade [xget_hw_proj_setting fpga_speedgrade]

    set cutoff_freq 120000000
    set reg_on 0x0000F
    set reg_off 0x00000
    if {$axi_use_upsizer == 1} { 
        set cutoff_freq 80000000
        set reg_on  0x0030E
        set reg_off 0x0000E
    }

    if {$axi_clk_freq == ""} { 
        return $reg_on
    }

    if {[string match $fpga_speedgrade "-2"]} { 
        set cutoff_freq [expr {$cutoff_freq * 1.10}]
    } elseif {[string match $fpga_speedgrade "-3"]} { 
        set cutoff_freq [expr {$cutoff_freq * 1.20}]
    } elseif {[string match $fpga_speedgrade "-4"]} { 
        set cutoff_freq [expr {$cutoff_freq * 1.30}]
    }

    if {$axi_clk_freq < $cutoff_freq} { 
        return $reg_off
    } else {
        return $reg_on
    }
}

###############################################################################
# if port is not enabled, return default value
# if max number of ports == 1 return 0
# if only 1 port enabled return 0
#   If not a port is not connected, consider it not enabled
###############################################################################
proc syslevel_update_axi_strict_coherency { param_handle } {
    set mhsinst     [xget_hw_parent_handle   $param_handle]
    set x           [util_get_port_number $param_handle]

    set port_enabled [xget_hw_parameter_value $mhsinst "C_S${x}_AXI_ENABLE"]

    if {$port_enabled == 0} { 
        # return default value
        set def_value [xget_hw_value $param_handle]
        return $def_value
    }

    set max_num_ports [util_get_max_num_ports $mhsinst]
    if {$max_num_ports == 1} { 
        return 0
    }

    set num_ports_enabled 0
    for { set x 0 } { $x < $max_num_ports } {incr x} {
        set port_enable_name "C_S${x}_AXI_ENABLE"
        set busif       "S${x}_AXI"
        set connector [xget_hw_busif_value $mhsinst $busif]
        set port_enable [xget_hw_parameter_value $mhsinst $port_enable_name]

        if {$port_enable == 1 && [llength $connector] > 0} { 
            incr num_ports_enabled
        }
    }
    
    if { $num_ports_enabled > 1 } {
        return 1
    } else { 
        return 0
    }
}

proc syslevel_update_memclk_period { param_handle } {
    set mhsinst [xget_hw_parent_handle $param_handle]
    set clock_port_2x [xget_hw_port_handle $mhsinst "sysclk_2x"]
    set clock_freq_2x [xget_hw_subproperty_value $clock_port_2x "CLK_FREQ_HZ"]
    # convert to picoseconds
    set clock_period_2x [expr {pow(10,12) / $clock_freq_2x}]
    # Multiply by 2 to get the period of the memory.
    return [expr {int($clock_period_2x *2)}]
}

proc syslevel_drc_memclk_period { param_handle } {
    set mhsinst [xget_hw_parent_handle $param_handle]
    set period [xget_hw_value $param_handle]
    if {$period == 0} { 
        error "Parameter C_MEMCLK_PERIOD is not set correctly.  Please set this value in the MHS.  This value should be the period in picoseconds of sys_clk_2x multiplied by 2." "" "mdt_error"
    }
}

proc xps_sav_add_new_mhsinst {mergedmhs mhsinst mpd} {
    for {set x 0} {$x < 6} {incr x 1} {
        set interface_enabletag [concat C_S${x}_AXI_ENABLE]
        set interface_enabled [xget_hw_parameter_value $mpd $interface_enabletag]

        if {$interface_enabled == 1} {
            set base_addr [concat C_S${x}_AXI_BASEADDR]
            set_param_value $mhsinst $base_addr "0X00000000"

            set high_addr [concat C_S${x}_AXI_HIGHADDR]
            set_param_value $mhsinst $high_addr "0X0FFFFFFF"
        }
    }
}

proc xps_sav_autobusconnection_mhsinst {mergedmhs mhsinst mpd} {
    for {set x 0} {$x < 6} {incr x 1} {
        set interface_enabletag [concat C_S${x}_AXI_ENABLE]
        set interface_enabled [xget_hw_parameter_value $mhsinst $interface_enabletag]
        
        if {$interface_enabled == 1} {
            set base_addr [concat C_S${x}_AXI_BASEADDR]
            set_param_value $mhsinst $base_addr "0X00000000"
            
            set high_addr [concat C_S${x}_AXI_HIGHADDR]
            set_param_value $mhsinst $high_addr "0X0FFFFFFF"
        }
    }
}
