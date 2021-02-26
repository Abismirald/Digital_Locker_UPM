library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Secuencia_FSM is
  Port(
    clk: in std_logic;
    reset: in std_logic;
    A: in std_logic;
    B: in std_logic;
    LED: out std_logic
   );
end Secuencia_FSM;

architecture Behavioral of Secuencia_FSM is
    
    --defino un enum que son las diferentes posibilidades de los estados de la FSM
    type State_t is (S_RESET, S_A, S_AA, S_AAB, S_AB, S_B, S_BB, S_ABB, S_AABB);
    signal STATE: State_t;
    
begin

    process(clk,reset)
    begin
        if(reset = '1') then
            state <= S_RESET;
        elsif(clk'event and clk='1') then
            case STATE is
                when S_RESET => --1
                    if(A='1') then
                        STATE <= S_A;
                    elsif(B='1') then
                        STATE <= S_B;
                    end if;
                    
                when S_A => --4
                    if(A='1') then
                        STATE <= S_AA;
                    elsif(B='1') then
                        STATE <= S_AB;
                    end if;
               
                when S_AA => --7
                    if(A='1') then 
                        STATE <= S_AA;
                    elsif(B='1') then
                        STATE <= S_AAB;
                    end if;
                
                when S_AAB => --8
                    if(A='1') then
                        STATE <= S_AAB;
                    elsif(B='1') then
                        STATE <= S_AABB;
                    end if;
               
                when S_AB => --5
                    if(A='1') then
                        STATE <= S_AAB;
                    elsif(B='1') then
                        STATE <= S_ABB;
                    end if;
                
                when S_B => --2
                    if(A='1') then
                        STATE <= S_AB;
                    elsif(B='1') then
                        STATE <= S_BB;
                    end if;
                
                when S_BB => --3
                    if(A='1') then
                        STATE <= S_ABB;
                    elsif(B='1') then
                        STATE <= S_BB;
                    end if;
                
                when S_ABB => --6
                    if(A='1') then
                        STATE <= S_AABB;
                    elsif(B='1') then
                        STATE <= S_ABB;
                    end if;
                
                when S_AABB => --9
                    --Empty     
            end case;
        end if;
    end process;

    LED <= '1' when (STATE= S_AABB) else '0'; -- se pone afuera del process y no en el process porque ocupa mas FFD
    
end Behavioral;