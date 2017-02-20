library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
  port (
    clk    : in  std_logic;                      
    rst_n  : in  std_logic;                     
    ini    : in  std_logic;                      
    fin    : out std_logic;                     
    ctrl   : out std_logic_vector(9 downto 0);   
    status : in  std_logic_vector(1 downto 0));  
end entity uc;

architecture rtl of uc is
  type t_st is (s0, s1, s2, s3, s4, s5, s6);
  signal current_state, next_state : t_st;
  signal zero, msb                 : std_logic;
begin

  p_status_signals : (msb, zero) <= status;

  p_next_state : process (current_state, ini, msb, zero) is
  begin  
    case current_state is
      when s0 =>
        if ini = '1' then
          next_state <= s1;
        else
          next_state <= s0;
        end if;
      when s1 =>
			next_state <= s2;
      when s2 =>
			next_state <= s3;
      when s3 =>
        if msb = '1' then
          next_state <= s4;
        else
          next_state <= s5;
        end if;
      when s4 =>
			next_state <= s6;
      when s5 =>
			next_state <= s6;
      when s6 =>
			if zero = '1' then 
				next_state <= s0;
			else next_state <= s2;
			end if;
      when others => null;
    end case;
  end process p_next_state;

  p_outputs : process (current_state)
    constant c_mux        : std_logic_vector(9 downto 0) := "0000000001";
    constant c_coc_sh     : std_logic_vector(9 downto 0) := "0000000010";
    constant c_coc_ld     : std_logic_vector(9 downto 0) := "0000000100";
    constant c_dndo_ld    : std_logic_vector(9 downto 0) := "0000001000";
    constant c_dsor_sh    : std_logic_vector(9 downto 0) := "0000010000";
    constant c_dsor_ld    : std_logic_vector(9 downto 0) := "0000100000";
    constant c_cntr_cu    : std_logic_vector(9 downto 0) := "0001000000";
    constant c_cntr_ld    : std_logic_vector(9 downto 0) := "0010000000";
    constant c_cntr_d1_ld : std_logic_vector(9 downto 0) := "0100000000";
    constant c_add_sub    : std_logic_vector(9 downto 0) := "1000000000";

  begin
    ctrl <= (others => '0');
    case current_state is
      when s0 =>
        ctrl <= (others => '0');
        fin  <= '1';
      when s1 =>
        ctrl <= c_dndo_ld or
                c_dsor_ld or
                c_coc_ld or
                c_cntr_ld or
					 c_cntr_d1_ld;
        fin <= '0';
      when s2 =>
			ctrl <= c_cntr_d1_ld or
						c_dndo_ld or
						c_mux;
			fin <= '0';			
      when s3 =>
			ctrl <= c_cntr_cu;
			fin <= '0';	
      when s4 =>
			ctrl <= c_add_sub or
						c_dndo_ld or
						c_mux or
						c_coc_sh;						
			fin <= '0';	
      when s5 =>
			ctrl <= c_coc_sh;
			fin <= '0';	
      when s6 =>
			ctrl <= c_dsor_sh;
			fin <= '0';	
      when others => null;
    end case;
  end process p_outputs;

  p_status_reg : process (clk, rst_n) is
  begin
    if rst_n = '0' then
      current_state <= s0;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process p_status_reg;

end architecture rtl;
