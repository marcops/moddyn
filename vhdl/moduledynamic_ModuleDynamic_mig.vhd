library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleDynamic_mig is
  port (
    clk : in std_logic;
    reset : in std_logic;
    migration_address : in signed(32-1 downto 0);
    migration_ecc : in signed(32-1 downto 0);
    migration_pageSize : in signed(32-1 downto 0);
    migration_busy : out std_logic;
    migration_req : in std_logic
  );
end moduledynamic_ModuleDynamic_mig;

architecture RTL of moduledynamic_ModuleDynamic_mig is

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
  signal incrementEcc_position_0008 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_position_local : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_0009 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal array_access_00015 : std_logic := '0';
  signal array_access_00017 : std_logic := '0';
  signal array_access_00019 : std_logic := '0';
  signal array_access_00021 : std_logic := '0';
  signal array_access_00023 : std_logic := '0';
  signal array_access_00025 : std_logic := '0';
  signal array_access_00027 : std_logic := '0';
  signal array_access_00029 : std_logic := '0';
  signal migration_address_0030 : signed(32-1 downto 0) := (others => '0');
  signal migration_address_local : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_0031 : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_0032 : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00034 : std_logic := '0';
  signal binary_expr_00036 : signed(32-1 downto 0) := (others => '0');
  signal migration_position_0035 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00038 : signed(32-1 downto 0) := (others => '0');
  signal migration_initialAddress_0037 : signed(32-1 downto 0) := (others => '0');
  signal migration_i_0039 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00041 : std_logic := '0';
  signal unary_expr_00042 : signed(32-1 downto 0) := (others => '0');
  signal unary_expr_postfix_preserved_00043 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00046 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00047 : signed(32-1 downto 0) := (others => '0');
  signal migration_read_0045 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00049 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00051 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00054 : signed(32-1 downto 0) := (others => '0');
  signal write_address_0055 : signed(32-1 downto 0) := (others => '0');
  signal write_address_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_0056 : signed(32-1 downto 0) := (others => '0');
  signal write_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_0057 : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00059 : signed(32-1 downto 0) := (others => '0');
  signal write_newData_0058 : signed(32-1 downto 0) := (others => '0');
  signal read_address_0066 : signed(32-1 downto 0) := (others => '0');
  signal read_address_local : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_0067 : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00069 : signed(32-1 downto 0) := (others => '0');
  signal read_data_0068 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00070 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_0071 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_0072 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_local : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_0073 : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_0075 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_0076 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00081 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00082 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00083 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_0084 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_0085 : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_0086 : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_busy : std_logic := '0';
  signal incrementEcc_req_flag : std_logic := '0';
  signal incrementEcc_req_local : std_logic := '0';
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
  signal doEcc_return : signed(32-1 downto 0) := (others => '0');
  signal doEcc_busy : std_logic := '0';
  signal doEcc_req_flag : std_logic := '0';
  signal doEcc_req_local : std_logic := '0';
  signal doReedSolomon_return : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_busy : std_logic := '0';
  signal doReedSolomon_req_flag : std_logic := '0';
  signal doReedSolomon_req_local : std_logic := '0';
  signal doHamming_return : signed(32-1 downto 0) := (others => '0');
  signal doHamming_busy : std_logic := '0';
  signal doHamming_req_flag : std_logic := '0';
  signal doHamming_req_local : std_logic := '0';
  signal doParity_return : signed(32-1 downto 0) := (others => '0');
  signal doParity_busy : std_logic := '0';
  signal doParity_req_flag : std_logic := '0';
  signal doParity_req_local : std_logic := '0';
  type Type_incrementEcc_method is (
    incrementEcc_method_IDLE,
    incrementEcc_method_S_0000,
    incrementEcc_method_S_0001,
    incrementEcc_method_S_0002,
    incrementEcc_method_S_0005,
    incrementEcc_method_S_0007,
    incrementEcc_method_S_0009,
    incrementEcc_method_S_0011,
    incrementEcc_method_S_0013,
    incrementEcc_method_S_0015,
    incrementEcc_method_S_0017,
    incrementEcc_method_S_0019,
    incrementEcc_method_S_0021,
    incrementEcc_method_S_0023,
    incrementEcc_method_S_0025,
    incrementEcc_method_S_0027  
  );
  signal incrementEcc_method : Type_incrementEcc_method := incrementEcc_method_IDLE;
  signal incrementEcc_method_prev : Type_incrementEcc_method := incrementEcc_method_IDLE;
  signal incrementEcc_method_delay : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_req_flag_d : std_logic := '0';
  signal incrementEcc_req_flag_edge : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
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
    migration_method_S_0026,
    migration_method_S_0027,
    migration_method_S_0020_body,
    migration_method_S_0020_wait,
    migration_method_S_0024_body,
    migration_method_S_0024_wait,
    migration_method_S_0027_body,
    migration_method_S_0027_wait  
  );
  signal migration_method : Type_migration_method := migration_method_IDLE;
  signal migration_method_prev : Type_migration_method := migration_method_IDLE;
  signal migration_method_delay : signed(32-1 downto 0) := (others => '0');
  signal migration_req_flag_d : std_logic := '0';
  signal migration_req_flag_edge : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
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
  signal tmp_0020 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal read_call_flag_0020 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal write_call_flag_0024 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : std_logic := '0';
  signal tmp_0028 : std_logic := '0';
  signal tmp_0029 : std_logic := '0';
  signal incrementEcc_call_flag_0027 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0039 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0040 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0044 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0045 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0046 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0047 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal doEcc_call_flag_0002 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal writeRAM_call_flag_0007 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal writeRAM_call_flag_0010 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal writeRAM_call_flag_0013 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
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
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
  signal readRAM_call_flag_0002 : std_logic := '0';
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal doEcc_call_flag_0004 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
  signal tmp_0086 : std_logic := '0';
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
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
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
  signal tmp_0094 : std_logic := '0';
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
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
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
  signal tmp_0106 : std_logic := '0';
  type Type_doEcc_method is (
    doEcc_method_IDLE,
    doEcc_method_S_0000,
    doEcc_method_S_0001,
    doEcc_method_S_0002,
    doEcc_method_S_0005,
    doEcc_method_S_0006,
    doEcc_method_S_0008,
    doEcc_method_S_0009,
    doEcc_method_S_0011,
    doEcc_method_S_0012,
    doEcc_method_S_0014,
    doEcc_method_S_0005_body,
    doEcc_method_S_0005_wait,
    doEcc_method_S_0008_body,
    doEcc_method_S_0008_wait,
    doEcc_method_S_0011_body,
    doEcc_method_S_0011_wait  
  );
  signal doEcc_method : Type_doEcc_method := doEcc_method_IDLE;
  signal doEcc_method_prev : Type_doEcc_method := doEcc_method_IDLE;
  signal doEcc_method_delay : signed(32-1 downto 0) := (others => '0');
  signal doEcc_req_flag_d : std_logic := '0';
  signal doEcc_req_flag_edge : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : std_logic := '0';
  signal tmp_0113 : std_logic := '0';
  signal tmp_0114 : std_logic := '0';
  signal doReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0115 : std_logic := '0';
  signal tmp_0116 : std_logic := '0';
  signal tmp_0117 : std_logic := '0';
  signal tmp_0118 : std_logic := '0';
  signal doHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
  signal tmp_0122 : std_logic := '0';
  signal doParity_call_flag_0011 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
  signal tmp_0126 : std_logic := '0';
  signal tmp_0127 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
  signal tmp_0130 : std_logic := '0';
  type Type_doReedSolomon_method is (
    doReedSolomon_method_IDLE,
    doReedSolomon_method_S_0000,
    doReedSolomon_method_S_0001,
    doReedSolomon_method_S_0002  
  );
  signal doReedSolomon_method : Type_doReedSolomon_method := doReedSolomon_method_IDLE;
  signal doReedSolomon_method_prev : Type_doReedSolomon_method := doReedSolomon_method_IDLE;
  signal doReedSolomon_method_delay : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_req_flag_d : std_logic := '0';
  signal doReedSolomon_req_flag_edge : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
  signal tmp_0134 : std_logic := '0';
  signal tmp_0135 : std_logic := '0';
  signal tmp_0136 : std_logic := '0';
  signal tmp_0137 : std_logic := '0';
  signal tmp_0138 : std_logic := '0';
  type Type_doHamming_method is (
    doHamming_method_IDLE,
    doHamming_method_S_0000,
    doHamming_method_S_0001,
    doHamming_method_S_0002  
  );
  signal doHamming_method : Type_doHamming_method := doHamming_method_IDLE;
  signal doHamming_method_prev : Type_doHamming_method := doHamming_method_IDLE;
  signal doHamming_method_delay : signed(32-1 downto 0) := (others => '0');
  signal doHamming_req_flag_d : std_logic := '0';
  signal doHamming_req_flag_edge : std_logic := '0';
  signal tmp_0139 : std_logic := '0';
  signal tmp_0140 : std_logic := '0';
  signal tmp_0141 : std_logic := '0';
  signal tmp_0142 : std_logic := '0';
  signal tmp_0143 : std_logic := '0';
  signal tmp_0144 : std_logic := '0';
  signal tmp_0145 : std_logic := '0';
  signal tmp_0146 : std_logic := '0';
  type Type_doParity_method is (
    doParity_method_IDLE,
    doParity_method_S_0000,
    doParity_method_S_0001,
    doParity_method_S_0002  
  );
  signal doParity_method : Type_doParity_method := doParity_method_IDLE;
  signal doParity_method_prev : Type_doParity_method := doParity_method_IDLE;
  signal doParity_method_delay : signed(32-1 downto 0) := (others => '0');
  signal doParity_req_flag_d : std_logic := '0';
  signal doParity_req_flag_edge : std_logic := '0';
  signal tmp_0147 : std_logic := '0';
  signal tmp_0148 : std_logic := '0';
  signal tmp_0149 : std_logic := '0';
  signal tmp_0150 : std_logic := '0';
  signal tmp_0151 : std_logic := '0';
  signal tmp_0152 : std_logic := '0';
  signal tmp_0153 : std_logic := '0';
  signal tmp_0154 : std_logic := '0';

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
          migration_busy_sig <= tmp_0017;
        end if;
      end if;
    end if;
  end process;

  migration_req_sig <= migration_req;

  -- expressions
  tmp_0001 <= migration_req_local or migration_req_sig;
  tmp_0002 <= not incrementEcc_req_flag_d;
  tmp_0003 <= incrementEcc_req_flag and tmp_0002;
  tmp_0004 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0005 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0006 <= '1' when incrementEcc_ecc_0009 = X"00000000" else '0';
  tmp_0007 <= '1' when incrementEcc_ecc_0009 = X"00000001" else '0';
  tmp_0008 <= '1' when incrementEcc_ecc_0009 = X"00000002" else '0';
  tmp_0009 <= '1' when incrementEcc_ecc_0009 = X"00000003" else '0';
  tmp_0010 <= '1' when incrementEcc_method /= incrementEcc_method_S_0000 else '0';
  tmp_0011 <= '1' when incrementEcc_method /= incrementEcc_method_S_0001 else '0';
  tmp_0012 <= tmp_0011 and incrementEcc_req_flag_edge;
  tmp_0013 <= tmp_0010 and tmp_0012;
  tmp_0014 <= not migration_req_flag_d;
  tmp_0015 <= migration_req_flag and tmp_0014;
  tmp_0016 <= migration_req_flag or migration_req_flag_d;
  tmp_0017 <= migration_req_flag or migration_req_flag_d;
  tmp_0018 <= '1' when binary_expr_00034 = '1' else '0';
  tmp_0019 <= '1' when binary_expr_00034 = '0' else '0';
  tmp_0020 <= '1' when binary_expr_00041 = '1' else '0';
  tmp_0021 <= '1' when binary_expr_00041 = '0' else '0';
  tmp_0022 <= '1' when read_busy = '0' else '0';
  tmp_0023 <= '1' when read_req_local = '0' else '0';
  tmp_0024 <= tmp_0022 and tmp_0023;
  tmp_0025 <= '1' when tmp_0024 = '1' else '0';
  tmp_0026 <= '1' when write_busy = '0' else '0';
  tmp_0027 <= '1' when write_req_local = '0' else '0';
  tmp_0028 <= tmp_0026 and tmp_0027;
  tmp_0029 <= '1' when tmp_0028 = '1' else '0';
  tmp_0030 <= '1' when incrementEcc_busy = '0' else '0';
  tmp_0031 <= '1' when incrementEcc_req_local = '0' else '0';
  tmp_0032 <= tmp_0030 and tmp_0031;
  tmp_0033 <= '1' when tmp_0032 = '1' else '0';
  tmp_0034 <= '1' when migration_method /= migration_method_S_0000 else '0';
  tmp_0035 <= '1' when migration_method /= migration_method_S_0001 else '0';
  tmp_0036 <= tmp_0035 and migration_req_flag_edge;
  tmp_0037 <= tmp_0034 and tmp_0036;
  tmp_0038 <= migration_address_sig when migration_req_sig = '1' else migration_address_local;
  tmp_0039 <= migration_ecc_sig when migration_req_sig = '1' else migration_ecc_local;
  tmp_0040 <= migration_pageSize_sig when migration_req_sig = '1' else migration_pageSize_local;
  tmp_0041 <= '1' when migration_ecc_0031 = X"00000003" else '0';
  tmp_0042 <= '1' when migration_i_0039 < migration_pageSize_0032 else '0';
  tmp_0043 <= migration_i_0039 + X"00000001";
  tmp_0044 <= migration_initialAddress_0037 + migration_i_0039;
  tmp_0045 <= migration_initialAddress_0037 + migration_i_0039;
  tmp_0046 <= migration_ecc_0031 + X"00000001";
  tmp_0047 <= migration_ecc_0031 + X"00000001";
  tmp_0048 <= not write_req_flag_d;
  tmp_0049 <= write_req_flag and tmp_0048;
  tmp_0050 <= write_req_flag or write_req_flag_d;
  tmp_0051 <= write_req_flag or write_req_flag_d;
  tmp_0052 <= '1' when doEcc_busy = '0' else '0';
  tmp_0053 <= '1' when doEcc_req_local = '0' else '0';
  tmp_0054 <= tmp_0052 and tmp_0053;
  tmp_0055 <= '1' when tmp_0054 = '1' else '0';
  tmp_0056 <= '1' when write_ecc_0057 = X"00000001" else '0';
  tmp_0057 <= '1' when write_ecc_0057 = X"00000002" else '0';
  tmp_0058 <= '1' when write_ecc_0057 = X"00000003" else '0';
  tmp_0059 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0060 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0061 <= tmp_0059 and tmp_0060;
  tmp_0062 <= '1' when tmp_0061 = '1' else '0';
  tmp_0063 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0064 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0065 <= tmp_0063 and tmp_0064;
  tmp_0066 <= '1' when tmp_0065 = '1' else '0';
  tmp_0067 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0068 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0069 <= tmp_0067 and tmp_0068;
  tmp_0070 <= '1' when tmp_0069 = '1' else '0';
  tmp_0071 <= '1' when write_method /= write_method_S_0000 else '0';
  tmp_0072 <= '1' when write_method /= write_method_S_0001 else '0';
  tmp_0073 <= tmp_0072 and write_req_flag_edge;
  tmp_0074 <= tmp_0071 and tmp_0073;
  tmp_0075 <= not read_req_flag_d;
  tmp_0076 <= read_req_flag and tmp_0075;
  tmp_0077 <= read_req_flag or read_req_flag_d;
  tmp_0078 <= read_req_flag or read_req_flag_d;
  tmp_0079 <= '1' when readRAM_busy = '0' else '0';
  tmp_0080 <= '1' when readRAM_req_local = '0' else '0';
  tmp_0081 <= tmp_0079 and tmp_0080;
  tmp_0082 <= '1' when tmp_0081 = '1' else '0';
  tmp_0083 <= '1' when doEcc_busy = '0' else '0';
  tmp_0084 <= '1' when doEcc_req_local = '0' else '0';
  tmp_0085 <= tmp_0083 and tmp_0084;
  tmp_0086 <= '1' when tmp_0085 = '1' else '0';
  tmp_0087 <= '1' when read_method /= read_method_S_0000 else '0';
  tmp_0088 <= '1' when read_method /= read_method_S_0001 else '0';
  tmp_0089 <= tmp_0088 and read_req_flag_edge;
  tmp_0090 <= tmp_0087 and tmp_0089;
  tmp_0091 <= not writeRAM_req_flag_d;
  tmp_0092 <= writeRAM_req_flag and tmp_0091;
  tmp_0093 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0094 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0095 <= '1' when writeRAM_method /= writeRAM_method_S_0000 else '0';
  tmp_0096 <= '1' when writeRAM_method /= writeRAM_method_S_0001 else '0';
  tmp_0097 <= tmp_0096 and writeRAM_req_flag_edge;
  tmp_0098 <= tmp_0095 and tmp_0097;
  tmp_0099 <= not readRAM_req_flag_d;
  tmp_0100 <= readRAM_req_flag and tmp_0099;
  tmp_0101 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0102 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0103 <= '1' when readRAM_method /= readRAM_method_S_0000 else '0';
  tmp_0104 <= '1' when readRAM_method /= readRAM_method_S_0001 else '0';
  tmp_0105 <= tmp_0104 and readRAM_req_flag_edge;
  tmp_0106 <= tmp_0103 and tmp_0105;
  tmp_0107 <= not doEcc_req_flag_d;
  tmp_0108 <= doEcc_req_flag and tmp_0107;
  tmp_0109 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0110 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0111 <= '1' when doEcc_ecc_0076 = X"00000000" else '0';
  tmp_0112 <= '1' when doEcc_ecc_0076 = X"00000001" else '0';
  tmp_0113 <= '1' when doEcc_ecc_0076 = X"00000002" else '0';
  tmp_0114 <= '1' when doEcc_ecc_0076 = X"00000003" else '0';
  tmp_0115 <= '1' when doReedSolomon_busy = '0' else '0';
  tmp_0116 <= '1' when doReedSolomon_req_local = '0' else '0';
  tmp_0117 <= tmp_0115 and tmp_0116;
  tmp_0118 <= '1' when tmp_0117 = '1' else '0';
  tmp_0119 <= '1' when doHamming_busy = '0' else '0';
  tmp_0120 <= '1' when doHamming_req_local = '0' else '0';
  tmp_0121 <= tmp_0119 and tmp_0120;
  tmp_0122 <= '1' when tmp_0121 = '1' else '0';
  tmp_0123 <= '1' when doParity_busy = '0' else '0';
  tmp_0124 <= '1' when doParity_req_local = '0' else '0';
  tmp_0125 <= tmp_0123 and tmp_0124;
  tmp_0126 <= '1' when tmp_0125 = '1' else '0';
  tmp_0127 <= '1' when doEcc_method /= doEcc_method_S_0000 else '0';
  tmp_0128 <= '1' when doEcc_method /= doEcc_method_S_0001 else '0';
  tmp_0129 <= tmp_0128 and doEcc_req_flag_edge;
  tmp_0130 <= tmp_0127 and tmp_0129;
  tmp_0131 <= not doReedSolomon_req_flag_d;
  tmp_0132 <= doReedSolomon_req_flag and tmp_0131;
  tmp_0133 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0134 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0135 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0000 else '0';
  tmp_0136 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0001 else '0';
  tmp_0137 <= tmp_0136 and doReedSolomon_req_flag_edge;
  tmp_0138 <= tmp_0135 and tmp_0137;
  tmp_0139 <= not doHamming_req_flag_d;
  tmp_0140 <= doHamming_req_flag and tmp_0139;
  tmp_0141 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0142 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0143 <= '1' when doHamming_method /= doHamming_method_S_0000 else '0';
  tmp_0144 <= '1' when doHamming_method /= doHamming_method_S_0001 else '0';
  tmp_0145 <= tmp_0144 and doHamming_req_flag_edge;
  tmp_0146 <= tmp_0143 and tmp_0145;
  tmp_0147 <= not doParity_req_flag_d;
  tmp_0148 <= doParity_req_flag and tmp_0147;
  tmp_0149 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0150 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0151 <= '1' when doParity_method /= doParity_method_S_0000 else '0';
  tmp_0152 <= '1' when doParity_method /= doParity_method_S_0001 else '0';
  tmp_0153 <= tmp_0152 and doParity_req_flag_edge;
  tmp_0154 <= tmp_0151 and tmp_0153;

  -- sequencers
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_method <= incrementEcc_method_IDLE;
        incrementEcc_method_delay <= (others => '0');
      else
        case (incrementEcc_method) is
          when incrementEcc_method_IDLE => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0000 => 
            incrementEcc_method <= incrementEcc_method_S_0001;
          when incrementEcc_method_S_0001 => 
            if tmp_0004 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0002;
            end if;
          when incrementEcc_method_S_0002 => 
            if tmp_0006 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0023;
            elsif tmp_0007 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0017;
            elsif tmp_0008 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0011;
            elsif tmp_0009 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0005;
            else
              incrementEcc_method <= incrementEcc_method_S_0000;
            end if;
          when incrementEcc_method_S_0005 => 
            incrementEcc_method <= incrementEcc_method_S_0007;
          when incrementEcc_method_S_0007 => 
            incrementEcc_method <= incrementEcc_method_S_0009;
          when incrementEcc_method_S_0009 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0011 => 
            incrementEcc_method <= incrementEcc_method_S_0013;
          when incrementEcc_method_S_0013 => 
            incrementEcc_method <= incrementEcc_method_S_0015;
          when incrementEcc_method_S_0015 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0017 => 
            incrementEcc_method <= incrementEcc_method_S_0019;
          when incrementEcc_method_S_0019 => 
            incrementEcc_method <= incrementEcc_method_S_0021;
          when incrementEcc_method_S_0021 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0023 => 
            incrementEcc_method <= incrementEcc_method_S_0025;
          when incrementEcc_method_S_0025 => 
            incrementEcc_method <= incrementEcc_method_S_0027;
          when incrementEcc_method_S_0027 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when others => null;
        end case;
        incrementEcc_req_flag_d <= incrementEcc_req_flag;
        if (tmp_0010 and tmp_0012) = '1' then
          incrementEcc_method <= incrementEcc_method_S_0001;
        end if;
      end if;
    end if;
  end process;

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
            if tmp_0016 = '1' then
              migration_method <= migration_method_S_0002;
            end if;
          when migration_method_S_0002 => 
            migration_method <= migration_method_S_0003;
          when migration_method_S_0003 => 
            if tmp_0018 = '1' then
              migration_method <= migration_method_S_0005;
            elsif tmp_0019 = '1' then
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
            if tmp_0020 = '1' then
              migration_method <= migration_method_S_0019;
            elsif tmp_0021 = '1' then
              migration_method <= migration_method_S_0026;
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
          when migration_method_S_0026 => 
            migration_method <= migration_method_S_0027;
          when migration_method_S_0027 => 
            migration_method <= migration_method_S_0027_body;
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
          when migration_method_S_0027_body => 
            migration_method <= migration_method_S_0027_wait;
          when migration_method_S_0027_wait => 
            if incrementEcc_call_flag_0027 = '1' then
              migration_method <= migration_method_S_0000;
            end if;
          when others => null;
        end case;
        migration_req_flag_d <= migration_req_flag;
        if (tmp_0034 and tmp_0036) = '1' then
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
            if tmp_0050 = '1' then
              write_method <= write_method_S_0002;
            end if;
          when write_method_S_0002 => 
            write_method <= write_method_S_0002_body;
          when write_method_S_0003 => 
            write_method <= write_method_S_0004;
          when write_method_S_0004 => 
            if tmp_0056 = '1' then
              write_method <= write_method_S_0013;
            elsif tmp_0057 = '1' then
              write_method <= write_method_S_0010;
            elsif tmp_0058 = '1' then
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
            if doEcc_call_flag_0002 = '1' then
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
        if (tmp_0071 and tmp_0073) = '1' then
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
            if tmp_0077 = '1' then
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
            if doEcc_call_flag_0004 = '1' then
              read_method <= read_method_S_0005;
            end if;
          when others => null;
        end case;
        read_req_flag_d <= read_req_flag;
        if (tmp_0087 and tmp_0089) = '1' then
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
            if tmp_0093 = '1' then
              writeRAM_method <= writeRAM_method_S_0000;
            end if;
          when others => null;
        end case;
        writeRAM_req_flag_d <= writeRAM_req_flag;
        if (tmp_0095 and tmp_0097) = '1' then
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
            if tmp_0101 = '1' then
              readRAM_method <= readRAM_method_S_0002;
            end if;
          when readRAM_method_S_0002 => 
            readRAM_method <= readRAM_method_S_0000;
          when others => null;
        end case;
        readRAM_req_flag_d <= readRAM_req_flag;
        if (tmp_0103 and tmp_0105) = '1' then
          readRAM_method <= readRAM_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_method <= doEcc_method_IDLE;
        doEcc_method_delay <= (others => '0');
      else
        case (doEcc_method) is
          when doEcc_method_IDLE => 
            doEcc_method <= doEcc_method_S_0000;
          when doEcc_method_S_0000 => 
            doEcc_method <= doEcc_method_S_0001;
          when doEcc_method_S_0001 => 
            if tmp_0109 = '1' then
              doEcc_method <= doEcc_method_S_0002;
            end if;
          when doEcc_method_S_0002 => 
            if tmp_0111 = '1' then
              doEcc_method <= doEcc_method_S_0014;
            elsif tmp_0112 = '1' then
              doEcc_method <= doEcc_method_S_0011;
            elsif tmp_0113 = '1' then
              doEcc_method <= doEcc_method_S_0008;
            elsif tmp_0114 = '1' then
              doEcc_method <= doEcc_method_S_0005;
            else
              doEcc_method <= doEcc_method_S_0000;
            end if;
          when doEcc_method_S_0005 => 
            doEcc_method <= doEcc_method_S_0005_body;
          when doEcc_method_S_0006 => 
            doEcc_method <= doEcc_method_S_0000;
          when doEcc_method_S_0008 => 
            doEcc_method <= doEcc_method_S_0008_body;
          when doEcc_method_S_0009 => 
            doEcc_method <= doEcc_method_S_0000;
          when doEcc_method_S_0011 => 
            doEcc_method <= doEcc_method_S_0011_body;
          when doEcc_method_S_0012 => 
            doEcc_method <= doEcc_method_S_0000;
          when doEcc_method_S_0014 => 
            doEcc_method <= doEcc_method_S_0000;
          when doEcc_method_S_0005_body => 
            doEcc_method <= doEcc_method_S_0005_wait;
          when doEcc_method_S_0005_wait => 
            if doReedSolomon_call_flag_0005 = '1' then
              doEcc_method <= doEcc_method_S_0006;
            end if;
          when doEcc_method_S_0008_body => 
            doEcc_method <= doEcc_method_S_0008_wait;
          when doEcc_method_S_0008_wait => 
            if doHamming_call_flag_0008 = '1' then
              doEcc_method <= doEcc_method_S_0009;
            end if;
          when doEcc_method_S_0011_body => 
            doEcc_method <= doEcc_method_S_0011_wait;
          when doEcc_method_S_0011_wait => 
            if doParity_call_flag_0011 = '1' then
              doEcc_method <= doEcc_method_S_0012;
            end if;
          when others => null;
        end case;
        doEcc_req_flag_d <= doEcc_req_flag;
        if (tmp_0127 and tmp_0129) = '1' then
          doEcc_method <= doEcc_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_method <= doReedSolomon_method_IDLE;
        doReedSolomon_method_delay <= (others => '0');
      else
        case (doReedSolomon_method) is
          when doReedSolomon_method_IDLE => 
            doReedSolomon_method <= doReedSolomon_method_S_0000;
          when doReedSolomon_method_S_0000 => 
            doReedSolomon_method <= doReedSolomon_method_S_0001;
          when doReedSolomon_method_S_0001 => 
            if tmp_0133 = '1' then
              doReedSolomon_method <= doReedSolomon_method_S_0002;
            end if;
          when doReedSolomon_method_S_0002 => 
            doReedSolomon_method <= doReedSolomon_method_S_0000;
          when others => null;
        end case;
        doReedSolomon_req_flag_d <= doReedSolomon_req_flag;
        if (tmp_0135 and tmp_0137) = '1' then
          doReedSolomon_method <= doReedSolomon_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_method <= doHamming_method_IDLE;
        doHamming_method_delay <= (others => '0');
      else
        case (doHamming_method) is
          when doHamming_method_IDLE => 
            doHamming_method <= doHamming_method_S_0000;
          when doHamming_method_S_0000 => 
            doHamming_method <= doHamming_method_S_0001;
          when doHamming_method_S_0001 => 
            if tmp_0141 = '1' then
              doHamming_method <= doHamming_method_S_0002;
            end if;
          when doHamming_method_S_0002 => 
            doHamming_method <= doHamming_method_S_0000;
          when others => null;
        end case;
        doHamming_req_flag_d <= doHamming_req_flag;
        if (tmp_0143 and tmp_0145) = '1' then
          doHamming_method <= doHamming_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_method <= doParity_method_IDLE;
        doParity_method_delay <= (others => '0');
      else
        case (doParity_method) is
          when doParity_method_IDLE => 
            doParity_method <= doParity_method_S_0000;
          when doParity_method_S_0000 => 
            doParity_method <= doParity_method_S_0001;
          when doParity_method_S_0001 => 
            if tmp_0149 = '1' then
              doParity_method <= doParity_method_S_0002;
            end if;
          when doParity_method_S_0002 => 
            doParity_method <= doParity_method_S_0000;
          when others => null;
        end case;
        doParity_req_flag_d <= doParity_req_flag;
        if (tmp_0151 and tmp_0153) = '1' then
          doParity_method <= doParity_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  class_data1_0002_clk <= clk_sig;

  class_data1_0002_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0002_address_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0002_address_b <= incrementEcc_position_0008;
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0002_address_b <= incrementEcc_position_0008;
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0002_address_b <= incrementEcc_position_0008;
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0002_address_b <= incrementEcc_position_0008;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0002_din_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0002_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0002_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0002_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0002_din_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0002_we_b <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0002_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0002_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0002_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0002_we_b <= '1';
        else
          class_data1_0002_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  class_data2_0005_clk <= clk_sig;

  class_data2_0005_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0005_address_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0005_address_b <= incrementEcc_position_0008;
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0005_address_b <= incrementEcc_position_0008;
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0005_address_b <= incrementEcc_position_0008;
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0005_address_b <= incrementEcc_position_0008;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0005_din_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0005_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0005_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0005_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0005_din_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0005_we_b <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0005_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0005_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0005_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0005_we_b <= '1';
        else
          class_data2_0005_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_position_0008 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_position_0008 <= incrementEcc_position_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_position_local <= (others => '0');
      else
        if migration_method = migration_method_S_0027_body and migration_method_delay = 0 then
          incrementEcc_position_local <= migration_position_0035;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_ecc_0009 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_ecc_0009 <= incrementEcc_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_ecc_local <= (others => '0');
      else
        if migration_method = migration_method_S_0027_body and migration_method_delay = 0 then
          incrementEcc_ecc_local <= binary_expr_00054;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_address_0030 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_address_0030 <= tmp_0038;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_ecc_0031 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_ecc_0031 <= tmp_0039;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_pageSize_0032 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_pageSize_0032 <= tmp_0040;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00034 <= '0';
      else
        if migration_method = migration_method_S_0002 then
          binary_expr_00034 <= tmp_0041;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00036 <= (others => '0');
      else
        if migration_method = migration_method_S_0007 and migration_method_delay >= 1 and u_synthesijer_div32_migration_valid = '1' then
          binary_expr_00036 <= u_synthesijer_div32_migration_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_position_0035 <= (others => '0');
      else
        if migration_method = migration_method_S_0008 then
          migration_position_0035 <= binary_expr_00036;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00038 <= (others => '0');
      else
        if migration_method = migration_method_S_0009 and migration_method_delay >= 1 and u_synthesijer_mul32_migration_valid = '1' then
          binary_expr_00038 <= u_synthesijer_mul32_migration_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_initialAddress_0037 <= (others => '0');
      else
        if migration_method = migration_method_S_0010 then
          migration_initialAddress_0037 <= binary_expr_00038;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_i_0039 <= X"00000000";
      else
        if migration_method = migration_method_S_0010 then
          migration_i_0039 <= X"00000000";
        elsif migration_method = migration_method_S_0017 then
          migration_i_0039 <= unary_expr_00042;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00041 <= '0';
      else
        if migration_method = migration_method_S_0012 then
          binary_expr_00041 <= tmp_0042;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_00042 <= (others => '0');
      else
        if migration_method = migration_method_S_0015 then
          unary_expr_00042 <= tmp_0043;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_postfix_preserved_00043 <= (others => '0');
      else
        if migration_method = migration_method_S_0015 then
          unary_expr_postfix_preserved_00043 <= migration_i_0039;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00046 <= (others => '0');
      else
        if migration_method = migration_method_S_0020_wait then
          method_result_00046 <= read_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00047 <= (others => '0');
      else
        if migration_method = migration_method_S_0019 then
          binary_expr_00047 <= tmp_0044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_read_0045 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          migration_read_0045 <= method_result_00046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00049 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          binary_expr_00049 <= tmp_0045;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00051 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          binary_expr_00051 <= tmp_0046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00054 <= (others => '0');
      else
        if migration_method = migration_method_S_0026 then
          binary_expr_00054 <= tmp_0047;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_address_0055 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_address_0055 <= write_address_local;
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
          write_address_local <= binary_expr_00049;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_data_0056 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_data_0056 <= write_data_local;
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
          write_data_local <= migration_read_0045;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_ecc_0057 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_ecc_0057 <= write_ecc_local;
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
          write_ecc_local <= binary_expr_00051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00059 <= (others => '0');
      else
        if write_method = write_method_S_0002_wait then
          method_result_00059 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_newData_0058 <= (others => '0');
      else
        if write_method = write_method_S_0003 then
          write_newData_0058 <= method_result_00059;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_address_0066 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_address_0066 <= read_address_local;
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
          read_address_local <= binary_expr_00047;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_ecc_0067 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_ecc_0067 <= read_ecc_local;
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
          read_ecc_local <= migration_ecc_0031;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00069 <= (others => '0');
      else
        if read_method = read_method_S_0002_wait then
          method_result_00069 <= readRAM_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_data_0068 <= (others => '0');
      else
        if read_method = read_method_S_0003 then
          read_data_0068 <= method_result_00069;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00070 <= (others => '0');
      else
        if read_method = read_method_S_0004_wait then
          method_result_00070 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_address_0071 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_address_0071 <= writeRAM_address_local;
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
          writeRAM_address_local <= write_address_0055;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0055;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0055;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_data_0072 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_data_0072 <= writeRAM_data_local;
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
          writeRAM_data_local <= write_newData_0058;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0058;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0058;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_address_0073 <= (others => '0');
      else
        if readRAM_method = readRAM_method_S_0001 then
          readRAM_address_0073 <= readRAM_address_local;
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
          readRAM_address_local <= read_address_0066;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_data_0075 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_data_0075 <= doEcc_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_data_local <= (others => '0');
      else
        if write_method = write_method_S_0002_body and write_method_delay = 0 then
          doEcc_data_local <= write_data_0056;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          doEcc_data_local <= read_data_0068;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_ecc_0076 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_ecc_0076 <= doEcc_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_ecc_local <= (others => '0');
      else
        if write_method = write_method_S_0002_body and write_method_delay = 0 then
          doEcc_ecc_local <= write_ecc_0057;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          doEcc_ecc_local <= read_ecc_0067;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00081 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0005_wait then
          method_result_00081 <= doReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00082 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0008_wait then
          method_result_00082 <= doHamming_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00083 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0011_wait then
          method_result_00083 <= doParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_data_0084 <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0001 then
          doReedSolomon_data_0084 <= doReedSolomon_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_data_local <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0005_body and doEcc_method_delay = 0 then
          doReedSolomon_data_local <= doEcc_data_0075;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_data_0085 <= (others => '0');
      else
        if doHamming_method = doHamming_method_S_0001 then
          doHamming_data_0085 <= doHamming_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_data_local <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0008_body and doEcc_method_delay = 0 then
          doHamming_data_local <= doEcc_data_0075;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_data_0086 <= (others => '0');
      else
        if doParity_method = doParity_method_S_0001 then
          doParity_data_0086 <= doParity_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_data_local <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0011_body and doEcc_method_delay = 0 then
          doParity_data_local <= doEcc_data_0075;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_busy <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0000 then
          incrementEcc_busy <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_busy <= tmp_0005;
        end if;
      end if;
    end if;
  end process;

  incrementEcc_req_flag <= incrementEcc_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_req_local <= '0';
      else
        if migration_method = migration_method_S_0027_body then
          incrementEcc_req_local <= '1';
        else
          incrementEcc_req_local <= '0';
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
          write_busy <= tmp_0051;
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
          read_return <= method_result_00070;
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
          read_busy <= tmp_0078;
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
          writeRAM_busy <= tmp_0094;
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
          readRAM_busy <= tmp_0102;
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

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_return <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0006 then
          doEcc_return <= method_result_00081;
        elsif doEcc_method = doEcc_method_S_0009 then
          doEcc_return <= method_result_00082;
        elsif doEcc_method = doEcc_method_S_0012 then
          doEcc_return <= method_result_00083;
        elsif doEcc_method = doEcc_method_S_0014 then
          doEcc_return <= doEcc_data_0075;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_busy <= '0';
      else
        if doEcc_method = doEcc_method_S_0000 then
          doEcc_busy <= '0';
        elsif doEcc_method = doEcc_method_S_0001 then
          doEcc_busy <= tmp_0110;
        end if;
      end if;
    end if;
  end process;

  doEcc_req_flag <= doEcc_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_req_local <= '0';
      else
        if write_method = write_method_S_0002_body then
          doEcc_req_local <= '1';
        elsif read_method = read_method_S_0004_body then
          doEcc_req_local <= '1';
        else
          doEcc_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_return <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0002 then
          doReedSolomon_return <= doReedSolomon_data_0084;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_busy <= '0';
      else
        if doReedSolomon_method = doReedSolomon_method_S_0000 then
          doReedSolomon_busy <= '0';
        elsif doReedSolomon_method = doReedSolomon_method_S_0001 then
          doReedSolomon_busy <= tmp_0134;
        end if;
      end if;
    end if;
  end process;

  doReedSolomon_req_flag <= doReedSolomon_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_req_local <= '0';
      else
        if doEcc_method = doEcc_method_S_0005_body then
          doReedSolomon_req_local <= '1';
        else
          doReedSolomon_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_return <= (others => '0');
      else
        if doHamming_method = doHamming_method_S_0002 then
          doHamming_return <= doHamming_data_0085;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_busy <= '0';
      else
        if doHamming_method = doHamming_method_S_0000 then
          doHamming_busy <= '0';
        elsif doHamming_method = doHamming_method_S_0001 then
          doHamming_busy <= tmp_0142;
        end if;
      end if;
    end if;
  end process;

  doHamming_req_flag <= doHamming_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_req_local <= '0';
      else
        if doEcc_method = doEcc_method_S_0008_body then
          doHamming_req_local <= '1';
        else
          doHamming_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_return <= (others => '0');
      else
        if doParity_method = doParity_method_S_0002 then
          doParity_return <= doParity_data_0086;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_busy <= '0';
      else
        if doParity_method = doParity_method_S_0000 then
          doParity_busy <= '0';
        elsif doParity_method = doParity_method_S_0001 then
          doParity_busy <= tmp_0150;
        end if;
      end if;
    end if;
  end process;

  doParity_req_flag <= doParity_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_req_local <= '0';
      else
        if doEcc_method = doEcc_method_S_0011_body then
          doParity_req_local <= '1';
        else
          doParity_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  incrementEcc_req_flag_edge <= tmp_0003;

  migration_req_flag_edge <= tmp_0015;

  u_synthesijer_div32_migration_clk <= clk_sig;

  u_synthesijer_div32_migration_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_migration_a <= (others => '0');
      else
        if migration_method = migration_method_S_0007 and migration_method_delay = 0 then
          u_synthesijer_div32_migration_a <= migration_address_0030;
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
          u_synthesijer_div32_migration_b <= migration_pageSize_0032;
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
          u_synthesijer_mul32_migration_a <= migration_position_0035;
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
          u_synthesijer_mul32_migration_b <= migration_pageSize_0032;
        end if;
      end if;
    end if;
  end process;

  read_call_flag_0020 <= tmp_0025;

  write_call_flag_0024 <= tmp_0029;

  incrementEcc_call_flag_0027 <= tmp_0033;

  write_req_flag_edge <= tmp_0049;

  doEcc_call_flag_0002 <= tmp_0055;

  writeRAM_call_flag_0007 <= tmp_0062;

  writeRAM_call_flag_0010 <= tmp_0066;

  writeRAM_call_flag_0013 <= tmp_0070;

  read_req_flag_edge <= tmp_0076;

  readRAM_call_flag_0002 <= tmp_0082;

  doEcc_call_flag_0004 <= tmp_0086;

  writeRAM_req_flag_edge <= tmp_0092;

  readRAM_req_flag_edge <= tmp_0100;

  doEcc_req_flag_edge <= tmp_0108;

  doReedSolomon_call_flag_0005 <= tmp_0118;

  doHamming_call_flag_0008 <= tmp_0122;

  doParity_call_flag_0011 <= tmp_0126;

  doReedSolomon_req_flag_edge <= tmp_0132;

  doHamming_req_flag_edge <= tmp_0140;

  doParity_req_flag_edge <= tmp_0148;


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
