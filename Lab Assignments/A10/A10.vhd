
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity A10 is
  Port (clock:in std_logic;
  reset: in std_logic;
        tx_start: in std_logic;
        data_in: in std_logic;
        data_out: out std_logic;
        anode: out std_logic_vector(3 downto 0);
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic
        );
end A10;

architecture Behavioral of A10 is

signal reset1: std_logic:='0';
signal tx_start1: std_logic:='0';

signal receiver_full: integer:=0;
signal transmitter_empty: std_logic:='1';
signal wa: integer:=0;
signal ra: integer:=0;
signal r: std_logic:='0';
signal w: std_logic:='0';
signal input_data: std_logic_vector(7 downto 0);
signal output_data: std_logic_vector(7 downto 0);

signal counter: integer range 0 to 10000000:=0;


component receiver is
port(clock            : in  std_logic;
        reset          : in  std_logic;
        data_in     : in  std_logic;
        data_out    : out std_logic_vector (7 downto 0);
        stop_tr: out integer);
end component;

component transmitter is
port(clock            : in  std_logic;
        reset          : in  std_logic;
        stop_transmitter: in std_logic; -- indicates start/stop of transmission
        data_in     : in  std_logic_vector(7 downto 0);
        tx_empty: out std_logic;
        data_out    : out std_logic);
end component;

component display is
port(clock: in std_logic;
register_data1: in std_logic_vector(7 downto 0);
register_data2: in std_logic_vector(7 downto 0);
anode: out std_logic_vector(3 downto 0);
  a_a :out std_logic;
  b_b: out std_logic;
  c_c: out std_logic;
  d_d: out std_logic;
  e: out std_logic;
  f: out std_logic;
  g: out std_logic);
end component;


component timing_circuit is
port(clock: in std_logic;
tx_start: in std_logic;
tx_empty: in std_logic;
reset: in std_logic;
rx_full: in integer;
wr_addr: out integer;
rd_addr: out integer;
wen: out std_logic;
id_tx:out std_logic);
end component;

component ram is
port(clock: in std_logic;
      write_address: in integer;
      read_address : in integer;
      write: in std_logic;
      
      data_in : in std_logic_vector(7 downto 0);
      data_out: out std_logic_vector(7 downto 0));
end component;

begin

process(clock)
begin
if clock'event and clock='1' then
counter<=counter+1;
if counter=10000000 then counter<=0;
reset1<=reset;
if reset='1' then 
tx_start1<='0';

else 
if tx_start='1' then tx_start1<='1';
end if;
end if;
end if;
end if;
end process;

rec: receiver
     port map(clock=>clock,
     reset=>reset1,
     data_in=>data_in,
     data_out=>input_data,
     stop_tr=>receiver_full);
     
transmit: transmitter
     port map(clock=>clock,
        reset=>reset1,
        stop_transmitter=>r, -- indicates start/stop of transmission
        data_in=>output_data,
        tx_empty=>transmitter_empty,
        data_out=>data_out);

timing: timing_circuit
     port map(clock=>clock,
tx_start=>tx_start1,
tx_empty=>transmitter_empty,
reset=>reset1,
rx_full=>receiver_full,
wr_addr=>wa,
rd_addr=>ra,
wen=>w,
id_tx=>r);

memory: ram
port map(clock=>clock,
      write_address=>wa,
      read_address=>ra,
      write=>w,
      
      data_in =>input_data,
      data_out=>output_data);
      
data_display: display
port map(clock=>clock,
register_data1=>input_data,
register_data2=>output_data,
anode=>anode,
  a_a =>a_a,
  b_b=>b_b,
  c_c=>c_c,
  d_d=>d_d,
  e=>e,
  f=>f,
  g=>g);

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity receiver is
  generic(divider: integer:=651); --100000000/9600/16 -- 16 times the baud rate)
   Port (clock            : in  std_logic;
        reset          : in  std_logic;
        data_in     : in  std_logic;
        data_out    : out std_logic_vector (7 downto 0);
        stop_tr: out integer );
end receiver;

architecture Behavioral of receiver is
    
    type states is (idle, start, data_read, stop);
    signal state: states:= idle;
    signal clock_16Xbaud_rate: std_logic:= '0'; -- 16 times the baud rate
    signal register_data: std_logic_vector(7 downto 0):="00000000"; -- to hold the data
    signal stop_transmit: integer := 0;
    

begin
   stop_tr<=stop_transmit;
   -- clock generator to generate a clock 16 times the baud rate
   process(clock)
   variable count: integer range 0 to (divider - 1) := 0;
   begin
   if (clock'Event and clock='1') then 
   if(reset='1') then clock_16Xbaud_rate<='0';
   count:=0;
   else
   if count=(divider-1) then count:=0;
   clock_16Xbaud_rate<='1';
   else count:=count+1; 
   clock_16Xbaud_rate<='0';
   end if;
   end if;
   end if;
   
   end process;
   
   -- state machine
   process(clock)
   variable bits_read : integer range 0 to 7  := 0;
   variable duration : integer range 0 to 15 := 0;
   
   begin
   if (clock'Event and clock='1') then
   if(reset='1') then
   state<=idle;
   register_data<="00000000";
   data_out<="00000000";
   duration:=0;
   bits_read:=0;
   stop_transmit <=0;
   
   else
   if clock_16Xbaud_rate='1' then
   case state is
   when idle=>  register_data<="00000000";
   duration:=0;
   bits_read:=0;
   stop_transmit <=0;
   if data_in='0' then -- indicates start bit 
   state<=start;
   end if;
   
   when start=> 
   if data_in='0' then 
   if duration=7 then state<=data_read; duration:=0; -- reaches half of the cycle
   else duration:=duration+1; state<=start;
   end if;
   else state<=idle;
   end if;                               
                                  
   when data_read=> if duration=15 then register_data(bits_read)<=data_in; duration:=0;stop_transmit<=0;                                                                                                                                                                                    
                    
                    if bits_read=7 then state<=stop; duration:=0; bits_read:=0; data_out<=register_data; stop_transmit<=1;
                    else bits_read:=bits_read+1; state<=data_read;stop_transmit<=0;
                    end if;
                    else duration:=duration+1; state<=data_read;stop_transmit<=1;
                    end if;
                    
  
  when stop=> if duration=15 then state<=idle;  -- reaches one cycle
              else duration:=duration+1; state<=stop;
              stop_transmit<=1;-- indicates end of transmission of one set of data bits
              end if;
              
              
  when others=> state<=idle;
   end case;
   end if;
   end if;
   end if;
   end process;


end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity transmitter is
  generic(divider: integer:=10417); --100000000/9600 -- the baud rate)
   Port (clock            : in  std_logic;
        reset          : in  std_logic;
        stop_transmitter: in std_logic; -- indicates start/stop of transmission
        data_in     : in  std_logic_vector(7 downto 0);
        tx_empty: out std_logic;
        data_out    : out std_logic);
end transmitter;

architecture Behavioral of transmitter is
    
    type states is (idle, start, data_read, stop);
    signal state: states:= idle;
    signal clock_baud_rate: std_logic:= '0'; -- baud rate
    signal register_data: std_logic_vector(7 downto 0):="00000000"; -- to hold the data
    signal bits_read_stop: std_logic:='1'; -- to stop reading the current bits and move to the next set
    signal bits_read: integer range 0 to 7  := 0 ;-- to keep count of the number of bits read
    signal begin_read: std_logic:='0'; -- to keep track of when to start reading 
    signal start_counter: std_logic:='0'; -- to indicate beginning of the next set
    signal empty: std_logic:='1';

begin
   tx_empty<=empty;
   -- clock generator to generate a clock corresponding to the baud rate
   process(clock)
   variable count: integer range 0 to (divider - 1) := 0;
   begin
   if (clock'Event and clock='1') then 
   if(reset='1') then clock_baud_rate<='0';
   count:=0;
   else
   if count=(divider-1) then count:=0;
   clock_baud_rate<='1';
   else count:=count+1; 
   clock_baud_rate<='0';
   end if;
   end if;
   end if;
   
   end process;
   
   -- reading the bits
   process(clock)
   begin
   if (clock'event and clock='1') then
   if reset='1' or bits_read_stop='1' then bits_read<=0;
   elsif clock_baud_rate='1' then bits_read<=bits_read+1;
   end if;
   end if;
   end process;
   
   
   -- keeping track of when to start reading
   process(clock)
   begin
   if (clock'event and clock='1') then 
   if reset='1' or start_counter='1' then begin_read<='0';
   elsif begin_read='0' and stop_transmitter='1' then begin_read<='1'; register_data<=data_in;
   end if;
   end if;
   end process;
   
   
   -- state machine
   process(clock)
   
   
   begin
   if (clock'Event and clock='1') then
   if(reset='1') then
   state<=idle;
   bits_read_stop<='1';
   start_counter<='1';
   data_out<='1';
   empty<='1';
  
   
   else
   if clock_baud_rate='1' then
   case state is
   when idle=>  
   data_out<='1';
   start_counter<='0';
   bits_read_stop<='1';
   empty<='1';
   if begin_read='1' then state<=start;empty<='0';
   end if;
   
   when start=> 
   data_out<='0';
   bits_read_stop<='0';
   empty<='0';
   state<=data_read;
   
   when data_read=> data_out<=register_data(bits_read);
                    
                   if bits_read=7 then bits_read_stop<='1'; state<=stop; empty<='1';
                   end if;
  
  when stop=> state<=idle;start_counter<='1';data_out<='1';empty<='1';
              
  
  when others=> state<=idle;
   end case;
   end if;
   end if;
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
      data_in : in std_logic_vector(7 downto 0);
      data_out: out std_logic_vector(7 downto 0));
end ram;

architecture Behavioral of ram is
type bram is array (0 to 255) of std_logic_vector(7 downto 0);
signal memory: bram:=(others=>(others=>'0'));
begin
process(clock)
begin
if clock'event and clock='1' then
if write='1' then memory(write_address)<=data_in;
end if;
data_out<=memory(read_address);
end if;
end process;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity display is
Port (clock: in std_logic;
register_data1: in std_logic_vector(7 downto 0);
register_data2: in std_logic_vector(7 downto 0);
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

process(LED_activating_counter,register_data1, register_data2)
begin
    case LED_activating_counter is
    
    when "00" =>
    
       
        anode <= "0111";
       
        A<=register_data1(7);
        B<=register_data1(6);
        C<=register_data1(5);
        D<=register_data1(4);
        
    when "10" =>
    
        anode <= "1011";
       
      
       A<=register_data1(3);
        B<=register_data1(2);
        C<=register_data1(1);
        D<=register_data1(0);
        
    when "01" =>
    
       
        anode <= "1101";
       
        A<=register_data2(7);
        B<=register_data2(6);
        C<=register_data2(5);
        D<=register_data2(4);
        
    when "11" =>
    
        anode <= "1110";
       
      
       A<=register_data2(3);
        B<=register_data2(2);
        C<=register_data2(1);
        D<=register_data2(0);
    
    when others =>
        anode <= "1111";
       
    end case;
end process;

end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity timing_circuit is
generic(divider: integer:=10417); --100000000/9600 -- the baud rate)
port(clock: in std_logic;
tx_start: in std_logic;
tx_empty: in std_logic;
reset: in std_logic;
rx_full: in integer;
wr_addr: out integer;
rd_addr: out integer;
wen: out std_logic;
id_tx:out std_logic);
end timing_circuit;

architecture behavioral of timing_circuit is

signal clock_baud_rate: std_logic:= '0'; -- baud rate

signal counter:std_logic:='0';
signal ra: integer range 0 to 255:=0; --read address
signal wa: integer range 0 to 255:=0; --write address

signal update_r: std_logic:='0'; --read flag
signal update_w: std_logic:='0'; --write flag


signal r: std_logic:='0'; --read flag
signal w: std_logic:='0'; --write flag

signal full_flag: std_logic:='0';--full
signal empty_flag: std_logic:='0'; --empty
begin

wr_addr<=wa;
rd_addr<=ra;
wen<=w;
id_tx<=r;
   process(clock)
   variable count: integer range 0 to (divider - 1) := 0;
   begin
   if (clock'Event and clock='1') then 
   if(reset='1') then clock_baud_rate<='0';
   count:=0;
   else
   if count=(divider-1) then count:=0;
   clock_baud_rate<='1';
   else count:=count+1; 
   clock_baud_rate<='0';
   end if;
   end if;
   end if;
   
   end process;
   
   

   process(clock)
   
   begin
   if clock'event and clock='1' then
   
   
   if reset='1' then 
   
   wa<=0;
   ra<=0;
   
   else
  if clock_baud_rate='1' then
      
     if tx_start='1' and empty_flag='0' then --pop
         if tx_empty='1' then
         ra<=ra+1;
         if ra=255 then ra<=0;
         end if;
         counter<='0';
         end if;
         
        end if;
         
         if rx_full=1 and full_flag='0' then --push
         wa<=wa+1;
         if wa=255 then wa<=0;
         end if;
         counter<='1';
         end if;
   end if;
   end if;
  end if; 
   end process;
   
   process(rx_full, tx_start,full_flag,empty_flag,tx_empty,clock,reset)
   begin
   if clock'event and clock='1' then
   if reset='1' then 
   r<='0';
   w<='0';
   

elsif clock_baud_rate='1' then

   
   if rx_full=1 and tx_start='0' then
   r<='0';
   if full_flag='0' then w<='1'; -- write
   else w<='0';
   
   end if;
   
   
   elsif rx_full=0 and tx_start='1' then
   w<='0';
   if empty_flag='0' then
   if tx_empty='1' then r<='1'; --read
   else r<='0';
   end if;
   else r<='0';
   
   end if;
   
   
   elsif rx_full=1 and tx_start='1' then
   if empty_flag='0' then
   if tx_empty='1' then r<='1'; w<='0';--read
   else w<='1'; r<='0';
   end if;
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
   
end behavioral;