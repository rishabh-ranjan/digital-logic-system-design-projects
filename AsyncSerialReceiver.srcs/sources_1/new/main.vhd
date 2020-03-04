----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.09.2019 13:35:38
-- Design Name: 
-- Module Name: Main - Behavioral
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

entity Main is
    Port (
        clk: in std_logic;
        rx_in: in std_logic;
        reset: in std_logic;
        led: out std_logic_vector(7 downto 0)
    );
end Main;

architecture Behavioral of Main is

type state_type is (idle, start, si);
signal state: state_type := idle;

signal rxclk: std_logic := '0';
signal rxctr: integer := 0;

signal count: integer := 0;
signal i: integer := 0;

signal rx_reg: std_logic_vector(7 downto 0);

signal ld: std_logic := '1';

begin

process(clk)
begin
    if clk = '1' and clk'event then
        rxctr <= rxctr + 1;
        if rxctr = 325 then
            rxctr <= 0;
            rxclk <= not rxclk;
        end if;
    end if;
end process;

process(rxclk)
begin
    if rxclk = '1' and rxclk'event then
        if state /= idle then
            count <= count + 1;
        end if;
    
        if count = 15 then
            count <= 0;
        end if;
        
        if count = 8 then
            state <= si;
        end if;
    
        if state = start then
            if rx_in = '1' then
                state <= idle;
                count <= 0;
            end if;
        end if;
        
        if state = si and count = 8 then
            rx_reg <= rx_in & rx_reg(7 downto 1);
            i <= i + 1;
        end if;
    
        if i = 8 then
            led <= rx_reg;
            state <= idle;
            count <= 0;
            i <= 0;
        end if;
        
        if state = idle and rx_in = '0' then
            state <= start;
        end if;
    
        if reset = '1' then
            state <= idle;
            count <= 0;
            i <= 0;
            rx_reg <= "00000000";
            led <= "00000000";
        end if;

    end if;
end process;

end Behavioral;
