library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram is
    generic (
        w : integer := 32;  -- number of bits per RAM word
        r : integer := 16   -- 2^r = number of words in RAM
    );
    port (
        clk : in std_logic;
        en : in std_logic;  -- clock enable
        we : in std_logic;  -- write enable
        addr : in std_logic_vector (r-1 downto 0);
        di : in std_logic_vector (w-1 downto 0);
        do : out std_logic_vector (w-1 downto 0)
    );
end bram;

architecture behavioral of bram is
    type ram_type is array (2**r-1 downto 0) of std_logic_vector (w-1 downto 0);
    signal ram : ram_type;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                do <= ram(to_integer(unsigned(addr)));
                if we = '1' then
                    ram(to_integer(unsigned(addr))) <= di;
                end if;
            end if;
        end if;
    end process;
end behavioral;