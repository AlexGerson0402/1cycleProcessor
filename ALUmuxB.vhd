library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--sign extention included
entity ALUmuxB is
	port(muxBsel: in std_logic; --wire to alu_src_B
	
		  muxBinp0: in signed(7 downto 0); -- wire to reg read 2
		  
		  muxBinp1: in signed(5 downto 0); -- wire to inst[5..0]
		  
		  muxBout: out signed(7 downto 0)); -- wire to alu_inpB
		  
end entity ALUmuxB;

architecture bhv of ALUmuxB is
	constant ext0: signed:="00";
	constant ext1: signed:="11";
	
begin
	process(all)
	begin
		if(muxBsel='0') then
			muxBout <= muxBinp0;
			
		-- sign extend below
		else
			if(muxBinp1(5)='0') then
				muxBout <= (ext0 & muxBinp1);
			else
				muxBout <= (ext1 & muxBinp1);
			end if;
		end if;
	end process;
end bhv;