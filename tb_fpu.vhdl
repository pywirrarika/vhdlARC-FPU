library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_fpu is
end entity tb_fpu;

architecture comp of tb_fpu is
    component fpu is
    port(   F: in std_logic_vector(3 downto 0);
            A, B: in std_logic_vector(31 downto 0);
            C: out std_logic_vector(31 downto 0)
            );
    end component fpu;

    signal busa: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
    signal busb: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
    signal inst: std_logic_vector(3 downto 0):="0000";
    signal busc: std_logic_vector(31 downto 0);
 
begin
    fpu0:fpu
    port map( A => busa, B => busb, F =>inst, C=>busc);
    process
    begin


        busa <=  "01000000000001100110011001100110";
        wait for 10 ns;
        busa <=  "01000000000001100110011001100110";
        wait for 10 ns;
        busa <=  "01000000000001100110011001100110";
        wait for 10 ns;
        busa <=  "01000000000001100110011001100110";
        wait for 10 ns;
     end process;

    process
    begin
        busb <= "11000010110010001000000000000000";
        wait for 10 ns;
        busb <= "11000010110010001000000000000000";
        wait for 10 ns;
        busb <= "11000010110010001000000000000000";
        wait for 10 ns;
        busb <= "11000010110010001000000000000000";
        wait for 10 ns;
     end process;
    process
    begin
       inst <= "0000";
       wait for 10 ns;
       inst <= "0001";
       wait for 10 ns;
       inst <= "0000";
       wait for 10 ns;
       inst <= "0001";
       wait for 10 ns;
 
   end process;
end architecture comp;

