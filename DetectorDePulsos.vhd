library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DetectorDePulsos is
    Port(
        clk : in std_logic;
        reset : in std_logic;
        Boton_A : in std_logic;
        Boton_B : in std_logic;
        Led : out std_logic
    );
end DetectorDePulsos;

architecture Behavioral of DetectorDePulsos is
    
    component Secuencia_FSM is
        Port(
            clk: in std_logic;
            reset: in std_logic;
            A: in std_logic;
            B: in std_logic;
            LED: out std_logic
        );
    end component;
    
    component Antirebotes is
        Port(
            clk : in std_logic;
            reset : in std_logic;
            boton : in std_logic;
            filtrado : out std_logic
        );
    end component;    
    
    signal A_filtered: std_logic;
    signal B_filtered: std_logic;
    
begin
--Antirebotes A
    Antirebotes_A: Antirebotes port map(
        clk=> clk,
        reset=> reset,
        boton=> Boton_A,
        filtrado=> A_filtered
    );
    
--Antirebotes B
    Antirebotes_B: Antirebotes port map(
        clk=> clk,
        reset=> reset,
        boton=> Boton_B,
        filtrado=> B_filtered    
    );

-- FSM
    FSM: Secuencia_FSM port map(
        clk=> clk,
        reset=> reset,
        A=> A_filtered,
        B=> B_filtered,
        LED=> Led
    );

--buena practica tener los estructurales y behavorial en archivos separados     
end Behavioral;
