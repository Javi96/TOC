----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:24:46 10/05/2016 
-- Design Name: 
-- Module Name:    reg_desplazamiento - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registro_siso is
	port (rst 	: in 	std_logic;
			clk 	: in 	std_logic;
			es		: in 	std_logic;
			ss		: out std_logic_vector(7 downto 0));
end registro_siso;

architecture rtl of registro_siso is
	
	signal clk_int 	: std_logic;
	signal data			: std_logic_vector(7 downto 0);
	
	-- descomentar para implementacion
	
--	component divisor is
--		port (rst			:	in		std_logic;
--				clk_100mhz	:	in		std_logic;
--				clk_1hz		:	out	std_logic);
--	end component;

begin
	
	-- descomentar para implementacion FPGA
	
--	i_clk_int : divisor port map(
--		rst			=> rst,
--		clk_100mhz	=> clk,
--		clk_1hz		=>	clk_int);

	-- comentar para implementar FPGA
	clk_int <= clk;
	
	p_reg : process(clk_int, rst)
	begin
		if rst = '1' then
			data <= "00000000";
		elsif rising_edge(clk_int) then
			data(7)				<=	es;
			data(6 downto 0)	<=	data(7 downto 1);
		end if;
	end process p_reg;
	
	ss <= data;
end rtl;



