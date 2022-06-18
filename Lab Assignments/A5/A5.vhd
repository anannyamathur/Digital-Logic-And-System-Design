library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;



entity A5 is
       port(clk : in STD_LOGIC;
       anode : out STD_LOGIC_VECTOR (3 downto 0);
       button1: in std_logic; --feeding the values
       button2: in std_logic; --brightness change
       
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
          
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic);
end A5;

architecture Behavioral of A5 is


signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";
signal LED_activating_counter: std_logic_vector(1 downto 0) := "00";
signal ts1 : natural range 0 to 10:= 0;
signal s : natural range 0 to 10 := 0;


signal count : natural range 0 to 10000000 := 0; 


signal temp1:    std_logic:='1'; 
signal temp2:   std_logic:='1'; 
signal temp3:    std_logic:='1'; 
signal temp4:   std_logic:='1'; 
signal temp5:    std_logic:='1'; 
signal temp6:    std_logic:='1'; 
signal temp7:    std_logic:='1'; 
signal temp8:    std_logic:='1'; 
signal temp9:     std_logic:='1'; 
signal temp10:    std_logic:='1'; 
signal temp11:    std_logic:='1'; 
signal temp12:    std_logic:='1'; 
signal temp13:     std_logic:='1'; 
signal temp14:    std_logic:='1'; 
signal temp15:    std_logic:='1'; 
signal temp16:    std_logic:='1';

signal br1:    std_logic:='1'; 
signal br2:   std_logic:='1'; 
signal br3:    std_logic:='1'; 
signal br4:   std_logic:='1'; 
signal br5:    std_logic:='1'; 
signal br6:    std_logic:='1'; 
signal br7:    std_logic:='1'; 
signal br8:    std_logic:='1';

signal A: std_logic;
signal B: std_logic;
signal C: std_logic;
signal D: std_logic;

signal brightness_counter: std_logic_vector(3 downto 0) := "0000";

signal level_1: std_logic_vector(3 downto 0) := "0000";
signal level_2: std_logic_vector(3 downto 0) := "0000";
signal level_3: std_logic_vector(3 downto 0) := "0000";
signal level_4: std_logic_vector(3 downto 0) := "0000";


begin 
process(A,B,C,D)
begin

a_a <= Not((Not(B) And Not(D)) Or (A And Not(B) And Not(C)) Or (A And Not(D)) Or (B And C) Or (Not(A) And C) Or (Not(A) And B And D));
b_b <= Not((Not(A) And Not(B)) Or (Not(A) And Not(C) And Not(D)) Or (Not(A) And C And D) Or (A And Not(C) And D) Or (Not(B) And Not(D)));
c_c <= Not((Not(A) And Not(C)) Or (Not(A) And D) Or (Not(A) And B) Or (A And Not(B)) Or (Not(C) And D)) ;
d_d<= Not((Not(A) And Not(B) And Not(D)) Or (A And Not(C)) Or (A And Not(B) And D) Or (B And Not(C) And D) Or (B And C And Not(D)) Or (Not(A) And Not(B) And C));
e <= Not((Not(B) And Not(D)) Or (C And Not(D)) Or (A And B) Or (A And C));
f<= Not((Not(C) And Not(D)) Or (B And Not(D)) Or (Not(A) And B And Not(C)) Or (A And Not(B)) Or (A And C));
g<= Not((Not(B) And C) Or (C And Not(D)) Or (Not(A) And B And Not(C)) Or (B And Not(C) And D) Or (A And D) Or (A And Not(B)));

end process;


process(clk)
begin
    if(rising_edge(clk)) then
        refresh_counter <= refresh_counter + 1;
	
		count <= count +1;
	
	if(count = 10000000) then -- reducing the frequency to 10 Hz
		count <=0;
		ts1 <= ts1 + 1;
	end if;
	if ts1 = 10 then  --  updating s every second
		ts1 <= 0;
		s <= s + 1;
	end if;
	if s= 4 then    -- s indicates rotation
		s <= 0;
		
	end if;
	
	
	if button1 = '1'then -- setting the values for display
		temp1<=a0 ;
		temp2<=a1 ;
		temp3<=a2 ;
		temp4<=a3 ;
		temp5<=b0 ;
		temp6<=b1 ;
		temp7<=b2 ;
		temp8<=b3 ;
		temp9<=c0 ;
		temp10<=c1 ;
		temp11<=c2 ;
		temp12<=c3 ;
		temp13<=d0 ;
		temp14<=d1 ;
		temp15<=d2 ;
		temp16<=d3 ;
	end if;
	if button2 = '1'then -- setting the brightness values
		 br1<=a0 ;
		br2<=a1 ;
		br3<=a2 ;
		br4<=a3 ;
		br5<=b0 ;
		br6<=b1 ;
		br7<=b2 ;
		br8<=b3 ;
	end if;
	
	
	
    end if;
end process;

level_1<= br5 & br6 &"11";
level_2<= br7 & br8 &"11";
level_3<= br1 & br2 &"11";
level_4<= br3 & br4 &"11";

brightness_counter<=refresh_counter(17 downto 14);

LED_activating_counter <= refresh_counter(19 downto 18);

process(LED_activating_counter,s,brightness_counter,level_1, level_2, level_3, level_4, temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp9, temp10, temp11, temp12, temp13, temp14, temp15, temp16)
begin
    case LED_activating_counter is
    
    when "00" =>
    if brightness_counter<=level_1 then
       if s=0 then
       
        anode <= "0111";
       elsif s=1 then anode<="1110";
       elsif s=2 then anode<="1101";
       else anode<="1011";
       end if; 
    else anode<="1111";
    end if;
        A<=temp13;
        B<=temp14;
        C<=temp15;
        D<=temp16;
        
    when "01" =>
    if brightness_counter<=level_2 then
        if s=0 then
        anode <= "1011";
       elsif s=1 then anode<="0111";
       elsif s=2 then anode<="1110";
       else anode<="1101";
       end if;
    else anode<="1111";
    end if;
       A<=temp9;
        B<=temp10;
        C<=temp11;
        D<=temp12;
        
    when "10" =>
    if brightness_counter<=level_3 then
        if s=0 then
        anode <= "1101";
       elsif s=1 then anode<="1011";
       elsif s=2 then anode<="0111";
       else anode<="1110";
       end if;
    else anode<="1111";
    end if;
        A<=temp5;
        B<=temp6;
        C<=temp7;
        D<=temp8;
    when "11" =>
    if brightness_counter<=level_4 then
        if s=0 then
        anode <= "1110";
       elsif s=1 then anode<="1101";
       elsif s=2 then anode<="1011";
       else anode<="0111";
       end if;
     else anode<="1111";
     end if;
        A<=temp1;
        B<=temp2;
        C<=temp3;
        D<=temp4;
    when others =>
        anode <= "1111";
       
    end case;
end process;

end Behavioral;