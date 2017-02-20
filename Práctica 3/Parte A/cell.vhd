
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
	signal pattern_cell: t_pattern;
begin

	p_pattern: process (pattern_in, d)
	begin
		case pattern_in is
			when no_pattern =>
				if (d = '1') then
					pattern_cell <= first_one;
				else
					pattern_cell <= no_pattern;
				end if;
			when first_one =>
				if (d = '0') then
					pattern_cell <= second_zero;
				else
					pattern_cell <= second_one;
				end if;
			when second_zero =>
				if (d = '1') then
					pattern_cell <= pattern_rec;
				else
					pattern_cell <= no_pattern;
				end if;
			when second_one =>
				if (d = '1') then
					pattern_cell <= pattern_rec;
				else
					pattern_cell <= second_zero;
				end if;
			when pattern_rec =>
				if (d = '1') then
					pattern_cell <= first_one;
				else
					pattern_cell <= no_pattern;
				end if;
			when others =>
				pattern_cell <= no_pattern;
		end case;
	end process p_pattern;
	
	p_count: process (pattern_cell, count_in)
	begin
		case pattern_cell is
			when no_pattern =>
				count_out <= count_in;
			when first_one =>
				count_out <= count_in;
			when second_zero =>
				count_out <= count_in;
			when second_one =>
				count_out <= count_in;
			when pattern_rec =>
				count_out <= count_in + 1;
			when others =>
				count_out <= count_in;
		end case;
	end process p_count;
	
	pattern_out <= pattern_cell;

end Behavioral;

