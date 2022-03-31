library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dftm_DFTM_noRecoding is
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
end dftm_DFTM_noRecoding;

architecture RTL of dftm_DFTM_noRecoding is

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
  signal read_address_0025 : signed(32-1 downto 0) := (others => '0');
  signal read_address_local : signed(32-1 downto 0) := (others => '0');
  signal read_data_0026 : signed(32-1 downto 0) := (others => '0');
  signal read_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00028 : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_0027 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00029 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_0030 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00031 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00032 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_address_0033 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00035 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_dataPosition_0034 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00037 : std_logic := '0';
  signal binary_expr_00039 : std_logic := '0';
  signal cond_expr_00042 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_currentData1_0036 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00044 : std_logic := '0';
  signal binary_expr_00046 : std_logic := '0';
  signal cond_expr_00049 : signed(32-1 downto 0) := (others => '0');
  signal blockFinder_currentData2_0043 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00050 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_data_0051 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_data_local : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_ecc_0052 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_encoder_0053 : signed(32-1 downto 0) := (others => '0');
  signal eccSelector_encoder_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00059 : std_logic := '0';
  signal method_result_00060 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00061 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00062 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00064 : std_logic := '0';
  signal method_result_00065 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00066 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00067 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00069 : std_logic := '0';
  signal method_result_00070 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00071 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00072 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_data_0074 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_REEDSOLOMON_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_data_0076 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_HAMMING_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_data_0078 : signed(32-1 downto 0) := (others => '0');
  signal ECC_DECODE_PARITY_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_data_0080 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_REEDSOLOMON_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_data_0082 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_HAMMING_data_local : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_data_0084 : signed(32-1 downto 0) := (others => '0');
  signal ECC_ENCODE_PARITY_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_req_flag : std_logic := '0';
  signal write_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal read_req_flag : std_logic := '0';
  signal read_req_local : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
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
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
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
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
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
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal getPosition_call_flag_0002 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0055 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal ECC_ENCODE_REEDSOLOMON_call_flag_0006 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal ECC_DECODE_REEDSOLOMON_call_flag_0007 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
  signal tmp_0071 : std_logic := '0';
  signal ECC_ENCODE_HAMMING_call_flag_0012 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal ECC_DECODE_HAMMING_call_flag_0013 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
  signal tmp_0079 : std_logic := '0';
  signal ECC_ENCODE_PARITY_call_flag_0018 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal ECC_DECODE_PARITY_call_flag_0019 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
  signal tmp_0086 : std_logic := '0';
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0094 : std_logic := '0';
  signal tmp_0095 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0098 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
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
  signal tmp_0106 : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : std_logic := '0';
  signal tmp_0113 : std_logic := '0';
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
  signal tmp_0114 : std_logic := '0';
  signal tmp_0115 : std_logic := '0';
  signal tmp_0116 : std_logic := '0';
  signal tmp_0117 : std_logic := '0';
  signal tmp_0118 : std_logic := '0';
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
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
  signal tmp_0122 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
  signal tmp_0126 : std_logic := '0';
  signal tmp_0127 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
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
  signal tmp_0130 : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
  signal tmp_0134 : std_logic := '0';
  signal tmp_0135 : std_logic := '0';
  signal tmp_0136 : std_logic := '0';
  signal tmp_0137 : std_logic := '0';
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
  signal tmp_0138 : std_logic := '0';
  signal tmp_0139 : std_logic := '0';
  signal tmp_0140 : std_logic := '0';
  signal tmp_0141 : std_logic := '0';
  signal tmp_0142 : std_logic := '0';
  signal tmp_0143 : std_logic := '0';
  signal tmp_0144 : std_logic := '0';
  signal tmp_0145 : std_logic := '0';

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
        if read_method = read_method_S_0005 then
          read_return_sig <= method_result_00029;
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
  tmp_0025 <= '1' when read_method /= read_method_S_0000 else '0';
  tmp_0026 <= '1' when read_method /= read_method_S_0001 else '0';
  tmp_0027 <= tmp_0026 and read_req_flag_edge;
  tmp_0028 <= tmp_0025 and tmp_0027;
  tmp_0029 <= read_address_sig when read_req_sig = '1' else read_address_local;
  tmp_0030 <= read_data_sig when read_req_sig = '1' else read_data_local;
  tmp_0031 <= not getPosition_req_flag_d;
  tmp_0032 <= getPosition_req_flag and tmp_0031;
  tmp_0033 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0034 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0035 <= '1' when getPosition_method /= getPosition_method_S_0000 else '0';
  tmp_0036 <= '1' when getPosition_method /= getPosition_method_S_0001 else '0';
  tmp_0037 <= tmp_0036 and getPosition_req_flag_edge;
  tmp_0038 <= tmp_0035 and tmp_0037;
  tmp_0039 <= not blockFinder_req_flag_d;
  tmp_0040 <= blockFinder_req_flag and tmp_0039;
  tmp_0041 <= blockFinder_req_flag or blockFinder_req_flag_d;
  tmp_0042 <= blockFinder_req_flag or blockFinder_req_flag_d;
  tmp_0043 <= '1' when getPosition_busy = '0' else '0';
  tmp_0044 <= '1' when getPosition_req_local = '0' else '0';
  tmp_0045 <= tmp_0043 and tmp_0044;
  tmp_0046 <= '1' when tmp_0045 = '1' else '0';
  tmp_0047 <= '1' when blockFinder_method /= blockFinder_method_S_0000 else '0';
  tmp_0048 <= '1' when blockFinder_method /= blockFinder_method_S_0001 else '0';
  tmp_0049 <= tmp_0048 and blockFinder_req_flag_edge;
  tmp_0050 <= tmp_0047 and tmp_0049;
  tmp_0051 <= '1' when array_access_00037 = '1' else '0';
  tmp_0052 <= X"00000001" when binary_expr_00039 = '1' else X"00000000";
  tmp_0053 <= '1' when array_access_00044 = '1' else '0';
  tmp_0054 <= X"00000002" when binary_expr_00046 = '1' else X"00000000";
  tmp_0055 <= blockFinder_currentData1_0036 + blockFinder_currentData2_0043;
  tmp_0056 <= not eccSelector_req_flag_d;
  tmp_0057 <= eccSelector_req_flag and tmp_0056;
  tmp_0058 <= eccSelector_req_flag or eccSelector_req_flag_d;
  tmp_0059 <= eccSelector_req_flag or eccSelector_req_flag_d;
  tmp_0060 <= '1' when eccSelector_ecc_0052 = X"00000000" else '0';
  tmp_0061 <= '1' when eccSelector_ecc_0052 = X"00000001" else '0';
  tmp_0062 <= '1' when eccSelector_ecc_0052 = X"00000002" else '0';
  tmp_0063 <= '1' when eccSelector_ecc_0052 = X"00000003" else '0';
  tmp_0064 <= '1' when ECC_ENCODE_REEDSOLOMON_busy = '0' else '0';
  tmp_0065 <= '1' when ECC_ENCODE_REEDSOLOMON_req_local = '0' else '0';
  tmp_0066 <= tmp_0064 and tmp_0065;
  tmp_0067 <= '1' when tmp_0066 = '1' else '0';
  tmp_0068 <= '1' when ECC_DECODE_REEDSOLOMON_busy = '0' else '0';
  tmp_0069 <= '1' when ECC_DECODE_REEDSOLOMON_req_local = '0' else '0';
  tmp_0070 <= tmp_0068 and tmp_0069;
  tmp_0071 <= '1' when tmp_0070 = '1' else '0';
  tmp_0072 <= '1' when ECC_ENCODE_HAMMING_busy = '0' else '0';
  tmp_0073 <= '1' when ECC_ENCODE_HAMMING_req_local = '0' else '0';
  tmp_0074 <= tmp_0072 and tmp_0073;
  tmp_0075 <= '1' when tmp_0074 = '1' else '0';
  tmp_0076 <= '1' when ECC_DECODE_HAMMING_busy = '0' else '0';
  tmp_0077 <= '1' when ECC_DECODE_HAMMING_req_local = '0' else '0';
  tmp_0078 <= tmp_0076 and tmp_0077;
  tmp_0079 <= '1' when tmp_0078 = '1' else '0';
  tmp_0080 <= '1' when ECC_ENCODE_PARITY_busy = '0' else '0';
  tmp_0081 <= '1' when ECC_ENCODE_PARITY_req_local = '0' else '0';
  tmp_0082 <= tmp_0080 and tmp_0081;
  tmp_0083 <= '1' when tmp_0082 = '1' else '0';
  tmp_0084 <= '1' when ECC_DECODE_PARITY_busy = '0' else '0';
  tmp_0085 <= '1' when ECC_DECODE_PARITY_req_local = '0' else '0';
  tmp_0086 <= tmp_0084 and tmp_0085;
  tmp_0087 <= '1' when tmp_0086 = '1' else '0';
  tmp_0088 <= '1' when eccSelector_method /= eccSelector_method_S_0000 else '0';
  tmp_0089 <= '1' when eccSelector_method /= eccSelector_method_S_0001 else '0';
  tmp_0090 <= tmp_0089 and eccSelector_req_flag_edge;
  tmp_0091 <= tmp_0088 and tmp_0090;
  tmp_0092 <= '1' when eccSelector_encoder_0053 = X"00000001" else '0';
  tmp_0093 <= method_result_00060 when binary_expr_00059 = '1' else method_result_00061;
  tmp_0094 <= '1' when eccSelector_encoder_0053 = X"00000001" else '0';
  tmp_0095 <= method_result_00065 when binary_expr_00064 = '1' else method_result_00066;
  tmp_0096 <= '1' when eccSelector_encoder_0053 = X"00000001" else '0';
  tmp_0097 <= method_result_00070 when binary_expr_00069 = '1' else method_result_00071;
  tmp_0098 <= not ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0099 <= ECC_DECODE_REEDSOLOMON_req_flag and tmp_0098;
  tmp_0100 <= ECC_DECODE_REEDSOLOMON_req_flag or ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0101 <= ECC_DECODE_REEDSOLOMON_req_flag or ECC_DECODE_REEDSOLOMON_req_flag_d;
  tmp_0102 <= '1' when ECC_DECODE_REEDSOLOMON_method /= ECC_DECODE_REEDSOLOMON_method_S_0000 else '0';
  tmp_0103 <= '1' when ECC_DECODE_REEDSOLOMON_method /= ECC_DECODE_REEDSOLOMON_method_S_0001 else '0';
  tmp_0104 <= tmp_0103 and ECC_DECODE_REEDSOLOMON_req_flag_edge;
  tmp_0105 <= tmp_0102 and tmp_0104;
  tmp_0106 <= not ECC_DECODE_HAMMING_req_flag_d;
  tmp_0107 <= ECC_DECODE_HAMMING_req_flag and tmp_0106;
  tmp_0108 <= ECC_DECODE_HAMMING_req_flag or ECC_DECODE_HAMMING_req_flag_d;
  tmp_0109 <= ECC_DECODE_HAMMING_req_flag or ECC_DECODE_HAMMING_req_flag_d;
  tmp_0110 <= '1' when ECC_DECODE_HAMMING_method /= ECC_DECODE_HAMMING_method_S_0000 else '0';
  tmp_0111 <= '1' when ECC_DECODE_HAMMING_method /= ECC_DECODE_HAMMING_method_S_0001 else '0';
  tmp_0112 <= tmp_0111 and ECC_DECODE_HAMMING_req_flag_edge;
  tmp_0113 <= tmp_0110 and tmp_0112;
  tmp_0114 <= not ECC_DECODE_PARITY_req_flag_d;
  tmp_0115 <= ECC_DECODE_PARITY_req_flag and tmp_0114;
  tmp_0116 <= ECC_DECODE_PARITY_req_flag or ECC_DECODE_PARITY_req_flag_d;
  tmp_0117 <= ECC_DECODE_PARITY_req_flag or ECC_DECODE_PARITY_req_flag_d;
  tmp_0118 <= '1' when ECC_DECODE_PARITY_method /= ECC_DECODE_PARITY_method_S_0000 else '0';
  tmp_0119 <= '1' when ECC_DECODE_PARITY_method /= ECC_DECODE_PARITY_method_S_0001 else '0';
  tmp_0120 <= tmp_0119 and ECC_DECODE_PARITY_req_flag_edge;
  tmp_0121 <= tmp_0118 and tmp_0120;
  tmp_0122 <= not ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0123 <= ECC_ENCODE_REEDSOLOMON_req_flag and tmp_0122;
  tmp_0124 <= ECC_ENCODE_REEDSOLOMON_req_flag or ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0125 <= ECC_ENCODE_REEDSOLOMON_req_flag or ECC_ENCODE_REEDSOLOMON_req_flag_d;
  tmp_0126 <= '1' when ECC_ENCODE_REEDSOLOMON_method /= ECC_ENCODE_REEDSOLOMON_method_S_0000 else '0';
  tmp_0127 <= '1' when ECC_ENCODE_REEDSOLOMON_method /= ECC_ENCODE_REEDSOLOMON_method_S_0001 else '0';
  tmp_0128 <= tmp_0127 and ECC_ENCODE_REEDSOLOMON_req_flag_edge;
  tmp_0129 <= tmp_0126 and tmp_0128;
  tmp_0130 <= not ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0131 <= ECC_ENCODE_HAMMING_req_flag and tmp_0130;
  tmp_0132 <= ECC_ENCODE_HAMMING_req_flag or ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0133 <= ECC_ENCODE_HAMMING_req_flag or ECC_ENCODE_HAMMING_req_flag_d;
  tmp_0134 <= '1' when ECC_ENCODE_HAMMING_method /= ECC_ENCODE_HAMMING_method_S_0000 else '0';
  tmp_0135 <= '1' when ECC_ENCODE_HAMMING_method /= ECC_ENCODE_HAMMING_method_S_0001 else '0';
  tmp_0136 <= tmp_0135 and ECC_ENCODE_HAMMING_req_flag_edge;
  tmp_0137 <= tmp_0134 and tmp_0136;
  tmp_0138 <= not ECC_ENCODE_PARITY_req_flag_d;
  tmp_0139 <= ECC_ENCODE_PARITY_req_flag and tmp_0138;
  tmp_0140 <= ECC_ENCODE_PARITY_req_flag or ECC_ENCODE_PARITY_req_flag_d;
  tmp_0141 <= ECC_ENCODE_PARITY_req_flag or ECC_ENCODE_PARITY_req_flag_d;
  tmp_0142 <= '1' when ECC_ENCODE_PARITY_method /= ECC_ENCODE_PARITY_method_S_0000 else '0';
  tmp_0143 <= '1' when ECC_ENCODE_PARITY_method /= ECC_ENCODE_PARITY_method_S_0001 else '0';
  tmp_0144 <= tmp_0143 and ECC_ENCODE_PARITY_req_flag_edge;
  tmp_0145 <= tmp_0142 and tmp_0144;

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
          when others => null;
        end case;
        read_req_flag_d <= read_req_flag;
        if (tmp_0025 and tmp_0027) = '1' then
          read_method <= read_method_S_0001;
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
            if tmp_0033 = '1' then
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
        if (tmp_0035 and tmp_0037) = '1' then
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
            if tmp_0041 = '1' then
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
        if (tmp_0047 and tmp_0049) = '1' then
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
            if tmp_0058 = '1' then
              eccSelector_method <= eccSelector_method_S_0002;
            end if;
          when eccSelector_method_S_0002 => 
            if tmp_0060 = '1' then
              eccSelector_method <= eccSelector_method_S_0023;
            elsif tmp_0061 = '1' then
              eccSelector_method <= eccSelector_method_S_0017;
            elsif tmp_0062 = '1' then
              eccSelector_method <= eccSelector_method_S_0011;
            elsif tmp_0063 = '1' then
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
        if (tmp_0088 and tmp_0090) = '1' then
          eccSelector_method <= eccSelector_method_S_0001;
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
            if tmp_0100 = '1' then
              ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0002;
            end if;
          when ECC_DECODE_REEDSOLOMON_method_S_0002 => 
            ECC_DECODE_REEDSOLOMON_method <= ECC_DECODE_REEDSOLOMON_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_REEDSOLOMON_req_flag_d <= ECC_DECODE_REEDSOLOMON_req_flag;
        if (tmp_0102 and tmp_0104) = '1' then
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
            if tmp_0108 = '1' then
              ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0002;
            end if;
          when ECC_DECODE_HAMMING_method_S_0002 => 
            ECC_DECODE_HAMMING_method <= ECC_DECODE_HAMMING_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_HAMMING_req_flag_d <= ECC_DECODE_HAMMING_req_flag;
        if (tmp_0110 and tmp_0112) = '1' then
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
            if tmp_0116 = '1' then
              ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0002;
            end if;
          when ECC_DECODE_PARITY_method_S_0002 => 
            ECC_DECODE_PARITY_method <= ECC_DECODE_PARITY_method_S_0000;
          when others => null;
        end case;
        ECC_DECODE_PARITY_req_flag_d <= ECC_DECODE_PARITY_req_flag;
        if (tmp_0118 and tmp_0120) = '1' then
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
            if tmp_0124 = '1' then
              ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0002;
            end if;
          when ECC_ENCODE_REEDSOLOMON_method_S_0002 => 
            ECC_ENCODE_REEDSOLOMON_method <= ECC_ENCODE_REEDSOLOMON_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_REEDSOLOMON_req_flag_d <= ECC_ENCODE_REEDSOLOMON_req_flag;
        if (tmp_0126 and tmp_0128) = '1' then
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
            if tmp_0132 = '1' then
              ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0002;
            end if;
          when ECC_ENCODE_HAMMING_method_S_0002 => 
            ECC_ENCODE_HAMMING_method <= ECC_ENCODE_HAMMING_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_HAMMING_req_flag_d <= ECC_ENCODE_HAMMING_req_flag;
        if (tmp_0134 and tmp_0136) = '1' then
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
            if tmp_0140 = '1' then
              ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0002;
            end if;
          when ECC_ENCODE_PARITY_method_S_0002 => 
            ECC_ENCODE_PARITY_method <= ECC_ENCODE_PARITY_method_S_0000;
          when others => null;
        end case;
        ECC_ENCODE_PARITY_req_flag_d <= ECC_ENCODE_PARITY_req_flag;
        if (tmp_0142 and tmp_0144) = '1' then
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
          class_memory1_0014_address_b <= blockFinder_dataPosition_0034;
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
          class_memory2_0017_address_b <= blockFinder_dataPosition_0034;
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
          read_address_0025 <= tmp_0029;
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
          read_data_0026 <= tmp_0030;
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
        method_result_00029 <= (others => '0');
      else
        if read_method = read_method_S_0004_wait then
          method_result_00029 <= eccSelector_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_address_0030 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0001 then
          getPosition_address_0030 <= getPosition_address_local;
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
          getPosition_address_local <= blockFinder_address_0033;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00031 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
          binary_expr_00031 <= u_synthesijer_mul32_getPosition_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00032 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
          binary_expr_00032 <= u_synthesijer_div32_getPosition_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_address_0033 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0001 then
          blockFinder_address_0033 <= blockFinder_address_local;
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
        method_result_00035 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0002_wait then
          method_result_00035 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_dataPosition_0034 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0003 then
          blockFinder_dataPosition_0034 <= method_result_00035;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00037 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0016 then
          array_access_00037 <= std_logic(class_memory1_0014_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00039 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0005 then
          binary_expr_00039 <= tmp_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00042 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0006 then
          cond_expr_00042 <= tmp_0052;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_currentData1_0036 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0007 then
          blockFinder_currentData1_0036 <= cond_expr_00042;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00044 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0018 then
          array_access_00044 <= std_logic(class_memory2_0017_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00046 <= '0';
      else
        if blockFinder_method = blockFinder_method_S_0009 then
          binary_expr_00046 <= tmp_0053;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00049 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0010 then
          cond_expr_00049 <= tmp_0054;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        blockFinder_currentData2_0043 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0011 then
          blockFinder_currentData2_0043 <= cond_expr_00049;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00050 <= (others => '0');
      else
        if blockFinder_method = blockFinder_method_S_0012 then
          binary_expr_00050 <= tmp_0055;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_data_0051 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_data_0051 <= eccSelector_data_local;
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
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_ecc_0052 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_ecc_0052 <= eccSelector_ecc_local;
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
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        eccSelector_encoder_0053 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0001 then
          eccSelector_encoder_0053 <= eccSelector_encoder_local;
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
        if eccSelector_method = eccSelector_method_S_0005 then
          binary_expr_00059 <= tmp_0092;
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
        if eccSelector_method = eccSelector_method_S_0006_wait then
          method_result_00060 <= ECC_ENCODE_REEDSOLOMON_return;
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
        if eccSelector_method = eccSelector_method_S_0007_wait then
          method_result_00061 <= ECC_DECODE_REEDSOLOMON_return;
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
        if eccSelector_method = eccSelector_method_S_0008 then
          cond_expr_00062 <= tmp_0093;
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
        if eccSelector_method = eccSelector_method_S_0011 then
          binary_expr_00064 <= tmp_0094;
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
        if eccSelector_method = eccSelector_method_S_0012_wait then
          method_result_00065 <= ECC_ENCODE_HAMMING_return;
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
        if eccSelector_method = eccSelector_method_S_0013_wait then
          method_result_00066 <= ECC_DECODE_HAMMING_return;
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
        if eccSelector_method = eccSelector_method_S_0014 then
          cond_expr_00067 <= tmp_0095;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00069 <= '0';
      else
        if eccSelector_method = eccSelector_method_S_0017 then
          binary_expr_00069 <= tmp_0096;
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
        if eccSelector_method = eccSelector_method_S_0018_wait then
          method_result_00070 <= ECC_ENCODE_PARITY_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00071 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0019_wait then
          method_result_00071 <= ECC_DECODE_PARITY_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00072 <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0020 then
          cond_expr_00072 <= tmp_0097;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_REEDSOLOMON_data_0074 <= (others => '0');
      else
        if ECC_DECODE_REEDSOLOMON_method = ECC_DECODE_REEDSOLOMON_method_S_0001 then
          ECC_DECODE_REEDSOLOMON_data_0074 <= ECC_DECODE_REEDSOLOMON_data_local;
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
          ECC_DECODE_REEDSOLOMON_data_local <= eccSelector_data_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_HAMMING_data_0076 <= (others => '0');
      else
        if ECC_DECODE_HAMMING_method = ECC_DECODE_HAMMING_method_S_0001 then
          ECC_DECODE_HAMMING_data_0076 <= ECC_DECODE_HAMMING_data_local;
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
          ECC_DECODE_HAMMING_data_local <= eccSelector_data_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_DECODE_PARITY_data_0078 <= (others => '0');
      else
        if ECC_DECODE_PARITY_method = ECC_DECODE_PARITY_method_S_0001 then
          ECC_DECODE_PARITY_data_0078 <= ECC_DECODE_PARITY_data_local;
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
          ECC_DECODE_PARITY_data_local <= eccSelector_data_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_REEDSOLOMON_data_0080 <= (others => '0');
      else
        if ECC_ENCODE_REEDSOLOMON_method = ECC_ENCODE_REEDSOLOMON_method_S_0001 then
          ECC_ENCODE_REEDSOLOMON_data_0080 <= ECC_ENCODE_REEDSOLOMON_data_local;
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
          ECC_ENCODE_REEDSOLOMON_data_local <= eccSelector_data_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_HAMMING_data_0082 <= (others => '0');
      else
        if ECC_ENCODE_HAMMING_method = ECC_ENCODE_HAMMING_method_S_0001 then
          ECC_ENCODE_HAMMING_data_0082 <= ECC_ENCODE_HAMMING_data_local;
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
          ECC_ENCODE_HAMMING_data_local <= eccSelector_data_0051;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        ECC_ENCODE_PARITY_data_0084 <= (others => '0');
      else
        if ECC_ENCODE_PARITY_method = ECC_ENCODE_PARITY_method_S_0001 then
          ECC_ENCODE_PARITY_data_0084 <= ECC_ENCODE_PARITY_data_local;
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
          ECC_ENCODE_PARITY_data_local <= eccSelector_data_0051;
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
        getPosition_return <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0004 then
          getPosition_return <= binary_expr_00032;
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
          getPosition_busy <= tmp_0034;
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
          blockFinder_return <= binary_expr_00050;
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
          blockFinder_busy <= tmp_0042;
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
        eccSelector_return <= (others => '0');
      else
        if eccSelector_method = eccSelector_method_S_0009 then
          eccSelector_return <= cond_expr_00062;
        elsif eccSelector_method = eccSelector_method_S_0015 then
          eccSelector_return <= cond_expr_00067;
        elsif eccSelector_method = eccSelector_method_S_0021 then
          eccSelector_return <= cond_expr_00072;
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
          eccSelector_busy <= tmp_0059;
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
          ECC_DECODE_REEDSOLOMON_busy <= tmp_0101;
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
          ECC_DECODE_HAMMING_busy <= tmp_0109;
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
          ECC_DECODE_PARITY_busy <= tmp_0117;
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
          ECC_ENCODE_REEDSOLOMON_busy <= tmp_0125;
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
          ECC_ENCODE_HAMMING_busy <= tmp_0133;
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
          ECC_ENCODE_PARITY_busy <= tmp_0141;
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

  getPosition_req_flag_edge <= tmp_0032;

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
          u_synthesijer_div32_getPosition_a <= getPosition_address_0030;
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
          u_synthesijer_div32_getPosition_b <= binary_expr_00031;
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

  blockFinder_req_flag_edge <= tmp_0040;

  getPosition_call_flag_0002 <= tmp_0046;

  eccSelector_req_flag_edge <= tmp_0057;

  ECC_ENCODE_REEDSOLOMON_call_flag_0006 <= tmp_0067;

  ECC_DECODE_REEDSOLOMON_call_flag_0007 <= tmp_0071;

  ECC_ENCODE_HAMMING_call_flag_0012 <= tmp_0075;

  ECC_DECODE_HAMMING_call_flag_0013 <= tmp_0079;

  ECC_ENCODE_PARITY_call_flag_0018 <= tmp_0083;

  ECC_DECODE_PARITY_call_flag_0019 <= tmp_0087;

  ECC_DECODE_REEDSOLOMON_req_flag_edge <= tmp_0099;

  ECC_DECODE_HAMMING_req_flag_edge <= tmp_0107;

  ECC_DECODE_PARITY_req_flag_edge <= tmp_0115;

  ECC_ENCODE_REEDSOLOMON_req_flag_edge <= tmp_0123;

  ECC_ENCODE_HAMMING_req_flag_edge <= tmp_0131;

  ECC_ENCODE_PARITY_req_flag_edge <= tmp_0139;


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
