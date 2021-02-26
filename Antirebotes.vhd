library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Antirebotes is
    Port(
        clk : in std_logic;
        reset : in std_logic;
        boton : in std_logic;
        filtrado : out std_logic
    );
end Antirebotes;

architecture Behavioral of Antirebotes is

    constant fsm_MAX: integer := 125000;
    type State_t is (S_NADA, S_BOTON);
    signal STATE: State_t;
    signal Q1: std_logic;
    signal Q2: std_logic;
    signal Q3: std_logic;
    signal edge: std_logic;
    signal E: std_logic;
    signal T: std_logic;
    signal S: std_logic;
    signal fsm_timer: integer range 0 to fsm_MAX;
    
    

begin

-- process with assignments to Q1, Q2 and Q3 (pipeline of D FFs)
    process(clk,reset)
    begin
    if(reset = '1') then
        Q1<= '0';
        Q2<= '0';
        Q3<= '0';
    elsif(clk'event and clk='1') then
        Q1<= boton;
        Q2<=Q1;
        Q3<=Q2;
    end if;
    end process;
    
    edge <= NOT(Q3) and Q2;
    
    -- process for the FSM (Edge Q2 T /S E)
    process(clk,reset)
    begin
        if(reset = '1') then
            state <= S_NADA;
        elsif(clk'event and clk='1') then
            case STATE is
                when S_NADA => 
                    if(edge='0' and T='0') then
                        STATE <= S_NADA;
                    elsif(edge='1' and T='0') then
                        STATE <= S_BOTON;
                    end if;
                
                when S_BOTON =>
                    if(T='0') then
                        STATE <= S_BOTON;
                    elsif(Q2='1' and T='1') then
                        STATE <= S_NADA;
                    elsif(Q2='0' and T='1') then
                        STATE <= S_NADA;
                    end if;
            end case;  
        end if;
    end process;
    
    --combinational generation of output signal in the FSM
    S<= '1' when (STATE=S_BOTON and Q2='1' and T='1') else '0';
    E<= '1' when STATE=S_BOTON else '0';
    
    filtrado<= S;
    
    --process for the timer (E,T) tiene que contar 1ms 
    process(clk, reset)
    begin
    if(reset = '1') then
        fsm_timer <= 0;
    elsif(clk'event and clk='1') then
        if(E='1') then --enable
            if(fsm_timer < fsm_MAX) then
                fsm_timer <= fsm_timer + 1;
            else
                fsm_timer <= 0;
            end if;
        end if;
    end if;
    end process;
    --el mismo proceso tiene que poner en 0 E
    T<= '1' when (fsm_timer = fsm_MAX) else '0';
    
end Behavioral;
