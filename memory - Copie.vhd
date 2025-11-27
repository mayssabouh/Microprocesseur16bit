library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_async is
    port (
        RnW    : in  std_logic; 
        addr   : in  std_logic_vector(11 downto 0);
        data_s : in  std_logic_vector(15 downto 0);
        data   : out std_logic_vector(15 downto 0)
    );
end entity;

architecture arch of memory_async is
    -- On garde un tableau de 32 mots (suffisant pour cet exercice)
    type mem_type is array (0 to 31) of std_logic_vector(15 downto 0);
    
    signal mem : mem_type := (
        -- === PROGRAMME (Instructions) ===
        -- Adr 000 : LDA 010 (Hex: 0010) -> Charge la valeur 3 dans l'ACC
        0 => x"0010", 
        
        -- Adr 001 : ADD 011 (Hex: 2011) -> Ajoute la valeur 1 à l'ACC
        1 => x"2011", 
        
        -- Adr 002 : STO 012 (Hex: 1012) -> Stocke le résultat (4) à l'adresse 012
        2 => x"1012", 
        
        -- Adr 003 : JMP 003 (Hex: 4003) -> Boucle infinie (fin du programme)
        3 => x"4003", 

        -- === DONNÉES (Variables) ===
        -- Adr 010 (16 en décimal) : Constante 3
        16 => x"0003",
        
        -- Adr 011 (17 en décimal) : Constante 1
        17 => x"0001",
        
        -- Adr 012 (18 en décimal) : Variable RESULTAT (initialisée à 0)
        18 => x"0000",

        -- Le reste de la mémoire est à 0
        others => (others => '0')
    );
begin

    -- LECTURE ASYNCHRONE
    -- Note importante : on utilise addr(4 downto 0) pour éviter le crash ModelSim
    -- Cela limite l'adresse aux 32 premières cases (0 à 31)
    data <= mem(to_integer(unsigned(addr(4 downto 0)))) when RnW = '1' else (others => 'Z');

    -- ÉCRITURE ASYNCHRONE
    process(RnW, addr, data_s)
    begin
        if RnW = '0' then
            mem(to_integer(unsigned(addr(4 downto 0)))) <= data_s;
        end if;
    end process;

end architecture;
