library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timing is
    port (
        tx_start : in std_logic;
        txclk : in std_logic;
        reset : in std_logic;
        tx_empty : in std_logic;
        rx_full : in std_logic;
        ld_tx : out std_logic;
        rd_addr : out std_logic_vector(7 downto 0);
        wr_addr : out std_logic_vector(7 downto 0);
        wen : out std_logic
    );
end timing;

architecture Behavioral of timing is
    type state_type is (idle, write, start_read, delay_read, wait_read, end_read);
    signal state : state_type := idle;
    signal rd : integer := 0;
    signal wr : integer := 0;
begin
    process (txclk, reset)
    begin
        if rising_edge(txclk) then
            ld_tx <= '0';
            wen <= '0';
            if state = idle then
                if tx_start = '1' then
                    rd <= 0;
                    state <= start_read;
                elsif rx_full = '0' then
                    state <= write;
                end if;
            elsif state = write then
                if rx_full = '1' then
                    wen <= '1';
                    wr <= wr + 1;
                    state <= idle;
                end if;
            elsif state = start_read then
                if rd = wr then
                    state <= end_read;
                else
                    rd <= rd + 1;
                    ld_tx <= '1';
                    state <= delay_read;
                end if;
            elsif state = delay_read then
                if tx_empty = '0' then
                    state <= wait_read;
                end if;
            elsif state = wait_read then
                if tx_empty = '1' then
                    state <= start_read;
                end if;
            elsif state = end_read then
                if tx_start = '0' then
                    state <= idle;
                end if;
            end if;
        end if;
        if reset = '1' then
            wr <= 0;
            state <= idle;
        end if;
    end process;
    rd_addr <= std_logic_vector(to_unsigned(rd, rd_addr'length));
    wr_addr <= std_logic_vector(to_unsigned(wr, wr_addr'length));
end architecture;