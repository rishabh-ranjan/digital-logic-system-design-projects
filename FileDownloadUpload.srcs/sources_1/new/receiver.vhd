library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity receiver is
    port (
        rx_in : in std_logic;
        reset : in std_logic;
        rxclk : in std_logic;
        rx_full : out std_logic;
        rx_data : out std_logic_vector (7 downto 0);
        led : out std_logic_vector(15 downto 0)
    );
end receiver;

architecture Behavioral of receiver is
    type state_type is (idle, start, si);
    signal state : state_type := idle;
    signal i : integer := 0;
    signal count : integer := 0;
    signal reg : std_logic_vector (7 downto 0);
begin
    process (rxclk, reset)
    begin
        if rising_edge(rxclk) then
            if count = 15 then
                count <= 0;
            else
                count <= count+1;
            end if;
            if state = idle then
                rx_full <= '1';
                if rx_in = '0' then
                    state <= start;
                    count <= 0;
                end if;
            elsif state = start then
                if count = 8 then
                    state <= si;
                    i <= 0;
                end if;
                if rx_in = '1' then
                    state <= idle;
                end if;
            elsif state = si then
                if count = 8 then
                    rx_full <= '0';
                    reg(i) <= rx_in;
                    i <= i+1;
                    if i = 7 then
                        state <= idle;
                        rx_data <= reg;
                        led(7 downto 0) <= reg;
                    end if;
                end if;
            end if;
        end if;
        if reset = '1' then
            state <= idle;
        end if;
    end process;
end architecture;