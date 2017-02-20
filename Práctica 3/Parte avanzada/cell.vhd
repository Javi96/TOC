library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.definitions.all;


entity cell is
	generic(g_width: natural := 32);
	port(d          : in std_logic;
		  pattern_in : in t_pattern;
		  count_in   : in unsigned(g_width-1 downto 0);
		  pattern_out: out t_pattern;
		  count_out  : out unsigned(g_width-1 downto 0)
	);
end cell;

use work.definitions.all;

architecture Behavioral of cell is
		
	constant c_add_alu : std_logic_vector(2 downto 0) := "000";
	constant c_sub_alu : std_logic_vector(2 downto 0) := "001";

	
	component multifunction
		generic(g_width_uf: natural := 32);
		port(op1: in signed(g_width_uf-1 downto 0);
			  op2: in signed(g_width_uf-1 downto 0);
			  sel: in std_logic_vector(2 downto 0);
			  res: out signed(g_width_uf-1 downto 0)
		);
	end component;
	
	
	
	signal pattern_cell: t_pattern;
	
	
	signal sel: std_logic_vector(2 downto 0) := "000";
	signal op1: signed(g_width-1 downto 0);
	signal op2: signed(g_width-1 downto 0) := to_signed(0, g_width);
	signal res: signed(g_width-1 downto 0);
	
	
	
begin
	
	op1 <= to_signed(to_integer(count_in), g_width);
	
	i_multifunction: multifunction generic map(g_width_uf => g_width)
		port map(op1 => op1,
			op2 => op2,
			sel => sel,
			res => res
		);
			
			
	p_pattern: process (pattern_in, d)
	begin
		case pattern_in is
			when no_pattern =>
				if (d = '1') then
					pattern_cell <= first_one;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				else
					pattern_cell <= no_pattern;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				end if;
			when first_one =>
				if (d = '0') then
					pattern_cell <= second_zero;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				else
					pattern_cell <= second_one;
					-- add 0 
					op2 <= to_signed(0, g_width);
					sel <= "000";
				end if;
			when second_zero =>
				if (d = '1') then
					pattern_cell <= pattern_rec;
					-- call ALU for sub
					op2 <= to_signed(1, g_width);
					sel <= "001";
				else
					pattern_cell <= no_pattern;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				end if;
			when second_one =>
				if (d = '1') then
					pattern_cell <= pattern_rec;
					-- call ALU for add
					op2 <= to_signed(1, g_width);
					sel <= "000";
				else
					pattern_cell <= second_zero;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				end if;
			when pattern_rec =>
				if (d = '1') then
					pattern_cell <= first_one;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				else
					pattern_cell <= no_pattern;
					-- add 0
					op2 <= to_signed(0, g_width);
					sel <= "000";
				end if;
			when others =>
				pattern_cell <= no_pattern;
				-- add 0
				op2 <= to_signed(0, g_width);
				sel <= "000";
		end case;
	end process p_pattern;
	
	pattern_out <= pattern_cell;
	count_out <= to_unsigned(to_integer(res), g_width);

end Behavioral;

