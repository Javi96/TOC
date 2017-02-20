----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       
-- 
-- Create Date:    
-- Design Name:    Practica 1a
-- Module Name:    tb_sumador_4bits - beh
-- Project Name:   Practica 1a
-- Target Devices: Spartan-3 
-- Tool versions: 
-- Description:    Testbench del sumador de 4 bits sin carry de salida 
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-------------------------------------------------------------------------------
-- Entidad
-------------------------------------------------------------------------------
entity tb_sumador is
end tb_sumador;

-------------------------------------------------------------------------------
-- Arquitectura
-------------------------------------------------------------------------------

architecture beh of tb_sumador is

-- Declaracion del componente que vamos a simular
  component sumador
    port(
      op1 : in  std_logic_vector(3 downto 0);
      op2 : in  std_logic_vector(3 downto 0);
      res : out std_logic_vector(3 downto 0)
      );
  end component;

-- Entradas
  signal op1 : std_logic_vector(3 downto 0) := (others => '0');
  signal op2 : std_logic_vector(3 downto 0) := (others => '0');

-- Salidas
  signal res : std_logic_vector(3 downto 0);  

begin

-- Instanciacion de la unidad a simular 
  dut : sumador port map (
    op1 => op1,
    op2 => op2,
    res => res
    );

-- Proceso de estimulos
  p_stim : process
    variable v_i : natural := 0;
    variable v_j : natural := 0;
  begin
    op1 <= "0000";
	 op2 <= "0000";
	 wait for 100 ns;
	 op1 <= "0101";
	 op2 <= "0100";
	 wait for 100 ns;
	 op1 <= "0000";
	 op2 <= "0111";
	 wait for 100 ns;
	 op1 <= "0011";
	 op2 <= "1000";
	 wait for 100 ns;
	 op1 <= "1011";
	 op2 <= "1111";
	 wait for 100 ns;
	 op1 <= "1001";
	 op2 <= "0110";
    wait;
  end process p_stim;

end beh;
