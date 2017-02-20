library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multifunction is
	generic(g_width_uf: natural := 32);
	port(op1: in signed(g_width_uf-1 downto 0);
		  op2: in signed(g_width_uf-1 downto 0);
		  sel: in std_logic_vector(2 downto 0);
		  res: out signed(g_width_uf-1 downto 0)
	);
end multifunction;

architecture Behavioral of multifunction is
	
	constant c_add : std_logic_vector(2 downto 0) := "000";
	constant c_sub : std_logic_vector(2 downto 0) := "001";
	constant c_min : std_logic_vector(2 downto 0) := "100";
	constant c_max : std_logic_vector(2 downto 0) := "101";
	constant c_abs : std_logic_vector(2 downto 0) := "111";

	signal aux : signed(g_width_uf -1 downto 0);
	signal min, max : signed(g_width_uf -1 downto 0);


begin

	p_fu : process (sel, op1, op2) is
		begin
		
		aux <= op1 - op2;
		if aux(g_width_uf -1) = '0'
		then min <= op2;
			max <= op1;
		else min <= op1;
			max <= op2;
		end if;
				
		case sel is
		
			when c_sub =>
				res <= aux;
			when c_min =>		
				res <= min;
				
			when c_max => 
				res <= max;
			
			when c_abs =>
			
				if op1(g_width_uf-1) = '0' then
					res <= op1;
				else 
					res <= -op1;
				end if;
				
			when others =>
				res <= op1 + op2;
		
		end case;
		

	end process p_fu;

end Behavioral;

