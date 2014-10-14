-------------------------------------------------------------------------------
-- axi_vdma_cdc
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
-- Filename:    axi_vdma_cdc.vhd
-- Description: This entity encompases the Clock Domain Crossing Pulse
--              Generator
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
--  GAB     6/22/10    v4_00_a
-- ^^^^^^
--  - Initial Release
-- ~~~~~~
--  GAB     8/19/11     v5_00_a
-- ^^^^^^
--  Intial release of v5_00_a
--  Added fsync on tuser(0) feature
--  Added fsync crossbar feature
--  Increased Frame Stores to 32
--  Added internal GenLock Option
-- ~~~~~~
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library axi_vdma_v5_00_a;
use axi_vdma_v5_00_a.axi_vdma_pkg.all;

-------------------------------------------------------------------------------
entity  axi_vdma_cdc is
    generic (
        C_CDC_TYPE                  : integer range 0 to 1 := 0                 ;
            -- Clock domain crossing type
            -- 0 = pulse
            -- 1 = level

        C_RESET_STATE               : integer range 0 to 1 := 0                 ;

        C_VECTOR_WIDTH              : integer := 32
            -- Vector Data witdth
    );
    port (
        prmry_aclk                  : in  std_logic                             ;               --
        prmry_resetn                : in  std_logic                             ;               --
                                                                                                --
        scndry_aclk                 : in  std_logic                             ;               --
        scndry_resetn               : in  std_logic                             ;               --
                                                                                                --
        -- Secondary to Primary Clock Crossing                                                  --
        scndry_in                   : in  std_logic                             ;               --
        prmry_out                   : out std_logic                             ;               --
                                                                                                --
        -- Primary to Secondary Clock Crossing                                                  --
        prmry_in                    : in  std_logic                             ;               --
        scndry_out                  : out std_logic                             ;               --
                                                                                                --
        scndry_vect_s_h             : in  std_logic                             ;               --
        scndry_vect_in              : in  std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)           ;               --
        prmry_vect_out              : out std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)           ;               --
                                                                                                --
        prmry_vect_s_h              : in  std_logic                             ;               --
        prmry_vect_in               : in  std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)           ;               --
        scndry_vect_out             : out std_logic_vector                                      --
                                        (C_VECTOR_WIDTH - 1 downto 0)                           --

    );

end axi_vdma_cdc;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture implementation of axi_vdma_cdc is

-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------

-- No Functions Declared

-------------------------------------------------------------------------------
-- Constants Declarations
-------------------------------------------------------------------------------

-- No Constants Declared

-------------------------------------------------------------------------------
-- Signal / Type Declarations
-------------------------------------------------------------------------------
signal p_vect_in_d1     : std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');
signal s_vect_out_d1    : std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');
signal s_vect_out_d2    : std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');

signal s_vect_in_d1     : std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');
signal p_vect_out_d1    : std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');
signal p_vect_out_d2    : std_logic_vector(C_VECTOR_WIDTH-1 downto 0) := (others => '0');

-------------------------------------------------------------------------------
-- Begin architecture logic
-------------------------------------------------------------------------------
begin

-- Generate PULSE clock domain crossing
GENERATE_PULSE_CDC : if C_CDC_TYPE = CDC_TYPE_PULSE generate
-- Secondary to Primary
signal s_pulse_in_s_h           : std_logic := '0';
signal s_pulse_in_s_h_clr       : std_logic := '0';
signal p_pulse_out_d1           : std_logic := '0';
signal p_pulse_out_d2           : std_logic := '0';
signal p_pulse_out_d3           : std_logic := '0';
signal p_pulse_out_re           : std_logic := '0';
signal p_pulse_out_s_h          : std_logic := '0';
signal s_pulse_out_s_h_d1       : std_logic := '0';
signal s_pulse_out_s_h_d2       : std_logic := '0';
signal s_pulse_out_s_h_d3       : std_logic := '0';

-- Primary to Secondary
signal p_pulse_in_s_h           : std_logic := '0';
signal p_pulse_in_s_h_clr       : std_logic := '0';
signal s_pulse_out_d1           : std_logic := '0';
signal s_pulse_out_d2           : std_logic := '0';
signal s_pulse_out_d3           : std_logic := '0';
signal s_pulse_out_re           : std_logic := '0';
signal s_pulse_out_s_h          : std_logic := '0';
signal p_pulse_out_s_h_d1       : std_logic := '0';
signal p_pulse_out_s_h_d2       : std_logic := '0';
signal p_pulse_out_s_h_d3       : std_logic := '0';

begin

    --*****************************************************************************
    --**                  Asynchronous Pulse Clock Crossing                      **
    --**                        PRIMARY TO SECONDARY                             **
    --*****************************************************************************
    -- Limitations:
    -- For prmry_aclk faster than scndry_aclk then limited to pulse period greater
    -- than (prmry_clk_freq / scndry_clk_freq) * 5
    -- For prmry_aclk slower than scndry_aclk then limited to pulse period greater
    -- than (scndry_clk_freq / prmry_clk_freq) / 5

    -- Sample and hold primary pulse
    PRMRY_IN_S_H_PULSE : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0' or p_pulse_in_s_h_clr='1')then
                    p_pulse_in_s_h <= '0';
                elsif(prmry_in = '1')then
                    p_pulse_in_s_h <= '1';
                end if;
            end if;
        end process PRMRY_IN_S_H_PULSE;

    -- Cross sample and held pulse to secondary domain
    P_IN_CROSS2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0')then
                    s_pulse_out_d1  <= '0';
                    s_pulse_out_d2  <= '0';
                    s_pulse_out_d3  <= '0';
                    s_pulse_out_re  <= '0';
                else
                    s_pulse_out_d1  <= p_pulse_in_s_h;
                    s_pulse_out_d2  <= s_pulse_out_d1;
                    s_pulse_out_d3  <= s_pulse_out_d2;
                    s_pulse_out_re  <= s_pulse_out_d2 and not s_pulse_out_d3;
                end if;
            end if;
        end process P_IN_CROSS2SCNDRY;

    -- Sample and hold secondary pulse for clearing primary sampled
    -- and held pulse
    SCNDRY_OUT_S_H_PULSE : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0' or s_pulse_out_d2='0')then
                    s_pulse_out_s_h <= '0';
                elsif(s_pulse_out_re = '1')then
                    s_pulse_out_s_h <= '1';
                end if;
            end if;
        end process SCNDRY_OUT_S_H_PULSE;

    -- Cross sample and held pulse to primary domain
    S_OUT_CROSS2PRMRY : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_pulse_out_s_h_d1   <= '0';
                    p_pulse_out_s_h_d2   <= '0';
                    p_pulse_out_s_h_d3   <= '0';
                else
                    p_pulse_out_s_h_d1   <= s_pulse_out_s_h;
                    p_pulse_out_s_h_d2   <= p_pulse_out_s_h_d1;
                    p_pulse_out_s_h_d3   <= p_pulse_out_s_h_d2;
                end if;
            end if;
        end process S_OUT_CROSS2PRMRY;

    -- Create sample and hold clear
    p_pulse_in_s_h_clr <= p_pulse_out_s_h_d2 and not p_pulse_out_s_h_d3;

    -- Feed secondary pulse out
    scndry_out <= s_pulse_out_re;



    --*****************************************************************************
    --**                  Asynchronous Pulse Clock Crossing                      **
    --**                        SECONDARY TO PRIMARY                             **
    --*****************************************************************************
    -- Limitations:
    -- For scndry_aclk faster than prmry_aclk then limited to pulse period greater
    -- than (prmry_clk_freq / scndry_clk_freq) * 5
    -- For scndry_aclk slower than prmry_aclk then limited to pulse period greater
    -- than (scndry_clk_freq / prmry_clk_freq) / 5

    -- Sample and hold secondary pulse
    SCNDRY_IN_S_H_PULSE : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0' or s_pulse_in_s_h_clr='1')then
                    s_pulse_in_s_h <= '0';
                elsif(scndry_in = '1')then
                    s_pulse_in_s_h <= '1';
                end if;
            end if;
        end process SCNDRY_IN_S_H_PULSE;

    -- Cross sample and held pulse to primary domain
    S_IN_CROSS2PRMRY : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_pulse_out_d1  <= '0';
                    p_pulse_out_d2  <= '0';
                    p_pulse_out_d3  <= '0';
                    p_pulse_out_re  <= '0';
                else
                    p_pulse_out_d1  <= s_pulse_in_s_h;
                    p_pulse_out_d2  <= p_pulse_out_d1;
                    p_pulse_out_d3  <= p_pulse_out_d2;
                    p_pulse_out_re  <= p_pulse_out_d2 and not p_pulse_out_d3;
                end if;
            end if;
        end process S_IN_CROSS2PRMRY;

    -- Sample and hold primary pulse for clearing secondary sampled
    -- and held pulse
    PRMRY_OUT_S_H_PULSE : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0' or p_pulse_out_d2='0')then
                    p_pulse_out_s_h <= '0';
                elsif(p_pulse_out_re = '1')then
                    p_pulse_out_s_h <= '1';
                end if;
            end if;
        end process PRMRY_OUT_S_H_PULSE;

    -- Cross sample and held pulse to secondary domain
    P_OUT_CROSS2SCDNRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0')then
                    s_pulse_out_s_h_d1   <= '0';
                    s_pulse_out_s_h_d2   <= '0';
                    s_pulse_out_s_h_d3   <= '0';
                else
                    s_pulse_out_s_h_d1   <= p_pulse_out_s_h;
                    s_pulse_out_s_h_d2   <= s_pulse_out_s_h_d1;
                    s_pulse_out_s_h_d3   <= s_pulse_out_s_h_d2;
                end if;
            end if;
        end process P_OUT_CROSS2SCDNRY;

    -- Create sample and hold clear
    s_pulse_in_s_h_clr <= s_pulse_out_s_h_d2 and not s_pulse_out_s_h_d3;

    -- Feed primary pulse out
    prmry_out <= p_pulse_out_re;
end generate GENERATE_PULSE_CDC;

-- Generate LEVEL clock domain crossing with reset state = 0
GENERATE_LEVEL_CDC : if C_CDC_TYPE = CDC_TYPE_LEVEL and C_RESET_STATE = 0 generate
-- Primary to Secondary
signal p_level_in_d1        : std_logic := '0';
signal s_level_out_d1       : std_logic := '0';
signal s_level_out_d2       : std_logic := '0';

-- Secondray to Primary
signal s_level_in_d1        : std_logic := '0';
signal p_level_out_d1       : std_logic := '0';
signal p_level_out_d2       : std_logic := '0';
begin

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        PRIMARY TO SECONDARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic
    REG_PLEVEL_IN : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_level_in_d1  <= '0';
                else
                    p_level_in_d1  <= prmry_in;
                end if;
            end if;
        end process REG_PLEVEL_IN;

    CROSS_PLEVEL_IN2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0')then
                    s_level_out_d1  <= '0';
                    s_level_out_d2  <= '0';
                else
                    s_level_out_d1  <= p_level_in_d1;
                    s_level_out_d2  <= s_level_out_d1;
                end if;
            end if;
        end process CROSS_PLEVEL_IN2SCNDRY;

    scndry_out <= s_level_out_d2;

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        SECONDARY TO PRIMARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic
    REG_SLEVEL_IN : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0')then
                    s_level_in_d1  <= '0';
                else
                    s_level_in_d1  <= scndry_in;
                end if;
            end if;
        end process REG_SLEVEL_IN;

    CROSS_SLEVEL_IN2PRMRY : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_level_out_d1  <= '0';
                    p_level_out_d2  <= '0';
                else
                    p_level_out_d1  <= s_level_in_d1;
                    p_level_out_d2  <= p_level_out_d1;
                end if;
            end if;
        end process CROSS_SLEVEL_IN2PRMRY;

    prmry_out <= p_level_out_d2;

end generate GENERATE_LEVEL_CDC;



-- Generate LEVEL clock domain crossing with reset state = 1
GENERATE_LEVEL_CDC2 : if C_CDC_TYPE = CDC_TYPE_LEVEL and C_RESET_STATE = 1 generate
-- Primary to Secondary
signal p_level_in_d1        : std_logic := '0';
signal s_level_out_d1       : std_logic := '0';
signal s_level_out_d2       : std_logic := '0';

-- Secondray to Primary
signal s_level_in_d1        : std_logic := '0';
signal p_level_out_d1       : std_logic := '0';
signal p_level_out_d2       : std_logic := '0';
begin

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        PRIMARY TO SECONDARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic
    REG_PLEVEL_IN : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_level_in_d1  <= '1';
                else
                    p_level_in_d1  <= prmry_in;
                end if;
            end if;
        end process REG_PLEVEL_IN;

    CROSS_PLEVEL_IN2SCNDRY : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0')then
                    s_level_out_d1  <= '1';
                    s_level_out_d2  <= '1';
                else
                    s_level_out_d1  <= p_level_in_d1;
                    s_level_out_d2  <= s_level_out_d1;
                end if;
            end if;
        end process CROSS_PLEVEL_IN2SCNDRY;

    scndry_out <= s_level_out_d2;

    --*****************************************************************************
    --**                  Asynchronous Level Clock Crossing                      **
    --**                        SECONDARY TO PRIMARY                             **
    --*****************************************************************************
    -- register is scndry to provide clean ff output to clock crossing logic
    REG_SLEVEL_IN : process(scndry_aclk)
        begin
            if(scndry_aclk'EVENT and scndry_aclk ='1')then
                if(scndry_resetn = '0')then
                    s_level_in_d1  <= '1';
                else
                    s_level_in_d1  <= scndry_in;
                end if;
            end if;
        end process REG_SLEVEL_IN;

    CROSS_SLEVEL_IN2PRMRY : process(prmry_aclk)
        begin
            if(prmry_aclk'EVENT and prmry_aclk ='1')then
                if(prmry_resetn = '0')then
                    p_level_out_d1  <= '1';
                    p_level_out_d2  <= '1';
                else
                    p_level_out_d1  <= s_level_in_d1;
                    p_level_out_d2  <= p_level_out_d1;
                end if;
            end if;
        end process CROSS_SLEVEL_IN2PRMRY;

    prmry_out <= p_level_out_d2;

end generate GENERATE_LEVEL_CDC2;








-- Register signal in to give clear FF output to CDC
P_REG_GREY_IN : process(prmry_aclk)
    begin
        if(prmry_aclk'EVENT and prmry_aclk ='1')then
            if(prmry_resetn = '0')then
                p_vect_in_d1   <= (others => '0');
            elsif(prmry_vect_s_h = '1')then
                p_vect_in_d1   <= prmry_vect_in;
            end if;
        end if;
    end process P_REG_GREY_IN;

-- Double register to secondary
S_REG_GREY_OUT : process(scndry_aclk)
    begin
        if(scndry_aclk'EVENT and scndry_aclk ='1')then
            if(scndry_resetn = '0')then
                s_vect_out_d1   <= (others => '0');
                s_vect_out_d2   <= (others => '0');
            else
                s_vect_out_d1   <= p_vect_in_d1;
                s_vect_out_d2   <= s_vect_out_d1;
            end if;
        end if;
    end process S_REG_GREY_OUT;

scndry_vect_out <= s_vect_out_d2;


--*****************************************************************************
--**                  Asynchronous Level Clock Crossing                      **
--**                        SECONDARY TO PRIMARY                             **
--*****************************************************************************


-- Register signal in to give clear FF output to CDC
S_REG_GREY_IN : process(scndry_aclk)
    begin
        if(scndry_aclk'EVENT and scndry_aclk ='1')then
            if(scndry_resetn = '0')then
                s_vect_in_d1   <= (others => '0');
            elsif(scndry_vect_s_h = '1')then
                s_vect_in_d1   <= scndry_vect_in;
            end if;
        end if;
    end process S_REG_GREY_IN;

-- Double register to primary
P_REG_GREY_OUT : process(prmry_aclk)
    begin
        if(prmry_aclk'EVENT and prmry_aclk ='1')then
            if(prmry_resetn = '0')then
                p_vect_out_d1   <= (others => '0');
                p_vect_out_d2   <= (others => '0');
            else
                p_vect_out_d1   <= s_vect_in_d1;
                p_vect_out_d2   <= p_vect_out_d1;
            end if;
        end if;
    end process P_REG_GREY_OUT;

prmry_vect_out <= p_vect_out_d2;


--GENERATE_AFIFO_CDC :
--

end implementation;
