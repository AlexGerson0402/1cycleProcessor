library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ramOUTmux is
	port(ramOUTsel: in std_logic; --wire to mem_to_reg
	
		  ramOUTinp1: in std_logic_vector(7 downto 0); -- wire to RAM_read
	
		  ramOUTinp0: in signed(7 downto 0); -- wire to out_alu
		  
		  ramOUTout: out std_logic_vector(7 downto 0)); -- wire to reg_write
		  
end entity ramOUTmux;

architecture bhv of ramOUTmux is
	
begin
	process(all)
	begin
		if(ramOUTsel='1') then
			ramOUTout <= ramOUTinp1;
		else
			ramOUTout <= std_logic_vector(ramOUTinp0);
		end if;
	end process;
end bhv;