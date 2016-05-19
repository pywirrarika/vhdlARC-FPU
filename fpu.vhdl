library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- library work;
-- use work.fpu_common.all;



entity fpu is
    port(   F: in std_logic_vector(3 downto 0);
            A, B: in std_logic_vector(31 downto 0);
            C: out std_logic_vector(31 downto 0);
            OsignoC: out std_logic;
            OmantizaC: out std_logic_vector(22 downto 0);
            OexponenteC: out std_logic_vector(7 downto 0);
            nzvc: out std_logic_vector(3 downto 0));
end fpu;

architecture comp of fpu is
    signal res: std_logic_vector(31 downto 0);
    signal flags: std_logic_vector(3 downto 0) := "0000";

    signal signoA: std_logic;
    signal exponenteA: std_logic_vector(7 downto 0);
    signal mantizaA: std_logic_vector(25 downto 0);

    signal signoB: std_logic;
    signal exponenteB: std_logic_vector(7 downto 0);
    signal mantizaB: std_logic_vector(25 downto 0);

    signal signoC: std_logic;
    signal exponenteC: std_logic_vector(7 downto 0);

    signal mantizaC: std_logic_vector(22 downto 0):=(others=>'0');
    signal mov: std_logic_vector(31 downto 0);
begin
    
    -- Se descompone el número de punto flotante
    signoA <= A(31);
    signoB <= B(31);

    exponenteA <= A(30 downto 23);
    exponenteB <= B(30 downto 23);

    mantizaA(22 downto 0) <= A(22 downto 0);
    mantizaB(22 downto 0) <= B(22 downto 0);
    mantizaA(25 downto 24) <= "01";
    mantizaB(25 downto 24) <= "01";
    -- Se agrega el bit implísito a la mantiza de A y B
    --mantizaA(23) <= '1';
    --mantizaB(23) <= '1';

    process(mantizaA, mantizaB, exponenteA, exponenteB, signoA, signoB)
    variable i: integer;
    variable vs1: std_logic;
    variable vs2: std_logic;
    variable vs: std_logic;
    variable ve1: std_logic_vector(7 downto 0);
    variable ve2: std_logic_vector(7 downto 0);
    variable ve: std_logic_vector(7 downto 0);
    variable vm1: std_logic_vector(25 downto 0);      
    variable vm2: std_logic_vector(25 downto 0);        
    variable vm: std_logic_vector(25 downto 0):=(others=>'0');        
    variable ret: std_logic_vector(31 downto 0);
    variable mant1 :integer;
    variable mant2 :integer;

    begin
        i := integer(0);
        ve1 := exponenteA; 
        ve2 := exponenteB; 
        vm1 := mantizaA; 
        vm2 := mantizaB; 
        vs1 := signoA;
        vs2 := signoB;
        
        -- Quitamos exceso 127
        --ve1 := std_logic_vector(signed(ve1)-127);
        --ve2 := std_logic_vector(signed(ve2)-127);
        
        --while ve1 /= ve2 loop
        --    if signed(ve1) > signed(ve2) then
        --        vm2 := std_logic_vector(unsigned(vm2) srl 1);
        --        ve2 := std_logic_vector(unsigned(ve2) + to_unsigned(1,25));
        --        i:= i + 1;
        --    elsif signed(ve1) < signed(ve2) then
        --        vm1 := std_logic_vector(unsigned(vm1) srl 1);
        --        ve1 := std_logic_vector(unsigned(ve1) + to_unsigned(1,25));
        --    end if;
        --end loop;
        --
        --ve := std_logic_vector(signed(ve)+127);
        --if vs1 = '1' then
        --    vm1 := not vm1;
        --    vm1 := std_logic_vector(signed(vm1) + 1);
        --end if;
        --
        --if vs2 = '1' then
        --    vm2 := not vm2;
        --    vm2 := std_logic_vector(signed(vm2) + 1);
        --end if;
       -- 
       --vm := std_logic_vector(signed(vm1) + signed(vm2));
       -- --ret(31 downto 0) := s1 & ve & vm(22 downto 0); 
        mantizaC<= vm1(22 downto 0); 
        exponenteC <= ve1; 
        signoC<=vs1;

    end process;


    --C <= signoC & exponenteC & mantizaA(22 downto 0);

    --res <= A and B when F = "0000" else
    --       A or  B when F = "0001"; 

    --C <= res;
    --nzvc <= flags;
    --OexponenteC <= exponenteC;
    --OsignoC <= signoC;

    OexponenteC <= exponenteC;
    OsignoC <= signoC;
    mantizaC <= std_logic_vector(unsigned(mantizaA(22 downto 0)) + 1);
    OmantizaC <= mantizaC(22 downto 0);

end comp;


