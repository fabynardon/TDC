library ieee;
use ieee.std_logic_1164.all;

entity tdc_cell is
	generic(
		delay : time := 1 ns);
		port(
		clk_in		:	in		std_logic;
		clk_out	:	out	std_logic := '0';
		stop			:	in		std_logic;
		Q				:	out	std_logic := '0');
end tdc_cell;

architecture tdc_cell_arq of tdc_cell is

	signal D : std_logic;
begin

	D <= clk_in after delay;
	
	process(stop)
	begin
		if rising_edge(stop) then
			Q <= D;
		end if;
	end process;
	
	clk_out <= D;
	
end tdc_cell_arq;
