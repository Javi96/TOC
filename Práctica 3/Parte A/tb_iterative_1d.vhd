library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_iterative_1d is
end tb_iterative_1d;


architecture beh of tb_iterative_1d is
  constant c_width_data  : natural := 16;
  constant c_width_count : natural := 4;

  component iterative_1d
    generic(
      g_width_data  : natural := 16;
      g_width_count : natural := 4
      );
    port(
      din          : in  std_logic_vector(g_width_data-1 downto 0);
      num_patterns : out unsigned(g_width_count-1 downto 0)
      );
  end component;

  signal din : std_logic_vector(c_width_data-1 downto 0);

  signal count    : unsigned(c_width_count -1 downto 0);
  signal count_tb : natural;
begin

  dut : iterative_1d
    generic map (
      g_width_data  => c_width_data,
      g_width_count => c_width_count
      )
    port map (
      din          => din,
      num_patterns => count
      );


  p_stim : process
    variable i        : natural := 0;
    variable j        : natural := 0;
    variable contador : natural := 0;
  begin
    i_loop : for i in 0 to 2**c_width_data-1 loop
      din      <= std_logic_vector(to_unsigned(i, c_width_data));
      wait for 1 ns;
      contador := 0;
      j        := 2;
      while j < c_width_data loop
        if (din(j) = '1') and (din(j-2) = '1') then
          contador := contador + 1;
          j        := j +3;
        else
          j := j +1;
        end if;
      end loop;
      count_tb <= contador;
      assert to_integer(unsigned(count)) = contador report "ERROR" severity error;
      wait for 99 ns;
    end loop i_loop;
    wait;
  end process p_stim;

end beh;
