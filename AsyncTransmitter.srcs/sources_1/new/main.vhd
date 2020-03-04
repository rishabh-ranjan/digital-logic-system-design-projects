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
        led: out std_logic_vector(7 downto 0);
        tx_out: out std_logic := '1'
    );
end Main;

architecture Behavioral of Main is

type state_type is (idle, start, si);
signal state: state_type := idle;
signal tx_state: state_type := idle;
signal tx_start: std_logic := '0';
signal tx_done: std_logic := '1';

signal rxclk: std_logic := '0';
signal rxctr: integer := 0;
signal txclk: std_logic := '0';
signal txctr: integer := 0;

signal count: integer := 0;
signal i: integer := 0;
signal txi: integer := 0;

signal rx_reg: std_logic_vector(7 downto 0);
signal tx_reg: std_logic_vector(7 downto 0);

begin

process(clk)
begin
    if clk = '1' and clk'event then
        rxctr <= rxctr + 1;
        if rxctr = 325 then
            rxctr <= 0;
            rxclk <= not rxclk;
        end if;
        txctr <= txctr + 1;
        if txctr = 5208 then
            txctr <= 0;
            txclk <= not txclk;
        end if;
    end if;
end process;

process(txclk)
begin
    if txclk = '1' and txclk'event then
        if tx_state = start then
            tx_out <= '0';
            tx_state <= si;
            txi <= 0;
        elsif tx_state = si then
            tx_out <= tx_reg(txi);
            txi <= txi+1;
            if txi = 7 then
                tx_done <= '1';
                tx_state <= idle;
            end if;
        else
            tx_out <= '1';
            tx_done <= '0';
            if tx_start = '1' then
                tx_state <= start;
            end if;
        end if;                
    end if;
end process;

process(rxclk)
begin
    if rxclk = '1' and rxclk'event then
        if state /= idle then
            count <= count + 1;
        elsif tx_done = '1' then
            tx_start <= '0';
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
            tx_reg <= rx_reg;
            tx_start <= '1';
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
