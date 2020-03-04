library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory is
  port (
    clka : in std_logic;
    wea : in std_logic;
    addra : in std_logic_vector (7 downto 0);
    dina : in std_logic_vector (7 downto 0);
    clkb : in std_logic;
    enb : in std_logic;
    addrb : in std_logic_vector (7 downto 0);
    doutb : out std_logic_vector (7 downto 0);
    led : out std_logic_vector (15 downto 0)
  );
end memory;

architecture Behavioral of memory is
	type Memory_type is array (0 to 255) of std_logic_vector (7 downto 0);
	signal Memory_array : Memory_type;
	signal address : unsigned (7 downto 0);
begin
	process (clkb)
	begin
        if rising_edge(clkb) then    
            if (enb = '1') then
                address <= unsigned(addrb);    
            end if;
        end if;
    end process;
	doutb <= Memory_array (to_integer(address));
	led(15 downto 8) <= Memory_array (to_integer(address));

	process (clka)
	begin
		if rising_edge(clka) then
			if (wea = '1') then
				Memory_array (to_integer(unsigned(addra))) <= dina (7 downto 0);	
			end if;
		end if;
	end process;
end Behavioral;