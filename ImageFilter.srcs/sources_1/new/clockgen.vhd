library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clockgen is
    port (
        reset : in std_logic;
        clk : in std_logic;
        rxclk : out std_logic;
        txclk : out std_logic
    );
end clockgen;

architecture Behavioral of clockgen is
    signal rxclki : std_logic;
    signal txclki : std_logic;
    signal rxctr : integer := 0;
    signal txctr : integer := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            rxctr <= rxctr + 1;
            if rxctr = 325 then
                rxctr <= 0;
                rxclki <= not rxclki;
            end if;
            txctr <= txctr + 1;
            if txctr = 5208 then
                txctr <= 0;
                txclki <= not txclki;
            end if;
        end if;
    end process;
    rxclk <= rxclki;
    txclk <= txclki;
end architecture;