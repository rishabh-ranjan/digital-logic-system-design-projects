library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    signal rx_data : std_logic_vector (7 downto 0);
    signal tx_data : std_logic_vector (7 downto 0);
    signal ld_tx : std_logic;
    signal tx_empty : std_logic;
    signal rx_full : std_logic;
    signal rd_addr : std_logic_vector (7 downto 0);
    signal wr_addr : std_logic_vector (7 downto 0);
    signal wen : std_logic;
begin
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
    timing : entity work.timing (Behavioral)
    port map (
        tx_start => tx_start,
        txclk => txclk,
        reset => reset,
        tx_empty => tx_empty,
        rx_full => rx_full,
        ld_tx => ld_tx,
        rd_addr => rd_addr,
        wr_addr => wr_addr,
        wen => wen
    );
    memory : entity work.memory (Behavioral)
    port map (
        clka => txclk,
        wea => wen,
        addra => wr_addr,
        dina => rx_data,
        clkb => txclk,
        enb => '1',
        addrb => rd_addr,
        doutb => tx_data,
        led => led
    );
    receiver : entity work.receiver (Behavioral)
    port map (
        rx_in => rx_in, 
        reset => reset,
        rxclk => rxclk,
        rx_full => rx_full,
        rx_data => rx_data,
        led => led
    );
    transmitter : entity work.transmitter (Behavioral)
    port map (
        tx_out => tx_out,
        reset => reset,
        txclk => txclk,
        tx_data => tx_data,
        tx_empty => tx_empty,
        ld_tx => ld_tx
    );
end architecture;