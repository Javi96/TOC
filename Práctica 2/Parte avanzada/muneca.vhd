----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:15:38 10/24/2016 
-- Design Name: 
-- Module Name:    muneca - Behavioral 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity muneca is
	port (clk 	: in std_logic;
			rst_n : in std_logic;
			r 		: in std_logic; 		-- ruido
			c 		: in std_logic; 		-- chupete
			g 		: out std_logic;		-- habla
			l 		: out std_logic); 	-- llora
			
end muneca;

architecture Behavioral of muneca is

	type t_state is (tranquila_st, dormida_st, asustada_st, hablando_st);
	
	signal current_state, next_state : t_state;
	
	signal clk_int : std_logic;
		
	-- nuevas señales
	signal c_rst	:	std_logic;
	signal c_cntr	:	std_logic_vector(1 downto 0);
	-- nuevas señales
	
	component divisor is
		port ( rst : in std_logic; 
				 clk_100mhz : in std_logic;
				 clk_1hz : out std_logic);
	end component;	 
	
	-- nuevo componente
	component cntr
		generic (k : integer := 4;
					n : integer := 2);
		port (rst	:	in		std_logic;
				clk	:	in 	std_logic;
				cntr	:	out 	std_logic_vector(n-1 downto 0));
	end component;
	-- nuevo componente
	
begin	

	

	-- instancia de contador
	mod_cntr	:	cntr port map(
		clk	=>	clk_int,
		rst	=>	c_rst,
		cntr	=>	c_cntr);
	-- instancia de contador
	
	i_clk_int : divisor port map ( 
		rst => rst_n,
		clk_100mhz => clk,
		clk_1hz => clk_int);
											 
												
	-- proceso para reseteo de contador								 
	p_cntr_activo : process(current_state)
	begin
		if current_state = tranquila_st then
			c_rst <= '0';
		else c_rst <= '1';
		end if;
	end process;
	-- proceso para reseteo de contador	
	
	p_reg : process(clk_int, rst_n)
	begin
		if rst_n = '0' then
			current_state <= tranquila_st;
		elsif rising_edge(clk_int) then
			current_state <= next_state;
		else
			current_state <= current_state;
		end if;
		--end if;
	end process p_reg;
	
	
	p_next_state : process(current_state, r, c)
	begin
		case current_state is
			when tranquila_st =>
				if ((c_cntr <= "00" and c_rst = '0') or c_cntr <= "01" or c_cntr <= "10") then
					next_state <= current_state;
				else
					if (r = '1' and c = '0') then
						next_state <= hablando_st;
					elsif (r = '0' and c = '1') then
						next_state <= dormida_st;
					else 
						next_state <= current_state;
					end if;
				end if;
			when hablando_st =>
				if (c = '1') then
					next_state <= dormida_st;
				else 
					next_state <= current_state;
				end if;
			when dormida_st =>
				if (r = '1') then
					next_state <= asustada_st;
				else
					next_state <= current_state;
				end if;
			when asustada_st =>
				if (c = '1' and r = '0') then
					next_state <= dormida_st;
				elsif (c = '0' and r = '0') then
					next_state <= tranquila_st;
				else
					next_state <= current_state;
				end if;
			end case;
		end process p_next_state;
		
	p_outputs : process(current_state)
	begin
		case current_state is
			when tranquila_st =>
				g <= '0';
				l <= '0';
			when dormida_st =>
				g <= '0';
				l <= '0';
			when asustada_st =>
				g <= '1';
				l <= '1';
			when hablando_st =>
				g <= '1';
				l <= '0';
		end case;
	end process p_outputs;
end Behavioral;

