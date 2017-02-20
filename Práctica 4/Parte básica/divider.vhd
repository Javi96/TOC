library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity divider is
  port (clk   : in  std_logic;
        rst_n : in  std_logic;
        ini   : in  std_logic;
        dsor  : in  std_logic_vector(7 downto 0); 
        dndo  : in  std_logic_vector(7 downto 0);  
        coc   : out std_logic_vector(7 downto 0);  
        res   : out std_logic_vector(7 downto 0);  
        ready : out std_logic
        );
end divider;

architecture struct of divider is

  component cd is
    port (
    clk    : in  std_logic;                      
    rst_n  : in  std_logic;                      
    dsor   : in  std_logic_vector(7 downto 0);   
    dndo   : in  std_logic_vector(7 downto 0);   
    coc    : out std_logic_vector(7 downto 0);   
    res    : out std_logic_vector(7 downto 0);   
    ctrl   : in  std_logic_vector(9 downto 0);   
    status : out std_logic_vector(1 downto 0)); 
  end component cd;


  component uc is
    port (
      clk    : in  std_logic;                      
      rst_n  : in  std_logic;                     
      ini    : in  std_logic;                      
      fin    : out std_logic;                     
      ctrl   : out std_logic_vector(9 downto 0);   
      status : in  std_logic_vector(1 downto 0)); 

  end component uc;

  signal ctrl   : std_logic_vector(9 downto 0);  
  signal status : std_logic_vector(1 downto 0);  
  
begin

  i_cd : cd port map (
    clk    => clk,
    rst_n  => rst_n,
    dsor   => dsor,
    dndo   => dndo,
    coc    => coc,
    res    => res,
    ctrl   => ctrl,
    status => status);

  i_uc : uc port map (
    clk    => clk,
    rst_n  => rst_n,
    ini    => ini,
    fin    => ready,
    ctrl   => ctrl,
    status => status);


end struct;
