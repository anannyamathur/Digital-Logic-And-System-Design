----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.04.2022 20:24:24
-- Design Name: 
-- Module Name: A2 - Behavioral
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

entity A2 is
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
  g: out std_logic;
  A1,A2,A3,A4: out std_logic
   );
end A2;

architecture Behavioral of A2 is

begin
a_a <= Not((Not(B) And Not(D)) Or (A And Not(B) And Not(C)) Or (A And Not(D)) Or (B And C) Or (Not(A) And C) Or (Not(A) And B And D));
b_b <= Not((Not(A) And Not(B)) Or (Not(A) And Not(C) And Not(D)) Or (Not(A) And C And D) Or (A And Not(C) And D) Or (Not(B) And Not(D)));
c_c <= Not((Not(A) And Not(C)) Or (Not(A) And D) Or (Not(A) And B) Or (A And Not(B)) Or (Not(C) And D)) ;
d_d<= Not((Not(A) And Not(B) And Not(D)) Or (A And Not(C)) Or (A And Not(B) And D) Or (B And Not(C) And D) Or (B And C And Not(D)) Or (Not(A) And Not(B) And C));
e <= Not((Not(B) And Not(D)) Or (C And Not(D)) Or (A And B) Or (A And C));
f<= Not((Not(C) And Not(D)) Or (B And Not(D)) Or (Not(A) And B And Not(C)) Or (A And Not(B)) Or (A And C));
g<= Not((Not(B) And C) Or (C And Not(D)) Or (Not(A) And B And Not(C)) Or (B And Not(C) And D) Or (A And D) Or (A And Not(B)));

A1<= '0';
A2<= '1';
A3<= '1';
A4<= '1';

end Behavioral;
