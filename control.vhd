library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port(ctrl: in std_logic_vector(3 downto 0);
		  mem_to_reg, ram_w, alu_src_A, alu_src_B, reg_w: out std_logic);
end entity control;

architecture dataflow of control is

begin
	process(all)
	begin
		if(ctrl="1000") then -- 1 only for LD
			mem_to_reg <= '1';
		else
			mem_to_reg <= '0';
		end if;
		
		--turn off reg_w and ram_w when SLT comes in
		if(ctrl="1001") then -- 1 only for ST 
			ram_w <='1';
		else
			ram_w <='0'; -- 6-SLT included here
		end if;
		
		if(ctrl="1100") then -- 1 only for LDI 
			alu_src_A <='1';
		else
			alu_src_A <='0';
		end if;
		
		if(ctrl="1000" or ctrl="1001" or ctrl="1100") then -- 1 for LD, ST and LDI  
			alu_src_B <='1';
		else
			alu_src_B <='0';
		end if;
		
		-- turn off reg_w and ram_w when SLT comes in
		-- Enable writing to the Register File
		-- 0 for ST
		if(ctrl="1001" or ctrl="0110" or ctrl="1111") then 
			reg_w <='0';
		else
			reg_w <='1';
		end if;
		
	end process;
end dataflow;