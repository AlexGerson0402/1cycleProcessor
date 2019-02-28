library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- sequence seletector
-- top level integration
entity processor is
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
end;

architecture behavioral of processor is
--	signals and constants
	
	signal myclk: std_logic; -- port map regFile and dataRAM
	signal count: unsigned(4 downto 0);
	signal instADDR: unsigned(7 downto 0); -- instROM input
	
-- simply prefix "SIG" ahead of port name for signal names(except 3 signals above)
	signal SIGinst15_12: std_logic_vector(3 downto 0);
	signal SIGinst11_10: std_logic_vector(1 downto 0);
	signal SIGinst9_8  : std_logic_vector(1 downto 0);
	signal SIGinst7_6  : std_logic_vector(1 downto 0);
	signal SIGinst5_0  : std_logic_vector(5 downto 0);
	
-- control
	signal SIGmem_to_reg: std_logic;
	signal SIGram_w : std_logic;
	signal SIGalu_src_A : std_logic;
	signal SIGalu_src_B : std_logic;
	signal SIGreg_w : std_logic;
	
-- register file
	signal SIGreg_write: std_logic_vector(7 downto 0);
	signal SIGreg_read1: std_logic_vector(7 downto 0);
	signal SIGreg_read2: std_logic_vector(7 downto 0);
	
-- ALU
-- signal inst[15..12] function select for control and ALU already exist
	signal SIGinp_a : signed(7 downto 0);
	signal SIGinp_b : signed(7 downto 0);	  
	signal SIGout_alu: signed(7 downto 0);
-- set_alu directly wire to top level output: set

-- dataRAM
-- WE wire to: SIGram_w
-- ram_addr wire to: SIGout_alu
--	ram_write wire to: SIGreg_read2
   signal SIGram_read : std_logic_vector(7 downto 0);
	
	
--	must create signal to wire ports of to instantiated components
-- only wire ports directly when wiring entity pins to instantiated component
	
-- instantiate components
	component instROM
		port(inst_addr: in unsigned(7 downto 0);  -- 256 words, 8 bit addr
			  inst: out std_logic_vector(15 downto 0));
	end component;
	
	component control
		port(ctrl: in std_logic_vector(3 downto 0);
			  mem_to_reg, ram_w, alu_src_A, alu_src_B, reg_w: out std_logic);
	end component;
	
	component registerFile
		port(DEMOregA: out std_logic_vector(7 downto 0);
			  DEMOregB: out std_logic_vector(7 downto 0);
			  DEMOregC: out std_logic_vector(7 downto 0);
			  DEMOregD: out std_logic_vector(7 downto 0);
			  
			  clk, w: in std_logic;
			  read_location1: in std_logic_vector(1 downto 0); -- inst[11..10]
			  read_location2: in std_logic_vector(1 downto 0); -- inst[9..8]
			  write_location: in std_logic_vector(1 downto 0); -- inst[7..6]
		  
			  reg_write: in std_logic_vector(7 downto 0);  
		  
			  reg_read1: out std_logic_vector(7 downto 0); -- data of read reg1
			  reg_read2: out std_logic_vector(7 downto 0)); -- data of read reg2
	end component;
	
	component ALUmuxA 
	port(muxAsel: in std_logic; --wire to alu_src_A
	
		  muxAinp0: in signed(7 downto 0); -- wire to reg read 1
		  
		  muxAout: out signed(7 downto 0)); -- wire to alu_inpA	  
	end component;
	
	component ALUmuxB 
	port(muxBsel: in std_logic; --wire to alu_src_B
	
		  muxBinp0: in signed(7 downto 0); -- wire to reg read 2
		  
		  muxBinp1: in signed(5 downto 0); -- wire to inst[5..0]
		  
		  muxBout: out signed(7 downto 0)); -- wire to alu_inpB
	end component;
	
	component ALU
		port(inp_a   : in signed(7 downto 0);
			  inp_b   : in signed(7 downto 0);
			  func_sel: in STD_LOGIC_VECTOR (3 downto 0); -- function selection
			  out_alu : out signed(7 downto 0);
			  set_alu: out std_logic);
	end component;
	
	component dataRAM
		port(clk, we: in std_logic;
			  ram_addr: in std_logic_vector(7 downto 0);
			  ram_write: in std_logic_vector(7 downto 0);
			  ram_read: out std_logic_vector(7 downto 0));
	end component;
	
	component ramOUTmux 
	port(ramOUTsel: in std_logic; --wire to mem_to_reg
	
		  ramOUTinp1: in std_logic_vector(7 downto 0); -- wire to RAM_read
	
		  ramOUTinp0: in signed(7 downto 0); -- wire to out_alu
		  
		  ramOUTout: out std_logic_vector(7 downto 0)); -- wire to reg_write  
	end component;

	
begin
-- top level and sequence selector clk	
	myclk <= clk;

-- sequence selector process
	process(clk, rstb)
	begin
		if(rstb='0') then 
			instADDR(7 downto 0) <= (start_addr & "00000");
			count <= "00000";
			done <= '0';
		-- in simulation, turn off rstb only when starting a block of program
		-- otherwise, turn on rstb
		
		-- always turn on start after turn on rstb
		elsif(start='1') then 
			if(rising_edge(clk)) then
				if(count<inst_count) then
					instADDR <= instADDR+1;
					count <= count+1;
					done <='0';
				else
					done <= '1';
				end if;
			end if;
		end if;

	end process;

------------------------------------
-- design placement
------------------------------------
-- component pin => signal
-- component pin => entity pin
	DESIGN0: instROM
	port map(inst_addr => instADDR,
				inst(15 downto 12) => SIGinst15_12, -- function select for control and ALU
				inst(11 downto 10) => SIGinst11_10, -- read location 1
				inst(9  downto  8) => SIGinst9_8  , -- read location 2
				inst(7  downto  6) => SIGinst7_6  , -- write location 
				inst(5  downto  0) => SIGinst5_0);  -- immediate value and sign extend
				

	DESIGN1: control
	port map(ctrl => SIGinst15_12,
			   mem_to_reg => SIGmem_to_reg,
			   ram_w => SIGram_w,
				alu_src_A => SIGalu_src_A, 
				alu_src_B => SIGalu_src_B, 
				reg_w => SIGreg_w); 
				 
	DESIGN2: registerFile --clocked
	port map(DEMOregA => regA,
				DEMOregB => regB,
				DEMOregC => regC,
				DEMOregD => regD,
				
				clk => myclk,
				w => SIGreg_w,
				read_location1 => SIGinst11_10,
				read_location2 => SIGinst9_8,
				write_location => SIGinst7_6,
				
				reg_write => SIGreg_write,
				reg_read1 => SIGreg_read1,
				reg_read2 => SIGreg_read2);
				
	DESIGN3: ALUmuxA 
	port map(muxAsel => SIGalu_src_A, --wire to alu_src_A
	
				muxAinp0 => signed(SIGreg_read1), -- wire to reg read 1
		  
				muxAout => SIGinp_a); -- wire to alu inpA	  
	
	DESIGN4: ALUmuxB 
	port map(muxBsel => SIGalu_src_B, --wire to alu_src_B
	
				muxBinp0 => signed(SIGreg_read2), -- wire to reg read 2
		  
				muxBinp1 => signed(SIGinst5_0), -- wire to inst[5..0]
		  
				muxBout => SIGinp_b); -- wire to alu_inpB
				
	DESIGN5: ALU 
	port map(func_sel => SIGinst15_12, -- inst[15..12] function select for control and ALU
				inp_a => SIGinp_a,
			   inp_b => SIGinp_b,
			   out_alu => SIGout_alu,
			   set_alu => set -- set is top level port
				);
	
-- dataRAM
-- WE wire to: SIGram_w
-- ram_addr wire to: SIGout_alu
--	ram_write wire to: SIGreg_read2
	
	DESIGN6: dataRAM -- clocked
	port map(clk => myclk,
				we => SIGram_w,
				ram_addr => STD_LOGIC_VECTOR(SIGout_alu),
				ram_write => SIGreg_read2,
				ram_read => SIGram_read);
				
	DESIGN7: ramOUTmux 
	port map(ramOUTsel => SIGmem_to_reg, --wire to mem_to_reg
	
				ramOUTinp1 => SIGram_read, -- wire to RAM_read
	
				ramOUTinp0 => SIGout_alu, -- wire to out_alu
		  
				ramOUTout => SIGreg_write); -- wire to reg_write 
	
end architecture behavioral;
