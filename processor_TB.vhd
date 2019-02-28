library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor_TB is
end entity;

architecture testbench of processor_TB is
	signal CLK: std_logic;
	signal RSTB: std_logic;
	signal START: std_logic;
	signal START_ADDR: unsigned(2 downto 0);
	signal INST_COUNT:  unsigned(4 downto 0);
	signal OUTPUT_SELECT: std_logic; -- not used in simulation 0 Reg AB, 1 Reg CD
		  
	signal DONE:  std_logic;
	signal REGA:  std_logic_vector(7 downto 0);
	signal REGB:  std_logic_vector(7 downto 0);
	signal REGC:  std_logic_vector(7 downto 0);
	signal REGD:  std_logic_vector(7 downto 0);
	signal SET :  std_logic;
	
	component processor   
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
	
	-- output constant
	
	
begin
------------------------------------
-- Device under test (DUT)
------------------------------------
DUT: processor
	
	port map(clk => CLK,
				rstb => RSTB,
				start => START,
				start_addr => START_ADDR,
				inst_count => INST_COUNT,
				output_select => OUTPUT_SELECT, -- not used in simulation
				
				done => DONE,
				regA => REGA,
				regB => REGB,
				regC => REGC,
				regD => REGD,
				set => SET);
				
------------------------------------
-- Test Processes
------------------------------------

clock: process -- note - no sensitivity list allowed
begin
	CLK <= '1';
	wait for 1 ns;
	infinite: loop
		CLK <= not CLK; wait for 1 ns;
	end loop;
end process;

-- rstb = 0 to start every program, 
-- followed by rstb = 1, start = 1 and start_addr

-- tosigned(decimal_number, num_of_bits)
reset: process 
begin
	OUTPUT_SELECT <= '0'; -- not used in simulation
	RSTB <= '0'; 
	wait for 4 ns;
	
	START_ADDR <= "000";
	INST_COUNT <= to_unsigned(11, 5);
	wait for 4 ns;
	
	RSTB <= '1';
	wait for 4 ns;
	
	START <='1'; 
	wait for 30 ns;
	
-- pogram 2
	RSTB <= '0'; 
	wait for 4 ns;
	
	START_ADDR <= "010";
	INST_COUNT <= to_unsigned(13, 5);
	wait for 4 ns;
	
	RSTB <= '1';
	wait for 4 ns;
	
	START <='1'; 
	wait for 34 ns;

-- program 3	
	RSTB <= '0'; 
	wait for 4 ns;
	
	START_ADDR <= "101";
	INST_COUNT <= to_unsigned(14, 5);
	wait for 4 ns;
	
	RSTB <= '1';
	wait for 4 ns;
	
	START <='1'; 
	wait for 34 ns;
	
	wait;
	
end process reset;

------------------------------------------
-- End test processes
------------------------------------------

end architecture;