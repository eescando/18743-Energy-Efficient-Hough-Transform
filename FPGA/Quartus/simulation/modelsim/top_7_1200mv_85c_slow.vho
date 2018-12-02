-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 64-Bit"
-- VERSION "Version 12.1 Build 177 11/07/2012 SJ Full Version"

-- DATE "12/01/2018 15:46:24"

-- 
-- Device: Altera EP4CE115F29C7 Package FBGA780
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	top IS
    PORT (
	CLOCK_50 : IN std_logic;
	LEDG : OUT std_logic_vector(8 DOWNTO 0)
	);
END top;

-- Design Ports Information
-- LEDG[0]	=>  Location: PIN_E21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[1]	=>  Location: PIN_E22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[2]	=>  Location: PIN_E25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[3]	=>  Location: PIN_E24,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[4]	=>  Location: PIN_H21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[5]	=>  Location: PIN_G20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[6]	=>  Location: PIN_G22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[7]	=>  Location: PIN_G21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- LEDG[8]	=>  Location: PIN_F17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- CLOCK_50	=>  Location: PIN_Y2,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF top IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_CLOCK_50 : std_logic;
SIGNAL ww_LEDG : std_logic_vector(8 DOWNTO 0);
SIGNAL \t1|lpm_mult_component|auto_generated|mac_out2_DATAA_bus\ : std_logic_vector(35 DOWNTO 0);
SIGNAL \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\ : std_logic_vector(35 DOWNTO 0);
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1_DATAA_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1_DATAB_bus\ : std_logic_vector(17 DOWNTO 0);
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\ : std_logic_vector(35 DOWNTO 0);
SIGNAL \m1|altsyncram_component|auto_generated|ram_block1a0_PORTADATAIN_bus\ : std_logic_vector(35 DOWNTO 0);
SIGNAL \m1|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBADDR_bus\ : std_logic_vector(0 DOWNTO 0);
SIGNAL \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\ : std_logic_vector(35 DOWNTO 0);
SIGNAL \CLOCK_50~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \t1|lpm_mult_component|auto_generated|mac_out2~0\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_out2~1\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_out2~2\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_out2~3\ : std_logic;
SIGNAL \LEDG[0]~output_o\ : std_logic;
SIGNAL \LEDG[1]~output_o\ : std_logic;
SIGNAL \LEDG[2]~output_o\ : std_logic;
SIGNAL \LEDG[3]~output_o\ : std_logic;
SIGNAL \LEDG[4]~output_o\ : std_logic;
SIGNAL \LEDG[5]~output_o\ : std_logic;
SIGNAL \LEDG[6]~output_o\ : std_logic;
SIGNAL \LEDG[7]~output_o\ : std_logic;
SIGNAL \LEDG[8]~output_o\ : std_logic;
SIGNAL \CLOCK_50~input_o\ : std_logic;
SIGNAL \CLOCK_50~inputclkctrl_outclk\ : std_logic;
SIGNAL \~GND~combout\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~dataout\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT1\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT2\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT3\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT4\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT5\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT6\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT7\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT8\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT9\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT10\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT11\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT12\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT13\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT14\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT15\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT16\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT17\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT18\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT19\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT20\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT21\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT22\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT23\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT24\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT25\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT26\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT27\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT28\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT29\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT30\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT31\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~0\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~1\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~2\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|mac_mult1~3\ : std_logic;
SIGNAL \t1|lpm_mult_component|auto_generated|result\ : std_logic_vector(31 DOWNTO 0);
SIGNAL \m1|altsyncram_component|auto_generated|q_b\ : std_logic_vector(31 DOWNTO 0);

BEGIN

ww_CLOCK_50 <= CLOCK_50;
LEDG <= ww_LEDG;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\t1|lpm_mult_component|auto_generated|mac_out2_DATAA_bus\ <= (\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT31\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT30\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT29\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT28\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT27\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT26\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT25\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT24\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT23\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT22\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT21\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT20\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT19\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT18\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT17\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT16\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT15\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT14\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT13\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT12\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT11\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT10\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT9\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT8\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT7\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT6\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT5\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT4\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT3\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT2\ & \t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT1\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~dataout\ & \t1|lpm_mult_component|auto_generated|mac_mult1~3\ & \t1|lpm_mult_component|auto_generated|mac_mult1~2\ & \t1|lpm_mult_component|auto_generated|mac_mult1~1\ & 
\t1|lpm_mult_component|auto_generated|mac_mult1~0\);

\t1|lpm_mult_component|auto_generated|mac_out2~0\ <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(0);
\t1|lpm_mult_component|auto_generated|mac_out2~1\ <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(1);
\t1|lpm_mult_component|auto_generated|mac_out2~2\ <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(2);
\t1|lpm_mult_component|auto_generated|mac_out2~3\ <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(3);
\t1|lpm_mult_component|auto_generated|result\(0) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(4);
\t1|lpm_mult_component|auto_generated|result\(1) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(5);
\t1|lpm_mult_component|auto_generated|result\(2) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(6);
\t1|lpm_mult_component|auto_generated|result\(3) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(7);
\t1|lpm_mult_component|auto_generated|result\(4) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(8);
\t1|lpm_mult_component|auto_generated|result\(5) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(9);
\t1|lpm_mult_component|auto_generated|result\(6) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(10);
\t1|lpm_mult_component|auto_generated|result\(7) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(11);
\t1|lpm_mult_component|auto_generated|result\(8) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(12);
\t1|lpm_mult_component|auto_generated|result\(9) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(13);
\t1|lpm_mult_component|auto_generated|result\(10) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(14);
\t1|lpm_mult_component|auto_generated|result\(11) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(15);
\t1|lpm_mult_component|auto_generated|result\(12) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(16);
\t1|lpm_mult_component|auto_generated|result\(13) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(17);
\t1|lpm_mult_component|auto_generated|result\(14) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(18);
\t1|lpm_mult_component|auto_generated|result\(15) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(19);
\t1|lpm_mult_component|auto_generated|result\(16) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(20);
\t1|lpm_mult_component|auto_generated|result\(17) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(21);
\t1|lpm_mult_component|auto_generated|result\(18) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(22);
\t1|lpm_mult_component|auto_generated|result\(19) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(23);
\t1|lpm_mult_component|auto_generated|result\(20) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(24);
\t1|lpm_mult_component|auto_generated|result\(21) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(25);
\t1|lpm_mult_component|auto_generated|result\(22) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(26);
\t1|lpm_mult_component|auto_generated|result\(23) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(27);
\t1|lpm_mult_component|auto_generated|result\(24) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(28);
\t1|lpm_mult_component|auto_generated|result\(25) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(29);
\t1|lpm_mult_component|auto_generated|result\(26) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(30);
\t1|lpm_mult_component|auto_generated|result\(27) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(31);
\t1|lpm_mult_component|auto_generated|result\(28) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(32);
\t1|lpm_mult_component|auto_generated|result\(29) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(33);
\t1|lpm_mult_component|auto_generated|result\(30) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(34);
\t1|lpm_mult_component|auto_generated|result\(31) <= \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\(35);

\t1|lpm_mult_component|auto_generated|mac_mult1_DATAA_bus\ <= (\m1|altsyncram_component|auto_generated|q_b\(31) & \m1|altsyncram_component|auto_generated|q_b\(30) & \m1|altsyncram_component|auto_generated|q_b\(29) & 
\m1|altsyncram_component|auto_generated|q_b\(28) & \m1|altsyncram_component|auto_generated|q_b\(27) & \m1|altsyncram_component|auto_generated|q_b\(26) & \m1|altsyncram_component|auto_generated|q_b\(25) & 
\m1|altsyncram_component|auto_generated|q_b\(24) & \m1|altsyncram_component|auto_generated|q_b\(23) & \m1|altsyncram_component|auto_generated|q_b\(22) & \m1|altsyncram_component|auto_generated|q_b\(21) & 
\m1|altsyncram_component|auto_generated|q_b\(20) & \m1|altsyncram_component|auto_generated|q_b\(19) & \m1|altsyncram_component|auto_generated|q_b\(18) & \m1|altsyncram_component|auto_generated|q_b\(17) & 
\m1|altsyncram_component|auto_generated|q_b\(16) & gnd & gnd);

\t1|lpm_mult_component|auto_generated|mac_mult1_DATAB_bus\ <= (\m1|altsyncram_component|auto_generated|q_b\(15) & \m1|altsyncram_component|auto_generated|q_b\(14) & \m1|altsyncram_component|auto_generated|q_b\(13) & 
\m1|altsyncram_component|auto_generated|q_b\(12) & \m1|altsyncram_component|auto_generated|q_b\(11) & \m1|altsyncram_component|auto_generated|q_b\(10) & \m1|altsyncram_component|auto_generated|q_b\(9) & 
\m1|altsyncram_component|auto_generated|q_b\(8) & \m1|altsyncram_component|auto_generated|q_b\(7) & \m1|altsyncram_component|auto_generated|q_b\(6) & \m1|altsyncram_component|auto_generated|q_b\(5) & 
\m1|altsyncram_component|auto_generated|q_b\(4) & \m1|altsyncram_component|auto_generated|q_b\(3) & \m1|altsyncram_component|auto_generated|q_b\(2) & \m1|altsyncram_component|auto_generated|q_b\(1) & 
\m1|altsyncram_component|auto_generated|q_b\(0) & gnd & gnd);

\t1|lpm_mult_component|auto_generated|mac_mult1~0\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(0);
\t1|lpm_mult_component|auto_generated|mac_mult1~1\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(1);
\t1|lpm_mult_component|auto_generated|mac_mult1~2\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(2);
\t1|lpm_mult_component|auto_generated|mac_mult1~3\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(3);
\t1|lpm_mult_component|auto_generated|mac_mult1~dataout\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(4);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT1\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(5);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT2\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(6);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT3\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(7);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT4\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(8);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT5\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(9);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT6\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(10);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT7\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(11);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT8\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(12);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT9\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(13);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT10\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(14);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT11\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(15);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT12\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(16);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT13\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(17);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT14\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(18);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT15\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(19);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT16\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(20);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT17\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(21);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT18\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(22);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT19\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(23);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT20\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(24);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT21\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(25);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT22\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(26);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT23\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(27);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT24\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(28);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT25\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(29);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT26\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(30);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT27\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(31);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT28\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(32);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT29\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(33);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT30\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(34);
\t1|lpm_mult_component|auto_generated|mac_mult1~DATAOUT31\ <= \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\(35);

\m1|altsyncram_component|auto_generated|ram_block1a0_PORTADATAIN_bus\ <= (gnd & gnd & gnd & gnd & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & 
\~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & 
\~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\ & \~GND~combout\);

\m1|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\(0) <= \~GND~combout\;

\m1|altsyncram_component|auto_generated|ram_block1a0_PORTBADDR_bus\(0) <= \~GND~combout\;

\m1|altsyncram_component|auto_generated|q_b\(0) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(0);
\m1|altsyncram_component|auto_generated|q_b\(1) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(1);
\m1|altsyncram_component|auto_generated|q_b\(2) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(2);
\m1|altsyncram_component|auto_generated|q_b\(3) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(3);
\m1|altsyncram_component|auto_generated|q_b\(4) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(4);
\m1|altsyncram_component|auto_generated|q_b\(5) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(5);
\m1|altsyncram_component|auto_generated|q_b\(6) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(6);
\m1|altsyncram_component|auto_generated|q_b\(7) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(7);
\m1|altsyncram_component|auto_generated|q_b\(8) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(8);
\m1|altsyncram_component|auto_generated|q_b\(9) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(9);
\m1|altsyncram_component|auto_generated|q_b\(10) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(10);
\m1|altsyncram_component|auto_generated|q_b\(11) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(11);
\m1|altsyncram_component|auto_generated|q_b\(12) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(12);
\m1|altsyncram_component|auto_generated|q_b\(13) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(13);
\m1|altsyncram_component|auto_generated|q_b\(14) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(14);
\m1|altsyncram_component|auto_generated|q_b\(15) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(15);
\m1|altsyncram_component|auto_generated|q_b\(16) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(16);
\m1|altsyncram_component|auto_generated|q_b\(17) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(17);
\m1|altsyncram_component|auto_generated|q_b\(18) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(18);
\m1|altsyncram_component|auto_generated|q_b\(19) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(19);
\m1|altsyncram_component|auto_generated|q_b\(20) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(20);
\m1|altsyncram_component|auto_generated|q_b\(21) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(21);
\m1|altsyncram_component|auto_generated|q_b\(22) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(22);
\m1|altsyncram_component|auto_generated|q_b\(23) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(23);
\m1|altsyncram_component|auto_generated|q_b\(24) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(24);
\m1|altsyncram_component|auto_generated|q_b\(25) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(25);
\m1|altsyncram_component|auto_generated|q_b\(26) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(26);
\m1|altsyncram_component|auto_generated|q_b\(27) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(27);
\m1|altsyncram_component|auto_generated|q_b\(28) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(28);
\m1|altsyncram_component|auto_generated|q_b\(29) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(29);
\m1|altsyncram_component|auto_generated|q_b\(30) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(30);
\m1|altsyncram_component|auto_generated|q_b\(31) <= \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\(31);

\CLOCK_50~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \CLOCK_50~input_o\);

-- Location: IOOBUF_X107_Y73_N9
\LEDG[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDG[0]~output_o\);

-- Location: IOOBUF_X111_Y73_N9
\LEDG[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDG[1]~output_o\);

-- Location: IOOBUF_X83_Y73_N2
\LEDG[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDG[2]~output_o\);

-- Location: IOOBUF_X85_Y73_N23
\LEDG[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDG[3]~output_o\);

-- Location: IOOBUF_X72_Y73_N16
\LEDG[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDG[4]~output_o\);

-- Location: IOOBUF_X74_Y73_N16
\LEDG[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \t1|lpm_mult_component|auto_generated|result\(1),
	devoe => ww_devoe,
	o => \LEDG[5]~output_o\);

-- Location: IOOBUF_X72_Y73_N23
\LEDG[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \t1|lpm_mult_component|auto_generated|result\(24),
	devoe => ww_devoe,
	o => \LEDG[6]~output_o\);

-- Location: IOOBUF_X74_Y73_N23
\LEDG[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \LEDG[7]~output_o\);

-- Location: IOOBUF_X67_Y73_N16
\LEDG[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \t1|lpm_mult_component|auto_generated|result\(29),
	devoe => ww_devoe,
	o => \LEDG[8]~output_o\);

-- Location: IOIBUF_X0_Y36_N15
\CLOCK_50~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_CLOCK_50,
	o => \CLOCK_50~input_o\);

-- Location: CLKCTRL_G4
\CLOCK_50~inputclkctrl\ : cycloneive_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \CLOCK_50~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \CLOCK_50~inputclkctrl_outclk\);

-- Location: LCCOMB_X65_Y4_N0
\~GND\ : cycloneive_lcell_comb
-- Equation(s):
-- \~GND~combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~GND~combout\);

-- Location: M9K_X64_Y4_N0
\m1|altsyncram_component|auto_generated|ram_block1a0\ : cycloneive_ram_block
-- pragma translate_off
GENERIC MAP (
	clk0_core_clock_enable => "ena0",
	data_interleave_offset_in_bits => 1,
	data_interleave_width_in_bits => 1,
	logical_ram_name => "inputRAM:m1|altsyncram:altsyncram_component|altsyncram_b5s1:auto_generated|ALTSYNCRAM",
	mixed_port_feed_through_mode => "dont_care",
	operation_mode => "dual_port",
	port_a_address_clear => "none",
	port_a_address_width => 1,
	port_a_byte_enable_clock => "none",
	port_a_data_out_clear => "none",
	port_a_data_out_clock => "none",
	port_a_data_width => 36,
	port_a_first_address => 0,
	port_a_first_bit_number => 0,
	port_a_last_address => 1,
	port_a_logical_ram_depth => 256,
	port_a_logical_ram_width => 32,
	port_a_read_during_write_mode => "new_data_with_nbe_read",
	port_b_address_clear => "none",
	port_b_address_clock => "clock1",
	port_b_address_width => 1,
	port_b_data_out_clear => "none",
	port_b_data_out_clock => "clock1",
	port_b_data_width => 36,
	port_b_first_address => 0,
	port_b_first_bit_number => 0,
	port_b_last_address => 1,
	port_b_logical_ram_depth => 256,
	port_b_logical_ram_width => 32,
	port_b_read_during_write_mode => "new_data_with_nbe_read",
	port_b_read_enable_clock => "clock1",
	ram_block_type => "M9K")
-- pragma translate_on
PORT MAP (
	portawe => GND,
	portbre => VCC,
	clk0 => \CLOCK_50~inputclkctrl_outclk\,
	clk1 => \CLOCK_50~inputclkctrl_outclk\,
	ena0 => GND,
	portadatain => \m1|altsyncram_component|auto_generated|ram_block1a0_PORTADATAIN_bus\,
	portaaddr => \m1|altsyncram_component|auto_generated|ram_block1a0_PORTAADDR_bus\,
	portbaddr => \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBADDR_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	portbdataout => \m1|altsyncram_component|auto_generated|ram_block1a0_PORTBDATAOUT_bus\);

-- Location: DSPMULT_X71_Y4_N0
\t1|lpm_mult_component|auto_generated|mac_mult1\ : cycloneive_mac_mult
-- pragma translate_off
GENERIC MAP (
	dataa_clock => "none",
	dataa_width => 18,
	datab_clock => "none",
	datab_width => 18,
	signa_clock => "none",
	signb_clock => "none")
-- pragma translate_on
PORT MAP (
	signa => GND,
	signb => GND,
	dataa => \t1|lpm_mult_component|auto_generated|mac_mult1_DATAA_bus\,
	datab => \t1|lpm_mult_component|auto_generated|mac_mult1_DATAB_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	dataout => \t1|lpm_mult_component|auto_generated|mac_mult1_DATAOUT_bus\);

-- Location: DSPOUT_X71_Y4_N2
\t1|lpm_mult_component|auto_generated|mac_out2\ : cycloneive_mac_out
-- pragma translate_off
GENERIC MAP (
	dataa_width => 36,
	output_clock => "none")
-- pragma translate_on
PORT MAP (
	dataa => \t1|lpm_mult_component|auto_generated|mac_out2_DATAA_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	dataout => \t1|lpm_mult_component|auto_generated|mac_out2_DATAOUT_bus\);

ww_LEDG(0) <= \LEDG[0]~output_o\;

ww_LEDG(1) <= \LEDG[1]~output_o\;

ww_LEDG(2) <= \LEDG[2]~output_o\;

ww_LEDG(3) <= \LEDG[3]~output_o\;

ww_LEDG(4) <= \LEDG[4]~output_o\;

ww_LEDG(5) <= \LEDG[5]~output_o\;

ww_LEDG(6) <= \LEDG[6]~output_o\;

ww_LEDG(7) <= \LEDG[7]~output_o\;

ww_LEDG(8) <= \LEDG[8]~output_o\;
END structure;


