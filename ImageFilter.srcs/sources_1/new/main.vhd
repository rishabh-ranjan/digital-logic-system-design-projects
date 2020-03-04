library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
    port (
        tx_out : out std_logic;
        rx_in : in std_logic;
        pb1 : in std_logic;
        pb0 : in std_logic;
        clk : in std_logic;
        led : out std_logic_vector(15 downto 0)
    );
end main;

architecture Behavioral of main is
    signal tx_start : std_logic;
    signal reset : std_logic;
    signal rxclk : std_logic;
    signal txclk : std_logic;
    signal rx_out : std_logic_vector (7 downto 0);
    signal tx_in : std_logic_vector (7 downto 0);
    signal ld_tx : std_logic;
    signal tx_empty : std_logic;
    signal rx_full : std_logic;
    signal rd_addr : integer;
    signal pre_wr_addr : integer;
    signal pre_wen : std_logic;
    signal rx_out_i : integer;
    signal tx_in_i : integer;
    signal width : integer;
    signal height : integer;
    signal max_val : integer;
    signal pre_data_in : integer;
    signal post_ren : std_logic;
    signal post_rd_addr : integer;
    signal post_data_out : integer;
    signal post_wen : std_logic;
    signal post_wr_addr : integer;
    signal post_data_in : integer;
begin
    rx_out_i <= to_integer(unsigned(rx_out));
    tx_in_i <= to_integer(unsigned(tx_in));
    led(7 downto 0) <= std_logic_vector(to_unsigned(width, 8));
    led(15 downto 8) <= std_logic_vector(to_unsigned(height, 8));
    debouncer : entity work.debouncer (Behavioral)
    port map (
        clk => clk,
        pb1 => pb1,
        pb0 => pb0,
        tx_start => tx_start,
        reset => reset
    );
    clockgen : entity work.clockgen (Behavioral)
    port map (
        reset => reset,
        clk => clk,
        txclk => txclk,
        rxclk => rxclk
    );
--    timing : entity work.timing (Behavioral)
--    port map (
--        tx_start => tx_start,
--        txclk => txclk,
--        reset => reset,
--        tx_empty => tx_empty,
--        ld_tx => ld_tx,
--        rd_addr => rd_addr
--    );
    file_writer : entity work.file_writer (Behavioral)
    port map (
        ld_tx => ld_tx,
        post_data_out => post_data_out,
        post_ren => post_ren,
        post_rd_addr => post_rd_addr,
        tx_start => tx_start,
        width => width,
        height => height,
        tx_empty => tx_empty,
        tx_in => tx_in,
        txclk => txclk,
        reset => reset
    );
    input_memory : entity work.memory (Behavioral)
    port map (
        clka => rxclk,
        wea => pre_wen,
        addra => pre_wr_addr,
        dina => pre_data_in,
        clkb => txclk,
        enb => post_ren,
        addrb => post_rd_addr,
        doutb => post_data_out,
        led => led
    );
--    output_memory : entity work.memory (Behavioral)
--    port map (
--        clka => rxclk,
--        wea => post_wen,
--        addra => post_wr_addr,
--        dina => post_data_in,
--        clkb => rxclk,
--        enb => post_ren,
--        addrb => post_rd_addr,
--        doutb => post_data_out,
--        led => led
--    );
    receiver : entity work.receiver (Behavioral)
    port map (
        rx_in => rx_in, 
        reset => reset,
        rxclk => rxclk,
        rx_full => rx_full,
        rx_out => rx_out
    );
    transmitter : entity work.transmitter (Behavioral)
    port map (
        tx_out => tx_out,
        reset => reset,
        txclk => txclk,
        tx_in => tx_in,
        tx_empty => tx_empty,
        ld_tx => ld_tx
    );
    file_reader : entity work.file_reader (Behavioral)
    port map (
        rx_out => rx_out,
        rx_full => rx_full,
        width => width,
        height => height,
        max_val => max_val,
        pre_data_in => pre_data_in,
        pre_wen => pre_wen,
        pre_wr_addr => pre_wr_addr,
        --conv_start => conv_start,
        rxclk => rxclk
    );
--    bram : entity work.bram (behavioral)
--    port map (
--        clk => txclk,
--        en => '1',
--        we => pre_wen,
--        addr => pre_wr_addr,
--        di => pre_data_in,
--        do => post_data_out
--    );
end architecture;