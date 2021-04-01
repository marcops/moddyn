library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleDynamic_happyCase is
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
end moduledynamic_ModuleDynamic_happyCase;

architecture RTL of moduledynamic_ModuleDynamic_happyCase is

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
  signal getEcc_address_0026 : signed(32-1 downto 0) := (others => '0');
  signal getEcc_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00028 : signed(32-1 downto 0) := (others => '0');
  signal getEcc_dataPosition_0027 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00030 : std_logic := '0';
  signal getEcc_currentData1_0029 : std_logic := '0';
  signal array_access_00032 : std_logic := '0';
  signal getEcc_currentData2_0031 : std_logic := '0';
  signal cond_expr_00035 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00038 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00039 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_0040 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00041 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00042 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_data_0043 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_0044 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00049 : std_logic := '0';
  signal method_result_00050 : std_logic := '0';
  signal method_result_00051 : std_logic := '0';
  signal doEcc_data_0053 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_0054 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00059 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00060 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00061 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_0062 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_0063 : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_0064 : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_data_0065 : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_data_0067 : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkParity_data_0069 : signed(32-1 downto 0) := (others => '0');
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
    readFlow_method_S_0002_body,
    readFlow_method_S_0002_wait,
    readFlow_method_S_0004_body,
    readFlow_method_S_0004_wait  
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
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0046 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal getPosition_call_flag_0002 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0060 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0061 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0062 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
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
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
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
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal checkReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal checkHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
  signal checkParity_call_flag_0011 : std_logic := '0';
  signal tmp_0086 : std_logic := '0';
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
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
  signal tmp_0094 : std_logic := '0';
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal doReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
  signal doHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0106 : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal doParity_call_flag_0011 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : std_logic := '0';
  signal tmp_0113 : std_logic := '0';
  signal tmp_0114 : std_logic := '0';
  signal tmp_0115 : std_logic := '0';
  signal tmp_0116 : std_logic := '0';
  signal tmp_0117 : std_logic := '0';
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
  signal tmp_0118 : std_logic := '0';
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
  signal tmp_0122 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
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
  signal tmp_0126 : std_logic := '0';
  signal tmp_0127 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
  signal tmp_0130 : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
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
  signal tmp_0134 : std_logic := '0';
  signal tmp_0135 : std_logic := '0';
  signal tmp_0136 : std_logic := '0';
  signal tmp_0137 : std_logic := '0';
  signal tmp_0138 : std_logic := '0';
  signal tmp_0139 : std_logic := '0';
  signal tmp_0140 : std_logic := '0';
  signal tmp_0141 : std_logic := '0';
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
  signal tmp_0142 : std_logic := '0';
  signal tmp_0143 : std_logic := '0';
  signal tmp_0144 : std_logic := '0';
  signal tmp_0145 : std_logic := '0';
  signal tmp_0146 : std_logic := '0';
  signal tmp_0147 : std_logic := '0';
  signal tmp_0148 : std_logic := '0';
  signal tmp_0149 : std_logic := '0';
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
  signal tmp_0150 : std_logic := '0';
  signal tmp_0151 : std_logic := '0';
  signal tmp_0152 : std_logic := '0';
  signal tmp_0153 : std_logic := '0';
  signal tmp_0154 : std_logic := '0';
  signal tmp_0155 : std_logic := '0';
  signal tmp_0156 : std_logic := '0';
  signal tmp_0157 : std_logic := '0';
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
  signal tmp_0158 : std_logic := '0';
  signal tmp_0159 : std_logic := '0';
  signal tmp_0160 : std_logic := '0';
  signal tmp_0161 : std_logic := '0';
  signal tmp_0162 : std_logic := '0';
  signal tmp_0163 : std_logic := '0';
  signal tmp_0164 : std_logic := '0';
  signal tmp_0165 : std_logic := '0';

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
        elsif readFlow_method = readFlow_method_S_0010 then
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
  tmp_0041 <= '1' when readFlow_method /= readFlow_method_S_0000 else '0';
  tmp_0042 <= '1' when readFlow_method /= readFlow_method_S_0001 else '0';
  tmp_0043 <= tmp_0042 and readFlow_req_flag_edge;
  tmp_0044 <= tmp_0041 and tmp_0043;
  tmp_0045 <= readFlow_address_sig when readFlow_req_sig = '1' else readFlow_address_local;
  tmp_0046 <= readFlow_data_sig when readFlow_req_sig = '1' else readFlow_data_local;
  tmp_0047 <= not getEcc_req_flag_d;
  tmp_0048 <= getEcc_req_flag and tmp_0047;
  tmp_0049 <= getEcc_req_flag or getEcc_req_flag_d;
  tmp_0050 <= getEcc_req_flag or getEcc_req_flag_d;
  tmp_0051 <= '1' when getPosition_busy = '0' else '0';
  tmp_0052 <= '1' when getPosition_req_local = '0' else '0';
  tmp_0053 <= tmp_0051 and tmp_0052;
  tmp_0054 <= '1' when tmp_0053 = '1' else '0';
  tmp_0055 <= '1' when getEcc_method /= getEcc_method_S_0000 else '0';
  tmp_0056 <= '1' when getEcc_method /= getEcc_method_S_0001 else '0';
  tmp_0057 <= tmp_0056 and getEcc_req_flag_edge;
  tmp_0058 <= tmp_0055 and tmp_0057;
  tmp_0059 <= X"00000001" when getEcc_currentData1_0029 = '1' else X"00000000";
  tmp_0060 <= X"00000002" when getEcc_currentData2_0031 = '1' else X"00000000";
  tmp_0061 <= cond_expr_00035 + cond_expr_00038;
  tmp_0062 <= not getPosition_req_flag_d;
  tmp_0063 <= getPosition_req_flag and tmp_0062;
  tmp_0064 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0065 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0066 <= '1' when getPosition_method /= getPosition_method_S_0000 else '0';
  tmp_0067 <= '1' when getPosition_method /= getPosition_method_S_0001 else '0';
  tmp_0068 <= tmp_0067 and getPosition_req_flag_edge;
  tmp_0069 <= tmp_0066 and tmp_0068;
  tmp_0070 <= not checkECC_req_flag_d;
  tmp_0071 <= checkECC_req_flag and tmp_0070;
  tmp_0072 <= checkECC_req_flag or checkECC_req_flag_d;
  tmp_0073 <= checkECC_req_flag or checkECC_req_flag_d;
  tmp_0074 <= '1' when checkECC_ecc_0044 = X"00000000" else '0';
  tmp_0075 <= '1' when checkECC_ecc_0044 = X"00000001" else '0';
  tmp_0076 <= '1' when checkECC_ecc_0044 = X"00000002" else '0';
  tmp_0077 <= '1' when checkECC_ecc_0044 = X"00000003" else '0';
  tmp_0078 <= '1' when checkReedSolomon_busy = '0' else '0';
  tmp_0079 <= '1' when checkReedSolomon_req_local = '0' else '0';
  tmp_0080 <= tmp_0078 and tmp_0079;
  tmp_0081 <= '1' when tmp_0080 = '1' else '0';
  tmp_0082 <= '1' when checkHamming_busy = '0' else '0';
  tmp_0083 <= '1' when checkHamming_req_local = '0' else '0';
  tmp_0084 <= tmp_0082 and tmp_0083;
  tmp_0085 <= '1' when tmp_0084 = '1' else '0';
  tmp_0086 <= '1' when checkParity_busy = '0' else '0';
  tmp_0087 <= '1' when checkParity_req_local = '0' else '0';
  tmp_0088 <= tmp_0086 and tmp_0087;
  tmp_0089 <= '1' when tmp_0088 = '1' else '0';
  tmp_0090 <= '1' when checkECC_method /= checkECC_method_S_0000 else '0';
  tmp_0091 <= '1' when checkECC_method /= checkECC_method_S_0001 else '0';
  tmp_0092 <= tmp_0091 and checkECC_req_flag_edge;
  tmp_0093 <= tmp_0090 and tmp_0092;
  tmp_0094 <= not doEcc_req_flag_d;
  tmp_0095 <= doEcc_req_flag and tmp_0094;
  tmp_0096 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0097 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0098 <= '1' when doEcc_ecc_0054 = X"00000000" else '0';
  tmp_0099 <= '1' when doEcc_ecc_0054 = X"00000001" else '0';
  tmp_0100 <= '1' when doEcc_ecc_0054 = X"00000002" else '0';
  tmp_0101 <= '1' when doEcc_ecc_0054 = X"00000003" else '0';
  tmp_0102 <= '1' when doReedSolomon_busy = '0' else '0';
  tmp_0103 <= '1' when doReedSolomon_req_local = '0' else '0';
  tmp_0104 <= tmp_0102 and tmp_0103;
  tmp_0105 <= '1' when tmp_0104 = '1' else '0';
  tmp_0106 <= '1' when doHamming_busy = '0' else '0';
  tmp_0107 <= '1' when doHamming_req_local = '0' else '0';
  tmp_0108 <= tmp_0106 and tmp_0107;
  tmp_0109 <= '1' when tmp_0108 = '1' else '0';
  tmp_0110 <= '1' when doParity_busy = '0' else '0';
  tmp_0111 <= '1' when doParity_req_local = '0' else '0';
  tmp_0112 <= tmp_0110 and tmp_0111;
  tmp_0113 <= '1' when tmp_0112 = '1' else '0';
  tmp_0114 <= '1' when doEcc_method /= doEcc_method_S_0000 else '0';
  tmp_0115 <= '1' when doEcc_method /= doEcc_method_S_0001 else '0';
  tmp_0116 <= tmp_0115 and doEcc_req_flag_edge;
  tmp_0117 <= tmp_0114 and tmp_0116;
  tmp_0118 <= not doReedSolomon_req_flag_d;
  tmp_0119 <= doReedSolomon_req_flag and tmp_0118;
  tmp_0120 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0121 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0122 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0000 else '0';
  tmp_0123 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0001 else '0';
  tmp_0124 <= tmp_0123 and doReedSolomon_req_flag_edge;
  tmp_0125 <= tmp_0122 and tmp_0124;
  tmp_0126 <= not doHamming_req_flag_d;
  tmp_0127 <= doHamming_req_flag and tmp_0126;
  tmp_0128 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0129 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0130 <= '1' when doHamming_method /= doHamming_method_S_0000 else '0';
  tmp_0131 <= '1' when doHamming_method /= doHamming_method_S_0001 else '0';
  tmp_0132 <= tmp_0131 and doHamming_req_flag_edge;
  tmp_0133 <= tmp_0130 and tmp_0132;
  tmp_0134 <= not doParity_req_flag_d;
  tmp_0135 <= doParity_req_flag and tmp_0134;
  tmp_0136 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0137 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0138 <= '1' when doParity_method /= doParity_method_S_0000 else '0';
  tmp_0139 <= '1' when doParity_method /= doParity_method_S_0001 else '0';
  tmp_0140 <= tmp_0139 and doParity_req_flag_edge;
  tmp_0141 <= tmp_0138 and tmp_0140;
  tmp_0142 <= not checkReedSolomon_req_flag_d;
  tmp_0143 <= checkReedSolomon_req_flag and tmp_0142;
  tmp_0144 <= checkReedSolomon_req_flag or checkReedSolomon_req_flag_d;
  tmp_0145 <= checkReedSolomon_req_flag or checkReedSolomon_req_flag_d;
  tmp_0146 <= '1' when checkReedSolomon_method /= checkReedSolomon_method_S_0000 else '0';
  tmp_0147 <= '1' when checkReedSolomon_method /= checkReedSolomon_method_S_0001 else '0';
  tmp_0148 <= tmp_0147 and checkReedSolomon_req_flag_edge;
  tmp_0149 <= tmp_0146 and tmp_0148;
  tmp_0150 <= not checkHamming_req_flag_d;
  tmp_0151 <= checkHamming_req_flag and tmp_0150;
  tmp_0152 <= checkHamming_req_flag or checkHamming_req_flag_d;
  tmp_0153 <= checkHamming_req_flag or checkHamming_req_flag_d;
  tmp_0154 <= '1' when checkHamming_method /= checkHamming_method_S_0000 else '0';
  tmp_0155 <= '1' when checkHamming_method /= checkHamming_method_S_0001 else '0';
  tmp_0156 <= tmp_0155 and checkHamming_req_flag_edge;
  tmp_0157 <= tmp_0154 and tmp_0156;
  tmp_0158 <= not checkParity_req_flag_d;
  tmp_0159 <= checkParity_req_flag and tmp_0158;
  tmp_0160 <= checkParity_req_flag or checkParity_req_flag_d;
  tmp_0161 <= checkParity_req_flag or checkParity_req_flag_d;
  tmp_0162 <= '1' when checkParity_method /= checkParity_method_S_0000 else '0';
  tmp_0163 <= '1' when checkParity_method /= checkParity_method_S_0001 else '0';
  tmp_0164 <= tmp_0163 and checkParity_req_flag_edge;
  tmp_0165 <= tmp_0162 and tmp_0164;

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
          when others => null;
        end case;
        readFlow_req_flag_d <= readFlow_req_flag;
        if (tmp_0041 and tmp_0043) = '1' then
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
            if tmp_0049 = '1' then
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
        if (tmp_0055 and tmp_0057) = '1' then
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
            if tmp_0064 = '1' then
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
        if (tmp_0066 and tmp_0068) = '1' then
          getPosition_method <= getPosition_method_S_0001;
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
            if tmp_0072 = '1' then
              checkECC_method <= checkECC_method_S_0002;
            end if;
          when checkECC_method_S_0002 => 
            if tmp_0074 = '1' then
              checkECC_method <= checkECC_method_S_0014;
            elsif tmp_0075 = '1' then
              checkECC_method <= checkECC_method_S_0011;
            elsif tmp_0076 = '1' then
              checkECC_method <= checkECC_method_S_0008;
            elsif tmp_0077 = '1' then
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
        if (tmp_0090 and tmp_0092) = '1' then
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
            if tmp_0096 = '1' then
              doEcc_method <= doEcc_method_S_0002;
            end if;
          when doEcc_method_S_0002 => 
            if tmp_0098 = '1' then
              doEcc_method <= doEcc_method_S_0014;
            elsif tmp_0099 = '1' then
              doEcc_method <= doEcc_method_S_0011;
            elsif tmp_0100 = '1' then
              doEcc_method <= doEcc_method_S_0008;
            elsif tmp_0101 = '1' then
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
        if (tmp_0114 and tmp_0116) = '1' then
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
            if tmp_0120 = '1' then
              doReedSolomon_method <= doReedSolomon_method_S_0002;
            end if;
          when doReedSolomon_method_S_0002 => 
            doReedSolomon_method <= doReedSolomon_method_S_0000;
          when others => null;
        end case;
        doReedSolomon_req_flag_d <= doReedSolomon_req_flag;
        if (tmp_0122 and tmp_0124) = '1' then
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
            if tmp_0128 = '1' then
              doHamming_method <= doHamming_method_S_0002;
            end if;
          when doHamming_method_S_0002 => 
            doHamming_method <= doHamming_method_S_0000;
          when others => null;
        end case;
        doHamming_req_flag_d <= doHamming_req_flag;
        if (tmp_0130 and tmp_0132) = '1' then
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
            if tmp_0136 = '1' then
              doParity_method <= doParity_method_S_0002;
            end if;
          when doParity_method_S_0002 => 
            doParity_method <= doParity_method_S_0000;
          when others => null;
        end case;
        doParity_req_flag_d <= doParity_req_flag;
        if (tmp_0138 and tmp_0140) = '1' then
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
            if tmp_0144 = '1' then
              checkReedSolomon_method <= checkReedSolomon_method_S_0002;
            end if;
          when checkReedSolomon_method_S_0002 => 
            checkReedSolomon_method <= checkReedSolomon_method_S_0000;
          when others => null;
        end case;
        checkReedSolomon_req_flag_d <= checkReedSolomon_req_flag;
        if (tmp_0146 and tmp_0148) = '1' then
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
            if tmp_0152 = '1' then
              checkHamming_method <= checkHamming_method_S_0002;
            end if;
          when checkHamming_method_S_0002 => 
            checkHamming_method <= checkHamming_method_S_0000;
          when others => null;
        end case;
        checkHamming_req_flag_d <= checkHamming_req_flag;
        if (tmp_0154 and tmp_0156) = '1' then
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
            if tmp_0160 = '1' then
              checkParity_method <= checkParity_method_S_0002;
            end if;
          when checkParity_method_S_0002 => 
            checkParity_method <= checkParity_method_S_0000;
          when others => null;
        end case;
        checkParity_req_flag_d <= checkParity_req_flag;
        if (tmp_0162 and tmp_0164) = '1' then
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
          class_data1_0007_address_b <= getEcc_dataPosition_0027;
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
          class_data2_0010_address_b <= getEcc_dataPosition_0027;
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
          readFlow_address_0019 <= tmp_0045;
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
          readFlow_data_0020 <= tmp_0046;
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
        getEcc_address_0026 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0001 then
          getEcc_address_0026 <= getEcc_address_local;
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
        method_result_00028 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0002_wait then
          method_result_00028 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_dataPosition_0027 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0003 then
          getEcc_dataPosition_0027 <= method_result_00028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00030 <= '0';
      else
        if getEcc_method = getEcc_method_S_0014 then
          array_access_00030 <= std_logic(class_data1_0007_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_currentData1_0029 <= '0';
      else
        if getEcc_method = getEcc_method_S_0005 then
          getEcc_currentData1_0029 <= array_access_00030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00032 <= '0';
      else
        if getEcc_method = getEcc_method_S_0016 then
          array_access_00032 <= std_logic(class_data2_0010_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_currentData2_0031 <= '0';
      else
        if getEcc_method = getEcc_method_S_0007 then
          getEcc_currentData2_0031 <= array_access_00032;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00035 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0007 then
          cond_expr_00035 <= tmp_0059;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00038 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0009 then
          cond_expr_00038 <= tmp_0060;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00039 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0010 then
          binary_expr_00039 <= tmp_0061;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_address_0040 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0001 then
          getPosition_address_0040 <= getPosition_address_local;
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
          getPosition_address_local <= getEcc_address_0026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00041 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
          binary_expr_00041 <= u_synthesijer_mul32_getPosition_result;
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
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
          binary_expr_00042 <= u_synthesijer_div32_getPosition_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_data_0043 <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0001 then
          checkECC_data_0043 <= checkECC_data_local;
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
        checkECC_ecc_0044 <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0001 then
          checkECC_ecc_0044 <= checkECC_ecc_local;
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
        method_result_00049 <= '0';
      else
        if checkECC_method = checkECC_method_S_0005_wait then
          method_result_00049 <= checkReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00050 <= '0';
      else
        if checkECC_method = checkECC_method_S_0008_wait then
          method_result_00050 <= checkHamming_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00051 <= '0';
      else
        if checkECC_method = checkECC_method_S_0011_wait then
          method_result_00051 <= checkParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_data_0053 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_data_0053 <= doEcc_data_local;
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
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_ecc_0054 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_ecc_0054 <= doEcc_ecc_local;
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
        if doEcc_method = doEcc_method_S_0005_wait then
          method_result_00059 <= doReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00060 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0008_wait then
          method_result_00060 <= doHamming_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00061 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0011_wait then
          method_result_00061 <= doParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_data_0062 <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0001 then
          doReedSolomon_data_0062 <= doReedSolomon_data_local;
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
          doReedSolomon_data_local <= doEcc_data_0053;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_data_0063 <= (others => '0');
      else
        if doHamming_method = doHamming_method_S_0001 then
          doHamming_data_0063 <= doHamming_data_local;
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
          doHamming_data_local <= doEcc_data_0053;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_data_0064 <= (others => '0');
      else
        if doParity_method = doParity_method_S_0001 then
          doParity_data_0064 <= doParity_data_local;
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
          doParity_data_local <= doEcc_data_0053;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_data_0065 <= (others => '0');
      else
        if checkReedSolomon_method = checkReedSolomon_method_S_0001 then
          checkReedSolomon_data_0065 <= checkReedSolomon_data_local;
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
          checkReedSolomon_data_local <= checkECC_data_0043;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_data_0067 <= (others => '0');
      else
        if checkHamming_method = checkHamming_method_S_0001 then
          checkHamming_data_0067 <= checkHamming_data_local;
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
          checkHamming_data_local <= checkECC_data_0043;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_data_0069 <= (others => '0');
      else
        if checkParity_method = checkParity_method_S_0001 then
          checkParity_data_0069 <= checkParity_data_local;
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
          checkParity_data_local <= checkECC_data_0043;
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
          getEcc_return <= binary_expr_00039;
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
          getEcc_busy <= tmp_0050;
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
          getPosition_return <= binary_expr_00042;
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
          getPosition_busy <= tmp_0065;
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
        checkECC_return <= '0';
      else
        if checkECC_method = checkECC_method_S_0006 then
          checkECC_return <= method_result_00049;
        elsif checkECC_method = checkECC_method_S_0009 then
          checkECC_return <= method_result_00050;
        elsif checkECC_method = checkECC_method_S_0012 then
          checkECC_return <= method_result_00051;
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
          checkECC_busy <= tmp_0073;
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
          doEcc_return <= method_result_00059;
        elsif doEcc_method = doEcc_method_S_0009 then
          doEcc_return <= method_result_00060;
        elsif doEcc_method = doEcc_method_S_0012 then
          doEcc_return <= method_result_00061;
        elsif doEcc_method = doEcc_method_S_0014 then
          doEcc_return <= doEcc_data_0053;
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
          doEcc_busy <= tmp_0097;
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
          doReedSolomon_return <= doReedSolomon_data_0062;
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
          doReedSolomon_busy <= tmp_0121;
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
          doHamming_return <= doHamming_data_0063;
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
          doHamming_busy <= tmp_0129;
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
          doParity_return <= doParity_data_0064;
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
          doParity_busy <= tmp_0137;
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
          checkReedSolomon_busy <= tmp_0145;
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
          checkHamming_busy <= tmp_0153;
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
          checkParity_busy <= tmp_0161;
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

  getEcc_req_flag_edge <= tmp_0048;

  getPosition_call_flag_0002 <= tmp_0054;

  getPosition_req_flag_edge <= tmp_0063;

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
          u_synthesijer_div32_getPosition_a <= getPosition_address_0040;
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
          u_synthesijer_div32_getPosition_b <= binary_expr_00041;
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

  checkECC_req_flag_edge <= tmp_0071;

  checkReedSolomon_call_flag_0005 <= tmp_0081;

  checkHamming_call_flag_0008 <= tmp_0085;

  checkParity_call_flag_0011 <= tmp_0089;

  doEcc_req_flag_edge <= tmp_0095;

  doReedSolomon_call_flag_0005 <= tmp_0105;

  doHamming_call_flag_0008 <= tmp_0109;

  doParity_call_flag_0011 <= tmp_0113;

  doReedSolomon_req_flag_edge <= tmp_0119;

  doHamming_req_flag_edge <= tmp_0127;

  doParity_req_flag_edge <= tmp_0135;

  checkReedSolomon_req_flag_edge <= tmp_0143;

  checkHamming_req_flag_edge <= tmp_0151;

  checkParity_req_flag_edge <= tmp_0159;


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


end RTL;
