--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:07:42 03/12/2019
-- Design Name:   
-- Module Name:   C:/Users/root/Desktop/TDC/tdc_tb.vhd
-- Project Name:  tdc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: tdc
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tdc_tb IS
END tdc_tb;
 
ARCHITECTURE behavior OF tdc_tb IS  

   --Inputs
   signal stop : std_logic := '0';
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal fine : std_logic_vector(63 downto 0);
	signal coarse : std_logic_vector(3 downto 0);
	
   -- Clock period definitions
   constant clock_period : time := 8 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.tdc 
		PORT MAP (
			stop => stop,
         fine => fine,
			coarse => coarse,
         clock => clock,
         reset => reset
        );

   -- Clock process definitions
   clock_process :process
   begin
		--wait for 380 ns;
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
		--wait;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
		reset <= '1';
      wait for 3 us;
		reset <= '0';
      wait for clock_period*10;
		
      -- insert stimulus here 
		
      wait;
   end process;
	
	stim_stop: process
	begin
		wait for 380516 ps;
		stop<= '1';
	end process;

END;
