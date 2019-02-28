library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dataRAM is
	port(clk, we: in std_logic;
		  ram_addr: in std_logic_vector(7 downto 0);
		  ram_write: in std_logic_vector(7 downto 0);
		  ram_read: out std_logic_vector(7 downto 0));
end;

architecture behavioral of dataRAM is
	
	-- create type
	type ram_type is array (0 to 255) of std_logic_vector (7 downto 0);
	
	-- create memory
	signal myRAM: ram_type;
	
	begin

	-- sync write process with clk
	process (clk)
	begin
	if (rising_edge(clk)) then
		if(we ='1') then
			myRAM(to_integer(unsigned(ram_addr))) <= ram_write;
		end if;
	end if;
	end process;

	-- acync read, no clk
	ram_read <= myRAM(to_integer(unsigned(ram_addr)));
end behavioral;