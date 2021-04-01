library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleDynamic_DATA_SIZE is
  port (
    clk : in std_logic;
    reset : in std_logic
  );
end moduledynamic_ModuleDynamic_DATA_SIZE;

architecture RTL of moduledynamic_ModuleDynamic_DATA_SIZE is

  attribute mark_debug : string;
  attribute keep : string;
  attribute S : string;

  component singleportram
    generic (
  WIDTH : integer := 1;
  DEPTH : integer := 10;
  WORDS : integer := 1024
    );
    port (
      clk : in std_logic;
      reset : in std_logic;
      length : out signed(31 downto 0);
      address_b : in signed(31 downto 0);
      din_b : in signed(WIDTH-1 downto 0);
      dout_b : out signed(WIDTH-1 downto 0);
      we_b : in std_logic;
      oe_b : in std_logic
    );
  end component singleportram;

  signal clk_sig : std_logic := '0';
  signal reset_sig : std_logic := '0';

  signal class_DEFAULT_MEMORY_SIZE_PER_BLOCK_0000 : signed(32-1 downto 0) := X"0003e800";
  signal class_data1_0002_clk : std_logic := '0';
  signal class_data1_0002_reset : std_logic := '0';
  signal class_data1_0002_length : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0002_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0002_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data1_0002_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data1_0002_we_b : std_logic := '0';
  signal class_data1_0002_oe_b : std_logic := '0';
  signal class_data2_0005_clk : std_logic := '0';
  signal class_data2_0005_reset : std_logic := '0';
  signal class_data2_0005_length : signed(32-1 downto 0) := (others => '0');
  signal class_data2_0005_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data2_0005_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data2_0005_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data2_0005_we_b : std_logic := '0';
  signal class_data2_0005_oe_b : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;

  -- expressions

  -- sequencers

  class_data1_0002_clk <= clk_sig;

  class_data1_0002_reset <= reset_sig;

  class_data2_0005_clk <= clk_sig;

  class_data2_0005_reset <= reset_sig;


  inst_class_data1_0002 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data1_0002_length,
    address_b => class_data1_0002_address_b,
    din_b => class_data1_0002_din_b,
    dout_b => class_data1_0002_dout_b,
    we_b => class_data1_0002_we_b,
    oe_b => class_data1_0002_oe_b
  );

  inst_class_data2_0005 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data2_0005_length,
    address_b => class_data2_0005_address_b,
    din_b => class_data2_0005_din_b,
    dout_b => class_data2_0005_dout_b,
    we_b => class_data2_0005_we_b,
    oe_b => class_data2_0005_oe_b
  );


end RTL;
