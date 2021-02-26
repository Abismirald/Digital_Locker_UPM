library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_weblab is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        buttons  : in  std_logic_vector(3 downto 0);
        switches : in  std_logic_vector(7 downto 0);
        leds     : out std_logic_vector(7 downto 0);
        segments : out std_logic_vector(7 downto 0);
        selector : out std_logic_vector(3 downto 0)
    );
end top_weblab;

architecture wrapper of top_weblab is
begin

    DetectorDePulsos_i: entity work.DetectorDePulsos
    port map (
        clk => clk,
        reset => reset,
        Boton_A => buttons(0),
        Boton_B => buttons(1),
        Led => leds(0)
    );
    
-- Ponemos el resto de salidas a 0 por si acaso...

leds(7 downto 1) <= (others => '0');
segments <= (others => '0');
selector <= (others => '0');

end wrapper;
