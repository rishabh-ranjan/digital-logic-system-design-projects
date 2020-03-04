library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity file_reader is
    port (
        rx_out : in std_logic_vector (7 downto 0);
        rx_full : in std_logic;
        width : out integer;
        height : out integer;
        max_val : out integer;
        pre_data_in : out integer;
        pre_wen : out std_logic;
        pre_wr_addr : out integer;
        --conv_start : out std_logic;
        rxclk : in std_logic
    );
end file_reader;

architecture Behavioral of file_reader is
    type state_type is (idle, read, read_wait);
    type content_type is (header, size, max, data);
    signal width_done : std_logic := '0';
    signal content : content_type := header;
    signal state : state_type := idle;
    signal ch : integer;
    signal px : integer := 0;
    signal addr : integer := 0;
    signal digit : std_logic := '0';
begin
    ch <= to_integer(unsigned(rx_out));
    pre_wr_addr <= addr;
    process(rxclk)
    begin
        if rising_edge(rxclk) then
            pre_wen <= '0';
            if state = idle then
                if rx_full = '1' then
                    state <= read;
                end if;
            elsif state = read then
                if ch >= 48 and ch < 58 then
                    px <= px*10 + ch-48;
                    digit <= '1';
                else
                    if digit <= '1' then
                        if content = header then
                            if ch /= 80 then
                                content <= size;
                            end if;
                        elsif content = size then
                            if width_done = '0' then
                                width <= px;
                                width_done <= '1';
                            else
                                height <= px;
                                content <= max;
                            end if;
                        elsif content = max then
                            max_val <= px;
                            content <= data;
                        elsif content = data then
                            pre_wen <= '1';
                            addr <= addr + 1;
                            pre_data_in <= px;
                        end if;
                        px <= 0;
                        digit <= '0';
                    end if;
                end if;
                state <= read_wait;
            elsif state = read_wait then
                if rx_full = '0' then
                    state <= idle;
                end if;
            end if;
        end if;
    end process;
end architecture;