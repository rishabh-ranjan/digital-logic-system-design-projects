library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity transmitter is
    port (
        reset : in std_logic;
        txclk : in std_logic;
        tx_data : in std_logic_vector (7 downto 0);
        ld_tx : in std_logic;
        tx_out : out std_logic;
        tx_empty : out std_logic
    );
end transmitter;

architecture Behavioral of transmitter is
    type state_type is (idle, start, si);
    signal state : state_type := idle;
    signal i : integer := 0;
    signal reg : std_logic_vector (7 downto 0);
begin
    process (txclk, reset)
    begin
        if rising_edge(txclk) then
            if state = idle then
                tx_out <= '1';
                if ld_tx = '1' then
                    tx_empty <= '0';
                    state <= start;
                end if;
            elsif state = start then
                tx_out <= '0';
                reg <= tx_data;
                i <= 0;
                state <= si;
            elsif state = si then
                tx_out <= reg(i);
                i <= i+1;
                if i = 7 then
                    tx_empty <= '1';
                    state <= idle;
                end if;
            end if;
        end if;
        if reset = '1' then
            state <= idle;
        end if;
    end process;
end architecture;