library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity alu is
    port(   F: in std_logic_vector(3 downto 0);
            A, B: in std_logic_vector(31 downto 0);
            C: out std_logic_vector(31 downto 0);
            nzvc: out std_logic_vector(3 downto 0));
end alu;

architecture comp of alu is
signal res: std_logic_vector(31 downto 0);
signal flags: std_logic_vector(3 downto 0) := "0000";
begin
    res <= A and B when F = "0000" else
           A or  B when F = "0001" else
           not(A or B) when F = "0010" else
           std_logic_vector(unsigned(A) + unsigned(B)) when F = "0011" else
           std_logic_vector(unsigned(A) srl to_integer(unsigned(B))) when F = "0100" else
           A and B when F = "0101" else 
           A or B when F = "0110" else 
           not(A or B) when F = "0111" else
           std_logic_vector(unsigned(A) + unsigned(B)) when F = "1000" else
           std_logic_vector(unsigned(A) sll 2) when F = "1001" else
           std_logic_vector(unsigned(A) sll 10) when F = "1010" else
           --SIMM13
           --SEXT14
           std_logic_vector(unsigned(A) + 1) when F = "1101" else
           std_logic_vector(unsigned(A) + 4) when F = "1110" else
           std_logic_vector(unsigned(A) srl 5) when F = "1111";


    -- Flag n negative
    flags(3) <=  '1' when ((res(31) = '1') and (F="0000")) else 
                 '1' when ((res(31) = '1') and (F="0001")) else 
                 '1' when ((res(31) = '1') and (F="0010")) else 
                 '1' when ((res(31) = '1') and (F="0011")) else '0';

    -- Flag z zero
    flags(2) <=  '1' when ((res = "00000000000000000000000000000000") and (F="0000")) else
                 '1' when ((res = "00000000000000000000000000000000") and (F="0001")) else
                 '1' when ((res = "00000000000000000000000000000000") and (F="0010")) else
                 '1' when ((res = "00000000000000000000000000000000") and (F="0011")) else '0';

    -- Flag v overflow
    flags(1) <= '0';
    -- Flag c carry
    flags(0) <= '0';

    C <= res;
    nzvc <= flags;

end comp;


