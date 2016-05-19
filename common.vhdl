library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
package fpu_common is
function correr_mantiza(
                        e1: std_logic_vector(7 downto 0);
                        e2: std_logic_vector(7 downto 0);
                        m1: std_logic_vector(23 downto 0);
                        m2: std_logic_vector(23 downto 0))
                        return unsigned;
end fpu_common;
 

package body fpu_common is
    function correr_mantiza(
                            e1: std_logic_vector(7 downto 0);
                            e2: std_logic_vector(7 downto 0);
                            m1: std_logic_vector(23 downto 0);
                            m2: std_logic_vector(23 downto 0))
                            return signed is
                            variable i: integer;
    begin
        i := integer(0);
        L1:
        while signed(e1) /= signed(e2) loop
            i:= i + 1;
        end loop L1;
        
        return signed(e1);
    end correr_mantiza;
end fpu_common;


