
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity A8 is
  Port (clock: in std_logic;
  reset: in std_logic;
  data_in: in std_logic;
  data_out: out std_logic;
  led: out std_logic_vector(7 downto 0) );
end A8;

architecture Behavioral of A8 is
signal output: std_logic_vector(7 downto 0);
signal transmit_flag: integer;

component receiver 
         port(clock            : in  std_logic;
        reset          : in  std_logic;
        data_in     : in  std_logic;
        data_out    : out std_logic_vector (7 downto 0);
        stop_tr: out integer);
        end component;

component transmitter
port(clock            : in  std_logic;
        reset          : in  std_logic;
        stop_transmitter: in integer;
        data_in     : in  std_logic_vector(7 downto 0);
        data_out    : out std_logic);
end component;

begin
led<= output;
receive : receiver
          port map(clock=>clock,
           reset=>reset,
           data_in=>data_in,
           data_out=>output,
           stop_tr=> transmit_flag);
transmit: transmitter
          port map(clock=>clock,
          reset=>reset,
          stop_transmitter=> transmit_flag,
          data_in=>output,
          data_out=>data_out);
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
   
   when data_read=> if duration=15 then register_data(bits_read)<=data_in; duration:=0;
                    
                    if bits_read=7 then state<=stop; duration:=0; bits_read:=0;  data_out<=register_data;
                    else bits_read:=bits_read+1; state<=data_read;
                    end if;
                    else duration:=duration+1; state<=data_read;
                    end if;
  
  when stop=> if duration=15 then state<=idle;  -- reaches one cycle
              else duration:=duration+1; state<=stop;
              stop_transmit<=1; -- indicates end of transmission of one set of data bits
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
        stop_transmitter: in integer; -- indicates start/stop of transmission
        data_in     : in  std_logic_vector(7 downto 0);
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
    

begin
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
   elsif begin_read='0' and stop_transmitter=1 then begin_read<='1'; register_data<=data_in;
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
   
  
   
   else
   if clock_baud_rate='1' then
   case state is
   when idle=>  
   data_out<='1';
   start_counter<='0';
   bits_read_stop<='1';
   if begin_read='1' then state<=start;
   end if;
   
   when start=> 
   data_out<='0';
   bits_read_stop<='0';
   state<=data_read;
   
   when data_read=> data_out<=register_data(bits_read);
                   if bits_read=7 then bits_read_stop<='1'; state<=stop;
                   end if;
  
  when stop=> state<=idle;start_counter<='1';data_out<='1'; 
              
  
  when others=> state<=idle;
   end case;
   end if;
   end if;
   end if;
   end process;


end Behavioral;

