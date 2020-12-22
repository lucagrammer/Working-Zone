----------------------------------------------------------------------------------
-- Authors: Lorenzo Giovanni Lacchini , Luca Minotti
-- Project Name: Prova Finale (Progetto di Reti Logiche)
-- Target Devices: FPGA xc7a200tfbg484-1
-- Tool Versions: Vivado 2018.3
---------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port(
        i_clk       :   in      std_logic;
        i_start     :   in      std_logic;
        i_rst       :   in      std_logic;
        i_data      :   in      std_logic_vector(7 downto 0);
        o_address   :   out     std_logic_vector(15 downto 0);
        o_done      :   out     std_logic;
        o_en        :   out     std_logic;
        o_we        :   out     std_logic;
        o_data      :   out     std_logic_vector(7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type state is (IDLE,WAIT_ADDR,READ_ADDR,WAIT_WZ,READ_WZ,WRITE_RESULT,DONE);

    signal curr_state:state :=IDLE;
    signal next_state:state :=IDLE;

    signal curr_done:std_logic:='0';
    signal next_done:std_logic:='0';

    signal curr_we:std_logic:='-'; --
    signal next_we:std_logic:='-'; --

    signal curr_en:std_logic:='0';
    signal next_en:std_logic:='0';

    signal curr_addr:std_logic_vector(15 downto 0):= (others =>'-'); --
    signal next_addr:std_logic_vector(15 downto 0):= (others =>'-');

    signal curr_data:std_logic_vector(7 downto 0):= (others =>'-');
    signal next_data:std_logic_vector(7 downto 0):= (others =>'-');

    signal curr_base_addr:std_logic_vector(7 downto 0):= (others =>'-');
    signal next_base_addr:std_logic_vector(7 downto 0):= (others =>'-');

    signal curr_counter: std_logic_vector(2 downto 0):= (others =>'-');
    signal next_counter: std_logic_vector(2 downto 0):= (others =>'-'); --

begin

    CONTROLLER: process(i_clk,i_rst)
    begin
        if(i_rst='1') then
            curr_state<=IDLE;
            curr_done<='0';
            curr_we<='-';
            curr_en<='0';
            curr_counter<=(others =>'0');
            curr_addr<=(others =>'-');
            curr_data<=(others =>'-');
            curr_base_addr<=(others =>'-');
        elsif (i_clk'event and i_clk='1' ) then
            curr_state <=next_state;
            curr_done<=next_done;
            curr_we<=next_we;
            curr_en<=next_en;
            curr_counter<=next_counter;
            curr_addr<=next_addr;
            curr_data<=next_data;
            curr_base_addr<=next_base_addr;
        end if;
    end process;

    FSM: process(curr_state,i_start,curr_we,curr_en,curr_done,curr_counter,curr_addr,curr_data,curr_base_addr,curr_data,i_data)
	variable wz: std_logic_vector(7 downto 0);
	variable counter: std_logic_vector(2 downto 0);
    begin
        next_state<=curr_state;
        next_done<=curr_done;
        next_we<=curr_we;
        next_en<=curr_en;
        next_counter<=curr_counter;
        counter:=curr_counter;
        next_addr<=curr_addr;
        next_data<=curr_data;
        next_base_addr<=curr_base_addr;

        case curr_state is
            when IDLE=>
                if(i_start='1') then
                    next_state<=WAIT_ADDR;
                    next_done<='0';
                    next_en<='1';
                    next_we<='0';
                    next_addr<="0000000000001000";
                end if;

             when WAIT_ADDR=>
                next_state<=READ_ADDR;

             when READ_ADDR=>
                next_state<=WAIT_WZ;
                next_base_addr<=i_data;
                counter :="000";
                next_addr<="0000000000000" & counter;

             when WAIT_WZ=>
                next_state<=READ_WZ;

             when READ_WZ=>
                wz:=i_data;
                if curr_base_addr=wz then
                        next_en<='1';
                        next_we<='1';
                        next_addr<="0000000000001001";
                        next_data<='1'& counter & "0001";
                        next_state<=WRITE_RESULT;

                 elsif curr_base_addr=std_logic_vector(unsigned(wz)+1) then
                        next_en<='1';
                        next_we<='1';
                        next_addr<="0000000000001001";
                        next_data<='1'& counter & "0010";
                        next_state<=WRITE_RESULT;

                 elsif curr_base_addr=std_logic_vector(unsigned(wz)+2) then
                        next_en<='1';
                        next_we<='1';
                        next_addr<="0000000000001001";
                        next_data<='1'& counter & "0100";
                        next_state<=WRITE_RESULT;

                 elsif curr_base_addr=std_logic_vector(unsigned(wz)+3) then
                        next_en<='1';
                        next_we<='1';
                        next_addr<="0000000000001001";
                        next_data<='1'& counter & "1000";
                        next_state<=WRITE_RESULT;

                 else

                        if(counter /= "111") then
                            counter:=std_logic_vector(unsigned(counter)+1);
		           next_addr<="0000000000000" & counter;
                            next_state<=WAIT_WZ;
                        else
                            next_en<='1';
                            next_we<='1';
                            next_addr<="0000000000001001";
                            next_data<='0'& curr_base_addr(6 downto 0);
                            next_state<=WRITE_RESULT;
                        end if;
                end if;

             when WRITE_RESULT=>
                next_state<=DONE;
                next_done<='1';
                next_en<='0';
                next_we<='0';
                next_addr<=(others =>'-');
                next_data<=(others =>'-');

             when DONE=>
                if(i_start='0') then
                    next_state<=IDLE;
                    next_done<='0';
                end if;
         end case;

         next_counter<=counter;

     end process;

    -- Connessioni verso l'output
    o_done<=next_done;
    o_en<=next_en;
    o_we<=next_we;
    o_address<=next_addr;
    o_data<=next_data;

end Behavioral;
