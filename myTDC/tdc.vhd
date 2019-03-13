LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tdc IS
END tdc;

ARCHITECTURE arq OF tdc IS

	SIGNAL	clk				:	std_logic := '1';
	SIGNAL	hit				:	std_logic := '0';
	
	SIGNAL 	q					:	std_logic_vector(0 to 9) := (others => '0');
	SIGNAL 	conexiones	:	std_logic_vector(0 to 9) := (others => '0');
	
	SIGNAl	count			:	unsigned(9 downto 0)  := (others => '0');
	
	SIGNAL Thit			:	time;
	SIGNAL Tstop			:	time := 0 ns;
	
BEGIN

	delay_line: FOR i IN 0 TO 9 GENERATE
	
		first_cell: IF i = 0 GENERATE
		
			conexiones(i) <= clk after 1 ns;

		END GENERATE;
		
		next_cell: IF i > 0 GENERATE
		
			conexiones(i) <= conexiones(i-1) after 1 ns;
		
		END GENERATE;
				
	END GENERATE;
		
	clk <= not clk after 10 ns;
	
	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
				count <= count + 1;
		END IF;
	END PROCESS;
	
	PROCESS
	BEGIN
		wait for 32 ns;
		--start <= '1';
		hit <= '1';
		wait for 71 ns;
		--stop <= '1';
		hit <= '0';
		wait for 232 ns;
		
		hit <= '1';
		wait;
	END PROCESS;
	
	PROCESS(hit)
		VARIABLE aux : time;
	BEGIN
		CASE conexiones IS
			WHEN "0000000000" => aux := 0 ns;
			WHEN "0000000001" => aux := 19 ns;
			WHEN "0000000011" => aux := 18 ns;
			WHEN "0000000111" => aux := 17 ns;
			WHEN "0000001111" => aux := 16 ns;
			WHEN "0000011111" => aux := 15 ns;
			WHEN "0000111111" => aux := 14 ns;
			WHEN "0001111111" => aux := 13 ns;
			WHEN "0011111111" => aux := 12 ns;
			WHEN "0111111111" => aux := 11 ns;
			WHEN "1111111111" => aux := 10 ns;
			WHEN "1111111110" => aux := 9 ns;
			WHEN "1111111100" => aux := 8 ns;
			WHEN "1111111000" => aux := 7 ns;
			WHEN "1111110000" => aux := 6 ns;
			WHEN "1111100000" => aux := 5 ns;
			WHEN "1111000000" => aux := 4 ns;
			WHEN "1110000000" => aux := 3 ns;
			WHEN "1100000000" => aux := 2 ns;
			WHEN "1000000000" => aux := 1 ns;	
			WHEN OTHERS => REPORT "unreachable" severity failure;
		END CASE;
		Thit <= to_integer(count) * 20 ns + aux;
	END PROCESS;

END arq;