library ieee;
use ieee.std_logic_1164.all;

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
use ieee.numeric_std.all;
USE ieee.math_real.ALL;
-- uncomment the following library declaration if instantiating
-- any xilinx leaf cells in this code.
library unisim;
use unisim.vcomponents.all;

--library SIMPRIM;
--use SIMPRIM.VCOMPONENTS.ALL;
--use SIMPRIM.VPACKAGE.ALL;

entity tdc is
	generic (
				stages	: integer := 4;
				Xoff			: integer := 8;
				Yoff			: integer := 24);
	port (	stop			: in std_logic;
				salida		: out std_logic_vector(stages - 1 downto 0);
				clock		: in std_logic;
				reset		: in std_logic);
end tdc;

architecture behavioral of tdc is
	
	attribute loc : string;
	attribute async_reg : string;
--	attribute keep_hierarchy : string;
--	attribute dont_touch : string;
--	
--	attribute keep_hierarchy of behavioral : architecture is "true";
--	attribute dont_touch of behavioral : architecture is "true";
	
	type carry_type is array (natural range<>) of std_logic_vector(3 downto 0);
	
	signal carrys	:	carry_type(stages - 1 downto 0);
		 
	--signal unreg    :   std_logic_vector(stages - 1 downto 0);
	signal unreg    :   std_logic_vector(0 to stages - 1);
	--signal reg      :   std_logic_vector(stages - 1 downto 0);
	signal reg    :   std_logic_vector(0 to stages - 1);
	
	attribute async_reg of unreg : signal is "true";
	attribute async_reg of reg : signal is "true";

begin

	carr_delay_line : for i in 0 to stages - 1 generate
	--carr_delay_line : for i in 0 to stages/4 - 1 generate
	
		first_delay_block : if i = 0 generate
			attribute loc of delay_block : label is "SLICE_X"&INTEGER'image(Xoff)&"Y"&integer'image(Yoff+i);
			--attribute dont_touch of delay_block : label is "true";
		begin	

			delay_block: carry4 
				port map(
					co 		=> carrys(0),
					--co			=> unreg(3 downto 0),
					ci 		=> '0',
					cyinit	=> clock,
					di 		=> "0000",
					s 			=> "1111");
					
			unreg(i) <= carrys(i)(2);
			
		end generate;
		
		next_delay_block : if i > 0 generate
			attribute loc of delay_block : label is "SLICE_X"&INTEGER'image(Xoff)&"Y"&integer'image(Yoff+i);
			--attribute dont_touch of delay_block : label is "true";
		begin		
		
			delay_block: carry4 
				port map(
					co		=> carrys(i),
					--co			=> unreg(4*(i+1)-1 DOWNTO 4*i),
					ci			=> carrys(i-1)(3),
					--ci			=> unreg(4*i-1),
					cyinit	=> '0',
					di 		=> "0000",
					s 			=> "1111");
				
			unreg(i) <= carrys(i)(3);
		end generate;
		
	end generate;
		   
	latch : for j in 0 to stages - 1 generate
		--attribute dont_touch of fdr_inst : label is "true";
		ATTRIBUTE LOC OF fdc0_inst : LABEL IS "SLICE_X"&INTEGER'image(Xoff)&"Y"&INTEGER'image(Yoff+integer(floor(real(j/4))));
		ATTRIBUTE LOC OF fdc1_inst : LABEL IS "SLICE_X"&INTEGER'image(Xoff+1)&"Y"&INTEGER'image(Yoff+integer(floor(real(j/4))));
	begin
		
		fdc0_inst: fdc
			generic map(
				init 	=> '1')
			port map(
				c 		=> stop,
				clr	=> reset,
				d 		=> unreg(j),
				q 		=> reg(j));
		
		fdc1_inst: fdc
			generic map(
				init 	=> '1')
			port map(
				c 		=> stop,
				clr	=> reset,
				d 		=> reg(j),
				q 		=> salida(j));
		
   end generate;
	    
end behavioral;
