library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity project3_tb is
end project3_tb;

architecture projecttb of project3_tb is
constant c_CLOCK_PERIOD		: time := 100 ns;
signal   tb_done		: std_logic;
signal   mem_address		: std_logic_vector (15 downto 0) := (others => '0');
signal   tb_rst	                : std_logic := '0';
signal   tb_start		: std_logic := '0';
signal   tb_clk		        : std_logic := '0';
signal   mem_o_data,mem_i_data	: std_logic_vector (7 downto 0);
signal   enable_wire  		: std_logic;
signal   mem_we		        : std_logic;

type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);

-- come da esempio su specifica
signal RAM: ram_type := (0 => std_logic_vector(to_unsigned( 4 , 8)),
                         1 => std_logic_vector(to_unsigned( 13 , 8)),
                         2 => std_logic_vector(to_unsigned( 22 , 8)),
                         3 => std_logic_vector(to_unsigned( 31 , 8)),
                         4 => std_logic_vector(to_unsigned( 37 , 8)),
                         5 => std_logic_vector(to_unsigned( 45 , 8)),
                         6 => std_logic_vector(to_unsigned( 77 , 8)),
                         7 => std_logic_vector(to_unsigned( 91 , 8)),
                         8 => std_logic_vector(to_unsigned( 33 , 8)),
			 others => (others =>'0'));


signal RAM2: ram_type := (0 => std_logic_vector(to_unsigned( 5 , 8)),
                         1 => std_logic_vector(to_unsigned( 21 , 8)),
                         2 => std_logic_vector(to_unsigned( 31 , 8)),
                         3 => std_logic_vector(to_unsigned( 26 , 8)),
                         4 => std_logic_vector(to_unsigned( 11 , 8)),
                         5 => std_logic_vector(to_unsigned( 55 , 8)),
                         6 => std_logic_vector(to_unsigned( 66 , 8)),
                         7 => std_logic_vector(to_unsigned( 43 , 8)),
                         8 => std_logic_vector(to_unsigned( 11 , 8)),
			 others => (others =>'0'));

shared variable counter : integer := 1;

component project_reti_logiche is
port (
      i_clk         : in  std_logic;
      i_start       : in  std_logic;
      i_rst         : in  std_logic;
      i_data        : in  std_logic_vector(7 downto 0);
      o_address     : out std_logic_vector(15 downto 0);
      o_done        : out std_logic;
      o_en          : out std_logic;
      o_we          : out std_logic;
      o_data        : out std_logic_vector (7 downto 0)
      );
end component project_reti_logiche;


begin
UUT: project_reti_logiche
port map (
          i_clk      	=> tb_clk,
          i_start       => tb_start,
          i_rst      	=> tb_rst,
          i_data    	=> mem_o_data,
          o_address  	=> mem_address,
          o_done      	=> tb_done,
          o_en   	=> enable_wire,
          o_we 		=> mem_we,
          o_data    	=> mem_i_data
          );

p_CLK_GEN : process is
begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
end process p_CLK_GEN;


MEM : process(tb_clk)
begin
    if tb_clk'event and tb_clk = '1' then
        if enable_wire = '1' then
            if mem_we = '1' then
                case counter is
                    when 1 =>
                        RAM(conv_integer(mem_address))  <= mem_i_data;
                        mem_o_data                      <= mem_i_data after 1 ns;
                    when 2 =>
                        RAM2(conv_integer(mem_address))  <= mem_i_data;
                        mem_o_data                      <= mem_i_data after 1 ns;
                    when others =>
                        report "** Possibile errore counter **";
                        RAM(conv_integer(mem_address))  <= mem_i_data;
                        mem_o_data                      <= mem_i_data after 1 ns;
                end case;
            else
                case counter is
                    when 1 =>
                        mem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;
                    when 2 =>
                        mem_o_data <= RAM2(conv_integer(mem_address)) after 1 ns;
                    when others =>
                        report "** Possibile errore counter **";
                        mem_o_data <= RAM(conv_integer(mem_address)) after 1 ns;
                end case;
            end if;
        end if;
    end if;
end process;

test : process is
begin

    -- RAM1
    wait for 100 ns;
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    tb_rst <= '0';
    wait for c_CLOCK_PERIOD;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;

    -- Maschera di output = 1 - 011 - 0100
    assert RAM(9) = std_logic_vector(to_unsigned( 180 , 8)) report "TEST MR1 FALLITO. Expected  180  found " & integer'image(to_integer(unsigned(RAM(9))))  severity failure;

    assert false report "Simulation Ended!, TEST MR1 PASSATO" severity failure;

    -- RAM2
    counter := counter + 1;
    wait for 100 ns;
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    tb_rst <= '0';
    wait for c_CLOCK_PERIOD;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;

    -- Maschera di output = 1 - 100 - 0001
    assert RAM2(9) = std_logic_vector(to_unsigned( 193 , 8)) report "TEST MR2 FALLITO. Expected  193  found " & integer'image(to_integer(unsigned(RAM2(9))))  severity failure;

    assert false report "Simulation Ended!, TEST MR2 PASSATO" severity failure;


end process test;

end projecttb;
