library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conv is
    port(
        pre_data_out : in integer;
        pre_ren : out std_logic;
        pre_rd_addr : out integer;
        post_data_in : in integer;
        post_wen : out integer;
        post_wr_addr : out integer;
        tx_start : out std_logic;
        width : in integer;
        height : in integer;
        conv_start : in std_logic;
        switch : in std_logic;
        clk : in std_logic;
        led : out std_logic_vector(15 downto 0)
    );
end conv;

architecture Behavioral of conv is
--    signal conv_data_in : integer;
--    signal conv_wen : std_logic;
--    signal conv_wr_addr : integer;
--    signal conv_data_out : integer;
--    signal conv_ren : std_logic;
--    signal conv_rd_addr : integer;
    
    type kernel is array(0 to 8) of integer;
    signal c : kernel;
    type image is array(0 to 100) of integer;
    signal p : image;
    signal r : image;
    signal h : integer;
    signal w : integer;
    signal ready : std_logic;
begin
    c <= (
        1,1,1,
        1,1,1,
        1,1,1
    );
    
--    conv_memory : entity work.memory(Behavioral)
--    port map(
--        clka => clk,
--        wea => conv_wen,
--        addra => conv_wr_addr,
--        dina => conv_data_in,
--        clkb => clk,
--        enb => conv_ren,
--        addrb => conv_rd_addr,
--        doutb => conv_data_out,
--        led => led
--    );
    load : process(conv_start)
    begin
        if conv_start = '1' then
            p <= (
                1,1,1,1,1,1,1,1,1,1,
                1,1,1,1,1,1,1,1,1,1,
                1,1,1,1,1,1,1,1,1,1,
                1,1,1,1,1,1,1,1,1,1,
                1,1,1,1,1,1,1,1,1,1,
                1,1,1,1,1,1,1,1,1,1,
                1,1,1,1,1,1,1,1,1,1
            );
            h <= 7;
            w <= 10;
            ready <= '1';
        end if;
    end process;
    convolve : process(ready)
    variable v : integer;
    begin
        if ready = '1' then
            for i in 1 to h-1 loop
                for j in 1 to w-1 loop
                    v := 0;
                    for ii in -1 to 1 loop
                        for jj in -1 to 1 loop
                            v := v + p((i+ii)*h + (j+jj)) * c((1+ii)*3 + (1+jj));
                        end loop;
                    end loop;
                    r((i-1)*(h-1) + (j-1)) <= v;
                end loop;
            end loop;
        end if;
    end process;
end architecture;