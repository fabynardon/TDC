library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;

library unisim;
use unisim.vcomponents.all;

entity tdc is
	generic(
		stages	: integer := 64;
		Xoff		: integer := 8;
		Yoff		: integer := 24);
	port(
		stop		: in std_logic;
		fine		: out std_logic_vector(stages - 1 downto 0);
		coarse	: out std_logic_vector(3 downto 0);
		clock		: in std_logic;
		reset		: in std_logic);
	
	attribute loc : string;
	attribute async_reg : string;
	attribute keep_hierarchy : string;
	attribute dont_touch : string;
	attribute keep : string;
	attribute S: string;

	attribute loc of clock : signal is "H16";
	
end tdc;

architecture behavioral of tdc is
		
	component dfs
		port (
			CLK_IN1	: in     std_logic;
			CLK_OUT1 : out    std_logic;
			RESET    : in     std_logic
			);
		end component;

	type carry_type is array (natural range<>) of std_logic_vector(3 downto 0);
	
	signal carrys	:	carry_type(stages downto 0);
	--attribute S of carrys : signal is "true"; 
	
	signal unreg   :   std_logic_vector(stages - 1 downto 0);
	attribute S of unreg : signal is "true";
	
	signal reg     :   std_logic_vector(stages - 1 downto 0);
	
	signal sys_clk	:	std_logic;

	signal D_cont: std_logic_vector(3 downto 0);
	signal Q_cont: std_logic_vector(3 downto 0);
	signal And_cont: std_logic_vector(4 downto 0);
	
	signal counter : std_logic_vector(3 downto 0);
	attribute S of counter : signal is "true";
		
begin
	
	dfs_inst : dfs
		port map (
			CLK_IN1 => clock,
			CLK_OUT1 => sys_clk,
			RESET  => reset
			);
	 
	--carr_delay_line : for i in 0 to stages - 1 generate
	carr_delay_line : for i in 0 to stages/4 - 1 generate
	
		first_delay_block : if i = 0 generate
			attribute loc of delay_block : label is "SLICE_X"&INTEGER'image(Xoff)&"Y"&integer'image(Yoff+i);
		begin	

			delay_block: carry4 
				port map (
					--co 		=> carrys(0),
					co			=> unreg(3 downto 0),
					ci 		=> '0',
					cyinit	=> sys_clk,
					di 		=> "0000",
					s 			=> "1111");
					
		--unreg(i) <= carrys(i)(0);
			
		end generate;
		
		next_delay_block : if i > 0 generate
			attribute loc of delay_block : label is "SLICE_X"&INTEGER'image(Xoff)&"Y"&integer'image(Yoff+i);
			--attribute dont_touch of delay_block : label is "true";
		begin		
		
			delay_block: carry4 
				port map(
					--co		=> carrys(i),
					co			=> unreg(4*(i+1)-1 DOWNTO 4*i),
					--ci			=> carrys(i-1)(3),
					ci			=> unreg(4*i-1),
					cyinit	=> '0',
					di 		=> "0000",
					s 			=> "1111");
				
			--unreg(i) <= carrys(i)(3);
		end generate;
		
	end generate;
		   
	latch : for j in 0 to stages - 1 generate
		ATTRIBUTE LOC OF fdc0_inst : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+integer(floor(real(j/4))));
		ATTRIBUTE LOC OF fdc1_inst : LABEL IS "SLICE_X"&INTEGER'image(Xoff+1)&"Y"&INTEGER'image(Yoff+integer(floor(real(j/4))));
	begin
		
		fdc0_inst: fdc
			generic map(
				init 	=> '0')
			port map(
				c 		=> stop,
				clr	=> reset,
				d 		=> unreg(j),
				q 		=> reg(j));
		
		fdc1_inst: fdc
			generic map(
				init 	=> '0')
			port map(
				c 		=> stop,
				clr	=> reset,
				d 		=> reg(j),
				q 		=> fine(j));
		
   end generate;
	
	latch2: for k in 0 to 3 generate
		ATTRIBUTE LOC OF fdc_inst : LABEL IS "SLICE_X"&INTEGER'image(7)&"Y"&INTEGER'image(23);
	begin
	
		fdc_inst: fdc
			generic map(
				init 	=> '0')
			port map(
				c 		=> stop,
				clr	=> reset,
				d 		=> counter(k),
				q 		=> coarse(k));
				
	end generate;
	
	contador:for i in 0 to 3 generate
		ATTRIBUTE LOC OF fdc_inst : LABEL IS "SLICE_X"&INTEGER'image(6)&"Y"&INTEGER'image(23);
	begin
		fdc_inst: fdc
			port map(
				c => sys_clk,
				clr => reset,
				d => D_cont(i),
				q => Q_cont(i)
			);
			
	And_cont(i+1) <= And_cont(i) and Q_cont(i);
	D_cont(i) <= Q_cont(i) xor And_cont(i);
		
	end generate;
	
	And_cont(0) <= '1';
	counter <= Q_cont;
	
end behavioral;
