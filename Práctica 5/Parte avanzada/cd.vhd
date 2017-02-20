----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:05:40 12/16/2014 
-- Design Name: 
-- Module Name:    cd - rtl 
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
library work;


entity cd is
   port (
      clk    : in  std_logic;
      rst    : in  std_logic;
      punt   : out std_logic_vector(5 downto 0);
      carta  : out std_logic_vector(3 downto 0);
      stat   : out std_logic_vector(1 downto 0);
      ctrl   : in  std_logic_vector(8 downto 0);
      pierdo : out std_logic);
end cd;

architecture rtl of cd is
   
   signal r_card     : std_logic_vector(3 downto 0);
   signal r_points   : std_logic_vector(5 downto 0);
   signal r_posicion : unsigned(5 downto 0);
   signal valor      : std_logic_vector(3 downto 0); -- dout de la memoria
   signal pos_aux    : unsigned(5 downto 0); -- valor del contador
	signal we_aux     : std_logic_vector(0 downto 0);
	
	-- nuevo vector de marcas
	signal leido      : std_logic_vector(51 downto 0);
	
	-- indice de elementos del vector de marcas
	signal indice     : integer;
   
   signal pierdo_mux : std_logic;
   signal pierdo_ld  : std_logic;
   signal r_punt_mux : std_logic;
   signal r_punt_ld  : std_logic;
   signal r_addr_ld  : std_logic;
   signal parar      : std_logic;
   signal r_valor_ld : std_logic;
   signal we         : std_logic;
	
	-- signal para nuevo vector
	signal we_ini     : std_logic;

   signal zero  : std_logic;
   signal mayor : std_logic;
	
	component contador is
		port (
			clk   : in  std_logic;
			parar : in  std_logic;
			rst   : in  std_logic;
			pos   : out unsigned(5 downto 0));
	end component contador;
	
	component bj_mem is
		port ( 
			clka  : in std_logic;
			wea   : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(5 downto 0);
			dina  : in std_logic_vector(3 downto 0);
			douta : out std_logic_vector(3 downto 0)); 
	end component bj_mem; 

begin

	i_cont: contador port map(
		clk   => clk,
		parar => parar,
		rst   => rst,
		pos   => pos_aux);
		
	i_bj_mem: bj_mem port map(
		clka  => clk,
		wea   => we_aux,
		-- casteo de tipo
		addra => std_logic_vector(r_posicion),
		dina  => "0000",
		douta => valor);
   
   (we_ini, we, r_valor_ld, parar, r_addr_ld, r_punt_ld, r_punt_mux, pierdo_ld, pierdo_mux) <= ctrl;
   stat <= (mayor & zero);
	
	p_we: we_aux(0) <= '0';
	-- casteo de std_logic~~ a integer
	p_indice: indice <= to_integer(r_posicion);
   p_puntuacion: punt <= r_points;
   p_carta: carta <= r_card;

   p_sumar: process (clk) is
   begin
      if rising_edge(clk) then
         if r_punt_ld = '1' then
            if r_punt_mux = '1' then
               r_points <= (others => '0');
            else
               r_points <= std_logic_vector(unsigned(r_points) + unsigned("00" & r_card));
            end if;
         end if;
      end if;
   end process p_sumar;
   
   -- cambio para correcion del reset
   p_ld_carta: process (clk) is
   begin
		if rst='1' then 
			r_card <= "0000";
      elsif rising_edge(clk) and r_valor_ld = '1' then
         r_card <= valor;
      end if;
   end process p_ld_carta;
   
   p_pierdo: process (clk) is
   begin
      if rising_edge(clk) and pierdo_ld = '1' then
         if pierdo_mux = '1' then
            pierdo <= '0';
         else
            pierdo <= '1';
         end if;
      end if;
   end process p_pierdo;
   
   p_direccion: process (clk) is
   begin
      if rising_edge(clk) and r_addr_ld = '1' then
         r_posicion <= pos_aux;
      end if;
   end process p_direccion;
	
	-- nuevo proceso para controlar la lectura de cartas
	p_leido: process (r_posicion) is
	begin
		if we = '1' and we_ini = '1' then
			leido <= (others => '1');
		elsif we = '1' then
			leido(indice) <= '0';
		end if;
	end process p_leido;
         
   p_mayor: process (r_points) is
   begin
      if r_points > "010101" then
         mayor <= '1';
      else
         mayor <= '0';
      end if;
   end process p_mayor;
   
   p_zero: process (r_card) is
   begin
	-- cambiamos r_card por leido, si leido = 0 entonces miramos otro
      if leido(indice) = '0' then
         zero <= '1';
      else
         zero <= '0';
      end if;
   end process p_zero;
   
end rtl;