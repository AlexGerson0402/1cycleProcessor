library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity alu is
 Port ( inp_a   : in signed(7 downto 0);
		  inp_b   : in signed(7 downto 0);
		  func_sel: in STD_LOGIC_VECTOR (3 downto 0); -- function selection
		  out_alu : out signed(7 downto 0);
		  set_alu: out std_logic);
end alu;
 
architecture Behavioral of alu is

begin

	process(inp_a, inp_b, func_sel) 
	begin
		case func_sel is
			when "0000" => 
				out_alu<= inp_a or inp_b; -- 0 or
				set_alu<= '0'; 
			when "0001" => 
				out_alu<= inp_a and inp_b; -- 1 and 
				set_alu<= '0';
			when "0010" => 
				out_alu<= inp_a nor inp_b;  -- 2 nor
				set_alu<= '0';
			when "0011" => 
				out_alu<= inp_a nand inp_b; 	-- 3 nand
				set_alu<= '0';
			when "0100" => 
				out_alu<= inp_a + inp_b; -- 4 add
				set_alu<= '0';
			when "0101" => 
				out_alu<= inp_a - inp_b; -- 5 sub
				set_alu<= '0';
			when "0110" => 
				if(inp_a < inp_b) then 
					set_alu<= '1'; -- 6 SLT set on less than
					out_alu<="00000000";
				else
					set_alu<= '0';
					out_alu<="00000000";
				end if;
			when "1111" => 
				set_alu<= '0';
				out_alu<="00000000"; -- F NOP 
				
			-- ld, st and ldi use add
			when "1000" => 
				out_alu<= inp_a + inp_b; -- 8 ld
				set_alu<= '0';
			when "1001" => 
				out_alu<= inp_a + inp_b; -- 9 st
				set_alu<= '0';
			when "1100" => 
				out_alu<= inp_a + inp_b; -- C ldi
				set_alu<= '0';
				
			when others =>
				set_alu<= '0';
				out_alu<="00000000"; 
		end case; 
  
	end process; 
 
end Behavioral;