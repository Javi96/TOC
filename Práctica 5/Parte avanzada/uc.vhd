----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:47:36 12/15/2014 
-- Design Name: 
-- Module Name:    uc - rtl 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uc is
   port (
      rst   : in  std_logic;
		clk   : in  std_logic;
      ini   : in  std_logic;
     -- fin   : out std_logic;
      ctrl  : out std_logic_vector(8 downto 0);
      jugar : in  std_logic;
      plant : in  std_logic;
      stat  : in  std_logic_vector(1 downto 0));
end uc;

architecture rtl of uc is

   type t_st is (s0, s1, s2, s3, s4, s5, s6, s7, s8);
   signal current_state, next_state : t_st;
   signal mayor, zero: std_logic;

begin
   
   p_status_signals : (mayor, zero) <= stat;
   
   p_next_state : process (current_state, ini, mayor, plant, jugar, zero) is
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
            if mayor = '1' then
               next_state <= s3;
            elsif mayor = '0' and plant = '0' then
               next_state <= s0;
            elsif mayor = '0' and plant = '1' and jugar = '1' then
               next_state <= s2;
            else
               next_state <= s4;
            end if;
         when s3 =>
            next_state <= s0;
         when s4 =>
            next_state <= s5;
         when s5 =>
            next_state <= s6;
         when s6 =>
				next_state <= s7;
         when s7 =>
            if zero = '1' then
               next_state <= s4;
            else
               next_state <= s8;
            end if;
			when s8 =>
				next_state <= s2;
         when others => null;
      end case;
   end process p_next_state;
-------------------------------------HASTA AQUI OK------------------------------------------
   p_outputs : process (current_state)

      constant c_pierdo_mux : std_logic_vector(8 downto 0) := "000000001";
      constant c_pierdo_ld  : std_logic_vector(8 downto 0) := "000000010";
      constant c_r_punt_mux : std_logic_vector(8 downto 0) := "000000100";
      constant c_r_punt_ld  : std_logic_vector(8 downto 0) := "000001000";
      constant c_r_addr_ld  : std_logic_vector(8 downto 0) := "000010000";
      constant c_parar      : std_logic_vector(8 downto 0) := "000100000";
      constant c_r_valor_ld : std_logic_vector(8 downto 0) := "001000000";
      constant c_we         : std_logic_vector(8 downto 0) := "010000000"; -- para escribir en el vector
		constant c_we_ini     : std_logic_vector(8 downto 0) := "100000000";
      
      
   begin
   ctrl <= (others => '0');
   case current_state is
         when s0 =>
            ctrl <= c_we or c_we_ini;
           -- fin  <= '1';
         when s1 =>
            ctrl <= c_r_punt_mux or c_pierdo_mux or c_pierdo_ld or c_r_punt_ld;
           -- fin <= '0';
         when s2 =>
            ctrl <= (others => '0');
         when s3 =>
            ctrl <= c_pierdo_ld;
         when s4 =>
            ctrl <= c_parar or c_r_addr_ld;
         when s5 =>
            ctrl <= (others => '0');
         when s6 =>
            ctrl <= c_r_valor_ld;
         when s7 =>
				ctrl <= (others => '0');
			when s8 =>
            ctrl <= c_r_punt_ld or c_we;
         when others => null;
      end case;
   end process p_outputs;
   
   p_status_reg : process (clk, rst) is
   begin
		if rst = '1' then
			current_state <= s0;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
   end process p_status_reg;
	
end rtl;