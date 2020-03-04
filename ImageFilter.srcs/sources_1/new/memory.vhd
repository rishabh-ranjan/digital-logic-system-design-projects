library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- give fast rxclk to memory!!!
entity memory is
  port (
    clka : in std_logic;
    wea : in std_logic;
    addra : in integer;
    dina : in integer;
    clkb : in std_logic;
    enb : in std_logic;
    addrb : in integer;
    doutb : out integer;
    led : out std_logic_vector(15 downto 0)
  );
end memory;
-- check the memory size
architecture Behavioral of memory is
	type Memory_type is array (0 to 6553) of integer;
	signal Memory_array : Memory_type;
	signal address : integer;
begin
--    led(3 downto 0) <= std_logic_vector(to_unsigned(Memory_array(0), 4));
--    led(7 downto 4) <= std_logic_vector(to_unsigned(Memory_array(1), 4));
--    led(11 downto 8) <= std_logic_vector(to_unsigned(Memory_array(2), 4));
--    led(15 downto 12) <= std_logic_vector(to_unsigned(Memory_array(3), 4));
	process (clkb)
	begin
        if rising_edge(clkb) then    
            if (enb = '1') then
                address <= addrb;    
            end if;
        end if;
        --led(7 downto 0) <= std_logic_vector(to_unsigned(Memory_array(0), 8));
    end process;
	doutb <= Memory_array(address);
    
	process (clka)
	begin
		if rising_edge(clka) then
			if (wea = '1') then
				Memory_array (addra) <= dina;	
			end if;
		end if;
		--led(7 downto 0) <= std_logic_vector(to_unsigned(Memory_array(0), 8));
	end process;
end Behavioral;