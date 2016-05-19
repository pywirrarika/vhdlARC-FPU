library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity fpu is
    port(   F: in std_logic_vector(3 downto 0);
            A, B: in std_logic_vector(31 downto 0);
            C: out std_logic_vector(31 downto 0)
        );
end fpu;

architecture comp of fpu is
signal omc: std_logic_vector(22 downto 0);
signal m: std_logic_vector(25 downto 0); -- para debug
signal mmult: std_logic_vector(25 downto 0); -- Para debug
signal rmult: std_logic_vector(51 downto 0); -- para debug
signal exp: std_logic_vector(7 downto 0);
signal e: std_logic_vector(7 downto 0); -- para debug
signal sig: std_logic;
signal omcmult: std_logic_vector(22 downto 0);
signal mult: std_logic_vector(25 downto 0);
signal expmult: std_logic_vector(7 downto 0);
signal sigmult: std_logic;
signal ii: integer;
signal mantos : std_logic_vector(25 downto 0);
signal expD : std_logic_vector(7 downto 0);

begin
    process(A,B,F)

    variable mantA : std_logic_vector(25 downto 0):=(others=>'0');
    variable mantB : std_logic_vector(25 downto 0):=(others=>'0');
    variable mantC : std_logic_vector(25 downto 0):=(others=>'0');
    variable expA : std_logic_vector(7 downto 0):=(others=>'0');
    variable expB : std_logic_vector(7 downto 0):=(others=>'0');
    variable expC : std_logic_vector(7 downto 0):=(others=>'0');
    variable expC2 : std_logic_vector(7 downto 0):=(others=>'0');
    variable sigA : std_logic;
    variable sigB : std_logic;
    variable sigC : std_logic;
    variable i : integer;
    variable j : integer;
    begin
        mantA(22 downto 0) := A(22 downto 0);
        mantB(22 downto 0) := B(22 downto 0);

        mantA(23) := '1';
        mantB(23) := '1';
        mantA(24) := '0';
        mantB(24) := '0';

        sigA := A(31);
        sigB := B(31);

        expA := A(30 downto 23);
        expB := B(30 downto 23);

        expA := std_logic_vector(unsigned(expA) - 127);
        expB := std_logic_vector(unsigned(expB) - 127);

        
        m <= mantA;

        while expA /= expB loop
            if signed(expA) > signed(expB) then
                mantB := std_logic_vector(unsigned(mantB) srl 1);
                expB := std_logic_vector(unsigned(expB) + 1);
            elsif signed(expA) < signed(expB) then
                mantA:= std_logic_vector(unsigned(mantA) srl 1);
                expA:= std_logic_vector(unsigned(expA) + 1);
            end if;
        end loop;
            
        if sigA = '1' then
            mantA := not mantA;
            mantA := std_logic_vector(unsigned(mantA) + 1);
        end if;
        
        if sigB = '1' then
            mantB := not mantB;
            mantB := std_logic_vector(unsigned(mantB) + 1);
        end if;
        
        expC :=  std_logic_vector(unsigned(expA)+127);
        mantC := std_logic_vector(unsigned(mantA) + unsigned(mantB));
        --

        if mantC(25) = '1' then
            mantC := not mantC;
            mantC := std_logic_vector(unsigned(mantC) + 1);
 
            sigC := '1';
        else
            sigC := '0';
        end if;
        
        i := 0;
        j := 0;
        while (i < 26) loop
            if mantC(i) = '1' then
                j := i;
            end if;
            i := i + 1;
        end loop;
        ii<=j; 
        i:= j-23;
        
        while (i /= 0) loop
            if i>0 then
                mantC := std_logic_vector(unsigned(mantC) srl 1);
                expC2 := std_logic_vector(unsigned(expC) + 1);
                expC := expC2;
                i := i - 1;
            else
                mantC := std_logic_vector(unsigned(mantC) sll 1);
                expC2 := std_logic_vector(unsigned(expC) - 1);
                expC := expC2;
                i := i + 1;
            end if;
        end loop;
        e <= expC;

        omc <= mantC(22 downto 0);
        exp <= expC;   

        sig <= sigC;
    end process;
        
    process(A,B,F)
    variable mantA : std_logic_vector(25 downto 0);
    variable mantB : std_logic_vector(25 downto 0);
    variable mantC : std_logic_vector(25 downto 0);
    variable mres : std_logic_vector(51 downto 0) := (others=>'0');
    variable expA : std_logic_vector(7 downto 0);
    variable expB : std_logic_vector(7 downto 0);
    variable expC : std_logic_vector(7 downto 0);
    variable expC2 : std_logic_vector(7 downto 0);
    variable sigA : std_logic;
    variable sigB : std_logic;
    variable sigC : std_logic;
    variable i : integer;
    variable j : integer;

    begin
        mantA(22 downto 0) := A(22 downto 0);
        mantB(22 downto 0) := B(22 downto 0);
        mantA(23) := '1';
        mantB(23) := '1';
        mantA(24) := '0';
        mantB(24) := '0';
        mantA(25) := '0';
        mantB(25) := '0';

        mantos<= mantA;

        sigA := A(31);
        sigB := B(31);

        expA := A(30 downto 23);
        expB := B(30 downto 23);

        expA := std_logic_vector(unsigned(expA) - 127);
        expB := std_logic_vector(unsigned(expB) - 127);
        
        expC := std_logic_vector(unsigned(expA) + unsigned(expB));
        expC :=  std_logic_vector(unsigned(expC)+127);
        expD <= expC;

        mres := std_logic_vector(unsigned(mantA) * unsigned(mantB));
        mres:= std_logic_vector(unsigned(mres) srl 23);
        
        rmult <= mres;
        if (sigA = '1' or sigB = '1') and (sigA /= sigB) then
            sigC := '1';
        else
            sigC := '0';
        end if;
        

        i := 0;
        j := 0;
        while (i < 26) loop
            if mres(i) = '1' then
                j := i;
            end if;
            i := i + 1;
        end loop;
        
        i:= j-23;

        while (i /= 0) loop
            if i>0 then
                mres := std_logic_vector(unsigned(mres) srl 1);
                expC2 := std_logic_vector(signed(expC) + 1);
                expC := expC2;
                i := i - 1;
            else
                mres := std_logic_vector(unsigned(mres) sll 1);
                expC2 := std_logic_vector(signed(expC) - 1);
                expC := expC2;
                i := i + 1;
            end if;
        end loop;
        mmult <= mres(25 downto 0);

        expmult <= expC;
        omcmult <= mres(22 downto 0);
        sigmult <= sigC;
    end process;


    C <= (sig & exp & omc) when F = "0000" else
         (sigmult & expmult & omcmult);

end comp;


