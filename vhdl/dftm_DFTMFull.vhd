library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dftm_DFTMFull is
  port (
    clk : in std_logic;
    reset : in std_logic;
    write_address : in signed(32-1 downto 0);
    write_data : in signed(32-1 downto 0);
    read_address : in signed(32-1 downto 0);
    read_data : in signed(32-1 downto 0);
    write_return : out signed(32-1 downto 0);
    write_busy : out std_logic;
    write_req : in std_logic;
    read_return : out signed(32-1 downto 0);
    read_busy : out std_logic;
    read_req : in std_logic
  );
end dftm_DFTMFull;

architecture RTL of dftm_DFTMFull is

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
  signal write_address_sig : signed(32-1 downto 0) := (others => '0');
  signal write_data_sig : signed(32-1 downto 0) := (others => '0');
  signal read_address_sig : signed(32-1 downto 0) := (others => '0');
  signal read_data_sig : signed(32-1 downto 0) := (others => '0');
  signal write_return_sig : signed(32-1 downto 0) := (others => '0');
  signal write_busy_sig : std_logic := '1';
  signal write_req_sig : std_logic := '0';
  signal read_return_sig : signed(32-1 downto 0) := (others => '0');
  signal read_busy_sig : std_logic := '1';
  signal read_req_sig : std_logic := '0';

  signal class_DEFAULT_PAGE_SIZE_0000 : signed(32-1 downto 0) := X"00007d00";
  signal class_DEFAULT_MEMORY_SIZE_PER_BLOCK_0002 : signed(32-1 downto 0) := X"0003e800";
  signal class_BYTE_SIZE_0004 : signed(32-1 downto 0) := X"00000008";
  signal class_pageSize_0006 : signed(32-1 downto 0) := (others => '0');
  signal class_ENCODER_MODE_0007 : signed(32-1 downto 0) := X"00000001";
  signal class_DECODER_MODE_0009 : signed(32-1 downto 0) := X"00000000";
  signal class_data0_0011_clk : std_logic := '0';
  signal class_data0_0011_reset : std_logic := '0';
  signal class_data0_0011_length : signed(32-1 downto 0) := (others => '0');
  signal class_data0_0011_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data0_0011_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data0_0011_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data0_0011_we_b : std_logic := '0';
  signal class_data0_0011_oe_b : std_logic := '0';
  signal class_data1_0014_clk : std_logic := '0';
  signal class_data1_0014_reset : std_logic := '0';
  signal class_data1_0014_length : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0014_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data1_0014_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data1_0014_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data1_0014_we_b : std_logic := '0';
  signal class_data1_0014_oe_b : std_logic := '0';
  signal class_data2_0017_clk : std_logic := '0';
  signal class_data2_0017_reset : std_logic := '0';
  signal class_data2_0017_length : signed(32-1 downto 0) := (others => '0');
  signal class_data2_0017_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data2_0017_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_data2_0017_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_data2_0017_we_b : std_logic := '0';
  signal class_data2_0017_oe_b : std_logic := '0';
  signal write_address_0020 : signed(32-1 downto 0) := (others => '0');
  signal write_address_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_0021 : signed(32-1 downto 0) := (others => '0');
  signal write_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00023 : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_0022 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00024 : signed(32-1 downto 0) := (others => '0');
  signal read_address_0025 : signed(32-1 downto 0) := (others => '0');
  signal read_address_local : signed(32-1 downto 0) := (others => '0');
  signal read_data_0026 : signed(32-1 downto 0) := (others => '0');
  signal read_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00028 : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_0027 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00030 : signed(32-1 downto 0) := (others => '0');
  signal read_status_0029 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00031 : std_logic := '0';
  signal eccEvaluator_data_0035 : signed(32-1 downto 0) := (others => '0');
  signal eccEvaluator_data_local : signed(32-1 downto 0) := (others => '0');
  signal eccEvaluator_status_0036 : signed(32-1 downto 0) := (others => '0');
  signal eccEvaluator_status_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00038 : std_logic := '0';
  signal getPosition_address_0039 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00040 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00041 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_address_0042 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00044 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_dataPosition_0043 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00046 : std_logic := '0';
  signal binary_expr_00048 : std_logic := '0';
  signal cond_expr_00051 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_currentData1_0045 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00053 : std_logic := '0';
  signal binary_expr_00055 : std_logic := '0';
  signal cond_expr_00058 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_currentData2_0052 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00059 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_position_0060 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_position_local : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_0061 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal array_access_00067 : std_logic := '0';
  signal array_access_00069 : std_logic := '0';
  signal array_access_00071 : std_logic := '0';
  signal array_access_00073 : std_logic := '0';
  signal array_access_00075 : std_logic := '0';
  signal array_access_00077 : std_logic := '0';
  signal array_access_00079 : std_logic := '0';
  signal array_access_00081 : std_logic := '0';
  signal recoding_address_0082 : signed(32-1 downto 0) := (others => '0');
  signal recoding_address_local : signed(32-1 downto 0) := (others => '0');
  signal recoding_ecc_0083 : signed(32-1 downto 0) := (others => '0');
  signal recoding_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal recoding_pageSize_0084 : signed(32-1 downto 0) := (others => '0');
  signal recoding_pageSize_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00086 : std_logic := '0';
  signal binary_expr_00088 : signed(32-1 downto 0) := (others => '0');
  signal recoding_position_0087 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00090 : signed(32-1 downto 0) := (others => '0');
  signal recoding_initialAddress_0089 : signed(32-1 downto 0) := (others => '0');
  signal recoding_i_0091 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00093 : std_logic := '0';
  signal unary_expr_00094 : signed(32-1 downto 0) := (others => '0');
  signal unary_expr_postfix_preserved_00095 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00098 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00099 : signed(32-1 downto 0) := (others => '0');
  signal recoding_read_0097 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00101 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00103 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00106 : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_address_0107 : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_address_local : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_data_0108 : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_data_local : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_ecc_0109 : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00111 : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_newData_0110 : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_address_0118 : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_address_local : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_ecc_0119 : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00121 : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_data_0120 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00122 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_data_0123 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_data_local : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_ecc_0124 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_encoder_0125 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_encoder_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00131 : std_logic := '0';
  signal method_result_00132 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00133 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00134 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00136 : std_logic := '0';
  signal method_result_00137 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00138 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00139 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00141 : std_logic := '0';
  signal method_result_00142 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00143 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00144 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_address_0146 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_address_local : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_data_0147 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_data_local : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_READ_address_0148 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_READ_address_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_data_0150 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_data_0152 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_data_0154 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_data_0156 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_data_0158 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_data_0160 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_req_flag : std_logic := '0';
  signal write_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal read_req_flag : std_logic := '0';
  signal read_req_local : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal eccEvaluator_return : std_logic := '0';
  signal eccEvaluator_busy : std_logic := '0';
  signal eccEvaluator_req_flag : std_logic := '0';
  signal eccEvaluator_req_local : std_logic := '0';
  signal getPosition_return : signed(32-1 downto 0) := (others => '0');
  signal getPosition_busy : std_logic := '0';
  signal getPosition_req_flag : std_logic := '0';
  signal getPosition_req_local : std_logic := '0';
  signal blockFinder_return : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_busy : std_logic := '0';
  signal blockFinder_req_flag : std_logic := '0';
  signal blockFinder_req_local : std_logic := '0';
  signal incrementEcc_busy : std_logic := '0';
  signal incrementEcc_req_flag : std_logic := '0';
  signal incrementEcc_req_local : std_logic := '0';
  signal recoding_busy : std_logic := '0';
  signal recoding_req_flag : std_logic := '0';
  signal recoding_req_local : std_logic := '0';
  signal recodingWrite_busy : std_logic := '0';
  signal recodingWrite_req_flag : std_logic := '0';
  signal recodingWrite_req_local : std_logic := '0';
  signal recodingRead_return : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_busy : std_logic := '0';
  signal recodingRead_req_flag : std_logic := '0';
  signal recodingRead_req_local : std_logic := '0';
  signal eccSelector_return : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_busy : std_logic := '0';
  signal eccSelector_req_flag : std_logic := '0';
  signal eccSelector_req_local : std_logic := '0';
  signal SCHEDULER_WRITE_busy : std_logic := '0';
  signal SCHEDULER_WRITE_req_flag : std_logic := '0';
  signal SCHEDULER_WRITE_req_local : std_logic := '0';
  signal SCHEDULER_READ_return : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_READ_busy : std_logic := '0';
  signal SCHEDULER_READ_req_flag : std_logic := '0';
  signal SCHEDULER_READ_req_local : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_return : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_busy : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_req_flag : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_req_local : std_logic := '0';
  signal ECC_DECODE_HAMMING_return : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_busy : std_logic := '0';
  signal ECC_DECODE_HAMMING_req_flag : std_logic := '0';
  signal ECC_DECODE_HAMMING_req_local : std_logic := '0';
  signal ECC_DECODE_PARITY_return : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_busy : std_logic := '0';
  signal ECC_DECODE_PARITY_req_flag : std_logic := '0';
  signal ECC_DECODE_PARITY_req_local : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_return : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_busy : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_req_flag : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_req_local : std_logic := '0';
  signal ECC_ENCODE_HAMMING_return : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_busy : std_logic := '0';
  signal ECC_ENCODE_HAMMING_req_flag : std_logic := '0';
  signal ECC_ENCODE_HAMMING_req_local : std_logic := '0';
  signal ECC_ENCODE_PARITY_return : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_busy : std_logic := '0';
  signal ECC_ENCODE_PARITY_req_flag : std_logic := '0';
  signal ECC_ENCODE_PARITY_req_local : std_logic := '0';
  type Type_write_method is (
    write_method_IDLE,
    write_method_S_0000,
    write_method_S_0001,
    write_method_S_0002,
    write_method_S_0003,
    write_method_S_0004,
    write_method_S_0005,
    write_method_S_0002_body,
    write_method_S_0002_wait,
    write_method_S_0004_body,
    write_method_S_0004_wait  
  );
  signal write_method : Type_write_method := write_method_IDLE;
  signal write_method_prev : Type_write_method := write_method_IDLE;
  signal write_method_delay : signed(32-1 downto 0) := (others => '0');
  signal write_req_flag_d : std_logic := '0';
  signal write_req_flag_edge : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal blockFinder_call_flag_0002 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal eccSelector_call_flag_0004 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal tmp_0019 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0020 : signed(32-1 downto 0) := (others => '0');
  type Type_read_method is (
    read_method_IDLE,
    read_method_S_0000,
    read_method_S_0001,
    read_method_S_0002,
    read_method_S_0003,
    read_method_S_0004,
    read_method_S_0005,
    read_method_S_0006,
    read_method_S_0007,
    read_method_S_0009,
    read_method_S_0011,
    read_method_S_0012,
    read_method_S_0002_body,
    read_method_S_0002_wait,
    read_method_S_0004_body,
    read_method_S_0004_wait,
    read_method_S_0006_body,
    read_method_S_0006_wait,
    read_method_S_0011_body,
    read_method_S_0011_wait  
  );
  signal read_method : Type_read_method := read_method_IDLE;
  signal read_method_prev : Type_read_method := read_method_IDLE;
  signal read_method_delay : signed(32-1 downto 0) := (others => '0');
  signal read_req_flag_d : std_logic := '0';
  signal read_req_flag_edge : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : std_logic := '0';
  signal eccEvaluator_call_flag_0006 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : std_logic := '0';
  signal tmp_0028 : std_logic := '0';
  signal tmp_0029 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal recoding_call_flag_0011 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0040 : signed(32-1 downto 0) := (others => '0');
  type Type_eccEvaluator_method is (
    eccEvaluator_method_IDLE,
    eccEvaluator_method_S_0000,
    eccEvaluator_method_S_0001,
    eccEvaluator_method_S_0002,
    eccEvaluator_method_S_0003  
  );
  signal eccEvaluator_method : Type_eccEvaluator_method := eccEvaluator_method_IDLE;
  signal eccEvaluator_method_prev : Type_eccEvaluator_method := eccEvaluator_method_IDLE;
  signal eccEvaluator_method_delay : signed(32-1 downto 0) := (others => '0');
  signal eccEvaluator_req_flag_d : std_logic := '0';
  signal eccEvaluator_req_flag_edge : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
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
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
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
  signal tmp_0054 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  type Type_blockFinder_method is (
    blockFinder_method_IDLE,
    blockFinder_method_S_0000,
    blockFinder_method_S_0001,
    blockFinder_method_S_0002,
    blockFinder_method_S_0003,
    blockFinder_method_S_0004,
    blockFinder_method_S_0015,
    blockFinder_method_S_0016,
    blockFinder_method_S_0005,
    blockFinder_method_S_0006,
    blockFinder_method_S_0007,
    blockFinder_method_S_0008,
    blockFinder_method_S_0017,
    blockFinder_method_S_0018,
    blockFinder_method_S_0009,
    blockFinder_method_S_0010,
    blockFinder_method_S_0011,
    blockFinder_method_S_0012,
    blockFinder_method_S_0013,
    blockFinder_method_S_0002_body,
    blockFinder_method_S_0002_wait  
  );
  signal blockFinder_method : Type_blockFinder_method := blockFinder_method_IDLE;
  signal blockFinder_method_prev : Type_blockFinder_method := blockFinder_method_IDLE;
  signal blockFinder_method_delay : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_req_flag_d : std_logic := '0';
  signal blockFinder_req_flag_edge : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal getPosition_call_flag_0002 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0074 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0086 : std_logic := '0';
  type Type_recoding_method is (
    recoding_method_IDLE,
    recoding_method_S_0000,
    recoding_method_S_0001,
    recoding_method_S_0002,
    recoding_method_S_0003,
    recoding_method_S_0005,
    recoding_method_S_0007,
    recoding_method_S_0008,
    recoding_method_S_0009,
    recoding_method_S_0010,
    recoding_method_S_0012,
    recoding_method_S_0013,
    recoding_method_S_0015,
    recoding_method_S_0017,
    recoding_method_S_0019,
    recoding_method_S_0020,
    recoding_method_S_0021,
    recoding_method_S_0024,
    recoding_method_S_0026,
    recoding_method_S_0027,
    recoding_method_S_0020_body,
    recoding_method_S_0020_wait,
    recoding_method_S_0024_body,
    recoding_method_S_0024_wait,
    recoding_method_S_0027_body,
    recoding_method_S_0027_wait  
  );
  signal recoding_method : Type_recoding_method := recoding_method_IDLE;
  signal recoding_method_prev : Type_recoding_method := recoding_method_IDLE;
  signal recoding_method_delay : signed(32-1 downto 0) := (others => '0');
  signal recoding_req_flag_d : std_logic := '0';
  signal recoding_req_flag_edge : std_logic := '0';
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal u_synthesijer_div32_recoding_clk : std_logic := '0';
  signal u_synthesijer_div32_recoding_reset : std_logic := '0';
  signal u_synthesijer_div32_recoding_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_recoding_b : signed(32-1 downto 0) := X"00000001";
  signal u_synthesijer_div32_recoding_nd : std_logic := '0';
  signal u_synthesijer_div32_recoding_quantient : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_recoding_remainder : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_div32_recoding_valid : std_logic := '0';
  signal u_synthesijer_mul32_recoding_clk : std_logic := '0';
  signal u_synthesijer_mul32_recoding_reset : std_logic := '0';
  signal u_synthesijer_mul32_recoding_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_recoding_b : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_recoding_nd : std_logic := '0';
  signal u_synthesijer_mul32_recoding_result : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_recoding_valid : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
  signal tmp_0094 : std_logic := '0';
  signal recodingRead_call_flag_0020 : std_logic := '0';
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
  signal recodingWrite_call_flag_0024 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
  signal incrementEcc_call_flag_0027 : std_logic := '0';
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
  signal tmp_0106 : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : std_logic := '0';
  signal tmp_0113 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0114 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0115 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0116 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0117 : signed(32-1 downto 0) := (others => '0');
  type Type_recodingWrite_method is (
    recodingWrite_method_IDLE,
    recodingWrite_method_S_0000,
    recodingWrite_method_S_0001,
    recodingWrite_method_S_0002,
    recodingWrite_method_S_0003,
    recodingWrite_method_S_0004,
    recodingWrite_method_S_0007,
    recodingWrite_method_S_0008,
    recodingWrite_method_S_0010,
    recodingWrite_method_S_0011,
    recodingWrite_method_S_0013,
    recodingWrite_method_S_0014,
    recodingWrite_method_S_0002_body,
    recodingWrite_method_S_0002_wait,
    recodingWrite_method_S_0007_body,
    recodingWrite_method_S_0007_wait,
    recodingWrite_method_S_0010_body,
    recodingWrite_method_S_0010_wait,
    recodingWrite_method_S_0013_body,
    recodingWrite_method_S_0013_wait  
  );
  signal recodingWrite_method : Type_recodingWrite_method := recodingWrite_method_IDLE;
  signal recodingWrite_method_prev : Type_recodingWrite_method := recodingWrite_method_IDLE;
  signal recodingWrite_method_delay : signed(32-1 downto 0) := (others => '0');
  signal recodingWrite_req_flag_d : std_logic := '0';
  signal recodingWrite_req_flag_edge : std_logic := '0';
  signal tmp_0118 : std_logic := '0';
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
  signal eccSelector_call_flag_0002 : std_logic := '0';
  signal tmp_0122 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
  signal tmp_0126 : std_logic := '0';
  signal tmp_0127 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal SCHEDULER_WRITE_call_flag_0007 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
  signal tmp_0130 : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal SCHEDULER_WRITE_call_flag_0010 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
  signal tmp_0134 : std_logic := '0';
  signal tmp_0135 : std_logic := '0';
  signal tmp_0136 : std_logic := '0';
  signal SCHEDULER_WRITE_call_flag_0013 : std_logic := '0';
  signal tmp_0137 : std_logic := '0';
  signal tmp_0138 : std_logic := '0';
  signal tmp_0139 : std_logic := '0';
  signal tmp_0140 : std_logic := '0';
  signal tmp_0141 : std_logic := '0';
  signal tmp_0142 : std_logic := '0';
  signal tmp_0143 : std_logic := '0';
  signal tmp_0144 : std_logic := '0';
  type Type_recodingRead_method is (
    recodingRead_method_IDLE,
    recodingRead_method_S_0000,
    recodingRead_method_S_0001,
    recodingRead_method_S_0002,
    recodingRead_method_S_0003,
    recodingRead_method_S_0004,
    recodingRead_method_S_0005,
    recodingRead_method_S_0002_body,
    recodingRead_method_S_0002_wait,
    recodingRead_method_S_0004_body,
    recodingRead_method_S_0004_wait  
  );
  signal recodingRead_method : Type_recodingRead_method := recodingRead_method_IDLE;
  signal recodingRead_method_prev : Type_recodingRead_method := recodingRead_method_IDLE;
  signal recodingRead_method_delay : signed(32-1 downto 0) := (others => '0');
  signal recodingRead_req_flag_d : std_logic := '0';
  signal recodingRead_req_flag_edge : std_logic := '0';
  signal tmp_0145 : std_logic := '0';
  signal tmp_0146 : std_logic := '0';
  signal tmp_0147 : std_logic := '0';
  signal tmp_0148 : std_logic := '0';
  signal SCHEDULER_READ_call_flag_0002 : std_logic := '0';
  signal tmp_0149 : std_logic := '0';
  signal tmp_0150 : std_logic := '0';
  signal tmp_0151 : std_logic := '0';
  signal tmp_0152 : std_logic := '0';
  signal tmp_0153 : std_logic := '0';
  signal tmp_0154 : std_logic := '0';
  signal tmp_0155 : std_logic := '0';
  signal tmp_0156 : std_logic := '0';
  type Type_eccSelector_method is (
    eccSelector_method_IDLE,
    eccSelector_method_S_0000,
    eccSelector_method_S_0001,
    eccSelector_method_S_0002,
    eccSelector_method_S_0005,
    eccSelector_method_S_0006,
    eccSelector_method_S_0007,
    eccSelector_method_S_0008,
    eccSelector_method_S_0009,
    eccSelector_method_S_0011,
    eccSelector_method_S_0012,
    eccSelector_method_S_0013,
    eccSelector_method_S_0014,
    eccSelector_method_S_0015,
    eccSelector_method_S_0017,
    eccSelector_method_S_0018,
    eccSelector_method_S_0019,
    eccSelector_method_S_0020,
    eccSelector_method_S_0021,
    eccSelector_method_S_0023,
    eccSelector_method_S_0006_body,
    eccSelector_method_S_0006_wait,
    eccSelector_method_S_0007_body,
    eccSelector_method_S_0007_wait,
    eccSelector_method_S_0012_body,
    eccSelector_method_S_0012_wait,
    eccSelector_method_S_0013_body,
    eccSelector_method_S_0013_wait,
    eccSelector_method_S_0018_body,
    eccSelector_method_S_0018_wait,
    eccSelector_method_S_0019_body,
    eccSelector_method_S_0019_wait  
  );
  signal eccSelector_method : Type_eccSelector_method := eccSelector_method_IDLE;
  signal eccSelector_method_prev : Type_eccSelector_method := eccSelector_method_IDLE;
  signal eccSelector_method_delay : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_req_flag_d : std_logic := '0';
  signal eccSelector_req_flag_edge : std_logic := '0';
  signal tmp_0157 : std_logic := '0';
  signal tmp_0158 : std_logic := '0';
  signal tmp_0159 : std_logic := '0';
  signal tmp_0160 : std_logic := '0';
  signal tmp_0161 : std_logic := '0';
  signal tmp_0162 : std_logic := '0';
  signal tmp_0163 : std_logic := '0';
  signal tmp_0164 : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_call_flag_0006 : std_logic := '0';
  signal tmp_0165 : std_logic := '0';
  signal tmp_0166 : std_logic := '0';
  signal tmp_0167 : std_logic := '0';
  signal tmp_0168 : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_call_flag_0007 : std_logic := '0';
  signal tmp_0169 : std_logic := '0';
  signal tmp_0170 : std_logic := '0';
  signal tmp_0171 : std_logic := '0';
  signal tmp_0172 : std_logic := '0';
  signal ECC_ENCODE_HAMMING_call_flag_0012 : std_logic := '0';
  signal tmp_0173 : std_logic := '0';
  signal tmp_0174 : std_logic := '0';
  signal tmp_0175 : std_logic := '0';
  signal tmp_0176 : std_logic := '0';
  signal ECC_DECODE_HAMMING_call_flag_0013 : std_logic := '0';
  signal tmp_0177 : std_logic := '0';
  signal tmp_0178 : std_logic := '0';
  signal tmp_0179 : std_logic := '0';
  signal tmp_0180 : std_logic := '0';
  signal ECC_ENCODE_PARITY_call_flag_0018 : std_logic := '0';
  signal tmp_0181 : std_logic := '0';
  signal tmp_0182 : std_logic := '0';
  signal tmp_0183 : std_logic := '0';
  signal tmp_0184 : std_logic := '0';
  signal ECC_DECODE_PARITY_call_flag_0019 : std_logic := '0';
  signal tmp_0185 : std_logic := '0';
  signal tmp_0186 : std_logic := '0';
  signal tmp_0187 : std_logic := '0';
  signal tmp_0188 : std_logic := '0';
  signal tmp_0189 : std_logic := '0';
  signal tmp_0190 : std_logic := '0';
  signal tmp_0191 : std_logic := '0';
  signal tmp_0192 : std_logic := '0';
  signal tmp_0193 : std_logic := '0';
  signal tmp_0194 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0195 : std_logic := '0';
  signal tmp_0196 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0197 : std_logic := '0';
  signal tmp_0198 : signed(32-1 downto 0) := (others => '0');
  type Type_SCHEDULER_WRITE_method is (
    SCHEDULER_WRITE_method_IDLE,
    SCHEDULER_WRITE_method_S_0000,
    SCHEDULER_WRITE_method_S_0001  
  );
  signal SCHEDULER_WRITE_method : Type_SCHEDULER_WRITE_method := SCHEDULER_WRITE_method_IDLE;
  signal SCHEDULER_WRITE_method_prev : Type_SCHEDULER_WRITE_method := SCHEDULER_WRITE_method_IDLE;
  signal SCHEDULER_WRITE_method_delay : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_req_flag_d : std_logic := '0';
  signal SCHEDULER_WRITE_req_flag_edge : std_logic := '0';
  signal tmp_0199 : std_logic := '0';
  signal tmp_0200 : std_logic := '0';
  signal tmp_0201 : std_logic := '0';
  signal tmp_0202 : std_logic := '0';
  signal tmp_0203 : std_logic := '0';
  signal tmp_0204 : std_logic := '0';
  signal tmp_0205 : std_logic := '0';
  signal tmp_0206 : std_logic := '0';
  type Type_SCHEDULER_READ_method is (
    SCHEDULER_READ_method_IDLE,
    SCHEDULER_READ_method_S_0000,
    SCHEDULER_READ_method_S_0001,
    SCHEDULER_READ_method_S_0002  
  );
  signal SCHEDULER_READ_method : Type_SCHEDULER_READ_method := SCHEDULER_READ_method_IDLE;
  signal SCHEDULER_READ_method_prev : Type_SCHEDULER_READ_method := SCHEDULER_READ_method_IDLE;
  signal SCHEDULER_READ_method_delay : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_READ_req_flag_d : std_logic := '0';
  signal SCHEDULER_READ_req_flag_edge : std_logic := '0';
  signal tmp_0207 : std_logic := '0';
  signal tmp_0208 : std_logic := '0';
  signal tmp_0209 : std_logic := '0';
  signal tmp_0210 : std_logic := '0';
  signal tmp_0211 : std_logic := '0';
  signal tmp_0212 : std_logic := '0';
  signal tmp_0213 : std_logic := '0';
  signal tmp_0214 : std_logic := '0';
  type Type_ECC_DECODE_REEDSOLOMON_method is (
    ECC_DECODE_REEDSOLOMON_method_IDLE,
    ECC_DECODE_REEDSOLOMON_method_S_0000,
    ECC_DECODE_REEDSOLOMON_method_S_0001,
    ECC_DECODE_REEDSOLOMON_method_S_0002  
  );
  signal ECC_DECODE_REEDSOLOMON_method : Type_ECC_DECODE_REEDSOLOMON_method := ECC_DECODE_REEDSOLOMON_method_IDLE;
  signal ECC_DECODE_REEDSOLOMON_method_prev : Type_ECC_DECODE_REEDSOLOMON_method := ECC_DECODE_REEDSOLOMON_method_IDLE;
  signal ECC_DECODE_REEDSOLOMON_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_req_flag_d : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_req_flag_edge : std_logic := '0';
  signal tmp_0215 : std_logic := '0';
  signal tmp_0216 : std_logic := '0';
  signal tmp_0217 : std_logic := '0';
  signal tmp_0218 : std_logic := '0';
  signal tmp_0219 : std_logic := '0';
  signal tmp_0220 : std_logic := '0';
  signal tmp_0221 : std_logic := '0';
  signal tmp_0222 : std_logic := '0';
  type Type_ECC_DECODE_HAMMING_method is (
    ECC_DECODE_HAMMING_method_IDLE,
    ECC_DECODE_HAMMING_method_S_0000,
    ECC_DECODE_HAMMING_method_S_0001,
    ECC_DECODE_HAMMING_method_S_0002  
  );
  signal ECC_DECODE_HAMMING_method : Type_ECC_DECODE_HAMMING_method := ECC_DECODE_HAMMING_method_IDLE;
  signal ECC_DECODE_HAMMING_method_prev : Type_ECC_DECODE_HAMMING_method := ECC_DECODE_HAMMING_method_IDLE;
  signal ECC_DECODE_HAMMING_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_req_flag_d : std_logic := '0';
  signal ECC_DECODE_HAMMING_req_flag_edge : std_logic := '0';
  signal tmp_0223 : std_logic := '0';
  signal tmp_0224 : std_logic := '0';
  signal tmp_0225 : std_logic := '0';
  signal tmp_0226 : std_logic := '0';
  signal tmp_0227 : std_logic := '0';
  signal tmp_0228 : std_logic := '0';
  signal tmp_0229 : std_logic := '0';
  signal tmp_0230 : std_logic := '0';
  type Type_ECC_DECODE_PARITY_method is (
    ECC_DECODE_PARITY_method_IDLE,
    ECC_DECODE_PARITY_method_S_0000,
    ECC_DECODE_PARITY_method_S_0001,
    ECC_DECODE_PARITY_method_S_0002  
  );
  signal ECC_DECODE_PARITY_method : Type_ECC_DECODE_PARITY_method := ECC_DECODE_PARITY_method_IDLE;
  signal ECC_DECODE_PARITY_method_prev : Type_ECC_DECODE_PARITY_method := ECC_DECODE_PARITY_method_IDLE;
  signal ECC_DECODE_PARITY_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_req_flag_d : std_logic := '0';
  signal ECC_DECODE_PARITY_req_flag_edge : std_logic := '0';
  signal tmp_0231 : std_logic := '0';
  signal tmp_0232 : std_logic := '0';
  signal tmp_0233 : std_logic := '0';
  signal tmp_0234 : std_logic := '0';
  signal tmp_0235 : std_logic := '0';
  signal tmp_0236 : std_logic := '0';
  signal tmp_0237 : std_logic := '0';
  signal tmp_0238 : std_logic := '0';
  type Type_ECC_ENCODE_REEDSOLOMON_method is (
    ECC_ENCODE_REEDSOLOMON_method_IDLE,
    ECC_ENCODE_REEDSOLOMON_method_S_0000,
    ECC_ENCODE_REEDSOLOMON_method_S_0001,
    ECC_ENCODE_REEDSOLOMON_method_S_0002  
  );
  signal ECC_ENCODE_REEDSOLOMON_method : Type_ECC_ENCODE_REEDSOLOMON_method := ECC_ENCODE_REEDSOLOMON_method_IDLE;
  signal ECC_ENCODE_REEDSOLOMON_method_prev : Type_ECC_ENCODE_REEDSOLOMON_method := ECC_ENCODE_REEDSOLOMON_method_IDLE;
  signal ECC_ENCODE_REEDSOLOMON_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_req_flag_d : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_req_flag_edge : std_logic := '0';
  signal tmp_0239 : std_logic := '0';
  signal tmp_0240 : std_logic := '0';
  signal tmp_0241 : std_logic := '0';
  signal tmp_0242 : std_logic := '0';
  signal tmp_0243 : std_logic := '0';
  signal tmp_0244 : std_logic := '0';
  signal tmp_0245 : std_logic := '0';
  signal tmp_0246 : std_logic := '0';
  type Type_ECC_ENCODE_HAMMING_method is (
    ECC_ENCODE_HAMMING_method_IDLE,
    ECC_ENCODE_HAMMING_method_S_0000,
    ECC_ENCODE_HAMMING_method_S_0001,
    ECC_ENCODE_HAMMING_method_S_0002  
  );
  signal ECC_ENCODE_HAMMING_method : Type_ECC_ENCODE_HAMMING_method := ECC_ENCODE_HAMMING_method_IDLE;
  signal ECC_ENCODE_HAMMING_method_prev : Type_ECC_ENCODE_HAMMING_method := ECC_ENCODE_HAMMING_method_IDLE;
  signal ECC_ENCODE_HAMMING_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_req_flag_d : std_logic := '0';
  signal ECC_ENCODE_HAMMING_req_flag_edge : std_logic := '0';
  signal tmp_0247 : std_logic := '0';
  signal tmp_0248 : std_logic := '0';
  signal tmp_0249 : std_logic := '0';
  signal tmp_0250 : std_logic := '0';
  signal tmp_0251 : std_logic := '0';
  signal tmp_0252 : std_logic := '0';
  signal tmp_0253 : std_logic := '0';
  signal tmp_0254 : std_logic := '0';
  type Type_ECC_ENCODE_PARITY_method is (
    ECC_ENCODE_PARITY_method_IDLE,
    ECC_ENCODE_PARITY_method_S_0000,
    ECC_ENCODE_PARITY_method_S_0001,
    ECC_ENCODE_PARITY_method_S_0002  
  );
  signal ECC_ENCODE_PARITY_method : Type_ECC_ENCODE_PARITY_method := ECC_ENCODE_PARITY_method_IDLE;
  signal ECC_ENCODE_PARITY_method_prev : Type_ECC_ENCODE_PARITY_method := ECC_ENCODE_PARITY_method_IDLE;
  signal ECC_ENCODE_PARITY_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_req_flag_d : std_logic := '0';
  signal ECC_ENCODE_PARITY_req_flag_edge : std_logic := '0';
  signal tmp_0255 : std_logic := '0';
  signal tmp_0256 : std_logic := '0';
  signal tmp_0257 : std_logic := '0';
  signal tmp_0258 : std_logic := '0';
  signal tmp_0259 : std_logic := '0';
  signal tmp_0260 : std_logic := '0';
  signal tmp_0261 : std_logic := '0';
  signal tmp_0262 : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;
  write_address_sig <= write_address;
  write_data_sig <= write_data;
  read_address_sig <= read_address;
  read_data_sig <= read_data;
  write_return <= write_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_return_sig <= (others => '0');
      else
        if write_method = write_method_S_0005 then
          write_return_sig <= method_result_00024;
        end if;
      end if;
    end if;
  end process;

  write_busy <= write_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_busy_sig <= '1';
      else
        if write_method = write_method_S_0000 then
          write_busy_sig <= '0';
        elsif write_method = write_method_S_0001 then
          write_busy_sig <= tmp_0006;
        end if;
      end if;
    end if;
  end process;

  write_req_sig <= write_req;
  read_return <= read_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_return_sig <= (others => '0');
      else
        if read_method = read_method_S_0009 then
          read_return_sig <= X"00000000";
        elsif read_method = read_method_S_0012 then
          read_return_sig <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  read_busy <= read_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_busy_sig <= '1';
      else
        if read_method = read_method_S_0000 then
          read_busy_sig <= '0';
        elsif read_method = read_method_S_0001 then
          read_busy_sig <= tmp_0024;
        end if;
      end if;
    end if;
  end process;

  read_req_sig <= read_req;

  -- expressions
  tmp_0001 <= write_req_local or write_req_sig;
  tmp_0002 <= read_req_local or read_req_sig;
  tmp_0003 <= not write_req_flag_d;
  tmp_0004 <= write_req_flag and tmp_0003;
  tmp_0005 <= write_req_flag or write_req_flag_d;
  tmp_0006 <= write_req_flag or write_req_flag_d;
  tmp_0007 <= '1' when blockFinder_busy = '0' else '0';
  tmp_0008 <= '1' when blockFinder_req_local = '0' else '0';
  tmp_0009 <= tmp_0007 and tmp_0008;
  tmp_0010 <= '1' when tmp_0009 = '1' else '0';
  tmp_0011 <= '1' when eccSelector_busy = '0' else '0';
  tmp_0012 <= '1' when eccSelector_req_local = '0' else '0';
  tmp_0013 <= tmp_0011 and tmp_0012;
  tmp_0014 <= '1' when tmp_0013 = '1' else '0';
  tmp_0015 <= '1' when write_method /= write_method_S_0000 else '0';
  tmp_0016 <= '1' when write_method /= write_method_S_0001 else '0';
  tmp_0017 <= tmp_0016 and write_req_flag_edge;
  tmp_0018 <= tmp_0015 and tmp_0017;
  tmp_0019 <= write_address_sig when write_req_sig = '1' else write_address_local;
  tmp_0020 <= write_data_sig when write_req_sig = '1' else write_data_local;
  tmp_0021 <= not read_req_flag_d;
  tmp_0022 <= read_req_flag and tmp_0021;
  tmp_0023 <= read_req_flag or read_req_flag_d;
  tmp_0024 <= read_req_flag or read_req_flag_d;
  tmp_0025 <= '1' when eccEvaluator_busy = '0' else '0';
  tmp_0026 <= '1' when eccEvaluator_req_local = '0' else '0';
  tmp_0027 <= tmp_0025 and tmp_0026;
  tmp_0028 <= '1' when tmp_0027 = '1' else '0';
  tmp_0029 <= '1' when method_result_00031 = '1' else '0';
  tmp_0030 <= '1' when method_result_00031 = '0' else '0';
  tmp_0031 <= '1' when recoding_busy = '0' else '0';
  tmp_0032 <= '1' when recoding_req_local = '0' else '0';
  tmp_0033 <= tmp_0031 and tmp_0032;
  tmp_0034 <= '1' when tmp_0033 = '1' else '0';
  tmp_0035 <= '1' when read_method /= read_method_S_0000 else '0';
  tmp_0036 <= '1' when read_method /= read_method_S_0001 else '0';
  tmp_0037 <= tmp_0036 and read_req_flag_edge;
  tmp_0038 <= tmp_0035 and tmp_0037;
  tmp_0039 <= read_address_sig when read_req_sig = '1' else read_address_local;
  tmp_0040 <= read_data_sig when read_req_sig = '1' else read_data_local;
  tmp_0041 <= not eccEvaluator_req_flag_d;
  tmp_0042 <= eccEvaluator_req_flag and tmp_0041;
  tmp_0043 <= eccEvaluator_req_flag or eccEvaluator_req_flag_d;
  tmp_0044 <= eccEvaluator_req_flag or eccEvaluator_req_flag_d;
  tmp_0045 <= '1' when eccEvaluator_method /= eccEvaluator_method_S_0000 else '0';
  tmp_0046 <= '1' when eccEvaluator_method /= eccEvaluator_method_S_0001 else '0';
  tmp_0047 <= tmp_0046 and eccEvaluator_req_flag_edge;
  tmp_0048 <= tmp_0045 and tmp_0047;
  tmp_0049 <= '1' when eccEvaluator_status_0036 = X"00000001" else '0';
  tmp_0050 <= not getPosition_req_flag_d;
  tmp_0051 <= getPosition_req_flag and tmp_0050;
  tmp_0052 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0053 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0054 <= '1' when getPosition_method /= getPosition_method_S_0000 else '0';
  tmp_0055 <= '1' when getPosition_method /= getPosition_method_S_0001 else '0';
  tmp_0056 <= tmp_0055 and getPosition_req_flag_edge;
  tmp_0057 <= tmp_0054 and tmp_0056;
  tmp_0058 <= not blockFinder_req_flag_d;
  tmp_0059 <= blockFinder_req_flag and tmp_0058;
  tmp_0060 <= blockFinder_req_flag or blockFinder_req_flag_d;
  tmp_0061 <= blockFinder_req_flag or blockFinder_req_flag_d;
  tmp_0062 <= '1' when getPosition_busy = '0' else '0';
  tmp_0063 <= '1' when getPosition_req_local = '0' else '0';
  tmp_0064 <= tmp_0062 and tmp_0063;
  tmp_0065 <= '1' when tmp_0064 = '1' else '0';
  tmp_0066 <= '1' when blockFinder_method /= blockFinder_method_S_0000 else '0';
  tmp_0067 <= '1' when blockFinder_method /= blockFinder_method_S_0001 else '0';
  tmp_0068 <= tmp_0067 and blockFinder_req_flag_edge;
  tmp_0069 <= tmp_0066 and tmp_0068;
  tmp_0070 <= '1' when array_access_00046 = '1' else '0';
  tmp_0071 <= X"00000001" when binary_expr_00048 = '1' else X"00000000";
  tmp_0072 <= '1' when array_access_00053 = '1' else '0';
  tmp_0073 <= X"00000002" when binary_expr_00055 = '1' else X"00000000";
  tmp_0074 <= blockFinder_currentData1_0045 + blockFinder_currentData2_0052;
  tmp_0075 <= not incrementEcc_req_flag_d;
  tmp_0076 <= incrementEcc_req_flag and tmp_0075;
  tmp_0077 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0078 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0079 <= '1' when incrementEcc_ecc_0061 = X"00000000" else '0';
  tmp_0080 <= '1' when incrementEcc_ecc_0061 = X"00000001" else '0';
  tmp_0081 <= '1' when incrementEcc_ecc_0061 = X"00000002" else '0';
  tmp_0082 <= '1' when incrementEcc_ecc_0061 = X"00000003" else '0';
  tmp_0083 <= '1' when incrementEcc_method /= incrementEcc_method_S_0000 else '0';
  tmp_0084 <= '1' when incrementEcc_method /= incrementEcc_method_S_0001 else '0';
  tmp_0085 <= tmp_0084 and incrementEcc_req_flag_edge;
  tmp_0086 <= tmp_0083 and tmp_0085;
  tmp_0087 <= not recoding_req_flag_d;
  tmp_0088 <= recoding_req_flag and tmp_0087;
  tmp_0089 <= recoding_req_flag or recoding_req_flag_d;
  tmp_0090 <= recoding_req_flag or recoding_req_flag_d;
  tmp_0091 <= '1' when binary_expr_00086 = '1' else '0';
  tmp_0092 <= '1' when binary_expr_00086 = '0' else '0';
  tmp_0093 <= '1' when binary_expr_00093 = '1' else '0';
  tmp_0094 <= '1' when binary_expr_00093 = '0' else '0';
  tmp_0095 <= '1' when recodingRead_busy = '0' else '0';
  tmp_0096 <= '1' when recodingRead_req_local = '0' else '0';
  tmp_0097 <= tmp_0095 and tmp_0096;
  tmp_0098 <= '1' when tmp_0097 = '1' else '0';
  tmp_0099 <= '1' when recodingWrite_busy = '0' else '0';
  tmp_0100 <= '1' when recodingWrite_req_local = '0' else '0';
  tmp_0101 <= tmp_0099 and tmp_0100;
  tmp_0102 <= '1' when tmp_0101 = '1' else '0';
  tmp_0103 <= '1' when incrementEcc_busy = '0' else '0';
  tmp_0104 <= '1' when incrementEcc_req_local = '0' else '0';
  tmp_0105 <= tmp_0103 and tmp_0104;
  tmp_0106 <= '1' when tmp_0105 = '1' else '0';
  tmp_0107 <= '1' when recoding_method /= recoding_method_S_0000 else '0';
  tmp_0108 <= '1' when recoding_method /= recoding_method_S_0001 else '0';
  tmp_0109 <= tmp_0108 and recoding_req_flag_edge;
  tmp_0110 <= tmp_0107 and tmp_0109;
  tmp_0111 <= '1' when recoding_ecc_0083 = X"00000003" else '0';
  tmp_0112 <= '1' when recoding_i_0091 < recoding_pageSize_0084 else '0';
  tmp_0113 <= recoding_i_0091 + X"00000001";
  tmp_0114 <= recoding_initialAddress_0089 + recoding_i_0091;
  tmp_0115 <= recoding_initialAddress_0089 + recoding_i_0091;
  tmp_0116 <= recoding_ecc_0083 + X"00000001";
  tmp_0117 <= recoding_ecc_0083 + X"00000001";
  tmp_0118 <= not recodingWrite_req_flag_d;
  tmp_0119 <= recodingWrite_req_flag and tmp_0118;
  tmp_0120 <= recodingWrite_req_flag or recodingWrite_req_flag_d;
  tmp_0121 <= recodingWrite_req_flag or recodingWrite_req_flag_d;
  tmp_0122 <= '1' when eccSelector_busy = '0' else '0';
  tmp_0123 <= '1' when eccSelector_req_local = '0' else '0';
  tmp_0124 <= tmp_0122 and tmp_0123;
  tmp_0125 <= '1' when tmp_0124 = '1' else '0';
  tmp_0126 <= '1' when recodingWrite_ecc_0109 = X"00000001" else '0';
  tmp_0127 <= '1' when recodingWrite_ecc_0109 = X"00000002" else '0';
  tmp_0128 <= '1' when recodingWrite_ecc_0109 = X"00000003" else '0';
  tmp_0129 <= '1' when SCHEDULER_WRITE_busy = '0' else '0';
  tmp_0130 <= '1' when SCHEDULER_WRITE_req_local = '0' else '0';
  tmp_0131 <= tmp_0129 and tmp_0130;
  tmp_0132 <= '1' when tmp_0131 = '1' else '0';
  tmp_0133 <= '1' when SCHEDULER_WRITE_busy = '0' else '0';
  tmp_0134 <= '1' when SCHEDULER_WRITE_req_local = '0' else '0';
  tmp_0135 <= tmp_0133 and tmp_0134;
  tmp_0136 <= '1' when tmp_0135 = '1' else '0';
  tmp_0137 <= '1' when SCHEDULER_WRITE_busy = '0' else '0';
  tmp_0138 <= '1' when SCHEDULER_WRITE_req_local = '0' else '0';
  tmp_0139 <= tmp_0137 and tmp_0138;
  tmp_0140 <= '1' when tmp_0139 = '1' else '0';
  tmp_0141 <= '1' when recodingWrite_method /= recodingWrite_method_S_0000 else '0';
  tmp_0142 <= '1' when recodingWrite_method /= recodingWrite_method_S_0001 else '0';
  tmp_0143 <= tmp_0142 and recodingWrite_req_flag_edge;
  tmp_0144 <= tmp_0141 and tmp_0143;
  tmp_0145 <= not recodingRead_req_flag_d;
  tmp_0146 <= recodingRead_req_flag and tmp_0145;
  tmp_0147 <= recodingRead_req_flag or recodingRead_req_flag_d;
  tmp_0148 <= recodingRead_req_flag or recodingRead_req_flag_d;
  tmp_0149 <= '1' when SCHEDULER_READ_busy = '0' else '0';
  tmp_0150 <= '1' when SCHEDULER_READ_req_local = '0' else '0';
  tmp_0151 <= tmp_0149 and tmp_0150;
  tmp_0152 <= '1' when tmp_0151 = '1' else '0';
  tmp_0153 <= '1' when recodingRead_method /= recodingRead_method_S_0000 else '0';
  tmp_0154 <= '1' when recodingRead_method /= recodingRead_method_S_0001 else '0';
  tmp_0155 <= tmp_0154 and recodingRead_req_flag_edge;
  tmp_0156 <= tmp_0153 and tmp_0155;
  tmp_0157 <= not eccSelector_req_flag_d;
  tmp_0158 <= eccSelector_req_flag and tmp_0157;
  tmp_0159 <= eccSelector_req_flag or eccSelector_req_flag_d;
  tmp_0160 <= eccSelector_req_flag or eccSelector_req_flag_d;
  tmp_0161 <= '1' when eccSelector_ecc_0124 = X"00000000" else '0';
  tmp_0162 <= '1' when eccSelector_ecc_0124 = X"00000001" else '0';
  tmp_0163 <= '1' when eccSelector_ecc_0124 = X"00000002" else '0';
  tmp_0164 <= '1' when eccSelector_ecc_0124 = X"00000003" else '0';
  tmp_0165 <= '1' when ECC_ENCODE_REEDSOLOMON_busy = '0' else '0';
  tmp_0166 <= '1' when ECC_ENCODE_REEDSOLOMON_req_local = '0' else '0';
  tmp_0167 <= tmp_0165 and tmp_0166;
  tmp_0168 <= '1' when tmp_0167 = '1' else '0';
  tmp_0169 <= '1' when ECC_DECODE_REEDSOLOMON_busy = '0' else '0';
  tmp_0170 <= '1' when ECC_DECODE_REEDSOLOMON_req_local = '0' else '0';
  tmp_0171 <= tmp_0169 and tmp_0170;
  tmp_0172 <= '1' when tmp_0171 = '1' else '0';
  tmp_0173 <= '1' when ECC_ENCODE_HAMMING_busy = '0' else '0';
  tmp_0174 <= '1' when ECC_ENCODE_HAMMING_req_local = '0' else '0';
  tmp_0175 <= tmp_0173 and tmp_0174;
  tmp_0176 <= '1' when tmp_0175 = '1' else '0';
  tmp_0177 <= '1' when ECC_DECODE_HAMMING_busy = '0' else '0';
  tmp_0178 <= '1' when ECC_DECODE_HAMMING_req_local = '0' else '0';
  tmp_0179 <= tmp_0177 and tmp_0178;
  tmp_0180 <= '1' when tmp_0179 = '1' else '0';
  tmp_0181 <= '1' when ECC_ENCODE_PARITY_busy = '0' else '0';
  tmp_0182 <= '1' when ECC_ENCODE_PARITY_req_local = '0' else '0';
  tmp_0183 <= tmp_0181 and tmp_0182;
  tmp_0184 <= '1' when tmp_0183 = '1' else '0';
  tmp_0185 <= '1' when ECC_DECODE_PARITY_busy = '0' else '0';
  tmp_0186 <= '1' when ECC_DECODE_PARITY_req_local = '0' else '0';
  tmp_0187 <= tmp_0185 and tmp_0186;
  tmp_0188 <= '1' when tmp_0187 = '1' else '0';
  tmp_0189 <= '1' when eccSelector_method /= eccSelector_method_S_0000 else '0';
  tmp_0190 <= '1' when eccSelector_method /= eccSelector_method_S_0001 else '0';
  tmp_0191 <= tmp_0190 and eccSelector_req_flag_edge;
  tmp_0192 <= tmp_0189 and tmp_0191;
  tmp_0193 <= '1' when eccSelector_encoder_0125 = X"00000001" else '0';
  tmp_0194 <= method_result_00132 when binary_expr_00131 = '1' else method_result_00133;
  tmp_0195 <= '1' when eccSelector_encoder_0125 = X"00000001" else '0';
  tmp_0196 <= method_result_00137 when binary_expr_00136 = '1' else method_result_00138;
  tmp_0197 <= '1' when eccSelector_encoder_0125 = X"00000001" else '0';
  tmp_0198 <= method_result_00142 when binary_expr_00141 = '1' else method_result_00143;
  tmp_0199 <= not SCHEDULER_WRITE_req_flag_d;
  tmp_0200 <= SCHEDULER_WRITE_req_flag and tmp_0199;
  tmp_0201 <= SCHEDULER_WRITE_req_flag or SCHEDULER_WRITE_req_flag_d;
  tmp_0202 <= SCHEDULER_WRITE_req_flag or SCHEDULER_WRITE_req_flag_d;
  tmp_0203 <= '1' when SCHEDULER_WRITE_method /= SCHEDULER_WRITE_method_S_0000 else '0';
  tmp_0204 <= '1' when SCHEDULER_WRITE_method /= SCHEDULER_WRITE_method_S_0001 else '0';
  tmp_0205 <= tmp_0204 and SCHEDULER_WRITE_req_flag_edge;
  tmp_0206 <= tmp_0203 and tmp_0205;
  tmp_0207 <= not SCHEDULER_READ_req_flag_d;
  tmp_0208 <= SCHEDULER_READ_req_flag and tmp_0207;
  tmp_0209 <= SCHEDULER_READ_req_flag or SCHEDULER_READ_req_flag_d;
  tmp_0210 <= SCHEDULER_READ_req_flag or SCHEDULER_READ_req_flag_d;
  tmp_0211 <= '1' when SCHEDULER_READ_method /= SCHEDULER_READ_method_S_0000 else '0';
  tmp_0212 <= '1' when SCHEDULER_READ_method /= SCHEDULER_READ_method_S_0001 else '0';
  tmp_0213 <= tmp_0212 and SCHEDULER_READ_req_flag_edge;
  tmp_0214 <= tmp_0211 and tmp_0213;
  tmp_0215 <= not ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0216 <= ECC_DECODE_REEDSOLOMON_req_flag and tmp_0215;
  tmp_0217 <= ECC_DECODE_REEDSOLOMON_req_flag or ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0218 <= ECC_DECODE_REEDSOLOMON_req_flag or ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0219 <= '1' when ECC_DECODE_REEDSOLOMON_method /= ECC_DECODE_REEDSOLOMON_method_S_0000 else '0';
  tmp_0220 <= '1' when ECC_DECODE_REEDSOLOMON_method /= ECC_DECODE_REEDSOLOMON_method_S_0001 else '0';
  tmp_0221 <= tmp_0220 and ECC_DECODE_REEDSOLOMON_req_flag_edge;
  tmp_0222 <= tmp_0219 and tmp_0221;
  tmp_0223 <= not ECC_DECODE_HAMMING_req_flag_d;
  tmp_0224 <= ECC_DECODE_HAMMING_req_flag and tmp_0223;
  tmp_0225 <= ECC_DECODE_HAMMING_req_flag or ECC_DECODE_HAMMING_req_flag_d;
  tmp_0226 <= ECC_DECODE_HAMMING_req_flag or ECC_DECODE_HAMMING_req_flag_d;
  tmp_0227 <= '1' when ECC_DECODE_HAMMING_method /= ECC_DECODE_HAMMING_method_S_0000 else '0';
  tmp_0228 <= '1' when ECC_DECODE_HAMMING_method /= ECC_DECODE_HAMMING_method_S_0001 else '0';
  tmp_0229 <= tmp_0228 and ECC_DECODE_HAMMING_req_flag_edge;
  tmp_0230 <= tmp_0227 and tmp_0229;
  tmp_0231 <= not ECC_DECODE_PARITY_req_flag_d;
  tmp_0232 <= ECC_DECODE_PARITY_req_flag and tmp_0231;
  tmp_0233 <= ECC_DECODE_PARITY_req_flag or ECC_DECODE_PARITY_req_flag_d;
  tmp_0234 <= ECC_DECODE_PARITY_req_flag or ECC_DECODE_PARITY_req_flag_d;
  tmp_0235 <= '1' when ECC_DECODE_PARITY_method /= ECC_DECODE_PARITY_method_S_0000 else '0';
  tmp_0236 <= '1' when ECC_DECODE_PARITY_method /= ECC_DECODE_PARITY_method_S_0001 else '0';
  tmp_0237 <= tmp_0236 and ECC_DECODE_PARITY_req_flag_edge;
  tmp_0238 <= tmp_0235 and tmp_0237;
  tmp_0239 <= not ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0240 <= ECC_ENCODE_REEDSOLOMON_req_flag and tmp_0239;
  tmp_0241 <= ECC_ENCODE_REEDSOLOMON_req_flag or ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0242 <= ECC_ENCODE_REEDSOLOMON_req_flag or ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0243 <= '1' when ECC_ENCODE_REEDSOLOMON_method /= ECC_ENCODE_REEDSOLOMON_method_S_0000 else '0';
  tmp_0244 <= '1' when ECC_ENCODE_REEDSOLOMON_method /= ECC_ENCODE_REEDSOLOMON_method_S_0001 else '0';
  tmp_0245 <= tmp_0244 and ECC_ENCODE_REEDSOLOMON_req_flag_edge;
  tmp_0246 <= tmp_0243 and tmp_0245;
  tmp_0247 <= not ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0248 <= ECC_ENCODE_HAMMING_req_flag and tmp_0247;
  tmp_0249 <= ECC_ENCODE_HAMMING_req_flag or ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0250 <= ECC_ENCODE_HAMMING_req_flag or ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0251 <= '1' when ECC_ENCODE_HAMMING_method /= ECC_ENCODE_HAMMING_method_S_0000 else '0';
  tmp_0252 <= '1' when ECC_ENCODE_HAMMING_method /= ECC_ENCODE_HAMMING_method_S_0001 else '0';
  tmp_0253 <= tmp_0252 and ECC_ENCODE_HAMMING_req_flag_edge;
  tmp_0254 <= tmp_0251 and tmp_0253;
  tmp_0255 <= not ECC_ENCODE_PARITY_req_flag_d;
  tmp_0256 <= ECC_ENCODE_PARITY_req_flag and tmp_0255;
  tmp_0257 <= ECC_ENCODE_PARITY_req_flag or ECC_ENCODE_PARITY_req_flag_d;
  tmp_0258 <= ECC_ENCODE_PARITY_req_flag or ECC_ENCODE_PARITY_req_flag_d;
  tmp_0259 <= '1' when ECC_ENCODE_PARITY_method /= ECC_ENCODE_PARITY_method_S_0000 else '0';
  tmp_0260 <= '1' when ECC_ENCODE_PARITY_method /= ECC_ENCODE_PARITY_method_S_0001 else '0';
  tmp_0261 <= tmp_0260 and ECC_ENCODE_PARITY_req_flag_edge;
  tmp_0262 <= tmp_0259 and tmp_0261;

  -- sequencers
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
            if tmp_0005 = '1' then
              write_method <= write_method_S_0002;
            end if;
          when write_method_S_0002 => 
            write_method <= write_method_S_0002_body;
          when write_method_S_0003 => 
            write_method <= write_method_S_0004;
          when write_method_S_0004 => 
            write_method <= write_method_S_0004_body;
          when write_method_S_0005 => 
            write_method <= write_method_S_0000;
          when write_method_S_0002_body => 
            write_method <= write_method_S_0002_wait;
          when write_method_S_0002_wait => 
            if blockFinder_call_flag_0002 = '1' then
              write_method <= write_method_S_0003;
            end if;
          when write_method_S_0004_body => 
            write_method <= write_method_S_0004_wait;
          when write_method_S_0004_wait => 
            if eccSelector_call_flag_0004 = '1' then
              write_method <= write_method_S_0005;
            end if;
          when others => null;
        end case;
        write_req_flag_d <= write_req_flag;
        if (tmp_0015 and tmp_0017) = '1' then
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
            if tmp_0023 = '1' then
              read_method <= read_method_S_0002;
            end if;
          when read_method_S_0002 => 
            read_method <= read_method_S_0002_body;
          when read_method_S_0003 => 
            read_method <= read_method_S_0004;
          when read_method_S_0004 => 
            read_method <= read_method_S_0004_body;
          when read_method_S_0005 => 
            read_method <= read_method_S_0006;
          when read_method_S_0006 => 
            read_method <= read_method_S_0006_body;
          when read_method_S_0007 => 
            if tmp_0029 = '1' then
              read_method <= read_method_S_0009;
            elsif tmp_0030 = '1' then
              read_method <= read_method_S_0011;
            end if;
          when read_method_S_0009 => 
            read_method <= read_method_S_0000;
          when read_method_S_0011 => 
            read_method <= read_method_S_0011_body;
          when read_method_S_0012 => 
            read_method <= read_method_S_0000;
          when read_method_S_0002_body => 
            read_method <= read_method_S_0002_wait;
          when read_method_S_0002_wait => 
            if blockFinder_call_flag_0002 = '1' then
              read_method <= read_method_S_0003;
            end if;
          when read_method_S_0004_body => 
            read_method <= read_method_S_0004_wait;
          when read_method_S_0004_wait => 
            if eccSelector_call_flag_0004 = '1' then
              read_method <= read_method_S_0005;
            end if;
          when read_method_S_0006_body => 
            read_method <= read_method_S_0006_wait;
          when read_method_S_0006_wait => 
            if eccEvaluator_call_flag_0006 = '1' then
              read_method <= read_method_S_0007;
            end if;
          when read_method_S_0011_body => 
            read_method <= read_method_S_0011_wait;
          when read_method_S_0011_wait => 
            if recoding_call_flag_0011 = '1' then
              read_method <= read_method_S_0012;
            end if;
          when others => null;
        end case;
        read_req_flag_d <= read_req_flag;
        if (tmp_0035 and tmp_0037) = '1' then
          read_method <= read_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_method <= eccEvaluator_method_IDLE;
        eccEvaluator_method_delay <= (others => '0');
      else
        case (eccEvaluator_method) is
          when eccEvaluator_method_IDLE => 
            eccEvaluator_method <= eccEvaluator_method_S_0000;
          when eccEvaluator_method_S_0000 => 
            eccEvaluator_method <= eccEvaluator_method_S_0001;
          when eccEvaluator_method_S_0001 => 
            if tmp_0043 = '1' then
              eccEvaluator_method <= eccEvaluator_method_S_0002;
            end if;
          when eccEvaluator_method_S_0002 => 
            eccEvaluator_method <= eccEvaluator_method_S_0003;
          when eccEvaluator_method_S_0003 => 
            eccEvaluator_method <= eccEvaluator_method_S_0000;
          when others => null;
        end case;
        eccEvaluator_req_flag_d <= eccEvaluator_req_flag;
        if (tmp_0045 and tmp_0047) = '1' then
          eccEvaluator_method <= eccEvaluator_method_S_0001;
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
            if tmp_0052 = '1' then
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
        if (tmp_0054 and tmp_0056) = '1' then
          getPosition_method <= getPosition_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_method <= blockFinder_method_IDLE;
        blockFinder_method_delay <= (others => '0');
      else
        case (blockFinder_method) is
          when blockFinder_method_IDLE => 
            blockFinder_method <= blockFinder_method_S_0000;
          when blockFinder_method_S_0000 => 
            blockFinder_method <= blockFinder_method_S_0001;
          when blockFinder_method_S_0001 => 
            if tmp_0060 = '1' then
              blockFinder_method <= blockFinder_method_S_0002;
            end if;
          when blockFinder_method_S_0002 => 
            blockFinder_method <= blockFinder_method_S_0002_body;
          when blockFinder_method_S_0003 => 
            blockFinder_method <= blockFinder_method_S_0004;
          when blockFinder_method_S_0004 => 
            blockFinder_method <= blockFinder_method_S_0015;
          when blockFinder_method_S_0015 => 
            blockFinder_method <= blockFinder_method_S_0016;
          when blockFinder_method_S_0016 => 
            blockFinder_method <= blockFinder_method_S_0005;
          when blockFinder_method_S_0005 => 
            blockFinder_method <= blockFinder_method_S_0006;
          when blockFinder_method_S_0006 => 
            blockFinder_method <= blockFinder_method_S_0007;
          when blockFinder_method_S_0007 => 
            blockFinder_method <= blockFinder_method_S_0008;
          when blockFinder_method_S_0008 => 
            blockFinder_method <= blockFinder_method_S_0017;
          when blockFinder_method_S_0017 => 
            blockFinder_method <= blockFinder_method_S_0018;
          when blockFinder_method_S_0018 => 
            blockFinder_method <= blockFinder_method_S_0009;
          when blockFinder_method_S_0009 => 
            blockFinder_method <= blockFinder_method_S_0010;
          when blockFinder_method_S_0010 => 
            blockFinder_method <= blockFinder_method_S_0011;
          when blockFinder_method_S_0011 => 
            blockFinder_method <= blockFinder_method_S_0012;
          when blockFinder_method_S_0012 => 
            blockFinder_method <= blockFinder_method_S_0013;
          when blockFinder_method_S_0013 => 
            blockFinder_method <= blockFinder_method_S_0000;
          when blockFinder_method_S_0002_body => 
            blockFinder_method <= blockFinder_method_S_0002_wait;
          when blockFinder_method_S_0002_wait => 
            if getPosition_call_flag_0002 = '1' then
              blockFinder_method <= blockFinder_method_S_0003;
            end if;
          when others => null;
        end case;
        blockFinder_req_flag_d <= blockFinder_req_flag;
        if (tmp_0066 and tmp_0068) = '1' then
          blockFinder_method <= blockFinder_method_S_0001;
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
            if tmp_0077 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0002;
            end if;
          when incrementEcc_method_S_0002 => 
            if tmp_0079 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0023;
            elsif tmp_0080 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0017;
            elsif tmp_0081 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0011;
            elsif tmp_0082 = '1' then
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
        if (tmp_0083 and tmp_0085) = '1' then
          incrementEcc_method <= incrementEcc_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_method <= recoding_method_IDLE;
        recoding_method_delay <= (others => '0');
      else
        case (recoding_method) is
          when recoding_method_IDLE => 
            recoding_method <= recoding_method_S_0000;
          when recoding_method_S_0000 => 
            recoding_method <= recoding_method_S_0001;
          when recoding_method_S_0001 => 
            if tmp_0089 = '1' then
              recoding_method <= recoding_method_S_0002;
            end if;
          when recoding_method_S_0002 => 
            recoding_method <= recoding_method_S_0003;
          when recoding_method_S_0003 => 
            if tmp_0091 = '1' then
              recoding_method <= recoding_method_S_0005;
            elsif tmp_0092 = '1' then
              recoding_method <= recoding_method_S_0007;
            end if;
          when recoding_method_S_0005 => 
            recoding_method <= recoding_method_S_0000;
          when recoding_method_S_0007 => 
            if recoding_method_delay >= 1 and u_synthesijer_div32_recoding_valid = '1' then
              recoding_method_delay <= (others => '0');
              recoding_method <= recoding_method_S_0008;
            else
              recoding_method_delay <= recoding_method_delay + 1;
            end if;
          when recoding_method_S_0008 => 
            recoding_method <= recoding_method_S_0009;
          when recoding_method_S_0009 => 
            if recoding_method_delay >= 1 and u_synthesijer_mul32_recoding_valid = '1' then
              recoding_method_delay <= (others => '0');
              recoding_method <= recoding_method_S_0010;
            else
              recoding_method_delay <= recoding_method_delay + 1;
            end if;
          when recoding_method_S_0010 => 
            recoding_method <= recoding_method_S_0012;
          when recoding_method_S_0012 => 
            recoding_method <= recoding_method_S_0013;
          when recoding_method_S_0013 => 
            if tmp_0093 = '1' then
              recoding_method <= recoding_method_S_0019;
            elsif tmp_0094 = '1' then
              recoding_method <= recoding_method_S_0026;
            end if;
          when recoding_method_S_0015 => 
            recoding_method <= recoding_method_S_0017;
          when recoding_method_S_0017 => 
            recoding_method <= recoding_method_S_0019;
          when recoding_method_S_0019 => 
            recoding_method <= recoding_method_S_0020;
          when recoding_method_S_0020 => 
            recoding_method <= recoding_method_S_0020_body;
          when recoding_method_S_0021 => 
            recoding_method <= recoding_method_S_0024;
          when recoding_method_S_0024 => 
            recoding_method <= recoding_method_S_0024_body;
          when recoding_method_S_0026 => 
            recoding_method <= recoding_method_S_0027;
          when recoding_method_S_0027 => 
            recoding_method <= recoding_method_S_0027_body;
          when recoding_method_S_0020_body => 
            recoding_method <= recoding_method_S_0020_wait;
          when recoding_method_S_0020_wait => 
            if recodingRead_call_flag_0020 = '1' then
              recoding_method <= recoding_method_S_0021;
            end if;
          when recoding_method_S_0024_body => 
            recoding_method <= recoding_method_S_0024_wait;
          when recoding_method_S_0024_wait => 
            if recodingWrite_call_flag_0024 = '1' then
              recoding_method <= recoding_method_S_0015;
            end if;
          when recoding_method_S_0027_body => 
            recoding_method <= recoding_method_S_0027_wait;
          when recoding_method_S_0027_wait => 
            if incrementEcc_call_flag_0027 = '1' then
              recoding_method <= recoding_method_S_0000;
            end if;
          when others => null;
        end case;
        recoding_req_flag_d <= recoding_req_flag;
        if (tmp_0107 and tmp_0109) = '1' then
          recoding_method <= recoding_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_method <= recodingWrite_method_IDLE;
        recodingWrite_method_delay <= (others => '0');
      else
        case (recodingWrite_method) is
          when recodingWrite_method_IDLE => 
            recodingWrite_method <= recodingWrite_method_S_0000;
          when recodingWrite_method_S_0000 => 
            recodingWrite_method <= recodingWrite_method_S_0001;
          when recodingWrite_method_S_0001 => 
            if tmp_0120 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0002;
            end if;
          when recodingWrite_method_S_0002 => 
            recodingWrite_method <= recodingWrite_method_S_0002_body;
          when recodingWrite_method_S_0003 => 
            recodingWrite_method <= recodingWrite_method_S_0004;
          when recodingWrite_method_S_0004 => 
            if tmp_0126 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0013;
            elsif tmp_0127 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0010;
            elsif tmp_0128 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0007;
            else
              recodingWrite_method <= recodingWrite_method_S_0000;
            end if;
          when recodingWrite_method_S_0007 => 
            recodingWrite_method <= recodingWrite_method_S_0007_body;
          when recodingWrite_method_S_0008 => 
            recodingWrite_method <= recodingWrite_method_S_0000;
          when recodingWrite_method_S_0010 => 
            recodingWrite_method <= recodingWrite_method_S_0010_body;
          when recodingWrite_method_S_0011 => 
            recodingWrite_method <= recodingWrite_method_S_0000;
          when recodingWrite_method_S_0013 => 
            recodingWrite_method <= recodingWrite_method_S_0013_body;
          when recodingWrite_method_S_0014 => 
            recodingWrite_method <= recodingWrite_method_S_0000;
          when recodingWrite_method_S_0002_body => 
            recodingWrite_method <= recodingWrite_method_S_0002_wait;
          when recodingWrite_method_S_0002_wait => 
            if eccSelector_call_flag_0002 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0003;
            end if;
          when recodingWrite_method_S_0007_body => 
            recodingWrite_method <= recodingWrite_method_S_0007_wait;
          when recodingWrite_method_S_0007_wait => 
            if SCHEDULER_WRITE_call_flag_0007 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0008;
            end if;
          when recodingWrite_method_S_0010_body => 
            recodingWrite_method <= recodingWrite_method_S_0010_wait;
          when recodingWrite_method_S_0010_wait => 
            if SCHEDULER_WRITE_call_flag_0010 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0011;
            end if;
          when recodingWrite_method_S_0013_body => 
            recodingWrite_method <= recodingWrite_method_S_0013_wait;
          when recodingWrite_method_S_0013_wait => 
            if SCHEDULER_WRITE_call_flag_0013 = '1' then
              recodingWrite_method <= recodingWrite_method_S_0014;
            end if;
          when others => null;
        end case;
        recodingWrite_req_flag_d <= recodingWrite_req_flag;
        if (tmp_0141 and tmp_0143) = '1' then
          recodingWrite_method <= recodingWrite_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_method <= recodingRead_method_IDLE;
        recodingRead_method_delay <= (others => '0');
      else
        case (recodingRead_method) is
          when recodingRead_method_IDLE => 
            recodingRead_method <= recodingRead_method_S_0000;
          when recodingRead_method_S_0000 => 
            recodingRead_method <= recodingRead_method_S_0001;
          when recodingRead_method_S_0001 => 
            if tmp_0147 = '1' then
              recodingRead_method <= recodingRead_method_S_0002;
            end if;
          when recodingRead_method_S_0002 => 
            recodingRead_method <= recodingRead_method_S_0002_body;
          when recodingRead_method_S_0003 => 
            recodingRead_method <= recodingRead_method_S_0004;
          when recodingRead_method_S_0004 => 
            recodingRead_method <= recodingRead_method_S_0004_body;
          when recodingRead_method_S_0005 => 
            recodingRead_method <= recodingRead_method_S_0000;
          when recodingRead_method_S_0002_body => 
            recodingRead_method <= recodingRead_method_S_0002_wait;
          when recodingRead_method_S_0002_wait => 
            if SCHEDULER_READ_call_flag_0002 = '1' then
              recodingRead_method <= recodingRead_method_S_0003;
            end if;
          when recodingRead_method_S_0004_body => 
            recodingRead_method <= recodingRead_method_S_0004_wait;
          when recodingRead_method_S_0004_wait => 
            if eccSelector_call_flag_0004 = '1' then
              recodingRead_method <= recodingRead_method_S_0005;
            end if;
          when others => null;
        end case;
        recodingRead_req_flag_d <= recodingRead_req_flag;
        if (tmp_0153 and tmp_0155) = '1' then
          recodingRead_method <= recodingRead_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_method <= eccSelector_method_IDLE;
        eccSelector_method_delay <= (others => '0');
      else
        case (eccSelector_method) is
          when eccSelector_method_IDLE => 
            eccSelector_method <= eccSelector_method_S_0000;
          when eccSelector_method_S_0000 => 
            eccSelector_method <= eccSelector_method_S_0001;
          when eccSelector_method_S_0001 => 
            if tmp_0159 = '1' then
              eccSelector_method <= eccSelector_method_S_0002;
            end if;
          when eccSelector_method_S_0002 => 
            if tmp_0161 = '1' then
              eccSelector_method <= eccSelector_method_S_0023;
            elsif tmp_0162 = '1' then
              eccSelector_method <= eccSelector_method_S_0017;
            elsif tmp_0163 = '1' then
              eccSelector_method <= eccSelector_method_S_0011;
            elsif tmp_0164 = '1' then
              eccSelector_method <= eccSelector_method_S_0005;
            else
              eccSelector_method <= eccSelector_method_S_0000;
            end if;
          when eccSelector_method_S_0005 => 
            eccSelector_method <= eccSelector_method_S_0006;
          when eccSelector_method_S_0006 => 
            eccSelector_method <= eccSelector_method_S_0006_body;
          when eccSelector_method_S_0007 => 
            eccSelector_method <= eccSelector_method_S_0007_body;
          when eccSelector_method_S_0008 => 
            eccSelector_method <= eccSelector_method_S_0009;
          when eccSelector_method_S_0009 => 
            eccSelector_method <= eccSelector_method_S_0000;
          when eccSelector_method_S_0011 => 
            eccSelector_method <= eccSelector_method_S_0012;
          when eccSelector_method_S_0012 => 
            eccSelector_method <= eccSelector_method_S_0012_body;
          when eccSelector_method_S_0013 => 
            eccSelector_method <= eccSelector_method_S_0013_body;
          when eccSelector_method_S_0014 => 
            eccSelector_method <= eccSelector_method_S_0015;
          when eccSelector_method_S_0015 => 
            eccSelector_method <= eccSelector_method_S_0000;
          when eccSelector_method_S_0017 => 
            eccSelector_method <= eccSelector_method_S_0018;
          when eccSelector_method_S_0018 => 
            eccSelector_method <= eccSelector_method_S_0018_body;
          when eccSelector_method_S_0019 => 
            eccSelector_method <= eccSelector_method_S_0019_body;
          when eccSelector_method_S_0020 => 
            eccSelector_method <= eccSelector_method_S_0021;
          when eccSelector_method_S_0021 => 
            eccSelector_method <= eccSelector_method_S_0000;
          when eccSelector_method_S_0023 => 
            eccSelector_method <= eccSelector_method_S_0000;
          when eccSelector_method_S_0006_body => 
            eccSelector_method <= eccSelector_method_S_0006_wait;
          when eccSelector_method_S_0006_wait => 
            if ECC_ENCODE_REEDSOLOMON_call_flag_0006 = '1' then
              eccSelector_method <= eccSelector_method_S_0007;
            end if;
          when eccSelector_method_S_0007_body => 
            eccSelector_method <= eccSelector_method_S_0007_wait;
          when eccSelector_method_S_0007_wait => 
            if ECC_DECODE_REEDSOLOMON_call_flag_0007 = '1' then
              eccSelector_method <= eccSelector_method_S_0008;
            end if;
          when eccSelector_method_S_0012_body => 
            eccSelector_method <= eccSelector_method_S_0012_wait;
          when eccSelector_method_S_0012_wait => 
            if ECC_ENCODE_HAMMING_call_flag_0012 = '1' then
              eccSelector_method <= eccSelector_method_S_0013;
            end if;
          when eccSelector_method_S_0013_body => 
            eccSelector_method <= eccSelector_method_S_0013_wait;
          when eccSelector_method_S_0013_wait => 
            if ECC_DECODE_HAMMING_call_flag_0013 = '1' then
              eccSelector_method <= eccSelector_method_S_0014;
            end if;
          when eccSelector_method_S_0018_body => 
            eccSelector_method <= eccSelector_method_S_0018_wait;
          when eccSelector_method_S_0018_wait => 
            if ECC_ENCODE_PARITY_call_flag_0018 = '1' then
              eccSelector_method <= eccSelector_method_S_0019;
            end if;
          when eccSelector_method_S_0019_body => 
            eccSelector_method <= eccSelector_method_S_0019_wait;
          when eccSelector_method_S_0019_wait => 
            if ECC_DECODE_PARITY_call_flag_0019 = '1' then
              eccSelector_method <= eccSelector_method_S_0020;
            end if;
          when others => null;
        end case;
        eccSelector_req_flag_d <= eccSelector_req_flag;
        if (tmp_0189 and tmp_0191) = '1' then
          eccSelector_method <= eccSelector_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_method <= SCHEDULER_WRITE_method_IDLE;
        SCHEDULER_WRITE_method_delay <= (others => '0');
      else
        case (SCHEDULER_WRITE_method) is
          when SCHEDULER_WRITE_method_IDLE => 
            SCHEDULER_WRITE_method <= SCHEDULER_WRITE_method_S_0000;
          when SCHEDULER_WRITE_method_S_0000 => 
            SCHEDULER_WRITE_method <= SCHEDULER_WRITE_method_S_0001;
          when SCHEDULER_WRITE_method_S_0001 => 
            if tmp_0201 = '1' then
              SCHEDULER_WRITE_method <= SCHEDULER_WRITE_method_S_0000;
            end if;
          when others => null;
        end case;
        SCHEDULER_WRITE_req_flag_d <= SCHEDULER_WRITE_req_flag;
        if (tmp_0203 and tmp_0205) = '1' then
          SCHEDULER_WRITE_method <= SCHEDULER_WRITE_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_method <= SCHEDULER_READ_method_IDLE;
        SCHEDULER_READ_method_delay <= (others => '0');
      else
        case (SCHEDULER_READ_method) is
          when SCHEDULER_READ_method_IDLE => 
            SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0000;
          when SCHEDULER_READ_method_S_0000 => 
            SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0001;
          when SCHEDULER_READ_method_S_0001 => 
            if tmp_0209 = '1' then
              SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0002;
            end if;
          when SCHEDULER_READ_method_S_0002 => 
            SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0000;
          when others => null;
        end case;
        SCHEDULER_READ_req_flag_d <= SCHEDULER_READ_req_flag;
        if (tmp_0211 and tmp_0213) = '1' then
          SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_IDLE;
        ECC_DECODE_REEDSOLOMON_method_delay <= (others => '0');
      else
        case (ECC_DECODE_REEDSOLOMON_method) is
          when ECC_DECODE_REEDSOLOMON_method_IDLE => 
            ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0000;
          when ECC_DECODE_REEDSOLOMON_method_S_0000 => 
            ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0001;
          when ECC_DECODE_REEDSOLOMON_method_S_0001 => 
            if tmp_0217 = '1' then
              ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0002;
            end if;
          when ECC_DECODE_REEDSOLOMON_method_S_0002 => 
            ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_REEDSOLOMON_req_flag_d <= ECC_DECODE_REEDSOLOMON_req_flag;
        if (tmp_0219 and tmp_0221) = '1' then
          ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_IDLE;
        ECC_DECODE_HAMMING_method_delay <= (others => '0');
      else
        case (ECC_DECODE_HAMMING_method) is
          when ECC_DECODE_HAMMING_method_IDLE => 
            ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0000;
          when ECC_DECODE_HAMMING_method_S_0000 => 
            ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0001;
          when ECC_DECODE_HAMMING_method_S_0001 => 
            if tmp_0225 = '1' then
              ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0002;
            end if;
          when ECC_DECODE_HAMMING_method_S_0002 => 
            ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_HAMMING_req_flag_d <= ECC_DECODE_HAMMING_req_flag;
        if (tmp_0227 and tmp_0229) = '1' then
          ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_IDLE;
        ECC_DECODE_PARITY_method_delay <= (others => '0');
      else
        case (ECC_DECODE_PARITY_method) is
          when ECC_DECODE_PARITY_method_IDLE => 
            ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0000;
          when ECC_DECODE_PARITY_method_S_0000 => 
            ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0001;
          when ECC_DECODE_PARITY_method_S_0001 => 
            if tmp_0233 = '1' then
              ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0002;
            end if;
          when ECC_DECODE_PARITY_method_S_0002 => 
            ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_PARITY_req_flag_d <= ECC_DECODE_PARITY_req_flag;
        if (tmp_0235 and tmp_0237) = '1' then
          ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_IDLE;
        ECC_ENCODE_REEDSOLOMON_method_delay <= (others => '0');
      else
        case (ECC_ENCODE_REEDSOLOMON_method) is
          when ECC_ENCODE_REEDSOLOMON_method_IDLE => 
            ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0000;
          when ECC_ENCODE_REEDSOLOMON_method_S_0000 => 
            ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0001;
          when ECC_ENCODE_REEDSOLOMON_method_S_0001 => 
            if tmp_0241 = '1' then
              ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0002;
            end if;
          when ECC_ENCODE_REEDSOLOMON_method_S_0002 => 
            ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_REEDSOLOMON_req_flag_d <= ECC_ENCODE_REEDSOLOMON_req_flag;
        if (tmp_0243 and tmp_0245) = '1' then
          ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_IDLE;
        ECC_ENCODE_HAMMING_method_delay <= (others => '0');
      else
        case (ECC_ENCODE_HAMMING_method) is
          when ECC_ENCODE_HAMMING_method_IDLE => 
            ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0000;
          when ECC_ENCODE_HAMMING_method_S_0000 => 
            ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0001;
          when ECC_ENCODE_HAMMING_method_S_0001 => 
            if tmp_0249 = '1' then
              ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0002;
            end if;
          when ECC_ENCODE_HAMMING_method_S_0002 => 
            ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_HAMMING_req_flag_d <= ECC_ENCODE_HAMMING_req_flag;
        if (tmp_0251 and tmp_0253) = '1' then
          ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_IDLE;
        ECC_ENCODE_PARITY_method_delay <= (others => '0');
      else
        case (ECC_ENCODE_PARITY_method) is
          when ECC_ENCODE_PARITY_method_IDLE => 
            ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0000;
          when ECC_ENCODE_PARITY_method_S_0000 => 
            ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0001;
          when ECC_ENCODE_PARITY_method_S_0001 => 
            if tmp_0257 = '1' then
              ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0002;
            end if;
          when ECC_ENCODE_PARITY_method_S_0002 => 
            ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_PARITY_req_flag_d <= ECC_ENCODE_PARITY_req_flag;
        if (tmp_0259 and tmp_0261) = '1' then
          ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  class_data0_0011_clk <= clk_sig;

  class_data0_0011_reset <= reset_sig;

  class_data1_0014_clk <= clk_sig;

  class_data1_0014_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0014_address_b <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0004 then
          class_data1_0014_address_b <= blockFinder_dataPosition_0043;
        elsif incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0014_address_b <= incrementEcc_position_0060;
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0014_address_b <= incrementEcc_position_0060;
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0014_address_b <= incrementEcc_position_0060;
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0014_address_b <= incrementEcc_position_0060;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0014_din_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0014_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0014_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0014_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0014_din_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0014_we_b <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          class_data1_0014_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data1_0014_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data1_0014_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data1_0014_we_b <= '1';
        else
          class_data1_0014_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0014_oe_b <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0016 and blockFinder_method_delay = 0 then
          class_data1_0014_oe_b <= '1';
        else
          class_data1_0014_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  class_data2_0017_clk <= clk_sig;

  class_data2_0017_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0017_address_b <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0008 then
          class_data2_0017_address_b <= blockFinder_dataPosition_0043;
        elsif incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0017_address_b <= incrementEcc_position_0060;
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0017_address_b <= incrementEcc_position_0060;
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0017_address_b <= incrementEcc_position_0060;
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0017_address_b <= incrementEcc_position_0060;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0017_din_b <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0017_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0017_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0017_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0017_din_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0017_we_b <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0007 then
          class_data2_0017_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0013 then
          class_data2_0017_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0019 then
          class_data2_0017_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0025 then
          class_data2_0017_we_b <= '1';
        else
          class_data2_0017_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data2_0017_oe_b <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0018 and blockFinder_method_delay = 0 then
          class_data2_0017_oe_b <= '1';
        else
          class_data2_0017_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_address_0020 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_address_0020 <= tmp_0019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_data_0021 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_data_0021 <= tmp_0020;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00023 <= (others => '0');
      else
        if write_method = write_method_S_0002_wait then
          method_result_00023 <= blockFinder_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_ecc_0022 <= (others => '0');
      else
        if write_method = write_method_S_0003 then
          write_ecc_0022 <= method_result_00023;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00024 <= (others => '0');
      else
        if write_method = write_method_S_0004_wait then
          method_result_00024 <= eccSelector_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_address_0025 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_address_0025 <= tmp_0039;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_data_0026 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_data_0026 <= tmp_0040;
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
        if read_method = read_method_S_0002_wait then
          method_result_00028 <= blockFinder_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_ecc_0027 <= (others => '0');
      else
        if read_method = read_method_S_0003 then
          read_ecc_0027 <= method_result_00028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00030 <= (others => '0');
      else
        if read_method = read_method_S_0004_wait then
          method_result_00030 <= eccSelector_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_status_0029 <= (others => '0');
      else
        if read_method = read_method_S_0005 then
          read_status_0029 <= method_result_00030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00031 <= '0';
      else
        if read_method = read_method_S_0006_wait then
          method_result_00031 <= eccEvaluator_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_data_0035 <= (others => '0');
      else
        if eccEvaluator_method = eccEvaluator_method_S_0001 then
          eccEvaluator_data_0035 <= eccEvaluator_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_data_local <= (others => '0');
      else
        if read_method = read_method_S_0006_body and read_method_delay = 0 then
          eccEvaluator_data_local <= read_data_0026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_status_0036 <= (others => '0');
      else
        if eccEvaluator_method = eccEvaluator_method_S_0001 then
          eccEvaluator_status_0036 <= eccEvaluator_status_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_status_local <= (others => '0');
      else
        if read_method = read_method_S_0006_body and read_method_delay = 0 then
          eccEvaluator_status_local <= read_status_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00038 <= '0';
      else
        if eccEvaluator_method = eccEvaluator_method_S_0002 then
          binary_expr_00038 <= tmp_0049;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_address_0039 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0001 then
          getPosition_address_0039 <= getPosition_address_local;
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
        if blockFinder_method = blockFinder_method_S_0002_body and blockFinder_method_delay = 0 then
          getPosition_address_local <= blockFinder_address_0042;
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
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
          binary_expr_00040 <= u_synthesijer_mul32_getPosition_result;
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
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
          binary_expr_00041 <= u_synthesijer_div32_getPosition_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_address_0042 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0001 then
          blockFinder_address_0042 <= blockFinder_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_address_local <= (others => '0');
      else
        if write_method = write_method_S_0002_body and write_method_delay = 0 then
          blockFinder_address_local <= write_address_0020;
        elsif read_method = read_method_S_0002_body and read_method_delay = 0 then
          blockFinder_address_local <= read_address_0025;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00044 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0002_wait then
          method_result_00044 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_dataPosition_0043 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0003 then
          blockFinder_dataPosition_0043 <= method_result_00044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00046 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0016 then
          array_access_00046 <= std_logic(class_data1_0014_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00048 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0005 then
          binary_expr_00048 <= tmp_0070;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00051 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0006 then
          cond_expr_00051 <= tmp_0071;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_currentData1_0045 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0007 then
          blockFinder_currentData1_0045 <= cond_expr_00051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00053 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0018 then
          array_access_00053 <= std_logic(class_data2_0017_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00055 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0009 then
          binary_expr_00055 <= tmp_0072;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00058 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0010 then
          cond_expr_00058 <= tmp_0073;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_currentData2_0052 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0011 then
          blockFinder_currentData2_0052 <= cond_expr_00058;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00059 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0012 then
          binary_expr_00059 <= tmp_0074;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_position_0060 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_position_0060 <= incrementEcc_position_local;
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
        if recoding_method = recoding_method_S_0027_body and recoding_method_delay = 0 then
          incrementEcc_position_local <= recoding_position_0087;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_ecc_0061 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_ecc_0061 <= incrementEcc_ecc_local;
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
        if recoding_method = recoding_method_S_0027_body and recoding_method_delay = 0 then
          incrementEcc_ecc_local <= binary_expr_00106;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_address_0082 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0001 then
          recoding_address_0082 <= recoding_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_address_local <= (others => '0');
      else
        if read_method = read_method_S_0011_body and read_method_delay = 0 then
          recoding_address_local <= read_address_0025;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_ecc_0083 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0001 then
          recoding_ecc_0083 <= recoding_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_ecc_local <= (others => '0');
      else
        if read_method = read_method_S_0011_body and read_method_delay = 0 then
          recoding_ecc_local <= read_ecc_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_pageSize_0084 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0001 then
          recoding_pageSize_0084 <= recoding_pageSize_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_pageSize_local <= (others => '0');
      else
        if read_method = read_method_S_0011_body and read_method_delay = 0 then
          recoding_pageSize_local <= class_pageSize_0006;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00086 <= '0';
      else
        if recoding_method = recoding_method_S_0002 then
          binary_expr_00086 <= tmp_0111;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00088 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0007 and recoding_method_delay >= 1 and u_synthesijer_div32_recoding_valid = '1' then
          binary_expr_00088 <= u_synthesijer_div32_recoding_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_position_0087 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0008 then
          recoding_position_0087 <= binary_expr_00088;
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
        if recoding_method = recoding_method_S_0009 and recoding_method_delay >= 1 and u_synthesijer_mul32_recoding_valid = '1' then
          binary_expr_00090 <= u_synthesijer_mul32_recoding_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_initialAddress_0089 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0010 then
          recoding_initialAddress_0089 <= binary_expr_00090;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_i_0091 <= X"00000000";
      else
        if recoding_method = recoding_method_S_0010 then
          recoding_i_0091 <= X"00000000";
        elsif recoding_method = recoding_method_S_0017 then
          recoding_i_0091 <= unary_expr_00094;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00093 <= '0';
      else
        if recoding_method = recoding_method_S_0012 then
          binary_expr_00093 <= tmp_0112;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_00094 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0015 then
          unary_expr_00094 <= tmp_0113;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_postfix_preserved_00095 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0015 then
          unary_expr_postfix_preserved_00095 <= recoding_i_0091;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00098 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0020_wait then
          method_result_00098 <= recodingRead_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00099 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0019 then
          binary_expr_00099 <= tmp_0114;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_read_0097 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0021 then
          recoding_read_0097 <= method_result_00098;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00101 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0021 then
          binary_expr_00101 <= tmp_0115;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00103 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0021 then
          binary_expr_00103 <= tmp_0116;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00106 <= (others => '0');
      else
        if recoding_method = recoding_method_S_0026 then
          binary_expr_00106 <= tmp_0117;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_address_0107 <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0001 then
          recodingWrite_address_0107 <= recodingWrite_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_address_local <= (others => '0');
      else
        if recoding_method = recoding_method_S_0024_body and recoding_method_delay = 0 then
          recodingWrite_address_local <= binary_expr_00101;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_data_0108 <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0001 then
          recodingWrite_data_0108 <= recodingWrite_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_data_local <= (others => '0');
      else
        if recoding_method = recoding_method_S_0024_body and recoding_method_delay = 0 then
          recodingWrite_data_local <= recoding_read_0097;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_ecc_0109 <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0001 then
          recodingWrite_ecc_0109 <= recodingWrite_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_ecc_local <= (others => '0');
      else
        if recoding_method = recoding_method_S_0024_body and recoding_method_delay = 0 then
          recodingWrite_ecc_local <= binary_expr_00103;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00111 <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0002_wait then
          method_result_00111 <= eccSelector_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_newData_0110 <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0003 then
          recodingWrite_newData_0110 <= method_result_00111;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_address_0118 <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0001 then
          recodingRead_address_0118 <= recodingRead_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_address_local <= (others => '0');
      else
        if recoding_method = recoding_method_S_0020_body and recoding_method_delay = 0 then
          recodingRead_address_local <= binary_expr_00099;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_ecc_0119 <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0001 then
          recodingRead_ecc_0119 <= recodingRead_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_ecc_local <= (others => '0');
      else
        if recoding_method = recoding_method_S_0020_body and recoding_method_delay = 0 then
          recodingRead_ecc_local <= recoding_ecc_0083;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00121 <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0002_wait then
          method_result_00121 <= SCHEDULER_READ_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_data_0120 <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0003 then
          recodingRead_data_0120 <= method_result_00121;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00122 <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0004_wait then
          method_result_00122 <= eccSelector_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_data_0123 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_data_0123 <= eccSelector_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_data_local <= (others => '0');
      else
        if write_method = write_method_S_0004_body and write_method_delay = 0 then
          eccSelector_data_local <= write_data_0021;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          eccSelector_data_local <= read_data_0026;
        elsif recodingWrite_method = recodingWrite_method_S_0002_body and recodingWrite_method_delay = 0 then
          eccSelector_data_local <= recodingWrite_data_0108;
        elsif recodingRead_method = recodingRead_method_S_0004_body and recodingRead_method_delay = 0 then
          eccSelector_data_local <= recodingRead_data_0120;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_ecc_0124 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_ecc_0124 <= eccSelector_ecc_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_ecc_local <= (others => '0');
      else
        if write_method = write_method_S_0004_body and write_method_delay = 0 then
          eccSelector_ecc_local <= write_ecc_0022;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          eccSelector_ecc_local <= read_ecc_0027;
        elsif recodingWrite_method = recodingWrite_method_S_0002_body and recodingWrite_method_delay = 0 then
          eccSelector_ecc_local <= recodingWrite_ecc_0109;
        elsif recodingRead_method = recodingRead_method_S_0004_body and recodingRead_method_delay = 0 then
          eccSelector_ecc_local <= recodingRead_ecc_0119;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_encoder_0125 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_encoder_0125 <= eccSelector_encoder_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_encoder_local <= (others => '0');
      else
        if write_method = write_method_S_0004_body and write_method_delay = 0 then
          eccSelector_encoder_local <= class_ENCODER_MODE_0007;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          eccSelector_encoder_local <= class_DECODER_MODE_0009;
        elsif recodingWrite_method = recodingWrite_method_S_0002_body and recodingWrite_method_delay = 0 then
          eccSelector_encoder_local <= class_ENCODER_MODE_0007;
        elsif recodingRead_method = recodingRead_method_S_0004_body and recodingRead_method_delay = 0 then
          eccSelector_encoder_local <= class_DECODER_MODE_0009;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00131 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0005 then
          binary_expr_00131 <= tmp_0193;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00132 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0006_wait then
          method_result_00132 <= ECC_ENCODE_REEDSOLOMON_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00133 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0007_wait then
          method_result_00133 <= ECC_DECODE_REEDSOLOMON_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00134 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0008 then
          cond_expr_00134 <= tmp_0194;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00136 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0011 then
          binary_expr_00136 <= tmp_0195;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00137 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0012_wait then
          method_result_00137 <= ECC_ENCODE_HAMMING_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00138 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0013_wait then
          method_result_00138 <= ECC_DECODE_HAMMING_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00139 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0014 then
          cond_expr_00139 <= tmp_0196;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00141 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0017 then
          binary_expr_00141 <= tmp_0197;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00142 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0018_wait then
          method_result_00142 <= ECC_ENCODE_PARITY_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00143 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0019_wait then
          method_result_00143 <= ECC_DECODE_PARITY_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00144 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0020 then
          cond_expr_00144 <= tmp_0198;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_address_0146 <= (others => '0');
      else
        if SCHEDULER_WRITE_method = SCHEDULER_WRITE_method_S_0001 then
          SCHEDULER_WRITE_address_0146 <= SCHEDULER_WRITE_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_address_local <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0007_body and recodingWrite_method_delay = 0 then
          SCHEDULER_WRITE_address_local <= recodingWrite_address_0107;
        elsif recodingWrite_method = recodingWrite_method_S_0010_body and recodingWrite_method_delay = 0 then
          SCHEDULER_WRITE_address_local <= recodingWrite_address_0107;
        elsif recodingWrite_method = recodingWrite_method_S_0013_body and recodingWrite_method_delay = 0 then
          SCHEDULER_WRITE_address_local <= recodingWrite_address_0107;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_data_0147 <= (others => '0');
      else
        if SCHEDULER_WRITE_method = SCHEDULER_WRITE_method_S_0001 then
          SCHEDULER_WRITE_data_0147 <= SCHEDULER_WRITE_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_data_local <= (others => '0');
      else
        if recodingWrite_method = recodingWrite_method_S_0007_body and recodingWrite_method_delay = 0 then
          SCHEDULER_WRITE_data_local <= recodingWrite_newData_0110;
        elsif recodingWrite_method = recodingWrite_method_S_0010_body and recodingWrite_method_delay = 0 then
          SCHEDULER_WRITE_data_local <= recodingWrite_newData_0110;
        elsif recodingWrite_method = recodingWrite_method_S_0013_body and recodingWrite_method_delay = 0 then
          SCHEDULER_WRITE_data_local <= recodingWrite_newData_0110;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_address_0148 <= (others => '0');
      else
        if SCHEDULER_READ_method = SCHEDULER_READ_method_S_0001 then
          SCHEDULER_READ_address_0148 <= SCHEDULER_READ_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_address_local <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0002_body and recodingRead_method_delay = 0 then
          SCHEDULER_READ_address_local <= recodingRead_address_0118;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_data_0150 <= (others => '0');
      else
        if ECC_DECODE_REEDSOLOMON_method = ECC_DECODE_REEDSOLOMON_method_S_0001 then
          ECC_DECODE_REEDSOLOMON_data_0150 <= ECC_DECODE_REEDSOLOMON_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_data_local <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0007_body and eccSelector_method_delay = 0 then
          ECC_DECODE_REEDSOLOMON_data_local <= eccSelector_data_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_data_0152 <= (others => '0');
      else
        if ECC_DECODE_HAMMING_method = ECC_DECODE_HAMMING_method_S_0001 then
          ECC_DECODE_HAMMING_data_0152 <= ECC_DECODE_HAMMING_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_data_local <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0013_body and eccSelector_method_delay = 0 then
          ECC_DECODE_HAMMING_data_local <= eccSelector_data_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_data_0154 <= (others => '0');
      else
        if ECC_DECODE_PARITY_method = ECC_DECODE_PARITY_method_S_0001 then
          ECC_DECODE_PARITY_data_0154 <= ECC_DECODE_PARITY_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_data_local <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0019_body and eccSelector_method_delay = 0 then
          ECC_DECODE_PARITY_data_local <= eccSelector_data_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_data_0156 <= (others => '0');
      else
        if ECC_ENCODE_REEDSOLOMON_method = ECC_ENCODE_REEDSOLOMON_method_S_0001 then
          ECC_ENCODE_REEDSOLOMON_data_0156 <= ECC_ENCODE_REEDSOLOMON_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_data_local <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0006_body and eccSelector_method_delay = 0 then
          ECC_ENCODE_REEDSOLOMON_data_local <= eccSelector_data_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_data_0158 <= (others => '0');
      else
        if ECC_ENCODE_HAMMING_method = ECC_ENCODE_HAMMING_method_S_0001 then
          ECC_ENCODE_HAMMING_data_0158 <= ECC_ENCODE_HAMMING_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_data_local <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0012_body and eccSelector_method_delay = 0 then
          ECC_ENCODE_HAMMING_data_local <= eccSelector_data_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_data_0160 <= (others => '0');
      else
        if ECC_ENCODE_PARITY_method = ECC_ENCODE_PARITY_method_S_0001 then
          ECC_ENCODE_PARITY_data_0160 <= ECC_ENCODE_PARITY_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_data_local <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0018_body and eccSelector_method_delay = 0 then
          ECC_ENCODE_PARITY_data_local <= eccSelector_data_0123;
        end if;
      end if;
    end if;
  end process;

  write_req_flag <= tmp_0001;

  read_req_flag <= tmp_0002;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_return <= '0';
      else
        if eccEvaluator_method = eccEvaluator_method_S_0003 then
          eccEvaluator_return <= binary_expr_00038;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_busy <= '0';
      else
        if eccEvaluator_method = eccEvaluator_method_S_0000 then
          eccEvaluator_busy <= '0';
        elsif eccEvaluator_method = eccEvaluator_method_S_0001 then
          eccEvaluator_busy <= tmp_0044;
        end if;
      end if;
    end if;
  end process;

  eccEvaluator_req_flag <= eccEvaluator_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccEvaluator_req_local <= '0';
      else
        if read_method = read_method_S_0006_body then
          eccEvaluator_req_local <= '1';
        else
          eccEvaluator_req_local <= '0';
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
          getPosition_return <= binary_expr_00041;
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
          getPosition_busy <= tmp_0053;
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
        if blockFinder_method = blockFinder_method_S_0002_body then
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
        blockFinder_return <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0013 then
          blockFinder_return <= binary_expr_00059;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_busy <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0000 then
          blockFinder_busy <= '0';
        elsif blockFinder_method = blockFinder_method_S_0001 then
          blockFinder_busy <= tmp_0061;
        end if;
      end if;
    end if;
  end process;

  blockFinder_req_flag <= blockFinder_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_req_local <= '0';
      else
        if write_method = write_method_S_0002_body then
          blockFinder_req_local <= '1';
        elsif read_method = read_method_S_0002_body then
          blockFinder_req_local <= '1';
        else
          blockFinder_req_local <= '0';
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
          incrementEcc_busy <= tmp_0078;
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
        if recoding_method = recoding_method_S_0027_body then
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
        recoding_busy <= '0';
      else
        if recoding_method = recoding_method_S_0000 then
          recoding_busy <= '0';
        elsif recoding_method = recoding_method_S_0001 then
          recoding_busy <= tmp_0090;
        end if;
      end if;
    end if;
  end process;

  recoding_req_flag <= recoding_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recoding_req_local <= '0';
      else
        if read_method = read_method_S_0011_body then
          recoding_req_local <= '1';
        else
          recoding_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_busy <= '0';
      else
        if recodingWrite_method = recodingWrite_method_S_0000 then
          recodingWrite_busy <= '0';
        elsif recodingWrite_method = recodingWrite_method_S_0001 then
          recodingWrite_busy <= tmp_0121;
        end if;
      end if;
    end if;
  end process;

  recodingWrite_req_flag <= recodingWrite_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingWrite_req_local <= '0';
      else
        if recoding_method = recoding_method_S_0024_body then
          recodingWrite_req_local <= '1';
        else
          recodingWrite_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_return <= (others => '0');
      else
        if recodingRead_method = recodingRead_method_S_0005 then
          recodingRead_return <= method_result_00122;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_busy <= '0';
      else
        if recodingRead_method = recodingRead_method_S_0000 then
          recodingRead_busy <= '0';
        elsif recodingRead_method = recodingRead_method_S_0001 then
          recodingRead_busy <= tmp_0148;
        end if;
      end if;
    end if;
  end process;

  recodingRead_req_flag <= recodingRead_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        recodingRead_req_local <= '0';
      else
        if recoding_method = recoding_method_S_0020_body then
          recodingRead_req_local <= '1';
        else
          recodingRead_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_return <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0009 then
          eccSelector_return <= cond_expr_00134;
        elsif eccSelector_method = eccSelector_method_S_0015 then
          eccSelector_return <= cond_expr_00139;
        elsif eccSelector_method = eccSelector_method_S_0021 then
          eccSelector_return <= cond_expr_00144;
        elsif eccSelector_method = eccSelector_method_S_0023 then
          eccSelector_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_busy <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0000 then
          eccSelector_busy <= '0';
        elsif eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_busy <= tmp_0160;
        end if;
      end if;
    end if;
  end process;

  eccSelector_req_flag <= eccSelector_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_req_local <= '0';
      else
        if write_method = write_method_S_0004_body then
          eccSelector_req_local <= '1';
        elsif read_method = read_method_S_0004_body then
          eccSelector_req_local <= '1';
        elsif recodingWrite_method = recodingWrite_method_S_0002_body then
          eccSelector_req_local <= '1';
        elsif recodingRead_method = recodingRead_method_S_0004_body then
          eccSelector_req_local <= '1';
        else
          eccSelector_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_busy <= '0';
      else
        if SCHEDULER_WRITE_method = SCHEDULER_WRITE_method_S_0000 then
          SCHEDULER_WRITE_busy <= '0';
        elsif SCHEDULER_WRITE_method = SCHEDULER_WRITE_method_S_0001 then
          SCHEDULER_WRITE_busy <= tmp_0202;
        end if;
      end if;
    end if;
  end process;

  SCHEDULER_WRITE_req_flag <= SCHEDULER_WRITE_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_req_local <= '0';
      else
        if recodingWrite_method = recodingWrite_method_S_0007_body then
          SCHEDULER_WRITE_req_local <= '1';
        elsif recodingWrite_method = recodingWrite_method_S_0010_body then
          SCHEDULER_WRITE_req_local <= '1';
        elsif recodingWrite_method = recodingWrite_method_S_0013_body then
          SCHEDULER_WRITE_req_local <= '1';
        else
          SCHEDULER_WRITE_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_return <= (others => '0');
      else
        if SCHEDULER_READ_method = SCHEDULER_READ_method_S_0002 then
          SCHEDULER_READ_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_busy <= '0';
      else
        if SCHEDULER_READ_method = SCHEDULER_READ_method_S_0000 then
          SCHEDULER_READ_busy <= '0';
        elsif SCHEDULER_READ_method = SCHEDULER_READ_method_S_0001 then
          SCHEDULER_READ_busy <= tmp_0210;
        end if;
      end if;
    end if;
  end process;

  SCHEDULER_READ_req_flag <= SCHEDULER_READ_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_req_local <= '0';
      else
        if recodingRead_method = recodingRead_method_S_0002_body then
          SCHEDULER_READ_req_local <= '1';
        else
          SCHEDULER_READ_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_return <= (others => '0');
      else
        if ECC_DECODE_REEDSOLOMON_method = ECC_DECODE_REEDSOLOMON_method_S_0002 then
          ECC_DECODE_REEDSOLOMON_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_busy <= '0';
      else
        if ECC_DECODE_REEDSOLOMON_method = ECC_DECODE_REEDSOLOMON_method_S_0000 then
          ECC_DECODE_REEDSOLOMON_busy <= '0';
        elsif ECC_DECODE_REEDSOLOMON_method = ECC_DECODE_REEDSOLOMON_method_S_0001 then
          ECC_DECODE_REEDSOLOMON_busy <= tmp_0218;
        end if;
      end if;
    end if;
  end process;

  ECC_DECODE_REEDSOLOMON_req_flag <= ECC_DECODE_REEDSOLOMON_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_req_local <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0007_body then
          ECC_DECODE_REEDSOLOMON_req_local <= '1';
        else
          ECC_DECODE_REEDSOLOMON_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_return <= (others => '0');
      else
        if ECC_DECODE_HAMMING_method = ECC_DECODE_HAMMING_method_S_0002 then
          ECC_DECODE_HAMMING_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_busy <= '0';
      else
        if ECC_DECODE_HAMMING_method = ECC_DECODE_HAMMING_method_S_0000 then
          ECC_DECODE_HAMMING_busy <= '0';
        elsif ECC_DECODE_HAMMING_method = ECC_DECODE_HAMMING_method_S_0001 then
          ECC_DECODE_HAMMING_busy <= tmp_0226;
        end if;
      end if;
    end if;
  end process;

  ECC_DECODE_HAMMING_req_flag <= ECC_DECODE_HAMMING_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_req_local <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0013_body then
          ECC_DECODE_HAMMING_req_local <= '1';
        else
          ECC_DECODE_HAMMING_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_return <= (others => '0');
      else
        if ECC_DECODE_PARITY_method = ECC_DECODE_PARITY_method_S_0002 then
          ECC_DECODE_PARITY_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_busy <= '0';
      else
        if ECC_DECODE_PARITY_method = ECC_DECODE_PARITY_method_S_0000 then
          ECC_DECODE_PARITY_busy <= '0';
        elsif ECC_DECODE_PARITY_method = ECC_DECODE_PARITY_method_S_0001 then
          ECC_DECODE_PARITY_busy <= tmp_0234;
        end if;
      end if;
    end if;
  end process;

  ECC_DECODE_PARITY_req_flag <= ECC_DECODE_PARITY_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_req_local <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0019_body then
          ECC_DECODE_PARITY_req_local <= '1';
        else
          ECC_DECODE_PARITY_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_return <= (others => '0');
      else
        if ECC_ENCODE_REEDSOLOMON_method = ECC_ENCODE_REEDSOLOMON_method_S_0002 then
          ECC_ENCODE_REEDSOLOMON_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_busy <= '0';
      else
        if ECC_ENCODE_REEDSOLOMON_method = ECC_ENCODE_REEDSOLOMON_method_S_0000 then
          ECC_ENCODE_REEDSOLOMON_busy <= '0';
        elsif ECC_ENCODE_REEDSOLOMON_method = ECC_ENCODE_REEDSOLOMON_method_S_0001 then
          ECC_ENCODE_REEDSOLOMON_busy <= tmp_0242;
        end if;
      end if;
    end if;
  end process;

  ECC_ENCODE_REEDSOLOMON_req_flag <= ECC_ENCODE_REEDSOLOMON_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_req_local <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0006_body then
          ECC_ENCODE_REEDSOLOMON_req_local <= '1';
        else
          ECC_ENCODE_REEDSOLOMON_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_return <= (others => '0');
      else
        if ECC_ENCODE_HAMMING_method = ECC_ENCODE_HAMMING_method_S_0002 then
          ECC_ENCODE_HAMMING_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_busy <= '0';
      else
        if ECC_ENCODE_HAMMING_method = ECC_ENCODE_HAMMING_method_S_0000 then
          ECC_ENCODE_HAMMING_busy <= '0';
        elsif ECC_ENCODE_HAMMING_method = ECC_ENCODE_HAMMING_method_S_0001 then
          ECC_ENCODE_HAMMING_busy <= tmp_0250;
        end if;
      end if;
    end if;
  end process;

  ECC_ENCODE_HAMMING_req_flag <= ECC_ENCODE_HAMMING_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_req_local <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0012_body then
          ECC_ENCODE_HAMMING_req_local <= '1';
        else
          ECC_ENCODE_HAMMING_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_return <= (others => '0');
      else
        if ECC_ENCODE_PARITY_method = ECC_ENCODE_PARITY_method_S_0002 then
          ECC_ENCODE_PARITY_return <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_busy <= '0';
      else
        if ECC_ENCODE_PARITY_method = ECC_ENCODE_PARITY_method_S_0000 then
          ECC_ENCODE_PARITY_busy <= '0';
        elsif ECC_ENCODE_PARITY_method = ECC_ENCODE_PARITY_method_S_0001 then
          ECC_ENCODE_PARITY_busy <= tmp_0258;
        end if;
      end if;
    end if;
  end process;

  ECC_ENCODE_PARITY_req_flag <= ECC_ENCODE_PARITY_req_local;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_req_local <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0018_body then
          ECC_ENCODE_PARITY_req_local <= '1';
        else
          ECC_ENCODE_PARITY_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  write_req_flag_edge <= tmp_0004;

  blockFinder_call_flag_0002 <= tmp_0010;

  eccSelector_call_flag_0004 <= tmp_0014;

  read_req_flag_edge <= tmp_0022;

  eccEvaluator_call_flag_0006 <= tmp_0028;

  recoding_call_flag_0011 <= tmp_0034;

  eccEvaluator_req_flag_edge <= tmp_0042;

  getPosition_req_flag_edge <= tmp_0051;

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
          u_synthesijer_div32_getPosition_a <= getPosition_address_0039;
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
          u_synthesijer_div32_getPosition_b <= binary_expr_00040;
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

  blockFinder_req_flag_edge <= tmp_0059;

  getPosition_call_flag_0002 <= tmp_0065;

  incrementEcc_req_flag_edge <= tmp_0076;

  recoding_req_flag_edge <= tmp_0088;

  u_synthesijer_div32_recoding_clk <= clk_sig;

  u_synthesijer_div32_recoding_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_recoding_a <= (others => '0');
      else
        if recoding_method = recoding_method_S_0007 and recoding_method_delay = 0 then
          u_synthesijer_div32_recoding_a <= recoding_address_0082;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_recoding_b <= X"00000001";
      else
        if recoding_method = recoding_method_S_0007 and recoding_method_delay = 0 then
          u_synthesijer_div32_recoding_b <= recoding_pageSize_0084;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_div32_recoding_nd <= '0';
      else
        if recoding_method = recoding_method_S_0007 and recoding_method_delay = 0 then
          u_synthesijer_div32_recoding_nd <= '1';
        else
          u_synthesijer_div32_recoding_nd <= '0';
        end if;
      end if;
    end if;
  end process;

  u_synthesijer_mul32_recoding_clk <= clk_sig;

  u_synthesijer_mul32_recoding_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_mul32_recoding_a <= (others => '0');
      else
        if recoding_method = recoding_method_S_0009 and recoding_method_delay = 0 then
          u_synthesijer_mul32_recoding_a <= recoding_position_0087;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        u_synthesijer_mul32_recoding_b <= (others => '0');
      else
        if recoding_method = recoding_method_S_0009 and recoding_method_delay = 0 then
          u_synthesijer_mul32_recoding_b <= recoding_pageSize_0084;
        end if;
      end if;
    end if;
  end process;

  recodingRead_call_flag_0020 <= tmp_0098;

  recodingWrite_call_flag_0024 <= tmp_0102;

  incrementEcc_call_flag_0027 <= tmp_0106;

  recodingWrite_req_flag_edge <= tmp_0119;

  eccSelector_call_flag_0002 <= tmp_0125;

  SCHEDULER_WRITE_call_flag_0007 <= tmp_0132;

  SCHEDULER_WRITE_call_flag_0010 <= tmp_0136;

  SCHEDULER_WRITE_call_flag_0013 <= tmp_0140;

  recodingRead_req_flag_edge <= tmp_0146;

  SCHEDULER_READ_call_flag_0002 <= tmp_0152;

  eccSelector_req_flag_edge <= tmp_0158;

  ECC_ENCODE_REEDSOLOMON_call_flag_0006 <= tmp_0168;

  ECC_DECODE_REEDSOLOMON_call_flag_0007 <= tmp_0172;

  ECC_ENCODE_HAMMING_call_flag_0012 <= tmp_0176;

  ECC_DECODE_HAMMING_call_flag_0013 <= tmp_0180;

  ECC_ENCODE_PARITY_call_flag_0018 <= tmp_0184;

  ECC_DECODE_PARITY_call_flag_0019 <= tmp_0188;

  SCHEDULER_WRITE_req_flag_edge <= tmp_0200;

  SCHEDULER_READ_req_flag_edge <= tmp_0208;

  ECC_DECODE_REEDSOLOMON_req_flag_edge <= tmp_0216;

  ECC_DECODE_HAMMING_req_flag_edge <= tmp_0224;

  ECC_DECODE_PARITY_req_flag_edge <= tmp_0232;

  ECC_ENCODE_REEDSOLOMON_req_flag_edge <= tmp_0240;

  ECC_ENCODE_HAMMING_req_flag_edge <= tmp_0248;

  ECC_ENCODE_PARITY_req_flag_edge <= tmp_0256;


  inst_class_data0_0011 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data0_0011_length,
    address_b => class_data0_0011_address_b,
    din_b => class_data0_0011_din_b,
    dout_b => class_data0_0011_dout_b,
    we_b => class_data0_0011_we_b,
    oe_b => class_data0_0011_oe_b
  );

  inst_class_data1_0014 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data1_0014_length,
    address_b => class_data1_0014_address_b,
    din_b => class_data1_0014_din_b,
    dout_b => class_data1_0014_dout_b,
    we_b => class_data1_0014_we_b,
    oe_b => class_data1_0014_oe_b
  );

  inst_class_data2_0017 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_data2_0017_length,
    address_b => class_data2_0017_address_b,
    din_b => class_data2_0017_din_b,
    dout_b => class_data2_0017_dout_b,
    we_b => class_data2_0017_we_b,
    oe_b => class_data2_0017_oe_b
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

  inst_u_synthesijer_div32_recoding : synthesijer_div32
  port map(
    clk => clk,
    reset => reset,
    a => u_synthesijer_div32_recoding_a,
    b => u_synthesijer_div32_recoding_b,
    nd => u_synthesijer_div32_recoding_nd,
    quantient => u_synthesijer_div32_recoding_quantient,
    remainder => u_synthesijer_div32_recoding_remainder,
    valid => u_synthesijer_div32_recoding_valid
  );

  inst_u_synthesijer_mul32_recoding : synthesijer_mul32
  port map(
    clk => clk,
    reset => reset,
    a => u_synthesijer_mul32_recoding_a,
    b => u_synthesijer_mul32_recoding_b,
    nd => u_synthesijer_mul32_recoding_nd,
    result => u_synthesijer_mul32_recoding_result,
    valid => u_synthesijer_mul32_recoding_valid
  );


end RTL;
