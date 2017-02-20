
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use work.definitions.all;

entity iterative_1d is
	generic(g_width_data : natural := 32;
			  g_width_count: natural := 5
	);
	port(din         : in std_logic_vector(g_width_data-1 downto 0);
		  num_patterns: out unsigned(g_width_count-1 downto 0)
	);
end iterative_1d;

use work.definitions.all;
architecture Behavioral of iterative_1d is
	component cell
		generic(g_width: natural := 32);
		port(d          : in std_logic;
			  pattern_in : in t_pattern;
			  count_in   : in unsigned(g_width-1 downto 0);
			  pattern_out: out t_pattern;
			  count_out  : out unsigned(g_width-1 downto 0)
		);
	end component;
	
	type t_pattern_vector is array (g_width_data downto 0) of t_pattern;
	type t_count_vector is array (g_width_data downto 0) of unsigned(g_width_count-1 downto 0);
	signal pattern: t_pattern_vector;
	signal count: t_count_vector;
begin
	pattern(0) <= no_pattern;
	count(0) <= to_unsigned(0, g_width_count);
	
	cell_generation: for idx in 0 to g_width_data-1 generate
		i_cell: cell generic map(g_width => g_width_count)
						 port map(d           => din(idx)        ,
									 pattern_in  => pattern(idx)    ,
									 count_in    => count(idx)      ,
									 pattern_out => pattern(idx + 1),
									 count_out   => count(idx + 1)  
				  );
	end generate cell_generation;
	
	num_patterns <= count(g_width_data);

end Behavioral;

