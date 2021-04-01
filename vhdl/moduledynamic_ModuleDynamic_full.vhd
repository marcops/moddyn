library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleDynamic_full is
  port (
    clk : in std_logic;
    reset : in std_logic;
    setPageSize_newPageSize : in signed(32-1 downto 0);
    writeFlow_address : in signed(32-1 downto 0);
    writeFlow_data : in signed(32-1 downto 0);
    readFlow_address : in signed(32-1 downto 0);
    readFlow_data : in signed(32-1 downto 0);
    setPageSize_busy : out std_logic;
    setPageSize_req : in std_logic;
    writeFlow_return : out signed(32-1 downto 0);
    writeFlow_busy : out std_logic;
    writeFlow_req : in std_logic;
    readFlow_return : out signed(32-1 downto 0);
    readFlow_busy : out std_logic;
    readFlow_req : in std_logic
  );
end moduledynamic_ModuleDynamic_full;

architecture RTL of moduledynamic_ModuleDynamic_full is

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

  signal clk_sig : std_logic := '0';
  signal reset_sig : std_logic := '0';
  signal setPageSize_newPageSize_sig : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_address_sig : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_data_sig : signed(32-1 downto 0) := (others => '0');
  signal readFlow_address_sig : signed(32-1 downto 0) := (others => '0');
  signal readFlow_data_sig : signed(32-1 downto 0) := (others => '0');
  signal setPageSize_busy_sig : std_logic := '1';
  signal setPageSize_req_sig : std_logic := '0';
  signal writeFlow_return_sig : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_busy_sig : std_logic := '1';
  signal writeFlow_req_sig : std_logic := '0';
  signal readFlow_return_sig : signed(32-1 downto 0) := (others => '0');
  signal readFlow_busy_sig : std_logic := '1';
  signal readFlow_req_sig : std_logic := '0';

  signal class_DEFAULT_PAGE_SIZE_0000 : signed(32-1 downto 0) := X"00007d00";
  signal class_DEFAULT_MEMORY_SIZE_PER_BLOCK_0002 : signed(32-1 downto 0) := X"0003e800";
  signal class_BYTE_SIZE_0004 : signed(32-1 downto 0) := X"00000008";
  signal class_pageSize_0006 : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0007_clk : std_logic := '0';
  signal class_data1_0007_reset : std_logic := '0';
  signal class_data1_0007_length : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0007_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0007_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data1_0007_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data1_0007_we_b : std_logic := '0';
  signal class_data1_0007_oe_b : std_logic := '0';
  signal class_data2_0010_clk : std_logic := '0';
  signal class_data2_0010_reset : std_logic := '0';
  signal class_data2_0010_length : signed(32-1 downto 0) := (others => '0');
  signal class_data2_0010_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data2_0010_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data2_0010_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data2_0010_we_b : std_logic := '0';
  signal class_data2_0010_oe_b : std_logic := '0';
  signal setPageSize_newPageSize_0013 : signed(32-1 downto 0) := (others => '0');
  signal setPageSize_newPageSize_local : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_address_0014 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_address_local : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_data_0015 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00017 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_ecc_0016 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00018 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_address_0019 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_address_local : signed(32-1 downto 0) := (others => '0');
  signal readFlow_data_0020 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00022 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_ecc_0021 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00024 : std_logic := '0';
  signal readFlow_isOk_0023 : std_logic := '0';
  signal getEcc_address_0027 : signed(32-1 downto 0) := (others => '0');
  signal getEcc_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00029 : signed(32-1 downto 0) := (others => '0');
  signal getEcc_dataPosition_0028 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00031 : std_logic := '0';
  signal getEcc_currentData1_0030 : std_logic := '0';
  signal array_access_00033 : std_logic := '0';
  signal getEcc_currentData2_0032 : std_logic := '0';
  signal cond_expr_00036 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00039 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00040 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_0041 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00042 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00043 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_position_0044 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_position_local : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_0045 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal array_access_00051 : std_logic := '0';
  signal array_access_00053 : std_logic := '0';
  signal array_access_00055 : std_logic := '0';
  signal array_access_00057 : std_logic := '0';
  signal array_access_00059 : std_logic := '0';
  signal array_access_00061 : std_logic := '0';
  signal array_access_00063 : std_logic := '0';
  signal array_access_00065 : std_logic := '0';
  signal migration_address_0066 : signed(32-1 downto 0) := (others => '0');
  signal migration_address_local : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_0067 : signed(32-1 downto 0) := (others => '0');
  signal migration_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_0068 : signed(32-1 downto 0) := (others => '0');
  signal migration_pageSize_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00070 : std_logic := '0';
  signal binary_expr_00072 : signed(32-1 downto 0) := (others => '0');
  signal migration_position_0071 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00074 : signed(32-1 downto 0) := (others => '0');
  signal migration_initialAddress_0073 : signed(32-1 downto 0) := (others => '0');
  signal migration_i_0075 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00077 : std_logic := '0';
  signal unary_expr_00078 : signed(32-1 downto 0) := (others => '0');
  signal unary_expr_postfix_preserved_00079 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00082 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00083 : signed(32-1 downto 0) := (others => '0');
  signal migration_read_0081 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00085 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00087 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00090 : signed(32-1 downto 0) := (others => '0');
  signal write_address_0091 : signed(32-1 downto 0) := (others => '0');
  signal write_address_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_0092 : signed(32-1 downto 0) := (others => '0');
  signal write_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_0093 : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00095 : signed(32-1 downto 0) := (others => '0');
  signal write_newData_0094 : signed(32-1 downto 0) := (others => '0');
  signal read_address_0102 : signed(32-1 downto 0) := (others => '0');
  signal read_address_local : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_0103 : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00105 : signed(32-1 downto 0) := (others => '0');
  signal read_data_0104 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00106 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_0107 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_0108 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_local : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_0109 : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal checkECC_data_0111 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_0112 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00117 : std_logic := '0';
  signal method_result_00118 : std_logic := '0';
  signal method_result_00119 : std_logic := '0';
  signal doEcc_data_0121 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_0122 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00127 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00128 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00129 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_0130 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_0131 : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_0132 : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_data_0133 : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_data_0135 : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkParity_data_0137 : signed(32-1 downto 0) := (others => '0');
  signal checkParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal setPageSize_req_flag : std_logic := '0';
  signal setPageSize_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal writeFlow_req_flag : std_logic := '0';
  signal writeFlow_req_local : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal readFlow_req_flag : std_logic := '0';
  signal readFlow_req_local : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  signal getEcc_return : signed(32-1 downto 0) := (others => '0');
  signal getEcc_busy : std_logic := '0';
  signal getEcc_req_flag : std_logic := '0';
  signal getEcc_req_local : std_logic := '0';
  signal getPosition_return : signed(32-1 downto 0) := (others => '0');
  signal getPosition_busy : std_logic := '0';
  signal getPosition_req_flag : std_logic := '0';
  signal getPosition_req_local : std_logic := '0';
  signal incrementEcc_busy : std_logic := '0';
  signal incrementEcc_req_flag : std_logic := '0';
  signal incrementEcc_req_local : std_logic := '0';
  signal migration_busy : std_logic := '0';
  signal migration_req_flag : std_logic := '0';
  signal migration_req_local : std_logic := '0';
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
  signal checkECC_return : std_logic := '0';
  signal checkECC_busy : std_logic := '0';
  signal checkECC_req_flag : std_logic := '0';
  signal checkECC_req_local : std_logic := '0';
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
  signal checkReedSolomon_return : std_logic := '0';
  signal checkReedSolomon_busy : std_logic := '0';
  signal checkReedSolomon_req_flag : std_logic := '0';
  signal checkReedSolomon_req_local : std_logic := '0';
  signal checkHamming_return : std_logic := '0';
  signal checkHamming_busy : std_logic := '0';
  signal checkHamming_req_flag : std_logic := '0';
  signal checkHamming_req_local : std_logic := '0';
  signal checkParity_return : std_logic := '0';
  signal checkParity_busy : std_logic := '0';
  signal checkParity_req_flag : std_logic := '0';
  signal checkParity_req_local : std_logic := '0';
  type Type_setPageSize_method is (
    setPageSize_method_IDLE,
    setPageSize_method_S_0000,
    setPageSize_method_S_0001,
    setPageSize_method_S_0002  
  );
  signal setPageSize_method : Type_setPageSize_method := setPageSize_method_IDLE;
  signal setPageSize_method_prev : Type_setPageSize_method := setPageSize_method_IDLE;
  signal setPageSize_method_delay : signed(32-1 downto 0) := (others => '0');
  signal setPageSize_req_flag_d : std_logic := '0';
  signal setPageSize_req_flag_edge : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : signed(32-1 downto 0) := (others => '0');
  type Type_writeFlow_method is (
    writeFlow_method_IDLE,
    writeFlow_method_S_0000,
    writeFlow_method_S_0001,
    writeFlow_method_S_0002,
    writeFlow_method_S_0003,
    writeFlow_method_S_0004,
    writeFlow_method_S_0005,
    writeFlow_method_S_0002_body,
    writeFlow_method_S_0002_wait,
    writeFlow_method_S_0004_body,
    writeFlow_method_S_0004_wait  
  );
  signal writeFlow_method : Type_writeFlow_method := writeFlow_method_IDLE;
  signal writeFlow_method_prev : Type_writeFlow_method := writeFlow_method_IDLE;
  signal writeFlow_method_delay : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_req_flag_d : std_logic := '0';
  signal writeFlow_req_flag_edge : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal getEcc_call_flag_0002 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
  signal tmp_0020 : std_logic := '0';
  signal doEcc_call_flag_0004 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : std_logic := '0';
  signal tmp_0028 : std_logic := '0';
  signal tmp_0029 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0030 : signed(32-1 downto 0) := (others => '0');
  type Type_readFlow_method is (
    readFlow_method_IDLE,
    readFlow_method_S_0000,
    readFlow_method_S_0001,
    readFlow_method_S_0002,
    readFlow_method_S_0003,
    readFlow_method_S_0004,
    readFlow_method_S_0005,
    readFlow_method_S_0006,
    readFlow_method_S_0008,
    readFlow_method_S_0010,
    readFlow_method_S_0011,
    readFlow_method_S_0002_body,
    readFlow_method_S_0002_wait,
    readFlow_method_S_0004_body,
    readFlow_method_S_0004_wait,
    readFlow_method_S_0010_body,
    readFlow_method_S_0010_wait  
  );
  signal readFlow_method : Type_readFlow_method := readFlow_method_IDLE;
  signal readFlow_method_prev : Type_readFlow_method := readFlow_method_IDLE;
  signal readFlow_method_delay : signed(32-1 downto 0) := (others => '0');
  signal readFlow_req_flag_d : std_logic := '0';
  signal readFlow_req_flag_edge : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal checkECC_call_flag_0004 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal migration_call_flag_0010 : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0050 : signed(32-1 downto 0) := (others => '0');
  type Type_getEcc_method is (
    getEcc_method_IDLE,
    getEcc_method_S_0000,
    getEcc_method_S_0001,
    getEcc_method_S_0002,
    getEcc_method_S_0003,
    getEcc_method_S_0004,
    getEcc_method_S_0013,
    getEcc_method_S_0014,
    getEcc_method_S_0005,
    getEcc_method_S_0006,
    getEcc_method_S_0015,
    getEcc_method_S_0016,
    getEcc_method_S_0007,
    getEcc_method_S_0009,
    getEcc_method_S_0010,
    getEcc_method_S_0011,
    getEcc_method_S_0002_body,
    getEcc_method_S_0002_wait  
  );
  signal getEcc_method : Type_getEcc_method := getEcc_method_IDLE;
  signal getEcc_method_prev : Type_getEcc_method := getEcc_method_IDLE;
  signal getEcc_method_delay : signed(32-1 downto 0) := (others => '0');
  signal getEcc_req_flag_d : std_logic := '0';
  signal getEcc_req_flag_edge : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
  signal getPosition_call_flag_0002 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal tmp_0063 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0064 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0065 : signed(32-1 downto 0) := (others => '0');
  type Type_getPosition_method is (
    getPosition_method_IDLE,
    getPosition_method_S_0000,
    getPosition_method_S_0001,
    getPosition_method_S_0002,
    getPosition_method_S_0003,
    getPosition_method_S_0004  
  );
  signal getPosition_method : Type_getPosition_method := getPosition_method_IDLE;
  signal getPosition_method_prev : Type_getPosition_method := getPosition_method_IDLE;
  signal getPosition_method_delay : signed(32-1 downto 0) := (others => '0');
  signal getPosition_req_flag_d : std_logic := '0';
  signal getPosition_req_flag_edge : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal u_synthesijer_mul32_getPosition_clk : std_logic := '0';
  signal u_synthesijer_mul32_getPosition_reset : std_logic := '0';
  signal u_synthesijer_mul32_getPosition_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_getPosition_b : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_getPosition_nd : std_logic := '0';
  signal u_synthesijer_mul32_getPosition_result : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_getPosition_valid : std_logic := '0';
  signal u_synthesijer_div32_getPosition_clk : std_logic := '0';
  signal u_synthesijer_div32_getPosition_reset : std_logic := '0';
  signal u_synthesijer_div32_getPosition_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_getPosition_b : signed(32-1 downto 0) := X"00000001";
  signal u_synthesijer_div32_getPosition_nd : std_logic := '0';
  signal u_synthesijer_div32_getPosition_quantient : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_getPosition_remainder : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_getPosition_valid : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
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
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
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
  signal tmp_0086 : std_logic := '0';
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
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
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
  signal read_call_flag_0020 : std_logic := '0';
  signal tmp_0094 : std_logic := '0';
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal write_call_flag_0024 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal incrementEcc_call_flag_0027 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
  signal tmp_0106 : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0113 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0114 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0115 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0116 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0117 : std_logic := '0';
  signal tmp_0118 : std_logic := '0';
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal doEcc_call_flag_0002 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
  signal tmp_0122 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
  signal tmp_0126 : std_logic := '0';
  signal tmp_0127 : std_logic := '0';
  signal writeRAM_call_flag_0007 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
  signal tmp_0130 : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal writeRAM_call_flag_0010 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
  signal tmp_0134 : std_logic := '0';
  signal tmp_0135 : std_logic := '0';
  signal writeRAM_call_flag_0013 : std_logic := '0';
  signal tmp_0136 : std_logic := '0';
  signal tmp_0137 : std_logic := '0';
  signal tmp_0138 : std_logic := '0';
  signal tmp_0139 : std_logic := '0';
  signal tmp_0140 : std_logic := '0';
  signal tmp_0141 : std_logic := '0';
  signal tmp_0142 : std_logic := '0';
  signal tmp_0143 : std_logic := '0';
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
  signal tmp_0144 : std_logic := '0';
  signal tmp_0145 : std_logic := '0';
  signal tmp_0146 : std_logic := '0';
  signal tmp_0147 : std_logic := '0';
  signal readRAM_call_flag_0002 : std_logic := '0';
  signal tmp_0148 : std_logic := '0';
  signal tmp_0149 : std_logic := '0';
  signal tmp_0150 : std_logic := '0';
  signal tmp_0151 : std_logic := '0';
  signal tmp_0152 : std_logic := '0';
  signal tmp_0153 : std_logic := '0';
  signal tmp_0154 : std_logic := '0';
  signal tmp_0155 : std_logic := '0';
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
  signal tmp_0156 : std_logic := '0';
  signal tmp_0157 : std_logic := '0';
  signal tmp_0158 : std_logic := '0';
  signal tmp_0159 : std_logic := '0';
  signal tmp_0160 : std_logic := '0';
  signal tmp_0161 : std_logic := '0';
  signal tmp_0162 : std_logic := '0';
  signal tmp_0163 : std_logic := '0';
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
  signal tmp_0164 : std_logic := '0';
  signal tmp_0165 : std_logic := '0';
  signal tmp_0166 : std_logic := '0';
  signal tmp_0167 : std_logic := '0';
  signal tmp_0168 : std_logic := '0';
  signal tmp_0169 : std_logic := '0';
  signal tmp_0170 : std_logic := '0';
  signal tmp_0171 : std_logic := '0';
  type Type_checkECC_method is (
    checkECC_method_IDLE,
    checkECC_method_S_0000,
    checkECC_method_S_0001,
    checkECC_method_S_0002,
    checkECC_method_S_0005,
    checkECC_method_S_0006,
    checkECC_method_S_0008,
    checkECC_method_S_0009,
    checkECC_method_S_0011,
    checkECC_method_S_0012,
    checkECC_method_S_0014,
    checkECC_method_S_0005_body,
    checkECC_method_S_0005_wait,
    checkECC_method_S_0008_body,
    checkECC_method_S_0008_wait,
    checkECC_method_S_0011_body,
    checkECC_method_S_0011_wait  
  );
  signal checkECC_method : Type_checkECC_method := checkECC_method_IDLE;
  signal checkECC_method_prev : Type_checkECC_method := checkECC_method_IDLE;
  signal checkECC_method_delay : signed(32-1 downto 0) := (others => '0');
  signal checkECC_req_flag_d : std_logic := '0';
  signal checkECC_req_flag_edge : std_logic := '0';
  signal tmp_0172 : std_logic := '0';
  signal tmp_0173 : std_logic := '0';
  signal tmp_0174 : std_logic := '0';
  signal tmp_0175 : std_logic := '0';
  signal tmp_0176 : std_logic := '0';
  signal tmp_0177 : std_logic := '0';
  signal tmp_0178 : std_logic := '0';
  signal tmp_0179 : std_logic := '0';
  signal checkReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0180 : std_logic := '0';
  signal tmp_0181 : std_logic := '0';
  signal tmp_0182 : std_logic := '0';
  signal tmp_0183 : std_logic := '0';
  signal checkHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0184 : std_logic := '0';
  signal tmp_0185 : std_logic := '0';
  signal tmp_0186 : std_logic := '0';
  signal tmp_0187 : std_logic := '0';
  signal checkParity_call_flag_0011 : std_logic := '0';
  signal tmp_0188 : std_logic := '0';
  signal tmp_0189 : std_logic := '0';
  signal tmp_0190 : std_logic := '0';
  signal tmp_0191 : std_logic := '0';
  signal tmp_0192 : std_logic := '0';
  signal tmp_0193 : std_logic := '0';
  signal tmp_0194 : std_logic := '0';
  signal tmp_0195 : std_logic := '0';
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
  signal tmp_0196 : std_logic := '0';
  signal tmp_0197 : std_logic := '0';
  signal tmp_0198 : std_logic := '0';
  signal tmp_0199 : std_logic := '0';
  signal tmp_0200 : std_logic := '0';
  signal tmp_0201 : std_logic := '0';
  signal tmp_0202 : std_logic := '0';
  signal tmp_0203 : std_logic := '0';
  signal doReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0204 : std_logic := '0';
  signal tmp_0205 : std_logic := '0';
  signal tmp_0206 : std_logic := '0';
  signal tmp_0207 : std_logic := '0';
  signal doHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0208 : std_logic := '0';
  signal tmp_0209 : std_logic := '0';
  signal tmp_0210 : std_logic := '0';
  signal tmp_0211 : std_logic := '0';
  signal doParity_call_flag_0011 : std_logic := '0';
  signal tmp_0212 : std_logic := '0';
  signal tmp_0213 : std_logic := '0';
  signal tmp_0214 : std_logic := '0';
  signal tmp_0215 : std_logic := '0';
  signal tmp_0216 : std_logic := '0';
  signal tmp_0217 : std_logic := '0';
  signal tmp_0218 : std_logic := '0';
  signal tmp_0219 : std_logic := '0';
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
  signal tmp_0220 : std_logic := '0';
  signal tmp_0221 : std_logic := '0';
  signal tmp_0222 : std_logic := '0';
  signal tmp_0223 : std_logic := '0';
  signal tmp_0224 : std_logic := '0';
  signal tmp_0225 : std_logic := '0';
  signal tmp_0226 : std_logic := '0';
  signal tmp_0227 : std_logic := '0';
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
  signal tmp_0228 : std_logic := '0';
  signal tmp_0229 : std_logic := '0';
  signal tmp_0230 : std_logic := '0';
  signal tmp_0231 : std_logic := '0';
  signal tmp_0232 : std_logic := '0';
  signal tmp_0233 : std_logic := '0';
  signal tmp_0234 : std_logic := '0';
  signal tmp_0235 : std_logic := '0';
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
  signal tmp_0236 : std_logic := '0';
  signal tmp_0237 : std_logic := '0';
  signal tmp_0238 : std_logic := '0';
  signal tmp_0239 : std_logic := '0';
  signal tmp_0240 : std_logic := '0';
  signal tmp_0241 : std_logic := '0';
  signal tmp_0242 : std_logic := '0';
  signal tmp_0243 : std_logic := '0';
  type Type_checkReedSolomon_method is (
    checkReedSolomon_method_IDLE,
    checkReedSolomon_method_S_0000,
    checkReedSolomon_method_S_0001,
    checkReedSolomon_method_S_0002  
  );
  signal checkReedSolomon_method : Type_checkReedSolomon_method := checkReedSolomon_method_IDLE;
  signal checkReedSolomon_method_prev : Type_checkReedSolomon_method := checkReedSolomon_method_IDLE;
  signal checkReedSolomon_method_delay : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_req_flag_d : std_logic := '0';
  signal checkReedSolomon_req_flag_edge : std_logic := '0';
  signal tmp_0244 : std_logic := '0';
  signal tmp_0245 : std_logic := '0';
  signal tmp_0246 : std_logic := '0';
  signal tmp_0247 : std_logic := '0';
  signal tmp_0248 : std_logic := '0';
  signal tmp_0249 : std_logic := '0';
  signal tmp_0250 : std_logic := '0';
  signal tmp_0251 : std_logic := '0';
  type Type_checkHamming_method is (
    checkHamming_method_IDLE,
    checkHamming_method_S_0000,
    checkHamming_method_S_0001,
    checkHamming_method_S_0002  
  );
  signal checkHamming_method : Type_checkHamming_method := checkHamming_method_IDLE;
  signal checkHamming_method_prev : Type_checkHamming_method := checkHamming_method_IDLE;
  signal checkHamming_method_delay : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_req_flag_d : std_logic := '0';
  signal checkHamming_req_flag_edge : std_logic := '0';
  signal tmp_0252 : std_logic := '0';
  signal tmp_0253 : std_logic := '0';
  signal tmp_0254 : std_logic := '0';
  signal tmp_0255 : std_logic := '0';
  signal tmp_0256 : std_logic := '0';
  signal tmp_0257 : std_logic := '0';
  signal tmp_0258 : std_logic := '0';
  signal tmp_0259 : std_logic := '0';
  type Type_checkParity_method is (
    checkParity_method_IDLE,
    checkParity_method_S_0000,
    checkParity_method_S_0001,
    checkParity_method_S_0002  
  );
  signal checkParity_method : Type_checkParity_method := checkParity_method_IDLE;
  signal checkParity_method_prev : Type_checkParity_method := checkParity_method_IDLE;
  signal checkParity_method_delay : signed(32-1 downto 0) := (others => '0');
  signal checkParity_req_flag_d : std_logic := '0';
  signal checkParity_req_flag_edge : std_logic := '0';
  signal tmp_0260 : std_logic := '0';
  signal tmp_0261 : std_logic := '0';
  signal tmp_0262 : std_logic := '0';
  signal tmp_0263 : std_logic := '0';
  signal tmp_0264 : std_logic := '0';
  signal tmp_0265 : std_logic := '0';
  signal tmp_0266 : std_logic := '0';
  signal tmp_0267 : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;
  setPageSize_newPageSize_sig <= setPageSize_newPageSize;
  writeFlow_address_sig <= writeFlow_address;
  writeFlow_data_sig <= writeFlow_data;
  readFlow_address_sig <= readFlow_address;
  readFlow_data_sig <= readFlow_data;
  setPageSize_busy <= setPageSize_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        setPageSize_busy_sig <= '1';
      else
        if setPageSize_method = setPageSize_method_S_0000 then
          setPageSize_busy_sig <= '0';
        elsif setPageSize_method = setPageSize_method_S_0001 then
          setPageSize_busy_sig <= tmp_0007;
        end if;
      end if;
    end if;
  end process;

  setPageSize_req_sig <= setPageSize_req;
  writeFlow_return <= writeFlow_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_return_sig <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0005 then
          writeFlow_return_sig <= method_result_00018;
        end if;
      end if;
    end if;
  end process;

  writeFlow_busy <= writeFlow_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_busy_sig <= '1';
      else
        if writeFlow_method = writeFlow_method_S_0000 then
          writeFlow_busy_sig <= '0';
        elsif writeFlow_method = writeFlow_method_S_0001 then
          writeFlow_busy_sig <= tmp_0016;
        end if;
      end if;
    end if;
  end process;

  writeFlow_req_sig <= writeFlow_req;
  readFlow_return <= readFlow_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_return_sig <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0008 then
          readFlow_return_sig <= readFlow_data_0020;
        elsif readFlow_method = readFlow_method_S_0011 then
          readFlow_return_sig <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  readFlow_busy <= readFlow_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_busy_sig <= '1';
      else
        if readFlow_method = readFlow_method_S_0000 then
          readFlow_busy_sig <= '0';
        elsif readFlow_method = readFlow_method_S_0001 then
          readFlow_busy_sig <= tmp_0034;
        end if;
      end if;
    end if;
  end process;

  readFlow_req_sig <= readFlow_req;

  -- expressions
  tmp_0001 <= setPageSize_req_local or setPageSize_req_sig;
  tmp_0002 <= writeFlow_req_local or writeFlow_req_sig;
  tmp_0003 <= readFlow_req_local or readFlow_req_sig;
  tmp_0004 <= not setPageSize_req_flag_d;
  tmp_0005 <= setPageSize_req_flag and tmp_0004;
  tmp_0006 <= setPageSize_req_flag or setPageSize_req_flag_d;
  tmp_0007 <= setPageSize_req_flag or setPageSize_req_flag_d;
  tmp_0008 <= '1' when setPageSize_method /= setPageSize_method_S_0000 else '0';
  tmp_0009 <= '1' when setPageSize_method /= setPageSize_method_S_0001 else '0';
  tmp_0010 <= tmp_0009 and setPageSize_req_flag_edge;
  tmp_0011 <= tmp_0008 and tmp_0010;
  tmp_0012 <= setPageSize_newPageSize_sig when setPageSize_req_sig = '1' else setPageSize_newPageSize_local;
  tmp_0013 <= not writeFlow_req_flag_d;
  tmp_0014 <= writeFlow_req_flag and tmp_0013;
  tmp_0015 <= writeFlow_req_flag or writeFlow_req_flag_d;
  tmp_0016 <= writeFlow_req_flag or writeFlow_req_flag_d;
  tmp_0017 <= '1' when getEcc_busy = '0' else '0';
  tmp_0018 <= '1' when getEcc_req_local = '0' else '0';
  tmp_0019 <= tmp_0017 and tmp_0018;
  tmp_0020 <= '1' when tmp_0019 = '1' else '0';
  tmp_0021 <= '1' when doEcc_busy = '0' else '0';
  tmp_0022 <= '1' when doEcc_req_local = '0' else '0';
  tmp_0023 <= tmp_0021 and tmp_0022;
  tmp_0024 <= '1' when tmp_0023 = '1' else '0';
  tmp_0025 <= '1' when writeFlow_method /= writeFlow_method_S_0000 else '0';
  tmp_0026 <= '1' when writeFlow_method /= writeFlow_method_S_0001 else '0';
  tmp_0027 <= tmp_0026 and writeFlow_req_flag_edge;
  tmp_0028 <= tmp_0025 and tmp_0027;
  tmp_0029 <= writeFlow_address_sig when writeFlow_req_sig = '1' else writeFlow_address_local;
  tmp_0030 <= writeFlow_data_sig when writeFlow_req_sig = '1' else writeFlow_data_local;
  tmp_0031 <= not readFlow_req_flag_d;
  tmp_0032 <= readFlow_req_flag and tmp_0031;
  tmp_0033 <= readFlow_req_flag or readFlow_req_flag_d;
  tmp_0034 <= readFlow_req_flag or readFlow_req_flag_d;
  tmp_0035 <= '1' when checkECC_busy = '0' else '0';
  tmp_0036 <= '1' when checkECC_req_local = '0' else '0';
  tmp_0037 <= tmp_0035 and tmp_0036;
  tmp_0038 <= '1' when tmp_0037 = '1' else '0';
  tmp_0039 <= '1' when readFlow_isOk_0023 = '1' else '0';
  tmp_0040 <= '1' when readFlow_isOk_0023 = '0' else '0';
  tmp_0041 <= '1' when migration_busy = '0' else '0';
  tmp_0042 <= '1' when migration_req_local = '0' else '0';
  tmp_0043 <= tmp_0041 and tmp_0042;
  tmp_0044 <= '1' when tmp_0043 = '1' else '0';
  tmp_0045 <= '1' when readFlow_method /= readFlow_method_S_0000 else '0';
  tmp_0046 <= '1' when readFlow_method /= readFlow_method_S_0001 else '0';
  tmp_0047 <= tmp_0046 and readFlow_req_flag_edge;
  tmp_0048 <= tmp_0045 and tmp_0047;
  tmp_0049 <= readFlow_address_sig when readFlow_req_sig = '1' else readFlow_address_local;
  tmp_0050 <= readFlow_data_sig when readFlow_req_sig = '1' else readFlow_data_local;
  tmp_0051 <= not getEcc_req_flag_d;
  tmp_0052 <= getEcc_req_flag and tmp_0051;
  tmp_0053 <= getEcc_req_flag or getEcc_req_flag_d;
  tmp_0054 <= getEcc_req_flag or getEcc_req_flag_d;
  tmp_0055 <= '1' when getPosition_busy = '0' else '0';
  tmp_0056 <= '1' when getPosition_req_local = '0' else '0';
  tmp_0057 <= tmp_0055 and tmp_0056;
  tmp_0058 <= '1' when tmp_0057 = '1' else '0';
  tmp_0059 <= '1' when getEcc_method /= getEcc_method_S_0000 else '0';
  tmp_0060 <= '1' when getEcc_method /= getEcc_method_S_0001 else '0';
  tmp_0061 <= tmp_0060 and getEcc_req_flag_edge;
  tmp_0062 <= tmp_0059 and tmp_0061;
  tmp_0063 <= X"00000001" when getEcc_currentData1_0030 = '1' else X"00000000";
  tmp_0064 <= X"00000002" when getEcc_currentData2_0032 = '1' else X"00000000";
  tmp_0065 <= cond_expr_00036 + cond_expr_00039;
  tmp_0066 <= not getPosition_req_flag_d;
  tmp_0067 <= getPosition_req_flag and tmp_0066;
  tmp_0068 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0069 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0070 <= '1' when getPosition_method /= getPosition_method_S_0000 else '0';
  tmp_0071 <= '1' when getPosition_method /= getPosition_method_S_0001 else '0';
  tmp_0072 <= tmp_0071 and getPosition_req_flag_edge;
  tmp_0073 <= tmp_0070 and tmp_0072;
  tmp_0074 <= not incrementEcc_req_flag_d;
  tmp_0075 <= incrementEcc_req_flag and tmp_0074;
  tmp_0076 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0077 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0078 <= '1' when incrementEcc_ecc_0045 = X"00000000" else '0';
  tmp_0079 <= '1' when incrementEcc_ecc_0045 = X"00000001" else '0';
  tmp_0080 <= '1' when incrementEcc_ecc_0045 = X"00000002" else '0';
  tmp_0081 <= '1' when incrementEcc_ecc_0045 = X"00000003" else '0';
  tmp_0082 <= '1' when incrementEcc_method /= incrementEcc_method_S_0000 else '0';
  tmp_0083 <= '1' when incrementEcc_method /= incrementEcc_method_S_0001 else '0';
  tmp_0084 <= tmp_0083 and incrementEcc_req_flag_edge;
  tmp_0085 <= tmp_0082 and tmp_0084;
  tmp_0086 <= not migration_req_flag_d;
  tmp_0087 <= migration_req_flag and tmp_0086;
  tmp_0088 <= migration_req_flag or migration_req_flag_d;
  tmp_0089 <= migration_req_flag or migration_req_flag_d;
  tmp_0090 <= '1' when binary_expr_00070 = '1' else '0';
  tmp_0091 <= '1' when binary_expr_00070 = '0' else '0';
  tmp_0092 <= '1' when binary_expr_00077 = '1' else '0';
  tmp_0093 <= '1' when binary_expr_00077 = '0' else '0';
  tmp_0094 <= '1' when read_busy = '0' else '0';
  tmp_0095 <= '1' when read_req_local = '0' else '0';
  tmp_0096 <= tmp_0094 and tmp_0095;
  tmp_0097 <= '1' when tmp_0096 = '1' else '0';
  tmp_0098 <= '1' when write_busy = '0' else '0';
  tmp_0099 <= '1' when write_req_local = '0' else '0';
  tmp_0100 <= tmp_0098 and tmp_0099;
  tmp_0101 <= '1' when tmp_0100 = '1' else '0';
  tmp_0102 <= '1' when incrementEcc_busy = '0' else '0';
  tmp_0103 <= '1' when incrementEcc_req_local = '0' else '0';
  tmp_0104 <= tmp_0102 and tmp_0103;
  tmp_0105 <= '1' when tmp_0104 = '1' else '0';
  tmp_0106 <= '1' when migration_method /= migration_method_S_0000 else '0';
  tmp_0107 <= '1' when migration_method /= migration_method_S_0001 else '0';
  tmp_0108 <= tmp_0107 and migration_req_flag_edge;
  tmp_0109 <= tmp_0106 and tmp_0108;
  tmp_0110 <= '1' when migration_ecc_0067 = X"00000003" else '0';
  tmp_0111 <= '1' when migration_i_0075 < migration_pageSize_0068 else '0';
  tmp_0112 <= migration_i_0075 + X"00000001";
  tmp_0113 <= migration_initialAddress_0073 + migration_i_0075;
  tmp_0114 <= migration_initialAddress_0073 + migration_i_0075;
  tmp_0115 <= migration_ecc_0067 + X"00000001";
  tmp_0116 <= migration_ecc_0067 + X"00000001";
  tmp_0117 <= not write_req_flag_d;
  tmp_0118 <= write_req_flag and tmp_0117;
  tmp_0119 <= write_req_flag or write_req_flag_d;
  tmp_0120 <= write_req_flag or write_req_flag_d;
  tmp_0121 <= '1' when doEcc_busy = '0' else '0';
  tmp_0122 <= '1' when doEcc_req_local = '0' else '0';
  tmp_0123 <= tmp_0121 and tmp_0122;
  tmp_0124 <= '1' when tmp_0123 = '1' else '0';
  tmp_0125 <= '1' when write_ecc_0093 = X"00000001" else '0';
  tmp_0126 <= '1' when write_ecc_0093 = X"00000002" else '0';
  tmp_0127 <= '1' when write_ecc_0093 = X"00000003" else '0';
  tmp_0128 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0129 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0130 <= tmp_0128 and tmp_0129;
  tmp_0131 <= '1' when tmp_0130 = '1' else '0';
  tmp_0132 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0133 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0134 <= tmp_0132 and tmp_0133;
  tmp_0135 <= '1' when tmp_0134 = '1' else '0';
  tmp_0136 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0137 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0138 <= tmp_0136 and tmp_0137;
  tmp_0139 <= '1' when tmp_0138 = '1' else '0';
  tmp_0140 <= '1' when write_method /= write_method_S_0000 else '0';
  tmp_0141 <= '1' when write_method /= write_method_S_0001 else '0';
  tmp_0142 <= tmp_0141 and write_req_flag_edge;
  tmp_0143 <= tmp_0140 and tmp_0142;
  tmp_0144 <= not read_req_flag_d;
  tmp_0145 <= read_req_flag and tmp_0144;
  tmp_0146 <= read_req_flag or read_req_flag_d;
  tmp_0147 <= read_req_flag or read_req_flag_d;
  tmp_0148 <= '1' when readRAM_busy = '0' else '0';
  tmp_0149 <= '1' when readRAM_req_local = '0' else '0';
  tmp_0150 <= tmp_0148 and tmp_0149;
  tmp_0151 <= '1' when tmp_0150 = '1' else '0';
  tmp_0152 <= '1' when read_method /= read_method_S_0000 else '0';
  tmp_0153 <= '1' when read_method /= read_method_S_0001 else '0';
  tmp_0154 <= tmp_0153 and read_req_flag_edge;
  tmp_0155 <= tmp_0152 and tmp_0154;
  tmp_0156 <= not writeRAM_req_flag_d;
  tmp_0157 <= writeRAM_req_flag and tmp_0156;
  tmp_0158 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0159 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0160 <= '1' when writeRAM_method /= writeRAM_method_S_0000 else '0';
  tmp_0161 <= '1' when writeRAM_method /= writeRAM_method_S_0001 else '0';
  tmp_0162 <= tmp_0161 and writeRAM_req_flag_edge;
  tmp_0163 <= tmp_0160 and tmp_0162;
  tmp_0164 <= not readRAM_req_flag_d;
  tmp_0165 <= readRAM_req_flag and tmp_0164;
  tmp_0166 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0167 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0168 <= '1' when readRAM_method /= readRAM_method_S_0000 else '0';
  tmp_0169 <= '1' when readRAM_method /= readRAM_method_S_0001 else '0';
  tmp_0170 <= tmp_0169 and readRAM_req_flag_edge;
  tmp_0171 <= tmp_0168 and tmp_0170;
  tmp_0172 <= not checkECC_req_flag_d;
  tmp_0173 <= checkECC_req_flag and tmp_0172;
  tmp_0174 <= checkECC_req_flag or checkECC_req_flag_d;
  tmp_0175 <= checkECC_req_flag or checkECC_req_flag_d;
  tmp_0176 <= '1' when checkECC_ecc_0112 = X"00000000" else '0';
  tmp_0177 <= '1' when checkECC_ecc_0112 = X"00000001" else '0';
  tmp_0178 <= '1' when checkECC_ecc_0112 = X"00000002" else '0';
  tmp_0179 <= '1' when checkECC_ecc_0112 = X"00000003" else '0';
  tmp_0180 <= '1' when checkReedSolomon_busy = '0' else '0';
  tmp_0181 <= '1' when checkReedSolomon_req_local = '0' else '0';
  tmp_0182 <= tmp_0180 and tmp_0181;
  tmp_0183 <= '1' when tmp_0182 = '1' else '0';
  tmp_0184 <= '1' when checkHamming_busy = '0' else '0';
  tmp_0185 <= '1' when checkHamming_req_local = '0' else '0';
  tmp_0186 <= tmp_0184 and tmp_0185;
  tmp_0187 <= '1' when tmp_0186 = '1' else '0';
  tmp_0188 <= '1' when checkParity_busy = '0' else '0';
  tmp_0189 <= '1' when checkParity_req_local = '0' else '0';
  tmp_0190 <= tmp_0188 and tmp_0189;
  tmp_0191 <= '1' when tmp_0190 = '1' else '0';
  tmp_0192 <= '1' when checkECC_method /= checkECC_method_S_0000 else '0';
  tmp_0193 <= '1' when checkECC_method /= checkECC_method_S_0001 else '0';
  tmp_0194 <= tmp_0193 and checkECC_req_flag_edge;
  tmp_0195 <= tmp_0192 and tmp_0194;
  tmp_0196 <= not doEcc_req_flag_d;
  tmp_0197 <= doEcc_req_flag and tmp_0196;
  tmp_0198 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0199 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0200 <= '1' when doEcc_ecc_0122 = X"00000000" else '0';
  tmp_0201 <= '1' when doEcc_ecc_0122 = X"00000001" else '0';
  tmp_0202 <= '1' when doEcc_ecc_0122 = X"00000002" else '0';
  tmp_0203 <= '1' when doEcc_ecc_0122 = X"00000003" else '0';
  tmp_0204 <= '1' when doReedSolomon_busy = '0' else '0';
  tmp_0205 <= '1' when doReedSolomon_req_local = '0' else '0';
  tmp_0206 <= tmp_0204 and tmp_0205;
  tmp_0207 <= '1' when tmp_0206 = '1' else '0';
  tmp_0208 <= '1' when doHamming_busy = '0' else '0';
  tmp_0209 <= '1' when doHamming_req_local = '0' else '0';
  tmp_0210 <= tmp_0208 and tmp_0209;
  tmp_0211 <= '1' when tmp_0210 = '1' else '0';
  tmp_0212 <= '1' when doParity_busy = '0' else '0';
  tmp_0213 <= '1' when doParity_req_local = '0' else '0';
  tmp_0214 <= tmp_0212 and tmp_0213;
  tmp_0215 <= '1' when tmp_0214 = '1' else '0';
  tmp_0216 <= '1' when doEcc_method /= doEcc_method_S_0000 else '0';
  tmp_0217 <= '1' when doEcc_method /= doEcc_method_S_0001 else '0';
  tmp_0218 <= tmp_0217 and doEcc_req_flag_edge;
  tmp_0219 <= tmp_0216 and tmp_0218;
  tmp_0220 <= not doReedSolomon_req_flag_d;
  tmp_0221 <= doReedSolomon_req_flag and tmp_0220;
  tmp_0222 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0223 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0224 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0000 else '0';
  tmp_0225 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0001 else '0';
  tmp_0226 <= tmp_0225 and doReedSolomon_req_flag_edge;
  tmp_0227 <= tmp_0224 and tmp_0226;
  tmp_0228 <= not doHamming_req_flag_d;
  tmp_0229 <= doHamming_req_flag and tmp_0228;
  tmp_0230 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0231 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0232 <= '1' when doHamming_method /= doHamming_method_S_0000 else '0';
  tmp_0233 <= '1' when doHamming_method /= doHamming_method_S_0001 else '0';
  tmp_0234 <= tmp_0233 and doHamming_req_flag_edge;
  tmp_0235 <= tmp_0232 and tmp_0234;
  tmp_0236 <= not doParity_req_flag_d;
  tmp_0237 <= doParity_req_flag and tmp_0236;
  tmp_0238 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0239 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0240 <= '1' when doParity_method /= doParity_method_S_0000 else '0';
  tmp_0241 <= '1' when doParity_method /= doParity_method_S_0001 else '0';
  tmp_0242 <= tmp_0241 and doParity_req_flag_edge;
  tmp_0243 <= tmp_0240 and tmp_0242;
  tmp_0244 <= not checkReedSolomon_req_flag_d;
  tmp_0245 <= checkReedSolomon_req_flag and tmp_0244;
  tmp_0246 <= checkReedSolomon_req_flag or checkReedSolomon_req_flag_d;
  tmp_0247 <= checkReedSolomon_req_flag or checkReedSolomon_req_flag_d;
  tmp_0248 <= '1' when checkReedSolomon_method /= checkReedSolomon_method_S_0000 else '0';
  tmp_0249 <= '1' when checkReedSolomon_method /= checkReedSolomon_method_S_0001 else '0';
  tmp_0250 <= tmp_0249 and checkReedSolomon_req_flag_edge;
  tmp_0251 <= tmp_0248 and tmp_0250;
  tmp_0252 <= not checkHamming_req_flag_d;
  tmp_0253 <= checkHamming_req_flag and tmp_0252;
  tmp_0254 <= checkHamming_req_flag or checkHamming_req_flag_d;
  tmp_0255 <= checkHamming_req_flag or checkHamming_req_flag_d;
  tmp_0256 <= '1' when checkHamming_method /= checkHamming_method_S_0000 else '0';
  tmp_0257 <= '1' when checkHamming_method /= checkHamming_method_S_0001 else '0';
  tmp_0258 <= tmp_0257 and checkHamming_req_flag_edge;
  tmp_0259 <= tmp_0256 and tmp_0258;
  tmp_0260 <= not checkParity_req_flag_d;
  tmp_0261 <= checkParity_req_flag and tmp_0260;
  tmp_0262 <= checkParity_req_flag or checkParity_req_flag_d;
  tmp_0263 <= checkParity_req_flag or checkParity_req_flag_d;
  tmp_0264 <= '1' when checkParity_method /= checkParity_method_S_0000 else '0';
  tmp_0265 <= '1' when checkParity_method /= checkParity_method_S_0001 else '0';
  tmp_0266 <= tmp_0265 and checkParity_req_flag_edge;
  tmp_0267 <= tmp_0264 and tmp_0266;

  -- sequencers
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        setPageSize_method <= setPageSize_method_IDLE;
        setPageSize_method_delay <= (others => '0');
      else
        case (setPageSize_method) is
          when setPageSize_method_IDLE => 
            setPageSize_method <= setPageSize_method_S_0000;
          when setPageSize_method_S_0000 => 
            setPageSize_method <= setPageSize_method_S_0001;
          when setPageSize_method_S_0001 => 
            if tmp_0006 = '1' then
              setPageSize_method <= setPageSize_method_S_0002;
            end if;
          when setPageSize_method_S_0002 => 
            setPageSize_method <= setPageSize_method_S_0000;
          when others => null;
        end case;
        setPageSize_req_flag_d <= setPageSize_req_flag;
        if (tmp_0008 and tmp_0010) = '1' then
          setPageSize_method <= setPageSize_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_method <= writeFlow_method_IDLE;
        writeFlow_method_delay <= (others => '0');
      else
        case (writeFlow_method) is
          when writeFlow_method_IDLE => 
            writeFlow_method <= writeFlow_method_S_0000;
          when writeFlow_method_S_0000 => 
            writeFlow_method <= writeFlow_method_S_0001;
          when writeFlow_method_S_0001 => 
            if tmp_0015 = '1' then
              writeFlow_method <= writeFlow_method_S_0002;
            end if;
          when writeFlow_method_S_0002 => 
            writeFlow_method <= writeFlow_method_S_0002_body;
          when writeFlow_method_S_0003 => 
            writeFlow_method <= writeFlow_method_S_0004;
          when writeFlow_method_S_0004 => 
            writeFlow_method <= writeFlow_method_S_0004_body;
          when writeFlow_method_S_0005 => 
            writeFlow_method <= writeFlow_method_S_0000;
          when writeFlow_method_S_0002_body => 
            writeFlow_method <= writeFlow_method_S_0002_wait;
          when writeFlow_method_S_0002_wait => 
            if getEcc_call_flag_0002 = '1' then
              writeFlow_method <= writeFlow_method_S_0003;
            end if;
          when writeFlow_method_S_0004_body => 
            writeFlow_method <= writeFlow_method_S_0004_wait;
          when writeFlow_method_S_0004_wait => 
            if doEcc_call_flag_0004 = '1' then
              writeFlow_method <= writeFlow_method_S_0005;
            end if;
          when others => null;
        end case;
        writeFlow_req_flag_d <= writeFlow_req_flag;
        if (tmp_0025 and tmp_0027) = '1' then
          writeFlow_method <= writeFlow_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_method <= readFlow_method_IDLE;
        readFlow_method_delay <= (others => '0');
      else
        case (readFlow_method) is
          when readFlow_method_IDLE => 
            readFlow_method <= readFlow_method_S_0000;
          when readFlow_method_S_0000 => 
            readFlow_method <= readFlow_method_S_0001;
          when readFlow_method_S_0001 => 
            if tmp_0033 = '1' then
              readFlow_method <= readFlow_method_S_0002;
            end if;
          when readFlow_method_S_0002 => 
            readFlow_method <= readFlow_method_S_0002_body;
          when readFlow_method_S_0003 => 
            readFlow_method <= readFlow_method_S_0004;
          when readFlow_method_S_0004 => 
            readFlow_method <= readFlow_method_S_0004_body;
          when readFlow_method_S_0005 => 
            readFlow_method <= readFlow_method_S_0006;
          when readFlow_method_S_0006 => 
            if tmp_0039 = '1' then
              readFlow_method <= readFlow_method_S_0008;
            elsif tmp_0040 = '1' then
              readFlow_method <= readFlow_method_S_0010;
            end if;
          when readFlow_method_S_0008 => 
            readFlow_method <= readFlow_method_S_0000;
          when readFlow_method_S_0010 => 
            readFlow_method <= readFlow_method_S_0010_body;
          when readFlow_method_S_0011 => 
            readFlow_method <= readFlow_method_S_0000;
          when readFlow_method_S_0002_body => 
            readFlow_method <= readFlow_method_S_0002_wait;
          when readFlow_method_S_0002_wait => 
            if getEcc_call_flag_0002 = '1' then
              readFlow_method <= readFlow_method_S_0003;
            end if;
          when readFlow_method_S_0004_body => 
            readFlow_method <= readFlow_method_S_0004_wait;
          when readFlow_method_S_0004_wait => 
            if checkECC_call_flag_0004 = '1' then
              readFlow_method <= readFlow_method_S_0005;
            end if;
          when readFlow_method_S_0010_body => 
            readFlow_method <= readFlow_method_S_0010_wait;
          when readFlow_method_S_0010_wait => 
            if migration_call_flag_0010 = '1' then
              readFlow_method <= readFlow_method_S_0011;
            end if;
          when others => null;
        end case;
        readFlow_req_flag_d <= readFlow_req_flag;
        if (tmp_0045 and tmp_0047) = '1' then
          readFlow_method <= readFlow_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_method <= getEcc_method_IDLE;
        getEcc_method_delay <= (others => '0');
      else
        case (getEcc_method) is
          when getEcc_method_IDLE => 
            getEcc_method <= getEcc_method_S_0000;
          when getEcc_method_S_0000 => 
            getEcc_method <= getEcc_method_S_0001;
          when getEcc_method_S_0001 => 
            if tmp_0053 = '1' then
              getEcc_method <= getEcc_method_S_0002;
            end if;
          when getEcc_method_S_0002 => 
            getEcc_method <= getEcc_method_S_0002_body;
          when getEcc_method_S_0003 => 
            getEcc_method <= getEcc_method_S_0004;
          when getEcc_method_S_0004 => 
            getEcc_method <= getEcc_method_S_0013;
          when getEcc_method_S_0013 => 
            getEcc_method <= getEcc_method_S_0014;
          when getEcc_method_S_0014 => 
            getEcc_method <= getEcc_method_S_0005;
          when getEcc_method_S_0005 => 
            getEcc_method <= getEcc_method_S_0006;
          when getEcc_method_S_0006 => 
            getEcc_method <= getEcc_method_S_0015;
          when getEcc_method_S_0015 => 
            getEcc_method <= getEcc_method_S_0016;
          when getEcc_method_S_0016 => 
            getEcc_method <= getEcc_method_S_0007;
          when getEcc_method_S_0007 => 
            getEcc_method <= getEcc_method_S_0009;
          when getEcc_method_S_0009 => 
            getEcc_method <= getEcc_method_S_0010;
          when getEcc_method_S_0010 => 
            getEcc_method <= getEcc_method_S_0011;
          when getEcc_method_S_0011 => 
            getEcc_method <= getEcc_method_S_0000;
          when getEcc_method_S_0002_body => 
            getEcc_method <= getEcc_method_S_0002_wait;
          when getEcc_method_S_0002_wait => 
            if getPosition_call_flag_0002 = '1' then
              getEcc_method <= getEcc_method_S_0003;
            end if;
          when others => null;
        end case;
        getEcc_req_flag_d <= getEcc_req_flag;
        if (tmp_0059 and tmp_0061) = '1' then
          getEcc_method <= getEcc_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_method <= getPosition_method_IDLE;
        getPosition_method_delay <= (others => '0');
      else
        case (getPosition_method) is
          when getPosition_method_IDLE => 
            getPosition_method <= getPosition_method_S_0000;
          when getPosition_method_S_0000 => 
            getPosition_method <= getPosition_method_S_0001;
          when getPosition_method_S_0001 => 
            if tmp_0068 = '1' then
              getPosition_method <= getPosition_method_S_0002;
            end if;
          when getPosition_method_S_0002 => 
            if getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
              getPosition_method_delay <= (others => '0');
              getPosition_method <= getPosition_method_S_0003;
            else
              getPosition_method_delay <= getPosition_method_delay + 1;
            end if;
          when getPosition_method_S_0003 => 
            if getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
              getPosition_method_delay <= (others => '0');
              getPosition_method <= getPosition_method_S_0004;
            else
              getPosition_method_delay <= getPosition_method_delay + 1;
            end if;
          when getPosition_method_S_0004 => 
            getPosition_method <= getPosition_method_S_0000;
          when others => null;
        end case;
        getPosition_req_flag_d <= getPosition_req_flag;
        if (tmp_0070 and tmp_0072) = '1' then
          getPosition_method <= getPosition_method_S_0001;
        end if;
      end if;
    end if;
  end process;

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
            if tmp_0076 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0002;
            end if;
          when incrementEcc_method_S_0002 => 
            if tmp_0078 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0023;
            elsif tmp_0079 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0017;
            elsif tmp_0080 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0011;
            elsif tmp_0081 = '1' then
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
        if (tmp_0082 and tmp_0084) = '1' then
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
            if tmp_0088 = '1' then
              migration_method <= migration_method_S_0002;
            end if;
          when migration_method_S_0002 => 
            migration_method <= migration_method_S_0003;
          when migration_method_S_0003 => 
            if tmp_0090 = '1' then
              migration_method <= migration_method_S_0005;
            elsif tmp_0091 = '1' then
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
            if tmp_0092 = '1' then
              migration_method <= migration_method_S_0019;
            elsif tmp_0093 = '1' then
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
        if (tmp_0106 and tmp_0108) = '1' then
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
            if tmp_0119 = '1' then
              write_method <= write_method_S_0002;
            end if;
          when write_method_S_0002 => 
            write_method <= write_method_S_0002_body;
          when write_method_S_0003 => 
            write_method <= write_method_S_0004;
          when write_method_S_0004 => 
            if tmp_0125 = '1' then
              write_method <= write_method_S_0013;
            elsif tmp_0126 = '1' then
              write_method <= write_method_S_0010;
            elsif tmp_0127 = '1' then
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
        if (tmp_0140 and tmp_0142) = '1' then
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
            if tmp_0146 = '1' then
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
        if (tmp_0152 and tmp_0154) = '1' then
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
            if tmp_0158 = '1' then
              writeRAM_method <= writeRAM_method_S_0000;
            end if;
          when others => null;
        end case;
        writeRAM_req_flag_d <= writeRAM_req_flag;
        if (tmp_0160 and tmp_0162) = '1' then
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
            if tmp_0166 = '1' then
              readRAM_method <= readRAM_method_S_0002;
            end if;
          when readRAM_method_S_0002 => 
            readRAM_method <= readRAM_method_S_0000;
          when others => null;
        end case;
        readRAM_req_flag_d <= readRAM_req_flag;
        if (tmp_0168 and tmp_0170) = '1' then
          readRAM_method <= readRAM_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_method <= checkECC_method_IDLE;
        checkECC_method_delay <= (others => '0');
      else
        case (checkECC_method) is
          when checkECC_method_IDLE => 
            checkECC_method <= checkECC_method_S_0000;
          when checkECC_method_S_0000 => 
            checkECC_method <= checkECC_method_S_0001;
          when checkECC_method_S_0001 => 
            if tmp_0174 = '1' then
              checkECC_method <= checkECC_method_S_0002;
            end if;
          when checkECC_method_S_0002 => 
            if tmp_0176 = '1' then
              checkECC_method <= checkECC_method_S_0014;
            elsif tmp_0177 = '1' then
              checkECC_method <= checkECC_method_S_0011;
            elsif tmp_0178 = '1' then
              checkECC_method <= checkECC_method_S_0008;
            elsif tmp_0179 = '1' then
              checkECC_method <= checkECC_method_S_0005;
            else
              checkECC_method <= checkECC_method_S_0000;
            end if;
          when checkECC_method_S_0005 => 
            checkECC_method <= checkECC_method_S_0005_body;
          when checkECC_method_S_0006 => 
            checkECC_method <= checkECC_method_S_0000;
          when checkECC_method_S_0008 => 
            checkECC_method <= checkECC_method_S_0008_body;
          when checkECC_method_S_0009 => 
            checkECC_method <= checkECC_method_S_0000;
          when checkECC_method_S_0011 => 
            checkECC_method <= checkECC_method_S_0011_body;
          when checkECC_method_S_0012 => 
            checkECC_method <= checkECC_method_S_0000;
          when checkECC_method_S_0014 => 
            checkECC_method <= checkECC_method_S_0000;
          when checkECC_method_S_0005_body => 
            checkECC_method <= checkECC_method_S_0005_wait;
          when checkECC_method_S_0005_wait => 
            if checkReedSolomon_call_flag_0005 = '1' then
              checkECC_method <= checkECC_method_S_0006;
            end if;
          when checkECC_method_S_0008_body => 
            checkECC_method <= checkECC_method_S_0008_wait;
          when checkECC_method_S_0008_wait => 
            if checkHamming_call_flag_0008 = '1' then
              checkECC_method <= checkECC_method_S_0009;
            end if;
          when checkECC_method_S_0011_body => 
            checkECC_method <= checkECC_method_S_0011_wait;
          when checkECC_method_S_0011_wait => 
            if checkParity_call_flag_0011 = '1' then
              checkECC_method <= checkECC_method_S_0012;
            end if;
          when others => null;
        end case;
        checkECC_req_flag_d <= checkECC_req_flag;
        if (tmp_0192 and tmp_0194) = '1' then
          checkECC_method <= checkECC_method_S_0001;
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
            if tmp_0198 = '1' then
              doEcc_method <= doEcc_method_S_0002;
            end if;
          when doEcc_method_S_0002 => 
            if tmp_0200 = '1' then
              doEcc_method <= doEcc_method_S_0014;
            elsif tmp_0201 = '1' then
              doEcc_method <= doEcc_method_S_0011;
            elsif tmp_0202 = '1' then
              doEcc_method <= doEcc_method_S_0008;
            elsif tmp_0203 = '1' then
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
        if (tmp_0216 and tmp_0218) = '1' then
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
            if tmp_0222 = '1' then
              doReedSolomon_method <= doReedSolomon_method_S_0002;
            end if;
          when doReedSolomon_method_S_0002 => 
            doReedSolomon_method <= doReedSolomon_method_S_0000;
          when others => null;
        end case;
        doReedSolomon_req_flag_d <= doReedSolomon_req_flag;
        if (tmp_0224 and tmp_0226) = '1' then
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
            if tmp_0230 = '1' then
              doHamming_method <= doHamming_method_S_0002;
            end if;
          when doHamming_method_S_0002 => 
            doHamming_method <= doHamming_method_S_0000;
          when others => null;
        end case;
        doHamming_req_flag_d <= doHamming_req_flag;
        if (tmp_0232 and tmp_0234) = '1' then
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
            if tmp_0238 = '1' then
              doParity_method <= doParity_method_S_0002;
            end if;
          when doParity_method_S_0002 => 
            doParity_method <= doParity_method_S_0000;
          when others => null;
        end case;
        doParity_req_flag_d <= doParity_req_flag;
        if (tmp_0240 and tmp_0242) = '1' then
          doParity_method <= doParity_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_method <= checkReedSolomon_method_IDLE;
        checkReedSolomon_method_delay <= (others => '0');
      else
        case (checkReedSolomon_method) is
          when checkReedSolomon_method_IDLE => 
            checkReedSolomon_method <= checkReedSolomon_method_S_0000;
          when checkReedSolomon_method_S_0000 => 
            checkReedSolomon_method <= checkReedSolomon_method_S_0001;
          when checkReedSolomon_method_S_0001 => 
            if tmp_0246 = '1' then
              checkReedSolomon_method <= checkReedSolomon_method_S_0002;
            end if;
          when checkReedSolomon_method_S_0002 => 
            checkReedSolomon_method <= checkReedSolomon_method_S_0000;
          when others => null;
        end case;
        checkReedSolomon_req_flag_d <= checkReedSolomon_req_flag;
        if (tmp_0248 and tmp_0250) = '1' then
          checkReedSolomon_method <= checkReedSolomon_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_method <= checkHamming_method_IDLE;
        checkHamming_method_delay <= (others => '0');
      else
        case (checkHamming_method) is
          when checkHamming_method_IDLE => 
            checkHamming_method <= checkHamming_method_S_0000;
          when checkHamming_method_S_0000 => 
            checkHamming_method <= checkHamming_method_S_0001;
          when checkHamming_method_S_0001 => 
            if tmp_0254 = '1' then
              checkHamming_method <= checkHamming_method_S_0002;
            end if;
          when checkHamming_method_S_0002 => 
            checkHamming_method <= checkHamming_method_S_0000;
          when others => null;
        end case;
        checkHamming_req_flag_d <= checkHamming_req_flag;
        if (tmp_0256 and tmp_0258) = '1' then
          checkHamming_method <= checkHamming_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_method <= checkParity_method_IDLE;
        checkParity_method_delay <= (others => '0');
      else
        case (checkParity_method) is
          when checkParity_method_IDLE => 
            checkParity_method <= checkParity_method_S_0000;
          when checkParity_method_S_0000 => 
            checkParity_method <= checkParity_method_S_0001;
          when checkParity_method_S_0001 => 
            if tmp_0262 = '1' then
              checkParity_method <= checkParity_method_S_0002;
            end if;
          when checkParity_method_S_0002 => 
            checkParity_method <= checkParity_method_S_0000;
          when others => null;
        end case;
        checkParity_req_flag_d <= checkParity_req_flag;
        if (tmp_0264 and tmp_0266) = '1' then
          checkParity_method <= checkParity_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_pageSize_0006 <= (others => '0');
      else
        if setPageSize_method = setPageSize_method_S_0002 then
          class_pageSize_0006 <= setPageSize_newPageSize_0013;
        end if;
      end if;
    end if;
  end process;

  class_data1_0007_clk <= clk_sig;

  class_data1_0007_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0007_address_b <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0004 then
          class_data1_0007_address_b <= getEcc_dataPosition_0028;
        elsif incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0007_address_b <= incrementEcc_position_0044;
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0007_address_b <= incrementEcc_position_0044;
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0007_address_b <= incrementEcc_position_0044;
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0007_address_b <= incrementEcc_position_0044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0007_din_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0007_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0007_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0007_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0007_din_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0007_we_b <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0007_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0007_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0007_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0007_we_b <= '1';
        else
          class_data1_0007_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0007_oe_b <= '0';
      else
        if getEcc_method = getEcc_method_S_0014 and getEcc_method_delay = 0 then
          class_data1_0007_oe_b <= '1';
        else
          class_data1_0007_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  class_data2_0010_clk <= clk_sig;

  class_data2_0010_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0010_address_b <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0006 then
          class_data2_0010_address_b <= getEcc_dataPosition_0028;
        elsif incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0010_address_b <= incrementEcc_position_0044;
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0010_address_b <= incrementEcc_position_0044;
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0010_address_b <= incrementEcc_position_0044;
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0010_address_b <= incrementEcc_position_0044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0010_din_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0010_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0010_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0010_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0010_din_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0010_we_b <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0010_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0010_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0010_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0010_we_b <= '1';
        else
          class_data2_0010_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0010_oe_b <= '0';
      else
        if getEcc_method = getEcc_method_S_0016 and getEcc_method_delay = 0 then
          class_data2_0010_oe_b <= '1';
        else
          class_data2_0010_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        setPageSize_newPageSize_0013 <= (others => '0');
      else
        if setPageSize_method = setPageSize_method_S_0001 then
          setPageSize_newPageSize_0013 <= tmp_0012;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_address_0014 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0001 then
          writeFlow_address_0014 <= tmp_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_data_0015 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0001 then
          writeFlow_data_0015 <= tmp_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00017 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0002_wait then
          method_result_00017 <= getEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_ecc_0016 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0003 then
          writeFlow_ecc_0016 <= method_result_00017;
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
        if writeFlow_method = writeFlow_method_S_0004_wait then
          method_result_00018 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_address_0019 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0001 then
          readFlow_address_0019 <= tmp_0049;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_data_0020 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0001 then
          readFlow_data_0020 <= tmp_0050;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00022 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0002_wait then
          method_result_00022 <= getEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_ecc_0021 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0003 then
          readFlow_ecc_0021 <= method_result_00022;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00024 <= '0';
      else
        if readFlow_method = readFlow_method_S_0004_wait then
          method_result_00024 <= checkECC_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_isOk_0023 <= '0';
      else
        if readFlow_method = readFlow_method_S_0005 then
          readFlow_isOk_0023 <= method_result_00024;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_address_0027 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0001 then
          getEcc_address_0027 <= getEcc_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_address_local <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0002_body and writeFlow_method_delay = 0 then
          getEcc_address_local <= writeFlow_address_0014;
        elsif readFlow_method = readFlow_method_S_0002_body and readFlow_method_delay = 0 then
          getEcc_address_local <= readFlow_address_0019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00029 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0002_wait then
          method_result_00029 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_dataPosition_0028 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0003 then
          getEcc_dataPosition_0028 <= method_result_00029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00031 <= '0';
      else
        if getEcc_method = getEcc_method_S_0014 then
          array_access_00031 <= std_logic(class_data1_0007_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_currentData1_0030 <= '0';
      else
        if getEcc_method = getEcc_method_S_0005 then
          getEcc_currentData1_0030 <= array_access_00031;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00033 <= '0';
      else
        if getEcc_method = getEcc_method_S_0016 then
          array_access_00033 <= std_logic(class_data2_0010_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_currentData2_0032 <= '0';
      else
        if getEcc_method = getEcc_method_S_0007 then
          getEcc_currentData2_0032 <= array_access_00033;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00036 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0007 then
          cond_expr_00036 <= tmp_0063;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00039 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0009 then
          cond_expr_00039 <= tmp_0064;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00040 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0010 then
          binary_expr_00040 <= tmp_0065;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_address_0041 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0001 then
          getPosition_address_0041 <= getPosition_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_address_local <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0002_body and getEcc_method_delay = 0 then
          getPosition_address_local <= getEcc_address_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00042 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
          binary_expr_00042 <= u_synthesijer_mul32_getPosition_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00043 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
          binary_expr_00043 <= u_synthesijer_div32_getPosition_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_position_0044 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_position_0044 <= incrementEcc_position_local;
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
          incrementEcc_position_local <= migration_position_0071;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_ecc_0045 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_ecc_0045 <= incrementEcc_ecc_local;
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
          incrementEcc_ecc_local <= binary_expr_00090;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_address_0066 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_address_0066 <= migration_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_address_local <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0010_body and readFlow_method_delay = 0 then
          migration_address_local <= readFlow_address_0019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_ecc_0067 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_ecc_0067 <= migration_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_ecc_local <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0010_body and readFlow_method_delay = 0 then
          migration_ecc_local <= readFlow_ecc_0021;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_pageSize_0068 <= (others => '0');
      else
        if migration_method = migration_method_S_0001 then
          migration_pageSize_0068 <= migration_pageSize_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_pageSize_local <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0010_body and readFlow_method_delay = 0 then
          migration_pageSize_local <= class_pageSize_0006;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00070 <= '0';
      else
        if migration_method = migration_method_S_0002 then
          binary_expr_00070 <= tmp_0110;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00072 <= (others => '0');
      else
        if migration_method = migration_method_S_0007 and migration_method_delay >= 1 and u_synthesijer_div32_migration_valid = '1' then
          binary_expr_00072 <= u_synthesijer_div32_migration_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_position_0071 <= (others => '0');
      else
        if migration_method = migration_method_S_0008 then
          migration_position_0071 <= binary_expr_00072;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00074 <= (others => '0');
      else
        if migration_method = migration_method_S_0009 and migration_method_delay >= 1 and u_synthesijer_mul32_migration_valid = '1' then
          binary_expr_00074 <= u_synthesijer_mul32_migration_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_initialAddress_0073 <= (others => '0');
      else
        if migration_method = migration_method_S_0010 then
          migration_initialAddress_0073 <= binary_expr_00074;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_i_0075 <= X"00000000";
      else
        if migration_method = migration_method_S_0010 then
          migration_i_0075 <= X"00000000";
        elsif migration_method = migration_method_S_0017 then
          migration_i_0075 <= unary_expr_00078;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00077 <= '0';
      else
        if migration_method = migration_method_S_0012 then
          binary_expr_00077 <= tmp_0111;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_00078 <= (others => '0');
      else
        if migration_method = migration_method_S_0015 then
          unary_expr_00078 <= tmp_0112;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_postfix_preserved_00079 <= (others => '0');
      else
        if migration_method = migration_method_S_0015 then
          unary_expr_postfix_preserved_00079 <= migration_i_0075;
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
        if migration_method = migration_method_S_0020_wait then
          method_result_00082 <= read_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00083 <= (others => '0');
      else
        if migration_method = migration_method_S_0019 then
          binary_expr_00083 <= tmp_0113;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_read_0081 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          migration_read_0081 <= method_result_00082;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00085 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          binary_expr_00085 <= tmp_0114;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00087 <= (others => '0');
      else
        if migration_method = migration_method_S_0021 then
          binary_expr_00087 <= tmp_0115;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00090 <= (others => '0');
      else
        if migration_method = migration_method_S_0026 then
          binary_expr_00090 <= tmp_0116;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_address_0091 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_address_0091 <= write_address_local;
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
          write_address_local <= binary_expr_00085;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_data_0092 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_data_0092 <= write_data_local;
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
          write_data_local <= migration_read_0081;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_ecc_0093 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_ecc_0093 <= write_ecc_local;
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
          write_ecc_local <= binary_expr_00087;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00095 <= (others => '0');
      else
        if write_method = write_method_S_0002_wait then
          method_result_00095 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_newData_0094 <= (others => '0');
      else
        if write_method = write_method_S_0003 then
          write_newData_0094 <= method_result_00095;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_address_0102 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_address_0102 <= read_address_local;
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
          read_address_local <= binary_expr_00083;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_ecc_0103 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_ecc_0103 <= read_ecc_local;
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
          read_ecc_local <= migration_ecc_0067;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00105 <= (others => '0');
      else
        if read_method = read_method_S_0002_wait then
          method_result_00105 <= readRAM_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_data_0104 <= (others => '0');
      else
        if read_method = read_method_S_0003 then
          read_data_0104 <= method_result_00105;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00106 <= (others => '0');
      else
        if read_method = read_method_S_0004_wait then
          method_result_00106 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_address_0107 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_address_0107 <= writeRAM_address_local;
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
          writeRAM_address_local <= write_address_0091;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0091;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0091;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_data_0108 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_data_0108 <= writeRAM_data_local;
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
          writeRAM_data_local <= write_newData_0094;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0094;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0094;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_address_0109 <= (others => '0');
      else
        if readRAM_method = readRAM_method_S_0001 then
          readRAM_address_0109 <= readRAM_address_local;
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
          readRAM_address_local <= read_address_0102;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_data_0111 <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0001 then
          checkECC_data_0111 <= checkECC_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_data_local <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0004_body and readFlow_method_delay = 0 then
          checkECC_data_local <= readFlow_data_0020;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_ecc_0112 <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0001 then
          checkECC_ecc_0112 <= checkECC_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_ecc_local <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0004_body and readFlow_method_delay = 0 then
          checkECC_ecc_local <= readFlow_ecc_0021;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00117 <= '0';
      else
        if checkECC_method = checkECC_method_S_0005_wait then
          method_result_00117 <= checkReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00118 <= '0';
      else
        if checkECC_method = checkECC_method_S_0008_wait then
          method_result_00118 <= checkHamming_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00119 <= '0';
      else
        if checkECC_method = checkECC_method_S_0011_wait then
          method_result_00119 <= checkParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_data_0121 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_data_0121 <= doEcc_data_local;
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
        if writeFlow_method = writeFlow_method_S_0004_body and writeFlow_method_delay = 0 then
          doEcc_data_local <= writeFlow_data_0015;
        elsif write_method = write_method_S_0002_body and write_method_delay = 0 then
          doEcc_data_local <= write_data_0092;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          doEcc_data_local <= read_data_0104;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_ecc_0122 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_ecc_0122 <= doEcc_ecc_local;
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
        if writeFlow_method = writeFlow_method_S_0004_body and writeFlow_method_delay = 0 then
          doEcc_ecc_local <= writeFlow_ecc_0016;
        elsif write_method = write_method_S_0002_body and write_method_delay = 0 then
          doEcc_ecc_local <= write_ecc_0093;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          doEcc_ecc_local <= read_ecc_0103;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00127 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0005_wait then
          method_result_00127 <= doReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00128 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0008_wait then
          method_result_00128 <= doHamming_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00129 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0011_wait then
          method_result_00129 <= doParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_data_0130 <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0001 then
          doReedSolomon_data_0130 <= doReedSolomon_data_local;
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
          doReedSolomon_data_local <= doEcc_data_0121;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_data_0131 <= (others => '0');
      else
        if doHamming_method = doHamming_method_S_0001 then
          doHamming_data_0131 <= doHamming_data_local;
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
          doHamming_data_local <= doEcc_data_0121;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_data_0132 <= (others => '0');
      else
        if doParity_method = doParity_method_S_0001 then
          doParity_data_0132 <= doParity_data_local;
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
          doParity_data_local <= doEcc_data_0121;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_data_0133 <= (others => '0');
      else
        if checkReedSolomon_method = checkReedSolomon_method_S_0001 then
          checkReedSolomon_data_0133 <= checkReedSolomon_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_data_local <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0005_body and checkECC_method_delay = 0 then
          checkReedSolomon_data_local <= checkECC_data_0111;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_data_0135 <= (others => '0');
      else
        if checkHamming_method = checkHamming_method_S_0001 then
          checkHamming_data_0135 <= checkHamming_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_data_local <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0008_body and checkECC_method_delay = 0 then
          checkHamming_data_local <= checkECC_data_0111;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_data_0137 <= (others => '0');
      else
        if checkParity_method = checkParity_method_S_0001 then
          checkParity_data_0137 <= checkParity_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_data_local <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0011_body and checkECC_method_delay = 0 then
          checkParity_data_local <= checkECC_data_0111;
        end if;
      end if;
    end if;
  end process;

  setPageSize_req_flag <= tmp_0001;

  writeFlow_req_flag <= tmp_0002;

  readFlow_req_flag <= tmp_0003;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_return <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0011 then
          getEcc_return <= binary_expr_00040;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_busy <= '0';
      else
        if getEcc_method = getEcc_method_S_0000 then
          getEcc_busy <= '0';
        elsif getEcc_method = getEcc_method_S_0001 then
          getEcc_busy <= tmp_0054;
        end if;
      end if;
    end if;
  end process;

  getEcc_req_flag <= getEcc_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_req_local <= '0';
      else
        if writeFlow_method = writeFlow_method_S_0002_body then
          getEcc_req_local <= '1';
        elsif readFlow_method = readFlow_method_S_0002_body then
          getEcc_req_local <= '1';
        else
          getEcc_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_return <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0004 then
          getPosition_return <= binary_expr_00043;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_busy <= '0';
      else
        if getPosition_method = getPosition_method_S_0000 then
          getPosition_busy <= '0';
        elsif getPosition_method = getPosition_method_S_0001 then
          getPosition_busy <= tmp_0069;
        end if;
      end if;
    end if;
  end process;

  getPosition_req_flag <= getPosition_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_req_local <= '0';
      else
        if getEcc_method = getEcc_method_S_0002_body then
          getPosition_req_local <= '1';
        else
          getPosition_req_local <= '0';
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
          incrementEcc_busy <= tmp_0077;
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

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_busy <= '0';
      else
        if migration_method = migration_method_S_0000 then
          migration_busy <= '0';
        elsif migration_method = migration_method_S_0001 then
          migration_busy <= tmp_0089;
        end if;
      end if;
    end if;
  end process;

  migration_req_flag <= migration_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration_req_local <= '0';
      else
        if readFlow_method = readFlow_method_S_0010_body then
          migration_req_local <= '1';
        else
          migration_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_busy <= '0';
      else
        if write_method = write_method_S_0000 then
          write_busy <= '0';
        elsif write_method = write_method_S_0001 then
          write_busy <= tmp_0120;
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
          read_return <= method_result_00106;
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
          read_busy <= tmp_0147;
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
          writeRAM_busy <= tmp_0159;
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
          readRAM_busy <= tmp_0167;
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
        checkECC_return <= '0';
      else
        if checkECC_method = checkECC_method_S_0006 then
          checkECC_return <= method_result_00117;
        elsif checkECC_method = checkECC_method_S_0009 then
          checkECC_return <= method_result_00118;
        elsif checkECC_method = checkECC_method_S_0012 then
          checkECC_return <= method_result_00119;
        elsif checkECC_method = checkECC_method_S_0014 then
          checkECC_return <= '1';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_busy <= '0';
      else
        if checkECC_method = checkECC_method_S_0000 then
          checkECC_busy <= '0';
        elsif checkECC_method = checkECC_method_S_0001 then
          checkECC_busy <= tmp_0175;
        end if;
      end if;
    end if;
  end process;

  checkECC_req_flag <= checkECC_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_req_local <= '0';
      else
        if readFlow_method = readFlow_method_S_0004_body then
          checkECC_req_local <= '1';
        else
          checkECC_req_local <= '0';
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
          doEcc_return <= method_result_00127;
        elsif doEcc_method = doEcc_method_S_0009 then
          doEcc_return <= method_result_00128;
        elsif doEcc_method = doEcc_method_S_0012 then
          doEcc_return <= method_result_00129;
        elsif doEcc_method = doEcc_method_S_0014 then
          doEcc_return <= doEcc_data_0121;
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
          doEcc_busy <= tmp_0199;
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
        if writeFlow_method = writeFlow_method_S_0004_body then
          doEcc_req_local <= '1';
        elsif write_method = write_method_S_0002_body then
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
          doReedSolomon_return <= doReedSolomon_data_0130;
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
          doReedSolomon_busy <= tmp_0223;
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
          doHamming_return <= doHamming_data_0131;
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
          doHamming_busy <= tmp_0231;
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
          doParity_return <= doParity_data_0132;
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
          doParity_busy <= tmp_0239;
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

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_return <= '0';
      else
        if checkReedSolomon_method = checkReedSolomon_method_S_0002 then
          checkReedSolomon_return <= '1';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_busy <= '0';
      else
        if checkReedSolomon_method = checkReedSolomon_method_S_0000 then
          checkReedSolomon_busy <= '0';
        elsif checkReedSolomon_method = checkReedSolomon_method_S_0001 then
          checkReedSolomon_busy <= tmp_0247;
        end if;
      end if;
    end if;
  end process;

  checkReedSolomon_req_flag <= checkReedSolomon_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_req_local <= '0';
      else
        if checkECC_method = checkECC_method_S_0005_body then
          checkReedSolomon_req_local <= '1';
        else
          checkReedSolomon_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_return <= '0';
      else
        if checkHamming_method = checkHamming_method_S_0002 then
          checkHamming_return <= '1';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_busy <= '0';
      else
        if checkHamming_method = checkHamming_method_S_0000 then
          checkHamming_busy <= '0';
        elsif checkHamming_method = checkHamming_method_S_0001 then
          checkHamming_busy <= tmp_0255;
        end if;
      end if;
    end if;
  end process;

  checkHamming_req_flag <= checkHamming_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_req_local <= '0';
      else
        if checkECC_method = checkECC_method_S_0008_body then
          checkHamming_req_local <= '1';
        else
          checkHamming_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_return <= '0';
      else
        if checkParity_method = checkParity_method_S_0002 then
          checkParity_return <= '1';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_busy <= '0';
      else
        if checkParity_method = checkParity_method_S_0000 then
          checkParity_busy <= '0';
        elsif checkParity_method = checkParity_method_S_0001 then
          checkParity_busy <= tmp_0263;
        end if;
      end if;
    end if;
  end process;

  checkParity_req_flag <= checkParity_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_req_local <= '0';
      else
        if checkECC_method = checkECC_method_S_0011_body then
          checkParity_req_local <= '1';
        else
          checkParity_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  setPageSize_req_flag_edge <= tmp_0005;

  writeFlow_req_flag_edge <= tmp_0014;

  getEcc_call_flag_0002 <= tmp_0020;

  doEcc_call_flag_0004 <= tmp_0024;

  readFlow_req_flag_edge <= tmp_0032;

  checkECC_call_flag_0004 <= tmp_0038;

  migration_call_flag_0010 <= tmp_0044;

  getEcc_req_flag_edge <= tmp_0052;

  getPosition_call_flag_0002 <= tmp_0058;

  getPosition_req_flag_edge <= tmp_0067;

  u_synthesijer_mul32_getPosition_clk <= clk_sig;

  u_synthesijer_mul32_getPosition_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_mul32_getPosition_a <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay = 0 then
          u_synthesijer_mul32_getPosition_a <= class_pageSize_0006;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_mul32_getPosition_b <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay = 0 then
          u_synthesijer_mul32_getPosition_b <= class_BYTE_SIZE_0004;
        end if;
      end if;
    end if;
  end process;

  u_synthesijer_div32_getPosition_clk <= clk_sig;

  u_synthesijer_div32_getPosition_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_getPosition_a <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay = 0 then
          u_synthesijer_div32_getPosition_a <= getPosition_address_0041;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_getPosition_b <= X"00000001";
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay = 0 then
          u_synthesijer_div32_getPosition_b <= binary_expr_00042;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_getPosition_nd <= '0';
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay = 0 then
          u_synthesijer_div32_getPosition_nd <= '1';
        else
          u_synthesijer_div32_getPosition_nd <= '0';
        end if;
      end if;
    end if;
  end process;

  incrementEcc_req_flag_edge <= tmp_0075;

  migration_req_flag_edge <= tmp_0087;

  u_synthesijer_div32_migration_clk <= clk_sig;

  u_synthesijer_div32_migration_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_migration_a <= (others => '0');
      else
        if migration_method = migration_method_S_0007 and migration_method_delay = 0 then
          u_synthesijer_div32_migration_a <= migration_address_0066;
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
          u_synthesijer_div32_migration_b <= migration_pageSize_0068;
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
          u_synthesijer_mul32_migration_a <= migration_position_0071;
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
          u_synthesijer_mul32_migration_b <= migration_pageSize_0068;
        end if;
      end if;
    end if;
  end process;

  read_call_flag_0020 <= tmp_0097;

  write_call_flag_0024 <= tmp_0101;

  incrementEcc_call_flag_0027 <= tmp_0105;

  write_req_flag_edge <= tmp_0118;

  doEcc_call_flag_0002 <= tmp_0124;

  writeRAM_call_flag_0007 <= tmp_0131;

  writeRAM_call_flag_0010 <= tmp_0135;

  writeRAM_call_flag_0013 <= tmp_0139;

  read_req_flag_edge <= tmp_0145;

  readRAM_call_flag_0002 <= tmp_0151;

  writeRAM_req_flag_edge <= tmp_0157;

  readRAM_req_flag_edge <= tmp_0165;

  checkECC_req_flag_edge <= tmp_0173;

  checkReedSolomon_call_flag_0005 <= tmp_0183;

  checkHamming_call_flag_0008 <= tmp_0187;

  checkParity_call_flag_0011 <= tmp_0191;

  doEcc_req_flag_edge <= tmp_0197;

  doReedSolomon_call_flag_0005 <= tmp_0207;

  doHamming_call_flag_0008 <= tmp_0211;

  doParity_call_flag_0011 <= tmp_0215;

  doReedSolomon_req_flag_edge <= tmp_0221;

  doHamming_req_flag_edge <= tmp_0229;

  doParity_req_flag_edge <= tmp_0237;

  checkReedSolomon_req_flag_edge <= tmp_0245;

  checkHamming_req_flag_edge <= tmp_0253;

  checkParity_req_flag_edge <= tmp_0261;


  inst_class_data1_0007 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data1_0007_length,
    address_b => class_data1_0007_address_b,
    din_b => class_data1_0007_din_b,
    dout_b => class_data1_0007_dout_b,
    we_b => class_data1_0007_we_b,
    oe_b => class_data1_0007_oe_b
  );

  inst_class_data2_0010 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data2_0010_length,
    address_b => class_data2_0010_address_b,
    din_b => class_data2_0010_din_b,
    dout_b => class_data2_0010_dout_b,
    we_b => class_data2_0010_we_b,
    oe_b => class_data2_0010_oe_b
  );

  inst_u_synthesijer_mul32_getPosition : synthesijer_mul32
  port map(
    clk => clk,
    reset => reset,
    a => u_synthesijer_mul32_getPosition_a,
    b => u_synthesijer_mul32_getPosition_b,
    nd => u_synthesijer_mul32_getPosition_nd,
    result => u_synthesijer_mul32_getPosition_result,
    valid => u_synthesijer_mul32_getPosition_valid
  );

  inst_u_synthesijer_div32_getPosition : synthesijer_div32
  port map(
    clk => clk,
    reset => reset,
    a => u_synthesijer_div32_getPosition_a,
    b => u_synthesijer_div32_getPosition_b,
    nd => u_synthesijer_div32_getPosition_nd,
    quantient => u_synthesijer_div32_getPosition_quantient,
    remainder => u_synthesijer_div32_getPosition_remainder,
    valid => u_synthesijer_div32_getPosition_valid
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
