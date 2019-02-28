library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUmuxA is
	port(muxAsel: in std_logic; --wire to alu_src_A
	
		  muxAinp0: in signed(7 downto 0); -- wire to reg read 1
		  
		  muxAout: out signed(7 downto 0)); -- wire to alu_inpA
		  
end entity ALUmuxA;

architecture bhv of ALUmuxA is
	constant zero: signed:="00000000";
	
begin
	process(all)
	begin
		if(muxAsel='1') then
			muxAout <= zero;
		else
			muxAout <= muxAinp0;
		end if;
	end process;
end bhv;