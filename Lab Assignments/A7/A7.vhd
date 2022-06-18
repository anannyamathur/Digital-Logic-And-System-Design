----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2022 22:25:59
-- Design Name: 
-- Module Name: A7 - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity A7 is
  generic(divider: integer:=651); --100000000/9600/16 -- 16 times the baud rate)
   Port (clock            : in  std_logic;
        reset          : in  std_logic;
        data_in     : in  std_logic;
        data_out    : out std_logic_vector (7 downto 0) );
end A7;

architecture Behavioral of A7 is
    
    type states is (idle, start, data_read, stop);
    signal state: states:= idle;
    signal clock_16Xbaud_rate: std_logic:= '0'; -- 16 times the baud rate
    signal register_data: std_logic_vector(7 downto 0):="00000000"; -- to hold the data
    

begin
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
                    
                    if bits_read=7 then state<=stop; duration:=0; bits_read:=0;
                    else bits_read:=bits_read+1; state<=data_read;
                    end if;
                    else duration:=duration+1; state<=data_read;
                    end if;
  
  when stop=> if duration=15 then state<=idle; data_out<=register_data; -- reaches one cycle
              else duration:=duration+1; state<=stop;
              end if;
  
  when others=> state<=idle;
   end case;
   end if;
   end if;
   end if;
   end process;


end Behavioral;
