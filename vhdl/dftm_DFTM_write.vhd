library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dftm_DFTM_write is
  port (
    clk : in std_logic;
    reset : in std_logic;
    write_address : in signed(32-1 downto 0);
    write_data : in signed(32-1 downto 0);
    write_return : out signed(32-1 downto 0);
    write_busy : out std_logic;
    write_req : in std_logic
  );
end dftm_DFTM_write;

architecture RTL of dftm_DFTM_write is

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
  signal write_return_sig : signed(32-1 downto 0) := (others => '0');
  signal write_busy_sig : std_logic := '1';
  signal write_req_sig : std_logic := '0';

  signal class_DEFAULT_PAGE_SIZE_0000 : signed(32-1 downto 0) := X"00007d00";
  signal class_DEFAULT_MEMORY_SIZE_PER_BLOCK_0002 : signed(32-1 downto 0) := X"0003e800";
  signal class_BYTE_SIZE_0004 : signed(32-1 downto 0) := X"00000008";
  signal class_pageSize_0006 : signed(32-1 downto 0) := (others => '0');
  signal class_ENCODER_MODE_0007 : signed(32-1 downto 0) := X"00000001";
  signal class_DECODER_MODE_0009 : signed(32-1 downto 0) := X"00000000";
  signal class_memory0_0011_clk : std_logic := '0';
  signal class_memory0_0011_reset : std_logic := '0';
  signal class_memory0_0011_length : signed(32-1 downto 0) := (others => '0');
  signal class_memory0_0011_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_memory0_0011_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_memory0_0011_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_memory0_0011_we_b : std_logic := '0';
  signal class_memory0_0011_oe_b : std_logic := '0';
  signal class_memory1_0014_clk : std_logic := '0';
  signal class_memory1_0014_reset : std_logic := '0';
  signal class_memory1_0014_length : signed(32-1 downto 0) := (others => '0');
  signal class_memory1_0014_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_memory1_0014_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_memory1_0014_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_memory1_0014_we_b : std_logic := '0';
  signal class_memory1_0014_oe_b : std_logic := '0';
  signal class_memory2_0017_clk : std_logic := '0';
  signal class_memory2_0017_reset : std_logic := '0';
  signal class_memory2_0017_length : signed(32-1 downto 0) := (others => '0');
  signal class_memory2_0017_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_memory2_0017_din_b : signed(1-1 downto 0) := (others => '0');
  signal class_memory2_0017_dout_b : signed(1-1 downto 0) := (others => '0');
  signal class_memory2_0017_we_b : std_logic := '0';
  signal class_memory2_0017_oe_b : std_logic := '0';
  signal write_address_0020 : signed(32-1 downto 0) := (others => '0');
  signal write_address_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_0021 : signed(32-1 downto 0) := (others => '0');
  signal write_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00023 : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_0022 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00024 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_0025 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00026 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00027 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_address_0028 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00030 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_dataPosition_0029 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00032 : std_logic := '0';
  signal binary_expr_00034 : std_logic := '0';
  signal cond_expr_00037 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_currentData1_0031 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00039 : std_logic := '0';
  signal binary_expr_00041 : std_logic := '0';
  signal cond_expr_00044 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_currentData2_0038 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00045 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_data_0046 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_data_local : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_ecc_0047 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_encoder_0048 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_encoder_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00054 : std_logic := '0';
  signal method_result_00055 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00056 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00057 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00059 : std_logic := '0';
  signal method_result_00060 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00061 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00062 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00064 : std_logic := '0';
  signal method_result_00065 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00066 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00067 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_address_0069 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_address_local : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_data_0070 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_WRITE_data_local : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_READ_address_0071 : signed(32-1 downto 0) := (others => '0');
  signal SCHEDULER_READ_address_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_data_0073 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_data_0075 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_data_0077 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_data_0079 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_data_0081 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_data_0083 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_req_flag : std_logic := '0';
  signal write_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal getPosition_return : signed(32-1 downto 0) := (others => '0');
  signal getPosition_busy : std_logic := '0';
  signal getPosition_req_flag : std_logic := '0';
  signal getPosition_req_local : std_logic := '0';
  signal blockFinder_return : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_busy : std_logic := '0';
  signal blockFinder_req_flag : std_logic := '0';
  signal blockFinder_req_local : std_logic := '0';
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
  signal tmp_0002 : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal blockFinder_call_flag_0002 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal eccSelector_call_flag_0004 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0019 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0020 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
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
  signal tmp_0024 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : std_logic := '0';
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
  signal tmp_0028 : std_logic := '0';
  signal tmp_0029 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal getPosition_call_flag_0002 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal tmp_0041 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0044 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_call_flag_0006 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_call_flag_0007 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal ECC_ENCODE_HAMMING_call_flag_0012 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal ECC_DECODE_HAMMING_call_flag_0013 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal ECC_ENCODE_PARITY_call_flag_0018 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal ECC_DECODE_PARITY_call_flag_0019 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal tmp_0082 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0085 : std_logic := '0';
  signal tmp_0086 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
  signal tmp_0094 : std_logic := '0';
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
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
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
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
  signal tmp_0106 : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
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
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : std_logic := '0';
  signal tmp_0113 : std_logic := '0';
  signal tmp_0114 : std_logic := '0';
  signal tmp_0115 : std_logic := '0';
  signal tmp_0116 : std_logic := '0';
  signal tmp_0117 : std_logic := '0';
  signal tmp_0118 : std_logic := '0';
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
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
  signal tmp_0122 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
  signal tmp_0126 : std_logic := '0';
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
  signal tmp_0127 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
  signal tmp_0130 : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
  signal tmp_0134 : std_logic := '0';
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
  signal tmp_0135 : std_logic := '0';
  signal tmp_0136 : std_logic := '0';
  signal tmp_0137 : std_logic := '0';
  signal tmp_0138 : std_logic := '0';
  signal tmp_0139 : std_logic := '0';
  signal tmp_0140 : std_logic := '0';
  signal tmp_0141 : std_logic := '0';
  signal tmp_0142 : std_logic := '0';
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
  signal tmp_0143 : std_logic := '0';
  signal tmp_0144 : std_logic := '0';
  signal tmp_0145 : std_logic := '0';
  signal tmp_0146 : std_logic := '0';
  signal tmp_0147 : std_logic := '0';
  signal tmp_0148 : std_logic := '0';
  signal tmp_0149 : std_logic := '0';
  signal tmp_0150 : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;
  write_address_sig <= write_address;
  write_data_sig <= write_data;
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
          write_busy_sig <= tmp_0005;
        end if;
      end if;
    end if;
  end process;

  write_req_sig <= write_req;

  -- expressions
  tmp_0001 <= write_req_local or write_req_sig;
  tmp_0002 <= not write_req_flag_d;
  tmp_0003 <= write_req_flag and tmp_0002;
  tmp_0004 <= write_req_flag or write_req_flag_d;
  tmp_0005 <= write_req_flag or write_req_flag_d;
  tmp_0006 <= '1' when blockFinder_busy = '0' else '0';
  tmp_0007 <= '1' when blockFinder_req_local = '0' else '0';
  tmp_0008 <= tmp_0006 and tmp_0007;
  tmp_0009 <= '1' when tmp_0008 = '1' else '0';
  tmp_0010 <= '1' when eccSelector_busy = '0' else '0';
  tmp_0011 <= '1' when eccSelector_req_local = '0' else '0';
  tmp_0012 <= tmp_0010 and tmp_0011;
  tmp_0013 <= '1' when tmp_0012 = '1' else '0';
  tmp_0014 <= '1' when write_method /= write_method_S_0000 else '0';
  tmp_0015 <= '1' when write_method /= write_method_S_0001 else '0';
  tmp_0016 <= tmp_0015 and write_req_flag_edge;
  tmp_0017 <= tmp_0014 and tmp_0016;
  tmp_0018 <= write_address_sig when write_req_sig = '1' else write_address_local;
  tmp_0019 <= write_data_sig when write_req_sig = '1' else write_data_local;
  tmp_0020 <= not getPosition_req_flag_d;
  tmp_0021 <= getPosition_req_flag and tmp_0020;
  tmp_0022 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0023 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0024 <= '1' when getPosition_method /= getPosition_method_S_0000 else '0';
  tmp_0025 <= '1' when getPosition_method /= getPosition_method_S_0001 else '0';
  tmp_0026 <= tmp_0025 and getPosition_req_flag_edge;
  tmp_0027 <= tmp_0024 and tmp_0026;
  tmp_0028 <= not blockFinder_req_flag_d;
  tmp_0029 <= blockFinder_req_flag and tmp_0028;
  tmp_0030 <= blockFinder_req_flag or blockFinder_req_flag_d;
  tmp_0031 <= blockFinder_req_flag or blockFinder_req_flag_d;
  tmp_0032 <= '1' when getPosition_busy = '0' else '0';
  tmp_0033 <= '1' when getPosition_req_local = '0' else '0';
  tmp_0034 <= tmp_0032 and tmp_0033;
  tmp_0035 <= '1' when tmp_0034 = '1' else '0';
  tmp_0036 <= '1' when blockFinder_method /= blockFinder_method_S_0000 else '0';
  tmp_0037 <= '1' when blockFinder_method /= blockFinder_method_S_0001 else '0';
  tmp_0038 <= tmp_0037 and blockFinder_req_flag_edge;
  tmp_0039 <= tmp_0036 and tmp_0038;
  tmp_0040 <= '1' when array_access_00032 = '1' else '0';
  tmp_0041 <= X"00000001" when binary_expr_00034 = '1' else X"00000000";
  tmp_0042 <= '1' when array_access_00039 = '1' else '0';
  tmp_0043 <= X"00000002" when binary_expr_00041 = '1' else X"00000000";
  tmp_0044 <= blockFinder_currentData1_0031 + blockFinder_currentData2_0038;
  tmp_0045 <= not eccSelector_req_flag_d;
  tmp_0046 <= eccSelector_req_flag and tmp_0045;
  tmp_0047 <= eccSelector_req_flag or eccSelector_req_flag_d;
  tmp_0048 <= eccSelector_req_flag or eccSelector_req_flag_d;
  tmp_0049 <= '1' when eccSelector_ecc_0047 = X"00000000" else '0';
  tmp_0050 <= '1' when eccSelector_ecc_0047 = X"00000001" else '0';
  tmp_0051 <= '1' when eccSelector_ecc_0047 = X"00000002" else '0';
  tmp_0052 <= '1' when eccSelector_ecc_0047 = X"00000003" else '0';
  tmp_0053 <= '1' when ECC_ENCODE_REEDSOLOMON_busy = '0' else '0';
  tmp_0054 <= '1' when ECC_ENCODE_REEDSOLOMON_req_local = '0' else '0';
  tmp_0055 <= tmp_0053 and tmp_0054;
  tmp_0056 <= '1' when tmp_0055 = '1' else '0';
  tmp_0057 <= '1' when ECC_DECODE_REEDSOLOMON_busy = '0' else '0';
  tmp_0058 <= '1' when ECC_DECODE_REEDSOLOMON_req_local = '0' else '0';
  tmp_0059 <= tmp_0057 and tmp_0058;
  tmp_0060 <= '1' when tmp_0059 = '1' else '0';
  tmp_0061 <= '1' when ECC_ENCODE_HAMMING_busy = '0' else '0';
  tmp_0062 <= '1' when ECC_ENCODE_HAMMING_req_local = '0' else '0';
  tmp_0063 <= tmp_0061 and tmp_0062;
  tmp_0064 <= '1' when tmp_0063 = '1' else '0';
  tmp_0065 <= '1' when ECC_DECODE_HAMMING_busy = '0' else '0';
  tmp_0066 <= '1' when ECC_DECODE_HAMMING_req_local = '0' else '0';
  tmp_0067 <= tmp_0065 and tmp_0066;
  tmp_0068 <= '1' when tmp_0067 = '1' else '0';
  tmp_0069 <= '1' when ECC_ENCODE_PARITY_busy = '0' else '0';
  tmp_0070 <= '1' when ECC_ENCODE_PARITY_req_local = '0' else '0';
  tmp_0071 <= tmp_0069 and tmp_0070;
  tmp_0072 <= '1' when tmp_0071 = '1' else '0';
  tmp_0073 <= '1' when ECC_DECODE_PARITY_busy = '0' else '0';
  tmp_0074 <= '1' when ECC_DECODE_PARITY_req_local = '0' else '0';
  tmp_0075 <= tmp_0073 and tmp_0074;
  tmp_0076 <= '1' when tmp_0075 = '1' else '0';
  tmp_0077 <= '1' when eccSelector_method /= eccSelector_method_S_0000 else '0';
  tmp_0078 <= '1' when eccSelector_method /= eccSelector_method_S_0001 else '0';
  tmp_0079 <= tmp_0078 and eccSelector_req_flag_edge;
  tmp_0080 <= tmp_0077 and tmp_0079;
  tmp_0081 <= '1' when eccSelector_encoder_0048 = X"00000001" else '0';
  tmp_0082 <= method_result_00055 when binary_expr_00054 = '1' else method_result_00056;
  tmp_0083 <= '1' when eccSelector_encoder_0048 = X"00000001" else '0';
  tmp_0084 <= method_result_00060 when binary_expr_00059 = '1' else method_result_00061;
  tmp_0085 <= '1' when eccSelector_encoder_0048 = X"00000001" else '0';
  tmp_0086 <= method_result_00065 when binary_expr_00064 = '1' else method_result_00066;
  tmp_0087 <= not SCHEDULER_WRITE_req_flag_d;
  tmp_0088 <= SCHEDULER_WRITE_req_flag and tmp_0087;
  tmp_0089 <= SCHEDULER_WRITE_req_flag or SCHEDULER_WRITE_req_flag_d;
  tmp_0090 <= SCHEDULER_WRITE_req_flag or SCHEDULER_WRITE_req_flag_d;
  tmp_0091 <= '1' when SCHEDULER_WRITE_method /= SCHEDULER_WRITE_method_S_0000 else '0';
  tmp_0092 <= '1' when SCHEDULER_WRITE_method /= SCHEDULER_WRITE_method_S_0001 else '0';
  tmp_0093 <= tmp_0092 and SCHEDULER_WRITE_req_flag_edge;
  tmp_0094 <= tmp_0091 and tmp_0093;
  tmp_0095 <= not SCHEDULER_READ_req_flag_d;
  tmp_0096 <= SCHEDULER_READ_req_flag and tmp_0095;
  tmp_0097 <= SCHEDULER_READ_req_flag or SCHEDULER_READ_req_flag_d;
  tmp_0098 <= SCHEDULER_READ_req_flag or SCHEDULER_READ_req_flag_d;
  tmp_0099 <= '1' when SCHEDULER_READ_method /= SCHEDULER_READ_method_S_0000 else '0';
  tmp_0100 <= '1' when SCHEDULER_READ_method /= SCHEDULER_READ_method_S_0001 else '0';
  tmp_0101 <= tmp_0100 and SCHEDULER_READ_req_flag_edge;
  tmp_0102 <= tmp_0099 and tmp_0101;
  tmp_0103 <= not ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0104 <= ECC_DECODE_REEDSOLOMON_req_flag and tmp_0103;
  tmp_0105 <= ECC_DECODE_REEDSOLOMON_req_flag or ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0106 <= ECC_DECODE_REEDSOLOMON_req_flag or ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0107 <= '1' when ECC_DECODE_REEDSOLOMON_method /= ECC_DECODE_REEDSOLOMON_method_S_0000 else '0';
  tmp_0108 <= '1' when ECC_DECODE_REEDSOLOMON_method /= ECC_DECODE_REEDSOLOMON_method_S_0001 else '0';
  tmp_0109 <= tmp_0108 and ECC_DECODE_REEDSOLOMON_req_flag_edge;
  tmp_0110 <= tmp_0107 and tmp_0109;
  tmp_0111 <= not ECC_DECODE_HAMMING_req_flag_d;
  tmp_0112 <= ECC_DECODE_HAMMING_req_flag and tmp_0111;
  tmp_0113 <= ECC_DECODE_HAMMING_req_flag or ECC_DECODE_HAMMING_req_flag_d;
  tmp_0114 <= ECC_DECODE_HAMMING_req_flag or ECC_DECODE_HAMMING_req_flag_d;
  tmp_0115 <= '1' when ECC_DECODE_HAMMING_method /= ECC_DECODE_HAMMING_method_S_0000 else '0';
  tmp_0116 <= '1' when ECC_DECODE_HAMMING_method /= ECC_DECODE_HAMMING_method_S_0001 else '0';
  tmp_0117 <= tmp_0116 and ECC_DECODE_HAMMING_req_flag_edge;
  tmp_0118 <= tmp_0115 and tmp_0117;
  tmp_0119 <= not ECC_DECODE_PARITY_req_flag_d;
  tmp_0120 <= ECC_DECODE_PARITY_req_flag and tmp_0119;
  tmp_0121 <= ECC_DECODE_PARITY_req_flag or ECC_DECODE_PARITY_req_flag_d;
  tmp_0122 <= ECC_DECODE_PARITY_req_flag or ECC_DECODE_PARITY_req_flag_d;
  tmp_0123 <= '1' when ECC_DECODE_PARITY_method /= ECC_DECODE_PARITY_method_S_0000 else '0';
  tmp_0124 <= '1' when ECC_DECODE_PARITY_method /= ECC_DECODE_PARITY_method_S_0001 else '0';
  tmp_0125 <= tmp_0124 and ECC_DECODE_PARITY_req_flag_edge;
  tmp_0126 <= tmp_0123 and tmp_0125;
  tmp_0127 <= not ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0128 <= ECC_ENCODE_REEDSOLOMON_req_flag and tmp_0127;
  tmp_0129 <= ECC_ENCODE_REEDSOLOMON_req_flag or ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0130 <= ECC_ENCODE_REEDSOLOMON_req_flag or ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0131 <= '1' when ECC_ENCODE_REEDSOLOMON_method /= ECC_ENCODE_REEDSOLOMON_method_S_0000 else '0';
  tmp_0132 <= '1' when ECC_ENCODE_REEDSOLOMON_method /= ECC_ENCODE_REEDSOLOMON_method_S_0001 else '0';
  tmp_0133 <= tmp_0132 and ECC_ENCODE_REEDSOLOMON_req_flag_edge;
  tmp_0134 <= tmp_0131 and tmp_0133;
  tmp_0135 <= not ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0136 <= ECC_ENCODE_HAMMING_req_flag and tmp_0135;
  tmp_0137 <= ECC_ENCODE_HAMMING_req_flag or ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0138 <= ECC_ENCODE_HAMMING_req_flag or ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0139 <= '1' when ECC_ENCODE_HAMMING_method /= ECC_ENCODE_HAMMING_method_S_0000 else '0';
  tmp_0140 <= '1' when ECC_ENCODE_HAMMING_method /= ECC_ENCODE_HAMMING_method_S_0001 else '0';
  tmp_0141 <= tmp_0140 and ECC_ENCODE_HAMMING_req_flag_edge;
  tmp_0142 <= tmp_0139 and tmp_0141;
  tmp_0143 <= not ECC_ENCODE_PARITY_req_flag_d;
  tmp_0144 <= ECC_ENCODE_PARITY_req_flag and tmp_0143;
  tmp_0145 <= ECC_ENCODE_PARITY_req_flag or ECC_ENCODE_PARITY_req_flag_d;
  tmp_0146 <= ECC_ENCODE_PARITY_req_flag or ECC_ENCODE_PARITY_req_flag_d;
  tmp_0147 <= '1' when ECC_ENCODE_PARITY_method /= ECC_ENCODE_PARITY_method_S_0000 else '0';
  tmp_0148 <= '1' when ECC_ENCODE_PARITY_method /= ECC_ENCODE_PARITY_method_S_0001 else '0';
  tmp_0149 <= tmp_0148 and ECC_ENCODE_PARITY_req_flag_edge;
  tmp_0150 <= tmp_0147 and tmp_0149;

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
            if tmp_0004 = '1' then
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
        if (tmp_0014 and tmp_0016) = '1' then
          write_method <= write_method_S_0001;
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
            if tmp_0022 = '1' then
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
        if (tmp_0024 and tmp_0026) = '1' then
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
            if tmp_0030 = '1' then
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
        if (tmp_0036 and tmp_0038) = '1' then
          blockFinder_method <= blockFinder_method_S_0001;
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
            if tmp_0047 = '1' then
              eccSelector_method <= eccSelector_method_S_0002;
            end if;
          when eccSelector_method_S_0002 => 
            if tmp_0049 = '1' then
              eccSelector_method <= eccSelector_method_S_0023;
            elsif tmp_0050 = '1' then
              eccSelector_method <= eccSelector_method_S_0017;
            elsif tmp_0051 = '1' then
              eccSelector_method <= eccSelector_method_S_0011;
            elsif tmp_0052 = '1' then
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
        if (tmp_0077 and tmp_0079) = '1' then
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
            if tmp_0089 = '1' then
              SCHEDULER_WRITE_method <= SCHEDULER_WRITE_method_S_0000;
            end if;
          when others => null;
        end case;
        SCHEDULER_WRITE_req_flag_d <= SCHEDULER_WRITE_req_flag;
        if (tmp_0091 and tmp_0093) = '1' then
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
            if tmp_0097 = '1' then
              SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0002;
            end if;
          when SCHEDULER_READ_method_S_0002 => 
            SCHEDULER_READ_method <= SCHEDULER_READ_method_S_0000;
          when others => null;
        end case;
        SCHEDULER_READ_req_flag_d <= SCHEDULER_READ_req_flag;
        if (tmp_0099 and tmp_0101) = '1' then
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
            if tmp_0105 = '1' then
              ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0002;
            end if;
          when ECC_DECODE_REEDSOLOMON_method_S_0002 => 
            ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_REEDSOLOMON_req_flag_d <= ECC_DECODE_REEDSOLOMON_req_flag;
        if (tmp_0107 and tmp_0109) = '1' then
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
            if tmp_0113 = '1' then
              ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0002;
            end if;
          when ECC_DECODE_HAMMING_method_S_0002 => 
            ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_HAMMING_req_flag_d <= ECC_DECODE_HAMMING_req_flag;
        if (tmp_0115 and tmp_0117) = '1' then
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
            if tmp_0121 = '1' then
              ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0002;
            end if;
          when ECC_DECODE_PARITY_method_S_0002 => 
            ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_PARITY_req_flag_d <= ECC_DECODE_PARITY_req_flag;
        if (tmp_0123 and tmp_0125) = '1' then
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
            if tmp_0129 = '1' then
              ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0002;
            end if;
          when ECC_ENCODE_REEDSOLOMON_method_S_0002 => 
            ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_REEDSOLOMON_req_flag_d <= ECC_ENCODE_REEDSOLOMON_req_flag;
        if (tmp_0131 and tmp_0133) = '1' then
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
            if tmp_0137 = '1' then
              ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0002;
            end if;
          when ECC_ENCODE_HAMMING_method_S_0002 => 
            ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_HAMMING_req_flag_d <= ECC_ENCODE_HAMMING_req_flag;
        if (tmp_0139 and tmp_0141) = '1' then
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
            if tmp_0145 = '1' then
              ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0002;
            end if;
          when ECC_ENCODE_PARITY_method_S_0002 => 
            ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_PARITY_req_flag_d <= ECC_ENCODE_PARITY_req_flag;
        if (tmp_0147 and tmp_0149) = '1' then
          ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  class_memory0_0011_clk <= clk_sig;

  class_memory0_0011_reset <= reset_sig;

  class_memory1_0014_clk <= clk_sig;

  class_memory1_0014_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memory1_0014_address_b <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0004 then
          class_memory1_0014_address_b <= blockFinder_dataPosition_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memory1_0014_oe_b <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0016 and blockFinder_method_delay = 0 then
          class_memory1_0014_oe_b <= '1';
        else
          class_memory1_0014_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  class_memory2_0017_clk <= clk_sig;

  class_memory2_0017_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memory2_0017_address_b <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0008 then
          class_memory2_0017_address_b <= blockFinder_dataPosition_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memory2_0017_oe_b <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0018 and blockFinder_method_delay = 0 then
          class_memory2_0017_oe_b <= '1';
        else
          class_memory2_0017_oe_b <= '0';
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
          write_address_0020 <= tmp_0018;
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
          write_data_0021 <= tmp_0019;
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
        getPosition_address_0025 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0001 then
          getPosition_address_0025 <= getPosition_address_local;
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
          getPosition_address_local <= blockFinder_address_0028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00026 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
          binary_expr_00026 <= u_synthesijer_mul32_getPosition_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00027 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
          binary_expr_00027 <= u_synthesijer_div32_getPosition_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_address_0028 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0001 then
          blockFinder_address_0028 <= blockFinder_address_local;
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
        if blockFinder_method = blockFinder_method_S_0002_wait then
          method_result_00030 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_dataPosition_0029 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0003 then
          blockFinder_dataPosition_0029 <= method_result_00030;
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
        if blockFinder_method = blockFinder_method_S_0016 then
          array_access_00032 <= std_logic(class_memory1_0014_dout_b);
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
        if blockFinder_method = blockFinder_method_S_0005 then
          binary_expr_00034 <= tmp_0040;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00037 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0006 then
          cond_expr_00037 <= tmp_0041;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_currentData1_0031 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0007 then
          blockFinder_currentData1_0031 <= cond_expr_00037;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00039 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0018 then
          array_access_00039 <= std_logic(class_memory2_0017_dout_b);
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
        if blockFinder_method = blockFinder_method_S_0009 then
          binary_expr_00041 <= tmp_0042;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00044 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0010 then
          cond_expr_00044 <= tmp_0043;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_currentData2_0038 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0011 then
          blockFinder_currentData2_0038 <= cond_expr_00044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00045 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0012 then
          binary_expr_00045 <= tmp_0044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_data_0046 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_data_0046 <= eccSelector_data_local;
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
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_ecc_0047 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_ecc_0047 <= eccSelector_ecc_local;
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
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_encoder_0048 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_encoder_0048 <= eccSelector_encoder_local;
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
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00054 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0005 then
          binary_expr_00054 <= tmp_0081;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00055 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0006_wait then
          method_result_00055 <= ECC_ENCODE_REEDSOLOMON_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00056 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0007_wait then
          method_result_00056 <= ECC_DECODE_REEDSOLOMON_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00057 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0008 then
          cond_expr_00057 <= tmp_0082;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00059 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0011 then
          binary_expr_00059 <= tmp_0083;
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
        if eccSelector_method = eccSelector_method_S_0012_wait then
          method_result_00060 <= ECC_ENCODE_HAMMING_return;
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
        if eccSelector_method = eccSelector_method_S_0013_wait then
          method_result_00061 <= ECC_DECODE_HAMMING_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00062 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0014 then
          cond_expr_00062 <= tmp_0084;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00064 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0017 then
          binary_expr_00064 <= tmp_0085;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00065 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0018_wait then
          method_result_00065 <= ECC_ENCODE_PARITY_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00066 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0019_wait then
          method_result_00066 <= ECC_DECODE_PARITY_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00067 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0020 then
          cond_expr_00067 <= tmp_0086;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_address_0069 <= (others => '0');
      else
        if SCHEDULER_WRITE_method = SCHEDULER_WRITE_method_S_0001 then
          SCHEDULER_WRITE_address_0069 <= SCHEDULER_WRITE_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_WRITE_data_0070 <= (others => '0');
      else
        if SCHEDULER_WRITE_method = SCHEDULER_WRITE_method_S_0001 then
          SCHEDULER_WRITE_data_0070 <= SCHEDULER_WRITE_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        SCHEDULER_READ_address_0071 <= (others => '0');
      else
        if SCHEDULER_READ_method = SCHEDULER_READ_method_S_0001 then
          SCHEDULER_READ_address_0071 <= SCHEDULER_READ_address_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_data_0073 <= (others => '0');
      else
        if ECC_DECODE_REEDSOLOMON_method = ECC_DECODE_REEDSOLOMON_method_S_0001 then
          ECC_DECODE_REEDSOLOMON_data_0073 <= ECC_DECODE_REEDSOLOMON_data_local;
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
          ECC_DECODE_REEDSOLOMON_data_local <= eccSelector_data_0046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_data_0075 <= (others => '0');
      else
        if ECC_DECODE_HAMMING_method = ECC_DECODE_HAMMING_method_S_0001 then
          ECC_DECODE_HAMMING_data_0075 <= ECC_DECODE_HAMMING_data_local;
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
          ECC_DECODE_HAMMING_data_local <= eccSelector_data_0046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_data_0077 <= (others => '0');
      else
        if ECC_DECODE_PARITY_method = ECC_DECODE_PARITY_method_S_0001 then
          ECC_DECODE_PARITY_data_0077 <= ECC_DECODE_PARITY_data_local;
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
          ECC_DECODE_PARITY_data_local <= eccSelector_data_0046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_data_0079 <= (others => '0');
      else
        if ECC_ENCODE_REEDSOLOMON_method = ECC_ENCODE_REEDSOLOMON_method_S_0001 then
          ECC_ENCODE_REEDSOLOMON_data_0079 <= ECC_ENCODE_REEDSOLOMON_data_local;
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
          ECC_ENCODE_REEDSOLOMON_data_local <= eccSelector_data_0046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_data_0081 <= (others => '0');
      else
        if ECC_ENCODE_HAMMING_method = ECC_ENCODE_HAMMING_method_S_0001 then
          ECC_ENCODE_HAMMING_data_0081 <= ECC_ENCODE_HAMMING_data_local;
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
          ECC_ENCODE_HAMMING_data_local <= eccSelector_data_0046;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_data_0083 <= (others => '0');
      else
        if ECC_ENCODE_PARITY_method = ECC_ENCODE_PARITY_method_S_0001 then
          ECC_ENCODE_PARITY_data_0083 <= ECC_ENCODE_PARITY_data_local;
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
          ECC_ENCODE_PARITY_data_local <= eccSelector_data_0046;
        end if;
      end if;
    end if;
  end process;

  write_req_flag <= tmp_0001;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_return <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0004 then
          getPosition_return <= binary_expr_00027;
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
          getPosition_busy <= tmp_0023;
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
          blockFinder_return <= binary_expr_00045;
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
          blockFinder_busy <= tmp_0031;
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
        eccSelector_return <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0009 then
          eccSelector_return <= cond_expr_00057;
        elsif eccSelector_method = eccSelector_method_S_0015 then
          eccSelector_return <= cond_expr_00062;
        elsif eccSelector_method = eccSelector_method_S_0021 then
          eccSelector_return <= cond_expr_00067;
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
          eccSelector_busy <= tmp_0048;
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
          SCHEDULER_WRITE_busy <= tmp_0090;
        end if;
      end if;
    end if;
  end process;

  SCHEDULER_WRITE_req_flag <= SCHEDULER_WRITE_req_local;

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
          SCHEDULER_READ_busy <= tmp_0098;
        end if;
      end if;
    end if;
  end process;

  SCHEDULER_READ_req_flag <= SCHEDULER_READ_req_local;

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
          ECC_DECODE_REEDSOLOMON_busy <= tmp_0106;
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
          ECC_DECODE_HAMMING_busy <= tmp_0114;
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
          ECC_DECODE_PARITY_busy <= tmp_0122;
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
          ECC_ENCODE_REEDSOLOMON_busy <= tmp_0130;
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
          ECC_ENCODE_HAMMING_busy <= tmp_0138;
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
          ECC_ENCODE_PARITY_busy <= tmp_0146;
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

  write_req_flag_edge <= tmp_0003;

  blockFinder_call_flag_0002 <= tmp_0009;

  eccSelector_call_flag_0004 <= tmp_0013;

  getPosition_req_flag_edge <= tmp_0021;

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
          u_synthesijer_div32_getPosition_a <= getPosition_address_0025;
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
          u_synthesijer_div32_getPosition_b <= binary_expr_00026;
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

  blockFinder_req_flag_edge <= tmp_0029;

  getPosition_call_flag_0002 <= tmp_0035;

  eccSelector_req_flag_edge <= tmp_0046;

  ECC_ENCODE_REEDSOLOMON_call_flag_0006 <= tmp_0056;

  ECC_DECODE_REEDSOLOMON_call_flag_0007 <= tmp_0060;

  ECC_ENCODE_HAMMING_call_flag_0012 <= tmp_0064;

  ECC_DECODE_HAMMING_call_flag_0013 <= tmp_0068;

  ECC_ENCODE_PARITY_call_flag_0018 <= tmp_0072;

  ECC_DECODE_PARITY_call_flag_0019 <= tmp_0076;

  SCHEDULER_WRITE_req_flag_edge <= tmp_0088;

  SCHEDULER_READ_req_flag_edge <= tmp_0096;

  ECC_DECODE_REEDSOLOMON_req_flag_edge <= tmp_0104;

  ECC_DECODE_HAMMING_req_flag_edge <= tmp_0112;

  ECC_DECODE_PARITY_req_flag_edge <= tmp_0120;

  ECC_ENCODE_REEDSOLOMON_req_flag_edge <= tmp_0128;

  ECC_ENCODE_HAMMING_req_flag_edge <= tmp_0136;

  ECC_ENCODE_PARITY_req_flag_edge <= tmp_0144;


  inst_class_memory0_0011 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_memory0_0011_length,
    address_b => class_memory0_0011_address_b,
    din_b => class_memory0_0011_din_b,
    dout_b => class_memory0_0011_dout_b,
    we_b => class_memory0_0011_we_b,
    oe_b => class_memory0_0011_oe_b
  );

  inst_class_memory1_0014 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_memory1_0014_length,
    address_b => class_memory1_0014_address_b,
    din_b => class_memory1_0014_din_b,
    dout_b => class_memory1_0014_dout_b,
    we_b => class_memory1_0014_we_b,
    oe_b => class_memory1_0014_oe_b
  );

  inst_class_memory2_0017 : singleportram
  generic map(
    WIDTH => 1,
    DEPTH => 18,
    WORDS => 256000
  )
  port map(
    clk => clk,
    reset => reset,
    length => class_memory2_0017_length,
    address_b => class_memory2_0017_address_b,
    din_b => class_memory2_0017_din_b,
    dout_b => class_memory2_0017_dout_b,
    we_b => class_memory2_0017_we_b,
    oe_b => class_memory2_0017_oe_b
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
