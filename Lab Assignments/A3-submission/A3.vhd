----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2022 14:08:39
-- Design Name: 
-- Module Name: and gate - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity update_clock is

  Port (C :in std_logic;
  T :in std_logic; 
  Q :out std_logic);
end update_clock;

architecture Behavioral of update_clock is
signal temp: std_logic := '0';

begin

process(C)

begin

if (C'event and C='1') then
if (T='1') then
temp<= not temp;
end if;
end if;
end process;

Q<=temp;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is 
     port (s1: in std_logic;
     s2: in std_logic;
     A:in std_logic;
     B:in std_logic;
     C:in std_logic;
     D:in std_logic;
     output: out std_logic);
end mux;

architecture Behavioral of mux is
begin
  process (s1, s2, A, B, C, D)
  variable sel : std_logic_vector(1 downto 0);
  begin
    sel := s1&s2;
    
      case sel is
      when "00" => output <= A;
      when "01" => output <= B;
      when "10" => output <= C;
      when "11" => output <= D;
      when others => NULL;
      end case;
    
    end process; 
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity anode is 
     port (s1: in std_logic;
     s2: in std_logic;
     A:out std_logic;
     B:out std_logic;
     C:out std_logic;
     D:out std_logic);
end anode;

architecture Behavioral of anode is
signal output : std_logic_vector(3 downto 0);
begin
  process (s1, s2)
  variable sel : std_logic_vector(1 downto 0);
  begin
    sel := s1&s2;
    
      case sel is
      when "00" => output <= "1110";
      when "01" => output <= "1101";
      when "10" => output <= "1011";
      when "11" => output <= "0111";
      when others => NULL;
      end case;
    
    end process; 
    A<=output(0);
    B<=output(1);
    C<=output(2);
    D<=output(3);
end Behavioral;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity timing is
   port ( Clk : in    std_logic; 
          s0  : out   std_logic; 
          s1  : out   std_logic);
end timing;

architecture BEHAVIORAL of timing is
   
   signal q1 : std_logic;
   signal toggle1 : std_logic;
   
   signal q2 : std_logic;
   signal q3 : std_logic;
   
   signal q4 : std_logic;
  
   signal q5 : std_logic;
   signal q6 : std_logic;
   signal q7 : std_logic;
   signal q8 : std_logic;
   signal q9 : std_logic;
   signal q10 : std_logic;
   signal q11 : std_logic;
   signal q14 : std_logic;
   signal q12: std_logic;
   signal q13 : std_logic;
   signal s0_temp: std_logic;
   component update_clock
      port ( C   : in    std_logic; 
             T   : in    std_logic; 
             Q   : out   std_logic);
   end component;
   
   
   
begin
  
   toggle1 <= '1';
   s0<=s0_temp;
   T1 : update_clock
      port map (C=>Clk,
                T=>toggle1,
                Q=>q1);
   
   T2 : update_clock
      port map (C=>q1,
                T=>toggle1,
                Q=>q2);
   
   T3 : update_clock
      port map (C=>q2,
                T=>toggle1,
                Q=>q3);
   
   T4 : update_clock
      port map (C=>q3,
                T=>toggle1,
                Q=>q4);
   
   T5 : update_clock
      port map (C=>q4,
                T=>toggle1,
                Q=>q5);
   
   T6 : update_clock
      port map (C=>q5,
                T=>toggle1,
                Q=>q6);

   T7 : update_clock
      port map (C=>q6,
                T=>toggle1,
                Q=>q7);
   
   T8 : update_clock
      port map (C=>q7,
                T=>toggle1,
                Q=>q8);
   
   T9 : update_clock
      port map (C=>q8,
                T=>toggle1,
                Q=>q9);
   
   T10 : update_clock
      port map (C=>q9,
                T=>toggle1,
                Q=>q10);
   
   T11 : update_clock
      port map (C=>q10,
                T=>toggle1,
                Q=>q11);
   
   T12 : update_clock
      port map (C=>q11,
                T=>toggle1,
                Q=>q12);
   
   T13 : update_clock
      port map (C=>q12,
                T=>toggle1,
                Q=>q13);
   
   T14 : update_clock
      port map (C=>q12,
                T=>toggle1,
                Q=>q14);
   
   T15 : update_clock
      port map (C=>q14,
                T=>toggle1,
                Q=>s0_temp);
   
   T16 : update_clock
      port map (C=>s0_temp,
                T=>toggle1,
                Q=>s1);
   
   
   
   
end BEHAVIORAL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
    Port (A :in std_logic;
  B :in std_logic; 
  C: in std_logic;
  D: in std_logic;
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic
   );
end display;

architecture Behavioral of display is

begin
a_a <= Not((Not(B) And Not(D)) Or (A And Not(B) And Not(C)) Or (A And Not(D)) Or (B And C) Or (Not(A) And C) Or (Not(A) And B And D));
b_b <= Not((Not(A) And Not(B)) Or (Not(A) And Not(C) And Not(D)) Or (Not(A) And C And D) Or (A And Not(C) And D) Or (Not(B) And Not(D)));
c_c <= Not((Not(A) And Not(C)) Or (Not(A) And D) Or (Not(A) And B) Or (A And Not(B)) Or (Not(C) And D)) ;
d_d<= Not((Not(A) And Not(B) And Not(D)) Or (A And Not(C)) Or (A And Not(B) And D) Or (B And Not(C) And D) Or (B And C And Not(D)) Or (Not(A) And Not(B) And C));
e <= Not((Not(B) And Not(D)) Or (C And Not(D)) Or (A And B) Or (A And C));
f<= Not((Not(C) And Not(D)) Or (B And Not(D)) Or (Not(A) And B And Not(C)) Or (A And Not(B)) Or (A And C));
g<= Not((Not(B) And C) Or (C And Not(D)) Or (Not(A) And B And Not(C)) Or (B And Not(C) And D) Or (A And D) Or (A And Not(B)));



end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
port( Clk : in    std_logic; 
          a0  : in    std_logic; 
          a1  : in    std_logic; 
          a2  : in    std_logic; 
          a3  : in    std_logic; 
          b0  : in    std_logic; 
          b1  : in    std_logic; 
          b2  : in    std_logic; 
          b3  : in    std_logic; 
          c0  : in    std_logic; 
          c1  : in    std_logic; 
          c2  : in    std_logic; 
          c3  : in    std_logic; 
          d0  : in    std_logic; 
          d1  : in    std_logic; 
          d2  : in    std_logic; 
          d3  : in    std_logic; 
          Anode0 : out   std_logic; 
          Anode1 : out   std_logic; 
          Anode2 : out   std_logic; 
          Anode3 : out   std_logic; 
          A   : out   std_logic; 
          B   : out   std_logic; 
          C   : out   std_logic; 
          D   : out   std_logic; 
          E   : out   std_logic; 
          F   : out   std_logic; 
          G   : out   std_logic);
 end main;
 
architecture Behavioral of main is

   signal output1 : std_logic;
   signal output2 : std_logic;
   signal output3 : std_logic;
   signal output4 : std_logic;
  
   signal state2 : std_logic;
   signal state1 : std_logic;
   
   component mux
      port ( s1: in std_logic;
     s2: in std_logic;
     A:in std_logic;
     B:in std_logic;
     C:in std_logic;
     D:in std_logic;
     output: out std_logic);
   end component;
   
   component display
      port ( A :in std_logic;
  B :in std_logic; 
  C: in std_logic;
  D: in std_logic;
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic);
   end component;
   
   component anode
      port ( s1: in std_logic;
     s2: in std_logic;
     A:out std_logic;
     B:out std_logic;
     C:out std_logic;
     D:out std_logic);
   end component;
   
   component timing
      port (Clk : in    std_logic; 
          s0  : out   std_logic; 
          s1  : out   std_logic);
   end component;
   

   
begin
   
   mux_1 : mux
      port map (s1=> state1,
     
                s2=>state2,
    
     A=>a0,
     B=>b0,
     C=>c0,
     D=>d0,
     output=> output1);
   
   mux_2 : mux
      port map (s1=>state1,
                s2=>state2,
      A=>a1,
                B=>b1,
                C=>c1,
                D=>d1,
                
                
                output=>output2);
   
   mux_3 : mux
      port map (A=>a2,
                B=>b2,
                C=>c2,
                D=>d2,
                
                S1=>state1,
                S2=>state2,
                output=>output3);
   
   mux_4 : mux
      port map (A=>a3,
                B=>b3,
                C=>c3,
                D=>d3,
                
                S1=>state1,
                S2=>state2,
                output=>output4);
   
   dis : display
      port map (A=>output1,
                B=>output2,
                C=>output3,
                D=>output4,
                a_a=>A,
                b_b=>B,
                c_c=>C,
                d_d=>D,
                e=>E,
                f=>F,
                g=>G);
   
   anode_activate : anode
      port map (s1=>state1,
                s2=>state2,
                
                A=>Anode0,
                B=>Anode1,
                C=>Anode2,
                D=>Anode3);
   
   timing_production : timing
      port map (CLK=>CLK,
                S0=>state1,
                S1=>state2);
   
   

end Behavioral; 
 


