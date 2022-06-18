
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;



entity A6 is
       port(clk : in STD_LOGIC;
       anode : out STD_LOGIC_VECTOR (3 downto 0);
	   b1: in STD_LOGIC;       -- running button
	   b2: in STD_LOGIC;       -- Pause button
	   b3: in STD_LOGIC;       -- Reset button.
       outp : out STD_LOGIC_VECTOR (6 downto 0));
end A6;

architecture Behavioral of A6 is

signal LED : natural range 0 to 10:=0;
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";
signal LED_activating_counter: std_logic_vector(1 downto 0) := "00";
signal ts1 : natural range 0 to 10:= 0;
signal s : natural range 0 to 10 := 0;
signal ts2 : natural range 0 to 10 := 0;
signal m : natural range 0 to 10 := 0;
signal count : natural range 0 to 10000000 := 0; 
signal RUNNING : STD_LOGIC := '0';

begin 

process(LED)
begin

case LED is 
when 0 =>
    outp <= "0000001";
when 1 =>
    outp <= "1001111" ;
when 2 =>
    outp <= "0010010"; 
when 3 =>
    outp <= "0000110"; 
when 4 =>
    outp <= "1001100"; 
when 5 =>
    outp <= "0100100"; 
when 6 =>
    outp <= "0100000"; 
when 7 =>
   outp <= "0001111"; 
when 8 =>
    outp <= "0000000"; 
when 9 =>
    outp <= "0000100"; 
when others =>
    outp <= "1111111"; 
    end case;

end process;

process(clk)
begin
    if(rising_edge(clk)) then
        refresh_counter <= refresh_counter + 1;
	if running ='1' then
		count <= count +1;
	end if;
	if(count = 10000000) then
		count <=0;
		ts1 <= ts1 + 1; -- gets updated every 0.1 s
	end if;
	if ts1 = 10 then
		ts1 <= 0;
		s <= s + 1;  -- updated every 1 s
	end if;
	if s= 10 then
		s <= 0;
		ts2 <= ts2 + 1; -- updated every 10 s
	end if;
	if ts2 = 6 then
		ts2 <= 0;
		m <= m + 1; -- updated every 60 s
	end if;
	
	if b1 = '1'then
		RUNNING <='1' ;
	end if;
	if b2 = '1'then
		RUNNING <='0' ;
	end if;
	if b3 = '1'then
		ts1 <= 0;
		s <= 0;
		ts2 <= 0;
		m <= 0;
		RUNNING <='0' ;
	end if;	
	
    end if;
end process;

LED_activating_counter <= refresh_counter(19 downto 18);
process(LED_activating_counter)
begin
    case LED_activating_counter is
    when "00" =>
        anode <= "0111"; 
        LED <= m;
    when "01" =>
        anode <= "1011"; 
        LED <= ts2;
    when "10" =>
        anode <= "1101"; 
        LED <= s;
    when "11" =>
        anode <= "1110"; 
        LED <= ts1;
    when others =>
        anode <= "1111";
       
    end case;
end process;

end Behavioral;
