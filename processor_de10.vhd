library ieee;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;


entity processor_de10 is
	 
	PORT(SW: in std_logic_vector(9 downto 0); 
	   --SW rstb: 3, start_addr: 2-0 
		--SW inst_count: 9-5
		--SW output_sel: 4
		
		  KEY: in std_logic_vector(1 downto 0);--start
		  
		  CLOCK_50: in std_logic;	
		
		  -- set: 0 or 1
		  HEX5: out std_logic_vector(6 downto 0);
		  
		  -- hex3-2: B if output_sel=0, D if output_sel=1
		  HEX3: out std_logic_vector(6 downto 0); 
		  HEX2: out std_logic_vector(6 downto 0);  

		  -- hex1-0: A if output_sel=0, C if output_sel=1
		  HEX1: out std_logic_vector(6 downto 0);  
		  HEX0: out std_logic_vector(6 downto 0); 
		  
 		  LEDR: out std_logic_vector(9 downto 0)); -- done
end entity;

architecture de10 of processor_de10 is

	signal clock1Hz: std_logic;
	signal SIGoutput_select: std_logic; -- 0 Reg AB, 1 Reg CD
	signal SIGdone: std_logic;
	signal SIGregA: std_logic_vector(7 downto 0);
	signal SIGregB: std_logic_vector(7 downto 0);
	signal SIGregC: std_logic_vector(7 downto 0);
	signal SIGregD: std_logic_vector(7 downto 0);
	signal SIGset : std_logic;
	
	-- output constant
	constant h0: std_logic_vector:="1000000";
	constant h1: std_logic_vector:="1111001";
	constant h2: std_logic_vector:="0100100";
	constant h3: std_logic_vector:="0110000";
	constant h4: std_logic_vector:="0011001";
	constant h5: std_logic_vector:="0010010";
	constant h6: std_logic_vector:="0000010";
	constant h7: std_logic_vector:="1111000";
	constant h8: std_logic_vector:="0000000";
	constant h9: std_logic_vector:="0010000";
	constant  A: std_logic_vector:="0001000";
	constant  B: std_logic_vector:="0000011";
	constant  C: std_logic_vector:="1000110";
	constant  D: std_logic_vector:="1011110";
	constant  E: std_logic_vector:="0000110";
	constant  F: std_logic_vector:="0001110";
	

	COMPONENT processor
		port(clk, rstb, start: in std_logic;
		  start_addr: in unsigned(2 downto 0);
		  inst_count: in unsigned(4 downto 0);
		  output_select:in std_logic; -- 0 Reg AB, 1 Reg CD
		  
		  done: out std_logic;
		  regA: out std_logic_vector(7 downto 0);
		  regB: out std_logic_vector(7 downto 0);
		  regC: out std_logic_vector(7 downto 0);
		  regD: out std_logic_vector(7 downto 0);
		  set : out std_logic);
	end component;
	
	COMPONENT clk_1Hz
		PORT(CLK_50MHZ, rstb : IN STD_LOGIC;
			  CLK_1HZ: OUT STD_LOGIC);
	END COMPONENT;
	
	
	
	begin
	
	SIGoutput_select <= SW(4);
	
-- 7 seg display	
	process(all)
	begin
		if(SIGset='1') then
			HEX5<=h1;
		else
			HEX5<=h0;
		end if;
		
		if(SIGdone='1') then
			LEDR(9 DOWNTO 0)<="1111111111";
		else
			LEDR(9 downto 0)<="0000000000";
		end if;
		
		if(SIGoutput_select='0') then -- 0 Reg AB
			case unsigned(SIGregA(7 downto 4)) is -- out_sel=0 regA(1)
			when to_unsigned(0, 4) =>
				HEX1 <= h0; 
			when to_unsigned(1, 4) =>
				HEX1 <= h1; 
			when to_unsigned(2, 4) =>
				HEX1 <= h2; 
			when to_unsigned(3, 4) =>
				HEX1 <= h3; 
			when to_unsigned(4, 4) =>
				HEX1 <= h4; 
			when to_unsigned(5, 4) =>
				HEX1 <= h5; 
			when to_unsigned(6, 4) =>
				HEX1 <= h6;
			when to_unsigned(7, 4) =>
				HEX1 <= h7; 
			when to_unsigned(8, 4) =>
				HEX1 <= h8; 
			when to_unsigned(9, 4) =>
				HEX1 <= h9; 
			when to_unsigned(10, 4) =>
				HEX1 <= A; 
			when to_unsigned(11, 4) =>
				HEX1 <= B; 
			when to_unsigned(12, 4) =>
				HEX1 <= C;	
			when to_unsigned(13, 4) =>
				HEX1 <= D; 
			when to_unsigned(14, 4) =>
				HEX1 <= E; 
			when to_unsigned(15, 4) =>
				HEX1 <= F;
			when others =>
				HEX1 <= "1111111";
			end case;
			
			case unsigned(SIGregA(3 downto 0)) is -- out_sel=0 regA(0)
			when to_unsigned(0, 4) =>
				HEX0 <= h0; 
			when to_unsigned(1, 4) =>
				HEX0 <= h1; 
			when to_unsigned(2, 4) =>
				HEX0 <= h2; 
			when to_unsigned(3, 4) =>
				HEX0 <= h3; 
			when to_unsigned(4, 4) =>
				HEX0 <= h4; 
			when to_unsigned(5, 4) =>
				HEX0 <= h5; 
			when to_unsigned(6, 4) =>
				HEX0 <= h6;
			when to_unsigned(7, 4) =>
				HEX0 <= h7; 
			when to_unsigned(8, 4) =>
				HEX0 <= h8; 
			when to_unsigned(9, 4) =>
				HEX0 <= h9; 
			when to_unsigned(10, 4) =>
				HEX0 <= A; 
			when to_unsigned(11, 4) =>
				HEX0 <= B; 
			when to_unsigned(12, 4) =>
				HEX0 <= C;	
			when to_unsigned(13, 4) =>
				HEX0 <= D; 
			when to_unsigned(14, 4) =>
				HEX0 <= E; 
			when to_unsigned(15, 4) =>
				HEX0 <= F;
			when others =>
				HEX0 <= "1111111";
			end case;
			
			case unsigned(SIGregB(7 downto 4)) is -- out_sel=0 regB(3)
			when to_unsigned(0, 4) =>
				HEX3 <= h0; 
			when to_unsigned(1, 4) =>
				HEX3 <= h1; 
			when to_unsigned(2, 4) =>
				HEX3 <= h2; 
			when to_unsigned(3, 4) =>
				HEX3 <= h3; 
			when to_unsigned(4, 4) =>
				HEX3 <= h4; 
			when to_unsigned(5, 4) =>
				HEX3 <= h5; 
			when to_unsigned(6, 4) =>
				HEX3 <= h6;
			when to_unsigned(7, 4) =>
				HEX3 <= h7; 
			when to_unsigned(8, 4) =>
				HEX3 <= h8; 
			when to_unsigned(9, 4) =>
				HEX3 <= h9; 
			when to_unsigned(10, 4) =>
				HEX3 <= A; 
			when to_unsigned(11, 4) =>
				HEX3 <= B; 
			when to_unsigned(12, 4) =>
				HEX3 <= C;	
			when to_unsigned(13, 4) =>
				HEX3 <= D; 
			when to_unsigned(14, 4) =>
				HEX3 <= E; 
			when to_unsigned(15, 4) =>
				HEX3 <= F;
			when others =>
				HEX3 <= "1111111";
			end case;
			
			case unsigned(SIGregB(3 downto 0)) is -- out_sel=0 regB(2)
			when to_unsigned(0, 4) =>
				HEX2 <= h0; 
			when to_unsigned(1, 4) =>
				HEX2 <= h1; 
			when to_unsigned(2, 4) =>
				HEX2 <= h2; 
			when to_unsigned(3, 4) =>
				HEX2 <= h3; 
			when to_unsigned(4, 4) =>
				HEX2 <= h4; 
			when to_unsigned(5, 4) =>
				HEX2 <= h5; 
			when to_unsigned(6, 4) =>
				HEX2 <= h6;
			when to_unsigned(7, 4) =>
				HEX2 <= h7; 
			when to_unsigned(8, 4) =>
				HEX2 <= h8; 
			when to_unsigned(9, 4) =>
				HEX2 <= h9; 
			when to_unsigned(10, 4) =>
				HEX2 <= A; 
			when to_unsigned(11, 4) =>
				HEX2 <= B; 
			when to_unsigned(12, 4) =>
				HEX2 <= C;	
			when to_unsigned(13, 4) =>
				HEX2 <= D; 
			when to_unsigned(14, 4) =>
				HEX2 <= E; 
			when to_unsigned(15, 4) =>
				HEX2 <= F;
			when others =>
				HEX2 <= "1111111";
			end case;
			
		-- out_sel = 1 Reg CD
		-- regC-hex[1..0] regD-hex[3..2]
		else 
			case unsigned(SIGregC(7 downto 4)) is -- out_sel=1 regC(1)
			when to_unsigned(0, 4) =>
				HEX1 <= h0; 
			when to_unsigned(1, 4) =>
				HEX1 <= h1; 
			when to_unsigned(2, 4) =>
				HEX1 <= h2; 
			when to_unsigned(3, 4) =>
				HEX1 <= h3; 
			when to_unsigned(4, 4) =>
				HEX1 <= h4; 
			when to_unsigned(5, 4) =>
				HEX1 <= h5; 
			when to_unsigned(6, 4) =>
				HEX1 <= h6;
			when to_unsigned(7, 4) =>
				HEX1 <= h7; 
			when to_unsigned(8, 4) =>
				HEX1 <= h8; 
			when to_unsigned(9, 4) =>
				HEX1 <= h9; 
			when to_unsigned(10, 4) =>
				HEX1 <= A; 
			when to_unsigned(11, 4) =>
				HEX1 <= B; 
			when to_unsigned(12, 4) =>
				HEX1 <= C;	
			when to_unsigned(13, 4) =>
				HEX1 <= D; 
			when to_unsigned(14, 4) =>
				HEX1 <= E; 
			when to_unsigned(15, 4) =>
				HEX1 <= F;
			when others =>
				HEX1 <= "1111111";
			end case;
			
			case unsigned(SIGregC(3 downto 0)) is -- out_sel=1 regC(0)
			when to_unsigned(0, 4) =>
				HEX0 <= h0; 
			when to_unsigned(1, 4) =>
				HEX0 <= h1; 
			when to_unsigned(2, 4) =>
				HEX0 <= h2; 
			when to_unsigned(3, 4) =>
				HEX0 <= h3; 
			when to_unsigned(4, 4) =>
				HEX0 <= h4; 
			when to_unsigned(5, 4) =>
				HEX0 <= h5; 
			when to_unsigned(6, 4) =>
				HEX0 <= h6;
			when to_unsigned(7, 4) =>
				HEX0 <= h7; 
			when to_unsigned(8, 4) =>
				HEX0 <= h8; 
			when to_unsigned(9, 4) =>
				HEX0 <= h9; 
			when to_unsigned(10, 4) =>
				HEX0 <= A; 
			when to_unsigned(11, 4) =>
				HEX0 <= B; 
			when to_unsigned(12, 4) =>
				HEX0 <= C;	
			when to_unsigned(13, 4) =>
				HEX0 <= D; 
			when to_unsigned(14, 4) =>
				HEX0 <= E; 
			when to_unsigned(15, 4) =>
				HEX0 <= F;
			when others =>
				HEX0 <= "1111111";
			end case;
			
			case unsigned(SIGregD(7 downto 4)) is -- out_sel=1 regD(3)
			when to_unsigned(0, 4) =>
				HEX3 <= h0; 
			when to_unsigned(1, 4) =>
				HEX3 <= h1; 
			when to_unsigned(2, 4) =>
				HEX3 <= h2; 
			when to_unsigned(3, 4) =>
				HEX3 <= h3; 
			when to_unsigned(4, 4) =>
				HEX3 <= h4; 
			when to_unsigned(5, 4) =>
				HEX3 <= h5; 
			when to_unsigned(6, 4) =>
				HEX3 <= h6;
			when to_unsigned(7, 4) =>
				HEX3 <= h7; 
			when to_unsigned(8, 4) =>
				HEX3 <= h8; 
			when to_unsigned(9, 4) =>
				HEX3 <= h9; 
			when to_unsigned(10, 4) =>
				HEX3 <= A; 
			when to_unsigned(11, 4) =>
				HEX3 <= B; 
			when to_unsigned(12, 4) =>
				HEX3 <= C;	
			when to_unsigned(13, 4) =>
				HEX3 <= D; 
			when to_unsigned(14, 4) =>
				HEX3 <= E; 
			when to_unsigned(15, 4) =>
				HEX3 <= F;
			when others =>
				HEX3 <= "1111111";
			end case;
			
			case unsigned(SIGregD(3 downto 0)) is -- out_sel=1 regD(2)
			when to_unsigned(0, 4) =>
				HEX2 <= h0; 
			when to_unsigned(1, 4) =>
				HEX2 <= h1; 
			when to_unsigned(2, 4) =>
				HEX2 <= h2; 
			when to_unsigned(3, 4) =>
				HEX2 <= h3; 
			when to_unsigned(4, 4) =>
				HEX2 <= h4; 
			when to_unsigned(5, 4) =>
				HEX2 <= h5; 
			when to_unsigned(6, 4) =>
				HEX2 <= h6;
			when to_unsigned(7, 4) =>
				HEX2 <= h7; 
			when to_unsigned(8, 4) =>
				HEX2 <= h8; 
			when to_unsigned(9, 4) =>
				HEX2 <= h9; 
			when to_unsigned(10, 4) =>
				HEX2 <= A; 
			when to_unsigned(11, 4) =>
				HEX2 <= B; 
			when to_unsigned(12, 4) =>
				HEX2 <= C;	
			when to_unsigned(13, 4) =>
				HEX2 <= D; 
			when to_unsigned(14, 4) =>
				HEX2 <= E; 
			when to_unsigned(15, 4) =>
				HEX2 <= F;
			when others =>
				HEX2 <= "1111111";
			end case;
		end if;
		
	end process;
		
------------------------------------
--Design placement
------------------------------------
	DESIGN: processor
	port map(rstb => SW(3),
				start_addr => unsigned(SW(2 DOWNTO 0)),
				inst_count => unsigned(SW(9 downto 5)),
				clk => clock1Hz,
				start => KEY(0),
				output_select => SIGoutput_select,
				done => SIGdone,
				set => SIGset,
				regA => SIGregA,
				regB => SIGregB,
				regC => SIGregC,
				regD => SIGregD); 
				
	clk_divider: clk_1Hz
	port map(CLK_50MHZ => CLOCK_50,
				CLK_1HZ => clock1Hz,
				rstb => SW(3));
				
end architecture de10;