library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instROM is
-- no clk
port(inst_addr: in unsigned(7 downto 0);  -- 256 words, 8 bit addr
	  inst: out std_logic_vector(15 downto 0)); -- 16 bit per word
end entity instROM;


architecture behavioral of instROM is
	-- ROM
	type rom_type is array (0 to 255) of std_logic_vector (15 downto 0);

	-- ROM content
	constant myROM: rom_type:=(
		0 => X"C010",
		1 => X"C04A",
		2 => X"5180",
		3 => X"02C0",
		4 => X"4640",
		5 => X"1D80",
		6 => X"5C00",
		7 => X"3180",
		8 => X"2E40",
		9 => X"6B00",
		10 => X"F000",
--		[11..63] => nop F000
		64 => X"C002",
		65 => X"C044",
		66 => X"C088",
		67 => X"C0CC",
		68 => X"9300",
		69 => X"9600",
		70 => X"9C00",
		71 => X"9900",
		72 => X"8000",
		73 => X"8440",
		74 => X"8880",
		75 => X"8CC0",
		76 => X"F000",
--		[77..159] => nop F000
		160 => X"C001",
		161 => X"C042",
		162 => X"4100",
		163 => X"C043",
		164 => X"4100",
		165 => X"C044",
		166 => X"4100",
		167 => X"C045",
		168 => X"4100",
		169 => X"C046",
		170 => X"4100",
		171 => X"C047",
		172 => X"4100",
--		[173..255] => nop F000
		others => X"F000"
		);

-- no signals
begin
	-- acync read, no clk
	inst <= myROM(to_integer(unsigned(inst_addr)));


end behavioral;
