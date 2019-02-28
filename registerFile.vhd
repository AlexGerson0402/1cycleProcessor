library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 4 registers with 2 read port and 1 write port
-- 8 bit per register
entity registerFile is
	port(DEMOregA: out std_logic_vector(7 downto 0);
		  DEMOregB: out std_logic_vector(7 downto 0);
		  DEMOregC: out std_logic_vector(7 downto 0);
		  DEMOregD: out std_logic_vector(7 downto 0);
		  clk, w: in std_logic;
		  read_location1: in std_logic_vector(1 downto 0); -- reg location inst[11..10]
		  read_location2: in std_logic_vector(1 downto 0); -- reg location inst[9..8]
		  write_location: in std_logic_vector(1 downto 0); -- reg location inst[7..6]
		  
		  reg_write: in std_logic_vector(7 downto 0);
		  
		  reg_read1: out std_logic_vector(7 downto 0); -- data of read reg1
		  reg_read2: out std_logic_vector(7 downto 0)); -- data of read reg2
end;

architecture behavioral of registerFile is
	
	-- create type
	type reg_type is array (0 to 3) of std_logic_vector (7 downto 0); -- 0..3 A..D
	
	-- create register file
	signal myREG: reg_type;
	
begin
	
	DEMOregA <= myREG(0);
	DEMOregB <= myREG(1);
	DEMOregC <= myREG(2);
	DEMOregD <= myREG(3);
	
	-- SRAM write process
	process (clk)
	begin
	if (rising_edge(clk)) then
		if(w ='1') then
			myREG(to_integer(unsigned(write_location))) <= reg_write;
		end if;
	end if;
	end process;

	-- acync read, no clk
	reg_read1 <= myREG(to_integer(unsigned(read_location1)));
	reg_read2 <= myREG(to_integer(unsigned(read_location2)));
	
end behavioral;