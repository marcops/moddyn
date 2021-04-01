library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleDynamic_migLOOP is
  port (
    clk : in std_logic;
    reset : in std_logic;
    migration2_initialAddress : in signed(32-1 downto 0);
    migration2_ecc : in signed(32-1 downto 0);
    migration2_pageSize : in signed(32-1 downto 0);
    migration2_busy : out std_logic;
    migration2_req : in std_logic
  );
end moduledynamic_ModuleDynamic_migLOOP;

architecture RTL of moduledynamic_ModuleDynamic_migLOOP is

  attribute mark_debug : string;
  attribute keep : string;
  attribute S : string;


  signal clk_sig : std_logic := '0';
  signal reset_sig : std_logic := '0';
  signal migration2_initialAddress_sig : signed(32-1 downto 0) := (others => '0');
  signal migration2_ecc_sig : signed(32-1 downto 0) := (others => '0');
  signal migration2_pageSize_sig : signed(32-1 downto 0) := (others => '0');
  signal migration2_busy_sig : std_logic := '1';
  signal migration2_req_sig : std_logic := '0';

  signal migration2_initialAddress_0000 : signed(32-1 downto 0) := (others => '0');
  signal migration2_initialAddress_local : signed(32-1 downto 0) := (others => '0');
  signal migration2_ecc_0001 : signed(32-1 downto 0) := (others => '0');
  signal migration2_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal migration2_pageSize_0002 : signed(32-1 downto 0) := (others => '0');
  signal migration2_pageSize_local : signed(32-1 downto 0) := (others => '0');
  signal migration2_i_0003 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00005 : std_logic := '0';
  signal unary_expr_00006 : signed(32-1 downto 0) := (others => '0');
  signal unary_expr_postfix_preserved_00007 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00010 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00011 : signed(32-1 downto 0) := (others => '0');
  signal migration2_read_0009 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00013 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00015 : signed(32-1 downto 0) := (others => '0');
  signal write_address_0016 : signed(32-1 downto 0) := (others => '0');
  signal write_address_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_0017 : signed(32-1 downto 0) := (others => '0');
  signal write_data_local : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_0018 : signed(32-1 downto 0) := (others => '0');
  signal write_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00020 : signed(32-1 downto 0) := (others => '0');
  signal write_newData_0019 : signed(32-1 downto 0) := (others => '0');
  signal read_address_0027 : signed(32-1 downto 0) := (others => '0');
  signal read_address_local : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_0028 : signed(32-1 downto 0) := (others => '0');
  signal read_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00030 : signed(32-1 downto 0) := (others => '0');
  signal read_data_0029 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00031 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_0032 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_0033 : signed(32-1 downto 0) := (others => '0');
  signal writeRAM_data_local : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_0034 : signed(32-1 downto 0) := (others => '0');
  signal readRAM_address_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_0036 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_0037 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00042 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00043 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00044 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_0045 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_0046 : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_0047 : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal migration2_req_flag : std_logic := '0';
  signal migration2_req_local : std_logic := '0';
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
  type Type_migration2_method is (
    migration2_method_IDLE,
    migration2_method_S_0000,
    migration2_method_S_0001,
    migration2_method_S_0002,
    migration2_method_S_0003,
    migration2_method_S_0004,
    migration2_method_S_0006,
    migration2_method_S_0008,
    migration2_method_S_0010,
    migration2_method_S_0011,
    migration2_method_S_0012,
    migration2_method_S_0015,
    migration2_method_S_0011_body,
    migration2_method_S_0011_wait,
    migration2_method_S_0015_body,
    migration2_method_S_0015_wait  
  );
  signal migration2_method : Type_migration2_method := migration2_method_IDLE;
  signal migration2_method_prev : Type_migration2_method := migration2_method_IDLE;
  signal migration2_method_delay : signed(32-1 downto 0) := (others => '0');
  signal migration2_req_flag_d : std_logic := '0';
  signal migration2_req_flag_edge : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal read_call_flag_0011 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal write_call_flag_0015 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
  signal tmp_0020 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0021 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0022 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0025 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0026 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0027 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0028 : std_logic := '0';
  signal tmp_0029 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal doEcc_call_flag_0002 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal writeRAM_call_flag_0007 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal writeRAM_call_flag_0010 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal writeRAM_call_flag_0013 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : std_logic := '0';
  signal tmp_0054 : std_logic := '0';
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
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal readRAM_call_flag_0002 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
  signal doEcc_call_flag_0004 : std_logic := '0';
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
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
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
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
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
  signal tmp_0086 : std_logic := '0';
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
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
  signal tmp_0094 : std_logic := '0';
  signal doReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
  signal doHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';
  signal doParity_call_flag_0011 : std_logic := '0';
  signal tmp_0103 : std_logic := '0';
  signal tmp_0104 : std_logic := '0';
  signal tmp_0105 : std_logic := '0';
  signal tmp_0106 : std_logic := '0';
  signal tmp_0107 : std_logic := '0';
  signal tmp_0108 : std_logic := '0';
  signal tmp_0109 : std_logic := '0';
  signal tmp_0110 : std_logic := '0';
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
  signal tmp_0111 : std_logic := '0';
  signal tmp_0112 : std_logic := '0';
  signal tmp_0113 : std_logic := '0';
  signal tmp_0114 : std_logic := '0';
  signal tmp_0115 : std_logic := '0';
  signal tmp_0116 : std_logic := '0';
  signal tmp_0117 : std_logic := '0';
  signal tmp_0118 : std_logic := '0';
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
  signal tmp_0119 : std_logic := '0';
  signal tmp_0120 : std_logic := '0';
  signal tmp_0121 : std_logic := '0';
  signal tmp_0122 : std_logic := '0';
  signal tmp_0123 : std_logic := '0';
  signal tmp_0124 : std_logic := '0';
  signal tmp_0125 : std_logic := '0';
  signal tmp_0126 : std_logic := '0';
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
  signal tmp_0127 : std_logic := '0';
  signal tmp_0128 : std_logic := '0';
  signal tmp_0129 : std_logic := '0';
  signal tmp_0130 : std_logic := '0';
  signal tmp_0131 : std_logic := '0';
  signal tmp_0132 : std_logic := '0';
  signal tmp_0133 : std_logic := '0';
  signal tmp_0134 : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;
  migration2_initialAddress_sig <= migration2_initialAddress;
  migration2_ecc_sig <= migration2_ecc;
  migration2_pageSize_sig <= migration2_pageSize;
  migration2_busy <= migration2_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_busy_sig <= '1';
      else
        if migration2_method = migration2_method_S_0000 then
          migration2_busy_sig <= '0';
        elsif migration2_method = migration2_method_S_0001 then
          migration2_busy_sig <= tmp_0005;
        end if;
      end if;
    end if;
  end process;

  migration2_req_sig <= migration2_req;

  -- expressions
  tmp_0001 <= migration2_req_local or migration2_req_sig;
  tmp_0002 <= not migration2_req_flag_d;
  tmp_0003 <= migration2_req_flag and tmp_0002;
  tmp_0004 <= migration2_req_flag or migration2_req_flag_d;
  tmp_0005 <= migration2_req_flag or migration2_req_flag_d;
  tmp_0006 <= '1' when binary_expr_00005 = '1' else '0';
  tmp_0007 <= '1' when binary_expr_00005 = '0' else '0';
  tmp_0008 <= '1' when read_busy = '0' else '0';
  tmp_0009 <= '1' when read_req_local = '0' else '0';
  tmp_0010 <= tmp_0008 and tmp_0009;
  tmp_0011 <= '1' when tmp_0010 = '1' else '0';
  tmp_0012 <= '1' when write_busy = '0' else '0';
  tmp_0013 <= '1' when write_req_local = '0' else '0';
  tmp_0014 <= tmp_0012 and tmp_0013;
  tmp_0015 <= '1' when tmp_0014 = '1' else '0';
  tmp_0016 <= '1' when migration2_method /= migration2_method_S_0000 else '0';
  tmp_0017 <= '1' when migration2_method /= migration2_method_S_0001 else '0';
  tmp_0018 <= tmp_0017 and migration2_req_flag_edge;
  tmp_0019 <= tmp_0016 and tmp_0018;
  tmp_0020 <= migration2_initialAddress_sig when migration2_req_sig = '1' else migration2_initialAddress_local;
  tmp_0021 <= migration2_ecc_sig when migration2_req_sig = '1' else migration2_ecc_local;
  tmp_0022 <= migration2_pageSize_sig when migration2_req_sig = '1' else migration2_pageSize_local;
  tmp_0023 <= '1' when migration2_i_0003 < migration2_pageSize_0002 else '0';
  tmp_0024 <= migration2_i_0003 + X"00000001";
  tmp_0025 <= migration2_initialAddress_0000 + migration2_i_0003;
  tmp_0026 <= migration2_initialAddress_0000 + migration2_i_0003;
  tmp_0027 <= migration2_ecc_0001 + X"00000001";
  tmp_0028 <= not write_req_flag_d;
  tmp_0029 <= write_req_flag and tmp_0028;
  tmp_0030 <= write_req_flag or write_req_flag_d;
  tmp_0031 <= write_req_flag or write_req_flag_d;
  tmp_0032 <= '1' when doEcc_busy = '0' else '0';
  tmp_0033 <= '1' when doEcc_req_local = '0' else '0';
  tmp_0034 <= tmp_0032 and tmp_0033;
  tmp_0035 <= '1' when tmp_0034 = '1' else '0';
  tmp_0036 <= '1' when write_ecc_0018 = X"00000001" else '0';
  tmp_0037 <= '1' when write_ecc_0018 = X"00000002" else '0';
  tmp_0038 <= '1' when write_ecc_0018 = X"00000003" else '0';
  tmp_0039 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0040 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0041 <= tmp_0039 and tmp_0040;
  tmp_0042 <= '1' when tmp_0041 = '1' else '0';
  tmp_0043 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0044 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0045 <= tmp_0043 and tmp_0044;
  tmp_0046 <= '1' when tmp_0045 = '1' else '0';
  tmp_0047 <= '1' when writeRAM_busy = '0' else '0';
  tmp_0048 <= '1' when writeRAM_req_local = '0' else '0';
  tmp_0049 <= tmp_0047 and tmp_0048;
  tmp_0050 <= '1' when tmp_0049 = '1' else '0';
  tmp_0051 <= '1' when write_method /= write_method_S_0000 else '0';
  tmp_0052 <= '1' when write_method /= write_method_S_0001 else '0';
  tmp_0053 <= tmp_0052 and write_req_flag_edge;
  tmp_0054 <= tmp_0051 and tmp_0053;
  tmp_0055 <= not read_req_flag_d;
  tmp_0056 <= read_req_flag and tmp_0055;
  tmp_0057 <= read_req_flag or read_req_flag_d;
  tmp_0058 <= read_req_flag or read_req_flag_d;
  tmp_0059 <= '1' when readRAM_busy = '0' else '0';
  tmp_0060 <= '1' when readRAM_req_local = '0' else '0';
  tmp_0061 <= tmp_0059 and tmp_0060;
  tmp_0062 <= '1' when tmp_0061 = '1' else '0';
  tmp_0063 <= '1' when doEcc_busy = '0' else '0';
  tmp_0064 <= '1' when doEcc_req_local = '0' else '0';
  tmp_0065 <= tmp_0063 and tmp_0064;
  tmp_0066 <= '1' when tmp_0065 = '1' else '0';
  tmp_0067 <= '1' when read_method /= read_method_S_0000 else '0';
  tmp_0068 <= '1' when read_method /= read_method_S_0001 else '0';
  tmp_0069 <= tmp_0068 and read_req_flag_edge;
  tmp_0070 <= tmp_0067 and tmp_0069;
  tmp_0071 <= not writeRAM_req_flag_d;
  tmp_0072 <= writeRAM_req_flag and tmp_0071;
  tmp_0073 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0074 <= writeRAM_req_flag or writeRAM_req_flag_d;
  tmp_0075 <= '1' when writeRAM_method /= writeRAM_method_S_0000 else '0';
  tmp_0076 <= '1' when writeRAM_method /= writeRAM_method_S_0001 else '0';
  tmp_0077 <= tmp_0076 and writeRAM_req_flag_edge;
  tmp_0078 <= tmp_0075 and tmp_0077;
  tmp_0079 <= not readRAM_req_flag_d;
  tmp_0080 <= readRAM_req_flag and tmp_0079;
  tmp_0081 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0082 <= readRAM_req_flag or readRAM_req_flag_d;
  tmp_0083 <= '1' when readRAM_method /= readRAM_method_S_0000 else '0';
  tmp_0084 <= '1' when readRAM_method /= readRAM_method_S_0001 else '0';
  tmp_0085 <= tmp_0084 and readRAM_req_flag_edge;
  tmp_0086 <= tmp_0083 and tmp_0085;
  tmp_0087 <= not doEcc_req_flag_d;
  tmp_0088 <= doEcc_req_flag and tmp_0087;
  tmp_0089 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0090 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0091 <= '1' when doEcc_ecc_0037 = X"00000000" else '0';
  tmp_0092 <= '1' when doEcc_ecc_0037 = X"00000001" else '0';
  tmp_0093 <= '1' when doEcc_ecc_0037 = X"00000002" else '0';
  tmp_0094 <= '1' when doEcc_ecc_0037 = X"00000003" else '0';
  tmp_0095 <= '1' when doReedSolomon_busy = '0' else '0';
  tmp_0096 <= '1' when doReedSolomon_req_local = '0' else '0';
  tmp_0097 <= tmp_0095 and tmp_0096;
  tmp_0098 <= '1' when tmp_0097 = '1' else '0';
  tmp_0099 <= '1' when doHamming_busy = '0' else '0';
  tmp_0100 <= '1' when doHamming_req_local = '0' else '0';
  tmp_0101 <= tmp_0099 and tmp_0100;
  tmp_0102 <= '1' when tmp_0101 = '1' else '0';
  tmp_0103 <= '1' when doParity_busy = '0' else '0';
  tmp_0104 <= '1' when doParity_req_local = '0' else '0';
  tmp_0105 <= tmp_0103 and tmp_0104;
  tmp_0106 <= '1' when tmp_0105 = '1' else '0';
  tmp_0107 <= '1' when doEcc_method /= doEcc_method_S_0000 else '0';
  tmp_0108 <= '1' when doEcc_method /= doEcc_method_S_0001 else '0';
  tmp_0109 <= tmp_0108 and doEcc_req_flag_edge;
  tmp_0110 <= tmp_0107 and tmp_0109;
  tmp_0111 <= not doReedSolomon_req_flag_d;
  tmp_0112 <= doReedSolomon_req_flag and tmp_0111;
  tmp_0113 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0114 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0115 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0000 else '0';
  tmp_0116 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0001 else '0';
  tmp_0117 <= tmp_0116 and doReedSolomon_req_flag_edge;
  tmp_0118 <= tmp_0115 and tmp_0117;
  tmp_0119 <= not doHamming_req_flag_d;
  tmp_0120 <= doHamming_req_flag and tmp_0119;
  tmp_0121 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0122 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0123 <= '1' when doHamming_method /= doHamming_method_S_0000 else '0';
  tmp_0124 <= '1' when doHamming_method /= doHamming_method_S_0001 else '0';
  tmp_0125 <= tmp_0124 and doHamming_req_flag_edge;
  tmp_0126 <= tmp_0123 and tmp_0125;
  tmp_0127 <= not doParity_req_flag_d;
  tmp_0128 <= doParity_req_flag and tmp_0127;
  tmp_0129 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0130 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0131 <= '1' when doParity_method /= doParity_method_S_0000 else '0';
  tmp_0132 <= '1' when doParity_method /= doParity_method_S_0001 else '0';
  tmp_0133 <= tmp_0132 and doParity_req_flag_edge;
  tmp_0134 <= tmp_0131 and tmp_0133;

  -- sequencers
  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_method <= migration2_method_IDLE;
        migration2_method_delay <= (others => '0');
      else
        case (migration2_method) is
          when migration2_method_IDLE => 
            migration2_method <= migration2_method_S_0000;
          when migration2_method_S_0000 => 
            migration2_method <= migration2_method_S_0001;
          when migration2_method_S_0001 => 
            if tmp_0004 = '1' then
              migration2_method <= migration2_method_S_0002;
            end if;
          when migration2_method_S_0002 => 
            migration2_method <= migration2_method_S_0003;
          when migration2_method_S_0003 => 
            migration2_method <= migration2_method_S_0004;
          when migration2_method_S_0004 => 
            if tmp_0006 = '1' then
              migration2_method <= migration2_method_S_0010;
            elsif tmp_0007 = '1' then
              migration2_method <= migration2_method_S_0000;
            end if;
          when migration2_method_S_0006 => 
            migration2_method <= migration2_method_S_0008;
          when migration2_method_S_0008 => 
            migration2_method <= migration2_method_S_0010;
          when migration2_method_S_0010 => 
            migration2_method <= migration2_method_S_0011;
          when migration2_method_S_0011 => 
            migration2_method <= migration2_method_S_0011_body;
          when migration2_method_S_0012 => 
            migration2_method <= migration2_method_S_0015;
          when migration2_method_S_0015 => 
            migration2_method <= migration2_method_S_0015_body;
          when migration2_method_S_0011_body => 
            migration2_method <= migration2_method_S_0011_wait;
          when migration2_method_S_0011_wait => 
            if read_call_flag_0011 = '1' then
              migration2_method <= migration2_method_S_0012;
            end if;
          when migration2_method_S_0015_body => 
            migration2_method <= migration2_method_S_0015_wait;
          when migration2_method_S_0015_wait => 
            if write_call_flag_0015 = '1' then
              migration2_method <= migration2_method_S_0006;
            end if;
          when others => null;
        end case;
        migration2_req_flag_d <= migration2_req_flag;
        if (tmp_0016 and tmp_0018) = '1' then
          migration2_method <= migration2_method_S_0001;
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
            if tmp_0030 = '1' then
              write_method <= write_method_S_0002;
            end if;
          when write_method_S_0002 => 
            write_method <= write_method_S_0002_body;
          when write_method_S_0003 => 
            write_method <= write_method_S_0004;
          when write_method_S_0004 => 
            if tmp_0036 = '1' then
              write_method <= write_method_S_0013;
            elsif tmp_0037 = '1' then
              write_method <= write_method_S_0010;
            elsif tmp_0038 = '1' then
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
        if (tmp_0051 and tmp_0053) = '1' then
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
            if tmp_0057 = '1' then
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
        if (tmp_0067 and tmp_0069) = '1' then
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
            if tmp_0073 = '1' then
              writeRAM_method <= writeRAM_method_S_0000;
            end if;
          when others => null;
        end case;
        writeRAM_req_flag_d <= writeRAM_req_flag;
        if (tmp_0075 and tmp_0077) = '1' then
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
            if tmp_0081 = '1' then
              readRAM_method <= readRAM_method_S_0002;
            end if;
          when readRAM_method_S_0002 => 
            readRAM_method <= readRAM_method_S_0000;
          when others => null;
        end case;
        readRAM_req_flag_d <= readRAM_req_flag;
        if (tmp_0083 and tmp_0085) = '1' then
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
            if tmp_0089 = '1' then
              doEcc_method <= doEcc_method_S_0002;
            end if;
          when doEcc_method_S_0002 => 
            if tmp_0091 = '1' then
              doEcc_method <= doEcc_method_S_0014;
            elsif tmp_0092 = '1' then
              doEcc_method <= doEcc_method_S_0011;
            elsif tmp_0093 = '1' then
              doEcc_method <= doEcc_method_S_0008;
            elsif tmp_0094 = '1' then
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
        if (tmp_0107 and tmp_0109) = '1' then
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
            if tmp_0113 = '1' then
              doReedSolomon_method <= doReedSolomon_method_S_0002;
            end if;
          when doReedSolomon_method_S_0002 => 
            doReedSolomon_method <= doReedSolomon_method_S_0000;
          when others => null;
        end case;
        doReedSolomon_req_flag_d <= doReedSolomon_req_flag;
        if (tmp_0115 and tmp_0117) = '1' then
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
            if tmp_0121 = '1' then
              doHamming_method <= doHamming_method_S_0002;
            end if;
          when doHamming_method_S_0002 => 
            doHamming_method <= doHamming_method_S_0000;
          when others => null;
        end case;
        doHamming_req_flag_d <= doHamming_req_flag;
        if (tmp_0123 and tmp_0125) = '1' then
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
            if tmp_0129 = '1' then
              doParity_method <= doParity_method_S_0002;
            end if;
          when doParity_method_S_0002 => 
            doParity_method <= doParity_method_S_0000;
          when others => null;
        end case;
        doParity_req_flag_d <= doParity_req_flag;
        if (tmp_0131 and tmp_0133) = '1' then
          doParity_method <= doParity_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_initialAddress_0000 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0001 then
          migration2_initialAddress_0000 <= tmp_0020;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_ecc_0001 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0001 then
          migration2_ecc_0001 <= tmp_0021;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_pageSize_0002 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0001 then
          migration2_pageSize_0002 <= tmp_0022;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_i_0003 <= X"00000000";
      else
        if migration2_method = migration2_method_S_0002 then
          migration2_i_0003 <= X"00000000";
        elsif migration2_method = migration2_method_S_0008 then
          migration2_i_0003 <= unary_expr_00006;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00005 <= '0';
      else
        if migration2_method = migration2_method_S_0003 then
          binary_expr_00005 <= tmp_0023;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_00006 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0006 then
          unary_expr_00006 <= tmp_0024;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        unary_expr_postfix_preserved_00007 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0006 then
          unary_expr_postfix_preserved_00007 <= migration2_i_0003;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00010 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0011_wait then
          method_result_00010 <= read_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00011 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0010 then
          binary_expr_00011 <= tmp_0025;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        migration2_read_0009 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0012 then
          migration2_read_0009 <= method_result_00010;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00013 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0012 then
          binary_expr_00013 <= tmp_0026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00015 <= (others => '0');
      else
        if migration2_method = migration2_method_S_0012 then
          binary_expr_00015 <= tmp_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_address_0016 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_address_0016 <= write_address_local;
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
        if migration2_method = migration2_method_S_0015_body and migration2_method_delay = 0 then
          write_address_local <= binary_expr_00013;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_data_0017 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_data_0017 <= write_data_local;
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
        if migration2_method = migration2_method_S_0015_body and migration2_method_delay = 0 then
          write_data_local <= migration2_read_0009;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_ecc_0018 <= (others => '0');
      else
        if write_method = write_method_S_0001 then
          write_ecc_0018 <= write_ecc_local;
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
        if migration2_method = migration2_method_S_0015_body and migration2_method_delay = 0 then
          write_ecc_local <= binary_expr_00015;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00020 <= (others => '0');
      else
        if write_method = write_method_S_0002_wait then
          method_result_00020 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_newData_0019 <= (others => '0');
      else
        if write_method = write_method_S_0003 then
          write_newData_0019 <= method_result_00020;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_address_0027 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_address_0027 <= read_address_local;
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
        if migration2_method = migration2_method_S_0011_body and migration2_method_delay = 0 then
          read_address_local <= binary_expr_00011;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_ecc_0028 <= (others => '0');
      else
        if read_method = read_method_S_0001 then
          read_ecc_0028 <= read_ecc_local;
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
        if migration2_method = migration2_method_S_0011_body and migration2_method_delay = 0 then
          read_ecc_local <= migration2_ecc_0001;
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
        if read_method = read_method_S_0002_wait then
          method_result_00030 <= readRAM_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        read_data_0029 <= (others => '0');
      else
        if read_method = read_method_S_0003 then
          read_data_0029 <= method_result_00030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00031 <= (others => '0');
      else
        if read_method = read_method_S_0004_wait then
          method_result_00031 <= doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_address_0032 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_address_0032 <= writeRAM_address_local;
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
          writeRAM_address_local <= write_address_0016;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0016;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_address_local <= write_address_0016;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeRAM_data_0033 <= (others => '0');
      else
        if writeRAM_method = writeRAM_method_S_0001 then
          writeRAM_data_0033 <= writeRAM_data_local;
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
          writeRAM_data_local <= write_newData_0019;
        elsif write_method = write_method_S_0010_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0019;
        elsif write_method = write_method_S_0013_body and write_method_delay = 0 then
          writeRAM_data_local <= write_newData_0019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readRAM_address_0034 <= (others => '0');
      else
        if readRAM_method = readRAM_method_S_0001 then
          readRAM_address_0034 <= readRAM_address_local;
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
          readRAM_address_local <= read_address_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_data_0036 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_data_0036 <= doEcc_data_local;
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
          doEcc_data_local <= write_data_0017;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          doEcc_data_local <= read_data_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_ecc_0037 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_ecc_0037 <= doEcc_ecc_local;
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
          doEcc_ecc_local <= write_ecc_0018;
        elsif read_method = read_method_S_0004_body and read_method_delay = 0 then
          doEcc_ecc_local <= read_ecc_0028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00042 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0005_wait then
          method_result_00042 <= doReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00043 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0008_wait then
          method_result_00043 <= doHamming_return;
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
        if doEcc_method = doEcc_method_S_0011_wait then
          method_result_00044 <= doParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_data_0045 <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0001 then
          doReedSolomon_data_0045 <= doReedSolomon_data_local;
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
          doReedSolomon_data_local <= doEcc_data_0036;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_data_0046 <= (others => '0');
      else
        if doHamming_method = doHamming_method_S_0001 then
          doHamming_data_0046 <= doHamming_data_local;
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
          doHamming_data_local <= doEcc_data_0036;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_data_0047 <= (others => '0');
      else
        if doParity_method = doParity_method_S_0001 then
          doParity_data_0047 <= doParity_data_local;
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
          doParity_data_local <= doEcc_data_0036;
        end if;
      end if;
    end if;
  end process;

  migration2_req_flag <= tmp_0001;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        write_busy <= '0';
      else
        if write_method = write_method_S_0000 then
          write_busy <= '0';
        elsif write_method = write_method_S_0001 then
          write_busy <= tmp_0031;
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
        if migration2_method = migration2_method_S_0015_body then
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
          read_return <= method_result_00031;
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
          read_busy <= tmp_0058;
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
        if migration2_method = migration2_method_S_0011_body then
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
          writeRAM_busy <= tmp_0074;
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
          readRAM_busy <= tmp_0082;
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
          doEcc_return <= method_result_00042;
        elsif doEcc_method = doEcc_method_S_0009 then
          doEcc_return <= method_result_00043;
        elsif doEcc_method = doEcc_method_S_0012 then
          doEcc_return <= method_result_00044;
        elsif doEcc_method = doEcc_method_S_0014 then
          doEcc_return <= doEcc_data_0036;
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
          doEcc_busy <= tmp_0090;
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
          doReedSolomon_return <= doReedSolomon_data_0045;
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
          doReedSolomon_busy <= tmp_0114;
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
          doHamming_return <= doHamming_data_0046;
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
          doHamming_busy <= tmp_0122;
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
          doParity_return <= doParity_data_0047;
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
          doParity_busy <= tmp_0130;
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

  migration2_req_flag_edge <= tmp_0003;

  read_call_flag_0011 <= tmp_0011;

  write_call_flag_0015 <= tmp_0015;

  write_req_flag_edge <= tmp_0029;

  doEcc_call_flag_0002 <= tmp_0035;

  writeRAM_call_flag_0007 <= tmp_0042;

  writeRAM_call_flag_0010 <= tmp_0046;

  writeRAM_call_flag_0013 <= tmp_0050;

  read_req_flag_edge <= tmp_0056;

  readRAM_call_flag_0002 <= tmp_0062;

  doEcc_call_flag_0004 <= tmp_0066;

  writeRAM_req_flag_edge <= tmp_0072;

  readRAM_req_flag_edge <= tmp_0080;

  doEcc_req_flag_edge <= tmp_0088;

  doReedSolomon_call_flag_0005 <= tmp_0098;

  doHamming_call_flag_0008 <= tmp_0102;

  doParity_call_flag_0011 <= tmp_0106;

  doReedSolomon_req_flag_edge <= tmp_0112;

  doHamming_req_flag_edge <= tmp_0120;

  doParity_req_flag_edge <= tmp_0128;



end RTL;
