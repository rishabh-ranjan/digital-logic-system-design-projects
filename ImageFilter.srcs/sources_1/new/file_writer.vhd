library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity file_writer is
    port (
        ld_tx : out std_logic;
        post_data_out : in integer;
        post_ren : out std_logic;
        post_rd_addr : out integer;
        tx_start : in std_logic;
        width : in integer;
        height : in integer;
        tx_empty : in std_logic;
        tx_in : out std_logic_vector(7 downto 0);
        txclk : in std_logic;
        reset : in std_logic
    );
end file_writer;

architecture Behavioral of file_writer is
    type digit_type is array(2 downto 0) of integer;
    signal digits : digit_type;
    signal dig_ptr : integer;
    type state_type is (idle, start_read, delay_convert, zero_convert, convert, send, delay_send, wait_send, end_read);
    signal state : state_type := idle;
    signal rd : integer := 0;
    signal px : integer := 0;
    signal ch : integer;
begin
    post_rd_addr <= rd;
    process (txclk, reset)
    begin
        if rising_edge(txclk) then
            ld_tx <= '0';
            post_ren <= '0';
            if state = idle then
                if tx_start = '1' then
                    rd <= 0;
                    state <= start_read;
                end if;
            elsif state = start_read then
                if rd = 10 then
                    state <= end_read;
                else
                    rd <= rd + 1;
                    post_ren <= '1';
                    state <= delay_convert;
                end if;
            elsif state = delay_convert then
                px <= post_data_out;
                state <= zero_convert;
            elsif state = zero_convert then
                if px = 0 then
                    dig_ptr <= -3;
                    digits(0) <= 0;
                    state <= send;
                else
                    dig_ptr <= 0;
                    state <= convert;
                end if;
            elsif state = convert then
                if px = 0 then
                    dig_ptr <= dig_ptr - 1;
                    state <= send;
                else
                    digits(dig_ptr) <= px mod 10;
                    dig_ptr <= dig_ptr + 1;
                    px <= px / 10;
                end if;
            elsif state = send then
                if dig_ptr = -3 then
                    tx_in <= std_logic_vector(to_unsigned(48, 8));
                    dig_ptr <= -1;
                    ld_tx <= '1';
                    state <= delay_send;
                elsif dig_ptr = -2 then
                    state <= start_read;
                else
                    if dig_ptr = -1 then
                        tx_in <= std_logic_vector(to_unsigned(9, 8));
                    else
                        tx_in <= std_logic_vector(to_unsigned(digits(dig_ptr) + 48, 8));
                    end if;
                    dig_ptr <= dig_ptr - 1;
                    ld_tx <= '1';
                    state <= delay_send;
                end if;
            elsif state = delay_send then
                if tx_empty = '0' then
                    state <= wait_send;
                end if;
            elsif state = wait_send then
                if tx_empty = '1' then
                    state <= send;
                end if;
            elsif state = end_read then
                if tx_start = '0' then
                    state <= idle;
                end if;
            end if;
        end if;
        if reset = '1' then
            state <= idle;
        end if;
    end process;
end architecture;