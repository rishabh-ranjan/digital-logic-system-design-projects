library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
    port (
        clk : in std_logic;
        pb1 : in std_logic;
        pb0 : in std_logic;
        tx_start : out std_logic;
        reset : out std_logic
    );
end debouncer;

architecture Behavioral of debouncer is
    signal ctr : integer := 0;
    signal iclk : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            ctr <= ctr + 1;
            if ctr = 10000000 then
                ctr <= 0;
                iclk <= not iclk;
            end if;
        end if;
    end process;
    process (iclk)
    begin
        if rising_edge(iclk) then
            if pb1 = '1' then
                tx_start <= '1';
            else
                tx_start <= '0';
            end if;
            if pb0 = '1' then
                reset <= '1';
            else
                reset <= '0';
            end if;
        end if;
    end process;
end Behavioral;
