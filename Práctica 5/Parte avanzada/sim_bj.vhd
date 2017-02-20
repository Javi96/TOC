--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:58:32 12/10/2014
-- Design Name:   
-- Module Name:   C:/Users/Inma/Documents/docencia/TOC/PracticasVHDL/blackjack/sim_bj.vhd
-- Project Name:  blackjack
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: blackjack
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
 
ENTITY sim_bj IS
END sim_bj;
 
ARCHITECTURE behavior OF sim_bj IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bj
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         ini : IN  std_logic;
         jugar : IN  std_logic;
         plantarse : IN  std_logic;
         pierdo : OUT  std_logic;
         puntuacion : OUT  std_logic_vector(5 downto 0);
         carta : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal inicio : std_logic := '0';
   signal jugar : std_logic := '0';
   signal plantarse : std_logic := '0';

 	--Outputs
   signal pierdo : std_logic;
   signal puntos : std_logic_vector(5 downto 0);
   signal carta : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bj PORT MAP (
          rst => rst,
          clk => clk,
          ini  => inicio,
          jugar => jugar,
          plantarse => plantarse,
          pierdo => pierdo,
          Puntos => puntos,
          carta => carta
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst<='1';
		inicio<='0';
		jugar<='0';
		plantarse<='0';
      wait for 2*clk_period;	
		rst<='0';
		inicio<='1';
      wait for 2*clk_period;
		inicio<='0';
		jugar<='1';
		inicio <= '1';
      wait for 2*clk_period;
		jugar<='0';
		wait for 2*clk_period*8;
		jugar<='1';
		 wait for 2*clk_period;
		jugar<='0';
		wait for 2*clk_period*8;
		jugar<='1';
		wait for 2*clk_period;
		jugar<='0';
		wait for 2*clk_period*5;
		plantarse<='1';
		wait for 2*clk_period;
		plantarse<='0';
      wait for 2*clk_period*4;
		inicio<='1';
		wait for 2*clk_period;
		inicio<='0';
		jugar<='1';
		wait for 2*clk_period;
		jugar<='0';
      wait for 2*clk_period*5;
		jugar<='1';
		wait for 2*clk_period;
		jugar<='0';
		wait for 2*clk_period*6;
		jugar<='1';
		wait for 2*clk_period;
		jugar<='0';
		wait for 2*clk_period*6;
		jugar<='1';
		wait for 2*clk_period;
		jugar<='0';
      wait;
   end process;

END;
