library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleMigration is
  port (
    clk : in std_logic;
    reset : in std_logic;
    migration_address : in signed(32-1 downto 0);
    migration_ecc : in signed(32-1 downto 0);
    migration_pageSize : in signed(32-1 downto 0);
    migration_busy : out std_logic;
    migration_req : in std_logic
  );
end moduledynamic_ModuleMigration;

architecture RTL of moduledynamic_ModuleMigration is

  attribute mark_debug : string;
  attribute keep : string;
  attribute S : string;

  component moduledynamic_ModuleECC
    port (
      clk : in std_logic;
      reset : in std_logic;
      checkECC_data : in signed(32-1 downto 0);
      checkECC_ecc : in signed(32-1 downto 0);
      doEcc_data : in signed(32-1 downto 0);
      doEcc_ecc : in signed(32-1 downto 0);
      checkECC_return : out std_logic;
      checkECC_busy : out std_logic;
      checkECC_req : in std_logic;
      doEcc_return : out signed(32-1 downto 0);
      doEcc_busy : out std_logic;
      doEcc_req : in std_logic
    );
  end component moduledynamic_ModuleECC;
  component synthesijer_div32
    port (
      clk : in std_logic;
      reset : in std_logic;
      a : in signed(32-1 downto 0);
      b : in signed(32-1 downto 0);
      nd : in std_logic;
      quantient : out signed(32-1 downto 0);
      remainder : out signed(32-1 downto 0);
      valid : out std_logic
    );
  end component synthesijer_div32;
  component synthesijer_mul32
    port (
      clk : in std_logic;
      reset : in std_logic;
      a : in signed(32-1 downto 0);
      b : in signed(32-1 downto 0);
      nd : in std_logic;
      result : out signed(32-1 downto 0);
      valid : out std_logic
    );
  end component synthesijer_mul32;

  signal clk_sig : std_logic := '0';
  signal reset_sig : std_logic := '0';
  signal migration_address_sig : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_sig : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_sig : signed(32-1 downto 0) := (others => '0');
  signal migration_busy_sig : std_logic := '1';
  signal migration_req_sig : std_logic := '0';

  signal class_moduleECC_0000_clk : std_logic := '0';
  signal class_moduleECC_0000_reset : std_logic := '0';
  signal class_moduleECC_0000_checkECC_data : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0000_checkECC_ecc : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0000_doEcc_data : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0000_doEcc_ecc : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0000_checkECC_return : std_logic := '0';
  signal class_moduleECC_0000_checkECC_busy : std_logic := '0';
  signal class_moduleECC_0000_checkECC_req : std_logic := '0';
  signal class_moduleECC_0000_doEcc_return : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0000_doEcc_busy : std_logic := '0';
  signal class_moduleECC_0000_doEcc_req : std_logic := '0';
  signal migration_address_0002 : signed(32-1 downto 0) := (others => '0');
  signal migration_address_local : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_0003 : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_0004 : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00006 : std_logic := '0';
  signal binary_expr_00008 : signed(32-1 downto 0) := (others => '0');
  signal migration_position_0007 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00010 : signed(32-1 downto 0) := (others => '0');
  signal migration_initialAddress_0009 : signed(32-1 downto 0) := (others => '0');
  signal migration_i_0011 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00013 : std_logic := '0';
  signal unary_expr_00014 : signed(32-1 downto 0) := (others => '0');
  signal unary_expr_postfix_preserved_00015 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00018 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00019 : signed(32-1 downto 0) := (others => '0');
  signal migration_read_0017 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00021 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00023 : signed(32-1 downto 0) := (others => '0');
  signal write_address_0024 : signed(32-1 downto 0) := (others => '0');
  signal write_address_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_0025 : signed(32-1 downto 0) := (others => '0');
  signal write_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_0026 : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00028 : signed(32-1 downto 0) := (others => '0');
  signal write_newData_0027 : signed(32-1 downto 0) := (others => '0');
  signal read_address_0035 : signed(32-1 downto 0) := (others => '0');
  signal read_address_local : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_0036 : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00038 : signed(32-1 downto 0) := (others => '0');
  signal read_data_0037 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00039 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_0040 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_0041 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_local : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_0042 : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal migration_req_flag : std_logic := '0';
  signal migration_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal write_busy : std_logic := '0';
  signal write_req_flag : std_logic := '0';
  signal write_req_local : std_logic := '0';
  signal read_return : signed(32-1 downto 0) := (others => '0');
  signal read_busy : std_logic := '0';
  signal read_req_flag : std_logic := '0';
  signal read_req_local : std_logic := '0';
  signal writeRAM_busy : std_logic := '0';
  signal writeRAM_req_flag : std_logic := '0';
  signal writeRAM_req_local : std_logic := '0';
  signal readRAM_return : signed(32-1 downto 0) := (others => '0');
  signal readRAM_busy : std_logic := '0';
  signal readRAM_req_flag : std_logic := '0';
  signal readRAM_req_local : std_logic := '0';
  type Type_migration_method is (
    migration_method_IDLE,
    migration_method_S_0000,
    migration_method_S_0001,
    migration_method_S_0002,
    migration_method_S_0003,
    migration_method_S_0005,
    migration_method_S_0007,
    migration_method_S_0008,
    migration_method_S_0009,
    migration_method_S_0010,
    migration_method_S_0012,
    migration_method_S_0013,
    migration_method_S_0015,
    migration_method_S_0017,
    migration_method_S_0019,
    migration_method_S_0020,
    migration_method_S_0021,
    migration_method_S_0024,
    migration_method_S_0020_body,
    migration_method_S_0020_wait,
    migration_method_S_0024_body,
    migration_method_S_0024_wait  
  );
  signal migration_method : Type_migration_method := migration_method_IDLE;
  signal migration_method_prev : Type_migration_method := migration_method_IDLE;
  signal migration_method_delay : signed(32-1 downto 0) := (others => '0');
  signal migration_req_flag_d : std_logic := '0';
  signal migration_req_flag_edge : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal u_synthesijer_div32_migration_clk : std_logic := '0';
  signal u_synthesijer_div32_migration_reset : std_logic := '0';
  signal u_synthesijer_div32_migration_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_migration_b : signed(32-1 downto 0) := X"00000001";
  signal u_synthesijer_div32_migration_nd : std_logic := '0';
  signal u_synthesijer_div32_migration_quantient : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_migration_remainder : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_migration_valid : std_logic := '0';
  signal u_synthesijer_mul32_migration_clk : std_logic := '0';
  signal u_synthesijer_mul32_migration_reset : std_logic := '0';
  signal u_synthesijer_mul32_migration_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_migration_b : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_migration_nd : std_logic := '0';
  signal u_synthesijer_mul32_migration_result : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_migration_valid : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal read_call_flag_0020 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal write_call_flag_0024 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
  signal tmp_0020 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0023 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0024 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0028 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0029 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0030 : signed(32-1 downto 0) := (others => '0');
  type Type_write_method is (
    write_method_IDLE,
    write_method_S_0000,
    write_method_S_0001,
    write_method_S_0002,
    write_method_S_0003,
    write_method_S_0004,
    write_method_S_0007,
    write_method_S_0008,
    write_method_S_0010,
    write_method_S_0011,
    write_method_S_0013,
    write_method_S_0014,
    write_method_S_0002_body,
    write_method_S_0002_wait,
    write_method_S_0007_body,
    write_method_S_0007_wait,
    write_method_S_0010_body,
    write_method_S_0010_wait,
    write_method_S_0013_body,
    write_method_S_0013_wait  
  );
  signal write_method : Type_write_method := write_method_IDLE;
  signal write_method_prev : Type_write_method := write_method_IDLE;
  signal write_method_delay : signed(32-1 downto 0) := (others => '0');
  signal write_req_flag_d : std_logic := '0';
  signal write_req_flag_edge : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal class_moduleECC_0000_doEcc_ext_call_flag_0002 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal writeRAM_call_flag_0007 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal writeRAM_call_flag_0010 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal writeRAM_call_flag_0013 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  type Type_read_method is (
    read_method_IDLE,
    read_method_S_0000,
    read_method_S_0001,
    read_method_S_0002,
    read_method_S_0003,
    read_method_S_0004,
    read_method_S_0005,
    read_method_S_0002_body,
    read_method_S_0002_wait,
    read_method_S_0004_body,
    read_method_S_0004_wait  
  );
  signal read_method : Type_read_method := read_method_IDLE;
  signal read_method_prev : Type_read_method := read_method_IDLE;
  signal read_method_delay : signed(32-1 downto 0) := (others => '0');
  signal read_req_flag_d : std_logic := '0';
  signal read_req_flag_edge : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal readRAM_call_flag_0002 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal class_moduleECC_0000_doEcc_ext_call_flag_0004 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  type Type_writeRAM_method is (
    writeRAM_method_IDLE,
    writeRAM_method_S_0000,
    writeRAM_method_S_0001  
  );
  signal writeRAM_method : Type_writeRAM_method := writeRAM_method_IDLE;
  signal writeRAM_method_prev : Type_writeRAM_method := writeRAM_method_IDLE;
  signal writeRAM_method_delay : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_req_flag_d : std_logic := '0';
  signal writeRAM_req_flag_edge : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  type Type_readRAM_method is (
    readRAM_method_IDLE,
    readRAM_method_S_0000,
    readRAM_method_S_0001,
    readRAM_method_S_0002  
  );
  signal readRAM_method : Type_readRAM_method := readRAM_method_IDLE;
  signal readRAM_method_prev : Type_readRAM_method := readRAM_method_IDLE;
  signal readRAM_method_delay : signed(32-1 downto 0) := (others => '0');
  signal readRAM_req_flag_d : std_logic := '0';
  signal readRAM_req_flag_edge : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
  signal tmp_0086 : std_logic := '0';
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;
  migration_address_sig <= migration_address;
  migration_ecc_sig <= migration_ecc;
  migration_pageSize_sig <= migration_pageSize;
  migration_busy <= migration_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_busy_sig <= '1';
      else
        if migration_method = migration_method_S_0000 then
          migration_busy_sig <= '0';
        elsif migration_method = migration_method_S_0001 then
          migration_busy_sig <= tmp_0005;
        end if;
      end if;
    end if;
  end process;

  migration_req_sig <= migration_req;

  -- expressions
  tmp_0001 <= migration_req_local or migration_req_sig;
  tmp_0002 <= not migration_req_flag_d;
  tmp_0003 <= migration_req_flag and tmp_0002;
  tmp_0004 <= migration_req_flag or migration_req_flag_d;
  tmp_0005 <= migration_req_flag or migration_req_flag_d;
  tmp_0006 <= '1' when binary_expr_00006 = '1' else '0';
  tmp_0007 <= '1' when binary_expr_00006 = '0' else '0';
  tmp_0008 <= '1' when binary_expr_00013 = '1' else '0';
  tmp_0009 <= '1' when binary_expr_00013 = '0' else '0';
  tmp_0010 <= '1' when read_busy = '0' else '0';
  tmp_0011 <= '1' when read_req_local = '0' else '0';
  tmp_0012 <= tmp_0010 and tmp_0011;
  tmp_0013 <= '1' when tmp_0012 = '1' else '0';
  tmp_0014 <= '1' when write_busy = '0' else '0';
  tmp_0015 <= '1' when write_req_local = '0' else '0';
  tmp_0016 <= tmp_0014 and tmp_0015;
  tmp_0017 <= '1' when tmp_0016 = '1' else '0';
  tmp_0018 <= '1' when migration_method /= migration_method_S_0000 else '0';
  tmp_0019 <= '1' when migration_method /= migration_method_S_0001 else '0';
  tmp_0020 <= tmp_0019 and migration_req_flag_edge;
  tmp_0021 <= tmp_0018 and tmp_0020;
  tmp_0022 <= migration_address_sig when migration_req_sig = '1' else migration_address_local;
  tmp_0023 <= migration_ecc_sig when migration_req_sig = '1' else migration_ecc_local;
  tmp_0024 <= migration_pageSize_sig when migration_req_sig = '1' else migration_pageSize_local;
  tmp_0025 <= '1' when migration_ecc_0003 = X"00000003" else '0';
  tmp_0026 <= '1' when migration_i_0011 < migration_pageSize_0004 else '0';
  tmp_0027 <= migration_i_0011 + X"00000001";
  tmp_0028 <= migration_initialAddress_0009 + migration_i_0011;
  tmp_0029 <= migration_initialAddress_0009 + migration_i_0011;
  tmp_0030 <= migration_ecc_0003 + X"00000001";
  tmp_0031 <= not write_req_flag_d;
  tmp_0032 <= write_req_flag and tmp_0031;
  tmp_0033 <= write_req_flag or write_req_flag_d;
  tmp_0034 <= write_req_flag or write_req_flag_d;
  tmp_0035 <= '1' when class_moduleECC_0000_doEcc_busy = '0' else '0';
  tmp_0036 <= '1' when class_moduleECC_0000_doEcc_req = '0' else '0';
  tmp_0037 <= tmp_0035 and tmp_0036;
  tmp_0038 <= '1' when tmp_0037 = '1' else '0';
  tmp_0039 <= '1' when write_ecc_0026 = X"00000001" else '0';
  tmp_0040 <= '1' when write_ecc_0026 = X"00000002" else '0';
  tmp_0041 <= '1' when write_ecc_0026 = X"00000003" else '0';
  tmp_0042 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0043 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0044 <= tmp_0042 and tmp_0043;
  tmp_0045 <= '1' when tmp_0044 = '1' else '0';
  tmp_0046 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0047 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0048 <= tmp_0046 and tmp_0047;
  tmp_0049 <= '1' when tmp_0048 = '1' else '0';
  tmp_0050 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0051 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0052 <= tmp_0050 and tmp_0051;
  tmp_0053 <= '1' when tmp_0052 = '1' else '0';
  tmp_0054 <= '1' when write_method /= write_method_S_0000 else '0';
  tmp_0055 <= '1' when write_method /= write_method_S_0001 else '0';
  tmp_0056 <= tmp_0055 and write_req_flag_edge;
  tmp_0057 <= tmp_0054 and tmp_0056;
  tmp_0058 <= not read_req_flag_d;
  tmp_0059 <= read_req_flag and tmp_0058;
  tmp_0060 <= read_req_flag or read_req_flag_d;
  tmp_0061 <= read_req_flag or read_req_flag_d;
  tmp_0062 <= '1' when readRAM_busy = '0' else '0';
  tmp_0063 <= '1' when readRAM_req_local = '0' else '0';
  tmp_0064 <= tmp_0062 and tmp_0063;
  tmp_0065 <= '1' when tmp_0064 = '1' else '0';
  tmp_0066 <= '1' when class_moduleECC_0000_doEcc_busy = '0' else '0';
  tmp_0067 <= '1' when class_moduleECC_0000_doEcc_req = '0' else '0';
  tmp_0068 <= tmp_0066 and tmp_0067;
  tmp_0069 <= '1' when tmp_0068 = '1' else '0';
  tmp_0070 <= '1' when read_method /= read_method_S_0000 else '0';
  tmp_0071 <= '1' when read_method /= read_method_S_0001 else '0';
  tmp_0072 <= tmp_0071 and read_req_flag_edge;
  tmp_0073 <= tmp_0070 and tmp_0072;
  tmp_0074 <= not writeRAM_req_flag_d;
  tmp_0075 <= writeRAM_req_flag and tmp_0074;
  tmp_0076 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0077 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0078 <= '1' when writeRAM_method /= writeRAM_method_S_0000 else '0';
  tmp_0079 <= '1' when writeRAM_method /= writeRAM_method_S_0001 else '0';
  tmp_0080 <= tmp_0079 and writeRAM_req_flag_edge;
  tmp_0081 <= tmp_0078 and tmp_0080;
  tmp_0082 <= not readRAM_req_flag_d;
  tmp_0083 <= readRAM_req_flag and tmp_0082;
  tmp_0084 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0085 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0086 <= '1' when readRAM_method /= readRAM_method_S_0000 else '0';
  tmp_0087 <= '1' when readRAM_method /= readRAM_method_S_0001 else '0';
  tmp_0088 <= tmp_0087 and readRAM_req_flag_edge;
  tmp_0089 <= tmp_0086 and tmp_0088;

  -- sequencers
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_method <= migration_method_IDLE;
        migration_method_delay <= (others => '0');
      else
        case (migration_method) is
          when migration_method_IDLE => 
            migration_method <= migration_method_S_0000;
          when migration_method_S_0000 => 
            migration_method <= migration_method_S_0001;
          when migration_method_S_0001 => 
            if tmp_0004 = '1' then
              migration_method <= migration_method_S_0002;
            end if;
          when migration_method_S_0002 => 
            migration_method <= migration_method_S_0003;
          when migration_method_S_0003 => 
            if tmp_0006 = '1' then
              migration_method <= migration_method_S_0005;
            elsif tmp_0007 = '1' then
              migration_method <= migration_method_S_0007;
            end if;
          when migration_method_S_0005 => 
            migration_method <= migration_method_S_0000;
          when migration_method_S_0007 => 
            if migration_method_delay >= 1 and u_synthesijer_div32_migration_valid = '1' then
              migration_method_delay <= (others => '0');
              migration_method <= migration_method_S_0008;
            else
              migration_method_delay <= migration_method_delay + 1;
            end if;
          when migration_method_S_0008 => 
            migration_method <= migration_method_S_0009;
          when migration_method_S_0009 => 
            if migration_method_delay >= 1 and u_synthesijer_mul32_migration_valid = '1' then
              migration_method_delay <= (others => '0');
              migration_method <= migration_method_S_0010;
            else
              migration_method_delay <= migration_method_delay + 1;
            end if;
          when migration_method_S_0010 => 
            migration_method <= migration_method_S_0012;
          when migration_method_S_0012 => 
            migration_method <= migration_method_S_0013;
          when migration_method_S_0013 => 
            if tmp_0008 = '1' then
              migration_method <= migration_method_S_0019;
            elsif tmp_0009 = '1' then
              migration_method <= migration_method_S_0000;
            end if;
          when migration_method_S_0015 => 
            migration_method <= migration_method_S_0017;
          when migration_method_S_0017 => 
            migration_method <= migration_method_S_0019;
          when migration_method_S_0019 => 
            migration_method <= migration_method_S_0020;
          when migration_method_S_0020 => 
            migration_method <= migration_method_S_0020_body;
          when migration_method_S_0021 => 
            migration_method <= migration_method_S_0024;
          when migration_method_S_0024 => 
            migration_method <= migration_method_S_0024_body;
          when migration_method_S_0020_body => 
            migration_method <= migration_method_S_0020_wait;
          when migration_method_S_0020_wait => 
            if read_call_flag_0020 = '1' then
              migration_method <= migration_method_S_0021;
            end if;
          when migration_method_S_0024_body => 
            migration_method <= migration_method_S_0024_wait;
          when migration_method_S_0024_wait => 
            if write_call_flag_0024 = '1' then
              migration_method <= migration_method_S_0015;
            end if;
          when others => null;
        end case;
        migration_req_flag_d <= migration_req_flag;
        if (tmp_0018 and tmp_0020) = '1' then
          migration_method <= migration_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_method <= write_method_IDLE;
        write_method_delay <= (others => '0');
      else
        case (write_method) is
          when write_method_IDLE => 
            write_method <= write_method_S_0000;
          when write_method_S_0000 => 
            write_method <= write_method_S_0001;
          when write_method_S_0001 => 
            if tmp_0033 = '1' then
              write_method <= write_method_S_0002;
            end if;
          when write_method_S_0002 => 
            write_method <= write_method_S_0002_body;
          when write_method_S_0003 => 
            write_method <= write_method_S_0004;
          when write_method_S_0004 => 
            if tmp_0039 = '1' then
              write_method <= write_method_S_0013;
            elsif tmp_0040 = '1' then
              write_method <= write_method_S_0010;
            elsif tmp_0041 = '1' then
              write_method <= write_method_S_0007;
            else
              write_method <= write_method_S_0000;
            end if;
          when write_method_S_0007 => 
            write_method <= write_method_S_0007_body;
          when write_method_S_0008 => 
            write_method <= write_method_S_0000;
          when write_method_S_0010 => 
            write_method <= write_method_S_0010_body;
          when write_method_S_0011 => 
            write_method <= write_method_S_0000;
          when write_method_S_0013 => 
            write_method <= write_method_S_0013_body;
          when write_method_S_0014 => 
            write_method <= write_method_S_0000;
          when write_method_S_0002_body => 
            write_method <= write_method_S_0002_wait;
          when write_method_S_0002_wait => 
            if class_moduleECC_0000_doEcc_ext_call_flag_0002 = '1' then
              write_method <= write_method_S_0003;
            end if;
          when write_method_S_0007_body => 
            write_method <= write_method_S_0007_wait;
          when write_method_S_0007_wait => 
            if writeRAM_call_flag_0007 = '1' then
              write_method <= write_method_S_0008;
            end if;
          when write_method_S_0010_body => 
            write_method <= write_method_S_0010_wait;
          when write_method_S_0010_wait => 
            if writeRAM_call_flag_0010 = '1' then
              write_method <= write_method_S_0011;
            end if;
          when write_method_S_0013_body => 
            write_method <= write_method_S_0013_wait;
          when write_method_S_0013_wait => 
            if writeRAM_call_flag_0013 = '1' then
              write_method <= write_method_S_0014;
            end if;
          when others => null;
        end case;
        write_req_flag_d <= write_req_flag;
        if (tmp_0054 and tmp_0056) = '1' then
          write_method <= write_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_method <= read_method_IDLE;
        read_method_delay <= (others => '0');
      else
        case (read_method) is
          when read_method_IDLE => 
            read_method <= read_method_S_0000;
          when read_method_S_0000 => 
            read_method <= read_method_S_0001;
          when read_method_S_0001 => 
            if tmp_0060 = '1' then
              read_method <= read_method_S_0002;
            end if;
          when read_method_S_0002 => 
            read_method <= read_method_S_0002_body;
          when read_method_S_0003 => 
            read_method <= read_method_S_0004;
          when read_method_S_0004 => 
            read_method <= read_method_S_0004_body;
          when read_method_S_0005 => 
            read_method <= read_method_S_0000;
          when read_method_S_0002_body => 
            read_method <= read_method_S_0002_wait;
          when read_method_S_0002_wait => 
            if readRAM_call_flag_0002 = '1' then
              read_method <= read_method_S_0003;
            end if;
          when read_method_S_0004_body => 
            read_method <= read_method_S_0004_wait;
          when read_method_S_0004_wait => 
            if class_moduleECC_0000_doEcc_ext_call_flag_0004 = '1' then
              read_method <= read_method_S_0005;
            end if;
          when others => null;
        end case;
        read_req_flag_d <= read_req_flag;
        if (tmp_0070 and tmp_0072) = '1' then
          read_method <= read_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_method <= writeRAM_method_IDLE;
        writeRAM_method_delay <= (others => '0');
      else
        case (writeRAM_method) is
          when writeRAM_method_IDLE => 
            writeRAM_method <= writeRAM_method_S_0000;
          when writeRAM_method_S_0000 => 
            writeRAM_method <= writeRAM_method_S_0001;
          when writeRAM_method_S_0001 => 
            if tmp_0076 = '1' then
              writeRAM_method <= writeRAM_method_S_0000;
            end if;
          when others => null;
        end case;
        writeRAM_req_flag_d <= writeRAM_req_flag;
        if (tmp_0078 and tmp_0080) = '1' then
          writeRAM_method <= writeRAM_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_method <= readRAM_method_IDLE;
        readRAM_method_delay <= (others => '0');
      else
        case (readRAM_method) is
          when readRAM_method_IDLE => 
            readRAM_method <= readRAM_method_S_0000;
          when readRAM_method_S_0000 => 
            readRAM_method <= readRAM_method_S_0001;
          when readRAM_method_S_0001 => 
            if tmp_0084 = '1' then
              readRAM_method <= readRAM_method_S_0002;
            end if;
          when readRAM_method_S_0002 => 
            readRAM_method <= readRAM_method_S_0000;
          when others => null;
        end case;
        readRAM_req_flag_d <= readRAM_req_flag;
        if (tmp_0086 and tmp_0088) = '1' then
          readRAM_method <= readRAM_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  class_moduleECC_0000_clk <= clk_sig;

  class_moduleECC_0000_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0000_doEcc_data <= (others => '0');
      else
        if write_method = write_method_S_0002_body and write_method_delay = 0 then
          class_moduleECC_0000_doEcc_data <= write_data_0025;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          class_moduleECC_0000_doEcc_data <= read_data_0037;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0000_doEcc_ecc <= (others => '0');
      else
        if write_method = write_method_S_0002_body and write_method_delay = 0 then
          class_moduleECC_0000_doEcc_ecc <= write_ecc_0026;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          class_moduleECC_0000_doEcc_ecc <= read_ecc_0036;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0000_doEcc_req <= '0';
      else
        if write_method = write_method_S_0002_body then
          class_moduleECC_0000_doEcc_req <= '1';
        elsif read_method = read_method_S_0004_body then
          class_moduleECC_0000_doEcc_req <= '1';
        else
          class_moduleECC_0000_doEcc_req <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_address_0002 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_address_0002 <= tmp_0022;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_ecc_0003 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_ecc_0003 <= tmp_0023;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_pageSize_0004 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_pageSize_0004 <= tmp_0024;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00006 <= '0';
      else
        if migration_method = migration_method_S_0002 then
          binary_expr_00006 <= tmp_0025;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00008 <= (others => '0');
      else
        if migration_method = migration_method_S_0007 and migration_method_delay >= 1 and u_synthesijer_div32_migration_valid = '1' then
          binary_expr_00008 <= u_synthesijer_div32_migration_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_position_0007 <= (others => '0');
      else
        if migration_method = migration_method_S_0008 then
          migration_position_0007 <= binary_expr_00008;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00010 <= (others => '0');
      else
        if migration_method = migration_method_S_0009 and migration_method_delay >= 1 and u_synthesijer_mul32_migration_valid = '1' then
          binary_expr_00010 <= u_synthesijer_mul32_migration_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_initialAddress_0009 <= (others => '0');
      else
        if migration_method = migration_method_S_0010 then
          migration_initialAddress_0009 <= binary_expr_00010;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_i_0011 <= X"00000000";
      else
        if migration_method = migration_method_S_0010 then
          migration_i_0011 <= X"00000000";
        elsif migration_method = migration_method_S_0017 then
          migration_i_0011 <= unary_expr_00014;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00013 <= '0';
      else
        if migration_method = migration_method_S_0012 then
          binary_expr_00013 <= tmp_0026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_00014 <= (others => '0');
      else
        if migration_method = migration_method_S_0015 then
          unary_expr_00014 <= tmp_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_postfix_preserved_00015 <= (others => '0');
      else
        if migration_method = migration_method_S_0015 then
          unary_expr_postfix_preserved_00015 <= migration_i_0011;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00018 <= (others => '0');
      else
        if migration_method = migration_method_S_0020_wait then
          method_result_00018 <= read_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00019 <= (others => '0');
      else
        if migration_method = migration_method_S_0019 then
          binary_expr_00019 <= tmp_0028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_read_0017 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          migration_read_0017 <= method_result_00018;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00021 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          binary_expr_00021 <= tmp_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00023 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          binary_expr_00023 <= tmp_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_address_0024 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_address_0024 <= write_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_address_local <= (others => '0');
      else
        if migration_method = migration_method_S_0024_body and migration_method_delay = 0 then
          write_address_local <= binary_expr_00021;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_data_0025 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_data_0025 <= write_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_data_local <= (others => '0');
      else
        if migration_method = migration_method_S_0024_body and migration_method_delay = 0 then
          write_data_local <= migration_read_0017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_ecc_0026 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_ecc_0026 <= write_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_ecc_local <= (others => '0');
      else
        if migration_method = migration_method_S_0024_body and migration_method_delay = 0 then
          write_ecc_local <= binary_expr_00023;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00028 <= (others => '0');
      else
        if write_method = write_method_S_0002_wait then
          method_result_00028 <= class_moduleECC_0000_doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_newData_0027 <= (others => '0');
      else
        if write_method = write_method_S_0003 then
          write_newData_0027 <= method_result_00028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_address_0035 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_address_0035 <= read_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_address_local <= (others => '0');
      else
        if migration_method = migration_method_S_0020_body and migration_method_delay = 0 then
          read_address_local <= binary_expr_00019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_ecc_0036 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_ecc_0036 <= read_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_ecc_local <= (others => '0');
      else
        if migration_method = migration_method_S_0020_body and migration_method_delay = 0 then
          read_ecc_local <= migration_ecc_0003;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00038 <= (others => '0');
      else
        if read_method = read_method_S_0002_wait then
          method_result_00038 <= readRAM_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_data_0037 <= (others => '0');
      else
        if read_method = read_method_S_0003 then
          read_data_0037 <= method_result_00038;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00039 <= (others => '0');
      else
        if read_method = read_method_S_0004_wait then
          method_result_00039 <= class_moduleECC_0000_doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_address_0040 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_address_0040 <= writeRAM_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_address_local <= (others => '0');
      else
        if write_method = write_method_S_0007_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0024;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0024;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0024;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_data_0041 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_data_0041 <= writeRAM_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_data_local <= (others => '0');
      else
        if write_method = write_method_S_0007_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0027;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0027;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_address_0042 <= (others => '0');
      else
        if readRAM_method = readRAM_method_S_0001 then
          readRAM_address_0042 <= readRAM_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_address_local <= (others => '0');
      else
        if read_method = read_method_S_0002_body and read_method_delay = 0 then
          readRAM_address_local <= read_address_0035;
        end if;
      end if;
    end if;
  end process;

  migration_req_flag <= tmp_0001;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_busy <= '0';
      else
        if write_method = write_method_S_0000 then
          write_busy <= '0';
        elsif write_method = write_method_S_0001 then
          write_busy <= tmp_0034;
        end if;
      end if;
    end if;
  end process;

  write_req_flag <= write_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_req_local <= '0';
      else
        if migration_method = migration_method_S_0024_body then
          write_req_local <= '1';
        else
          write_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_return <= (others => '0');
      else
        if read_method = read_method_S_0005 then
          read_return <= method_result_00039;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_busy <= '0';
      else
        if read_method = read_method_S_0000 then
          read_busy <= '0';
        elsif read_method = read_method_S_0001 then
          read_busy <= tmp_0061;
        end if;
      end if;
    end if;
  end process;

  read_req_flag <= read_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_req_local <= '0';
      else
        if migration_method = migration_method_S_0020_body then
          read_req_local <= '1';
        else
          read_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_busy <= '0';
      else
        if writeRAM_method = writeRAM_method_S_0000 then
          writeRAM_busy <= '0';
        elsif writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_busy <= tmp_0077;
        end if;
      end if;
    end if;
  end process;

  writeRAM_req_flag <= writeRAM_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_req_local <= '0';
      else
        if write_method = write_method_S_0007_body then
          writeRAM_req_local <= '1';
        elsif write_method = write_method_S_0010_body then
          writeRAM_req_local <= '1';
        elsif write_method = write_method_S_0013_body then
          writeRAM_req_local <= '1';
        else
          writeRAM_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_return <= (others => '0');
      else
        if readRAM_method = readRAM_method_S_0002 then
          readRAM_return <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_busy <= '0';
      else
        if readRAM_method = readRAM_method_S_0000 then
          readRAM_busy <= '0';
        elsif readRAM_method = readRAM_method_S_0001 then
          readRAM_busy <= tmp_0085;
        end if;
      end if;
    end if;
  end process;

  readRAM_req_flag <= readRAM_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_req_local <= '0';
      else
        if read_method = read_method_S_0002_body then
          readRAM_req_local <= '1';
        else
          readRAM_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  migration_req_flag_edge <= tmp_0003;

  u_synthesijer_div32_migration_clk <= clk_sig;

  u_synthesijer_div32_migration_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_migration_a <= (others => '0');
      else
        if migration_method = migration_method_S_0007 and migration_method_delay = 0 then
          u_synthesijer_div32_migration_a <= migration_address_0002;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_migration_b <= X"00000001";
      else
        if migration_method = migration_method_S_0007 and migration_method_delay = 0 then
          u_synthesijer_div32_migration_b <= migration_pageSize_0004;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_migration_nd <= '0';
      else
        if migration_method = migration_method_S_0007 and migration_method_delay = 0 then
          u_synthesijer_div32_migration_nd <= '1';
        else
          u_synthesijer_div32_migration_nd <= '0';
        end if;
      end if;
    end if;
  end process;

  u_synthesijer_mul32_migration_clk <= clk_sig;

  u_synthesijer_mul32_migration_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_mul32_migration_a <= (others => '0');
      else
        if migration_method = migration_method_S_0009 and migration_method_delay = 0 then
          u_synthesijer_mul32_migration_a <= migration_position_0007;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_mul32_migration_b <= (others => '0');
      else
        if migration_method = migration_method_S_0009 and migration_method_delay = 0 then
          u_synthesijer_mul32_migration_b <= migration_pageSize_0004;
        end if;
      end if;
    end if;
  end process;

  read_call_flag_0020 <= tmp_0013;

  write_call_flag_0024 <= tmp_0017;

  write_req_flag_edge <= tmp_0032;

  class_moduleECC_0000_doEcc_ext_call_flag_0002 <= tmp_0038;

  writeRAM_call_flag_0007 <= tmp_0045;

  writeRAM_call_flag_0010 <= tmp_0049;

  writeRAM_call_flag_0013 <= tmp_0053;

  read_req_flag_edge <= tmp_0059;

  readRAM_call_flag_0002 <= tmp_0065;

  class_moduleECC_0000_doEcc_ext_call_flag_0004 <= tmp_0069;

  writeRAM_req_flag_edge <= tmp_0075;

  readRAM_req_flag_edge <= tmp_0083;


  inst_class_moduleECC_0000 : moduledynamic_ModuleECC
  port map(
    clk => clk,
    reset => reset,
    checkECC_data => class_moduleECC_0000_checkECC_data,
    checkECC_ecc => class_moduleECC_0000_checkECC_ecc,
    doEcc_data => class_moduleECC_0000_doEcc_data,
    doEcc_ecc => class_moduleECC_0000_doEcc_ecc,
    checkECC_return => class_moduleECC_0000_checkECC_return,
    checkECC_busy => class_moduleECC_0000_checkECC_busy,
    checkECC_req => class_moduleECC_0000_checkECC_req,
    doEcc_return => class_moduleECC_0000_doEcc_return,
    doEcc_busy => class_moduleECC_0000_doEcc_busy,
    doEcc_req => class_moduleECC_0000_doEcc_req
  );

  inst_u_synthesijer_div32_migration : synthesijer_div32
  port map(
    clk => clk,
    reset => reset,
    a => u_synthesijer_div32_migration_a,
    b => u_synthesijer_div32_migration_b,
    nd => u_synthesijer_div32_migration_nd,
    quantient => u_synthesijer_div32_migration_quantient,
    remainder => u_synthesijer_div32_migration_remainder,
    valid => u_synthesijer_div32_migration_valid
  );

  inst_u_synthesijer_mul32_migration : synthesijer_mul32
  port map(
    clk => clk,
    reset => reset,
    a => u_synthesijer_mul32_migration_a,
    b => u_synthesijer_mul32_migration_b,
    nd => u_synthesijer_mul32_migration_nd,
    result => u_synthesijer_mul32_migration_result,
    valid => u_synthesijer_mul32_migration_valid
  );


end RTL;
