library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity A9 is
Port(clock: in std_logic;
     data_in: in std_logic_vector(15 downto 0);
     write: in std_logic;
     read: in std_logic;
     full: out std_logic;
     empty: out std_logic;
     anode: out std_logic_vector(3 downto 0);
       a_a :out std_logic;
       b_b: out std_logic;
       c_c: out std_logic;
       d_d: out std_logic;
       e: out std_logic;
       f: out std_logic;
       g: out std_logic);
end A9;

architecture Behavioral of A9 is

signal wa: integer;
signal ra: integer;
signal w: std_logic;
signal r: std_logic;
signal store: std_logic_vector(15 downto 0);
component fifo is
port(clock: in std_logic;
 
  write: in std_logic;
  read: in std_logic;
  full: out std_logic;
  empty: out std_logic;
  write_address: out integer;
  read_address: out integer;
  write_flag: out std_logic;
  read_flag: out std_logic);
  end component;
  
component ram is
Port( clock: in std_logic;
      write_address: in integer;
      read_address : in integer;
      write: in std_logic;
      read: in std_logic;
      data_in : in std_logic_vector(15 downto 0);
      data_out: out std_logic_vector(15 downto 0));
end component;

component display is
Port (clock: in std_logic;
register_data: in std_logic_vector(15 downto 0);
anode: out std_logic_vector(3 downto 0);
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic
);
end component;

begin

fifo1: fifo
     port map(clock=>clock,
     
     write=>write,
     read=>read,
     full=>full,
     empty=>empty,
     write_address=>wa,
     read_address=>ra,
     write_flag=>w,
     read_flag=>r
     );

ram1: ram
      port map(clock=> clock,
      write_address=>wa,
      read_address=>ra,
      write=>w,
      read=>r,
      data_in=>data_in,
      data_out=>store
      );
      
display1: display
      port map(clock=>clock,
      register_data=>store,
      anode=>anode,
      a_a=>a_a,
      b_b=>b_b,
      c_c=>c_c,
      d_d=>d_d,
      e=>e,
      f=>f,
      g=>g);
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity fifo is
 Port (clock: in std_logic;
  
  write: in std_logic;
  read: in std_logic;
  full: out std_logic;
  empty: out std_logic;
  write_address: out integer;
  read_address: out integer;
  write_flag: out std_logic;
  read_flag: out std_logic);
end fifo;

architecture Behavioral of fifo is

signal ra: integer range 0 to 255:=0; --read address
signal wa: integer range 0 to 255:=0; --write address

signal r: std_logic:='0'; --read flag
signal w: std_logic:='0'; --write flag

signal full_flag: std_logic:='0';--full
signal empty_flag: std_logic:='0'; --empty
signal counter: std_logic:='0'; -- to keep track of read/write operations

signal count: integer range 0 to 10000000:=0;


begin 

full<= full_flag;
empty<=empty_flag;

write_address<=wa;
read_address<=ra;

write_flag<=w;
read_flag<=r;


process(clock)
begin
if clock'event and clock='1' then
count<=count+1;

if count=10000000 then
count<=0;

if read='1' and empty_flag='0' then --pop
ra<=ra+1;
if ra=255 then ra<=0;
end if;
counter<='0';
elsif write='1' and full_flag='0' then --push
wa<=wa+1;
if wa=255 then wa<=0;
end if;
counter<='1';
end if;

if write='1' and read='0' then
if full_flag='0' then w<='1'; -- write
else w<='0';
r<='0';
end if;

elsif write='0' and read='1' then
if empty_flag='0' then r<='1'; --read
else r<='0';
w<='0';
end if;

elsif write='1' and read='1' then
if empty_flag='0' then r<='1'; w<='0';--read
else w<='1';r<='0'; --write
end if;

else w<='0'; r<='0';

end if;

end if;

end if;
end process;

process(counter,wa,ra)
begin
if wa=ra then
if counter='0' then empty_flag<='1'; full_flag<='0';
else empty_flag<='0'; full_flag<='1';
end if;
else empty_flag<='0'; full_flag<='0';
end if;


end process;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity ram is
Port( clock: in std_logic;
      write_address: in integer;
      read_address : in integer;
      write: in std_logic;
      read: in std_logic;
      data_in : in std_logic_vector(15 downto 0);
      data_out: out std_logic_vector(15 downto 0));
end ram;

architecture Behavioral of ram is
type bram is array (0 to 255) of std_logic_vector(15 downto 0);
signal memory: bram:=(others=>(others=>'0'));
begin
process(clock)
begin
if clock'event and clock='1' then
if write='1' then memory(write_address)<=data_in;
end if;
if read='1' then data_out<=memory(read_address);
end if;
end if;
end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity display is
Port (clock: in std_logic;
register_data: in std_logic_vector(15 downto 0);
anode: out std_logic_vector(3 downto 0);
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic
);
 end display;
architecture behavioural of display is
signal A: std_logic;
signal B: std_logic;
signal C: std_logic;
signal D: std_logic;

signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";
signal LED_activating_counter: std_logic_vector(1 downto 0) := "00";

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

process(clock)
begin
    if(rising_edge(clock)) then
        refresh_counter <= refresh_counter + 1;
	
		
end if;
end process;

LED_activating_counter <= refresh_counter(19 downto 18);

process(LED_activating_counter,register_data)
begin
    case LED_activating_counter is
    
    when "00" =>
    
       
        anode <= "0111";
       
        A<=register_data(15);
        B<=register_data(14);
        C<=register_data(13);
        D<=register_data(12);
        
    when "01" =>
    
        anode <= "1011";
       
      
       A<=register_data(11);
        B<=register_data(10);
        C<=register_data(9);
        D<=register_data(8);
        
    when "10" =>
    
        anode <= "1101";
       
        A<=register_data(7);
        B<=register_data(6);
        C<=register_data(5);
        D<=register_data(4);
    when "11" =>
    
        anode <= "1110";
       
        A<=register_data(3);
        B<=register_data(2);
        C<=register_data(1);
        D<=register_data(0);
    when others =>
        anode <= "1111";
       
    end case;
end process;

end behavioural;