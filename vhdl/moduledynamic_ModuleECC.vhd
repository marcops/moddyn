library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleECC is
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
end moduledynamic_ModuleECC;

architecture RTL of moduledynamic_ModuleECC is

  attribute mark_debug : string;
  attribute keep : string;
  attribute S : string;


  signal clk_sig : std_logic := '0';
  signal reset_sig : std_logic := '0';
  signal checkECC_data_sig : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_sig : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_sig : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_sig : signed(32-1 downto 0) := (others => '0');
  signal checkECC_return_sig : std_logic := '0';
  signal checkECC_busy_sig : std_logic := '1';
  signal checkECC_req_sig : std_logic := '0';
  signal doEcc_return_sig : signed(32-1 downto 0) := (others => '0');
  signal doEcc_busy_sig : std_logic := '1';
  signal doEcc_req_sig : std_logic := '0';

  signal checkECC_data_0000 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_0001 : signed(32-1 downto 0) := (others => '0');
  signal checkECC_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00006 : std_logic := '0';
  signal method_result_00007 : std_logic := '0';
  signal method_result_00008 : std_logic := '0';
  signal doEcc_data_0010 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_data_local : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_0011 : signed(32-1 downto 0) := (others => '0');
  signal doEcc_ecc_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00016 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00017 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00018 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_0019 : signed(32-1 downto 0) := (others => '0');
  signal doReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_0020 : signed(32-1 downto 0) := (others => '0');
  signal doHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_0021 : signed(32-1 downto 0) := (others => '0');
  signal doParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_data_0022 : signed(32-1 downto 0) := (others => '0');
  signal checkReedSolomon_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_data_0024 : signed(32-1 downto 0) := (others => '0');
  signal checkHamming_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkParity_data_0026 : signed(32-1 downto 0) := (others => '0');
  signal checkParity_data_local : signed(32-1 downto 0) := (others => '0');
  signal checkECC_req_flag : std_logic := '0';
  signal checkECC_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal doEcc_req_flag : std_logic := '0';
  signal doEcc_req_local : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
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
  signal tmp_0003 : std_logic := '0';
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal checkReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal checkHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal checkParity_call_flag_0011 : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
  signal tmp_0020 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0028 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0029 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal doReedSolomon_call_flag_0005 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal doHamming_call_flag_0008 : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : std_logic := '0';
  signal doParity_call_flag_0011 : std_logic := '0';
  signal tmp_0045 : std_logic := '0';
  signal tmp_0046 : std_logic := '0';
  signal tmp_0047 : std_logic := '0';
  signal tmp_0048 : std_logic := '0';
  signal tmp_0049 : std_logic := '0';
  signal tmp_0050 : std_logic := '0';
  signal tmp_0051 : std_logic := '0';
  signal tmp_0052 : std_logic := '0';
  signal tmp_0053 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0054 : signed(32-1 downto 0) := (others => '0');
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
  signal tmp_0055 : std_logic := '0';
  signal tmp_0056 : std_logic := '0';
  signal tmp_0057 : std_logic := '0';
  signal tmp_0058 : std_logic := '0';
  signal tmp_0059 : std_logic := '0';
  signal tmp_0060 : std_logic := '0';
  signal tmp_0061 : std_logic := '0';
  signal tmp_0062 : std_logic := '0';
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
  signal tmp_0063 : std_logic := '0';
  signal tmp_0064 : std_logic := '0';
  signal tmp_0065 : std_logic := '0';
  signal tmp_0066 : std_logic := '0';
  signal tmp_0067 : std_logic := '0';
  signal tmp_0068 : std_logic := '0';
  signal tmp_0069 : std_logic := '0';
  signal tmp_0070 : std_logic := '0';
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
  signal tmp_0071 : std_logic := '0';
  signal tmp_0072 : std_logic := '0';
  signal tmp_0073 : std_logic := '0';
  signal tmp_0074 : std_logic := '0';
  signal tmp_0075 : std_logic := '0';
  signal tmp_0076 : std_logic := '0';
  signal tmp_0077 : std_logic := '0';
  signal tmp_0078 : std_logic := '0';
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
  signal tmp_0079 : std_logic := '0';
  signal tmp_0080 : std_logic := '0';
  signal tmp_0081 : std_logic := '0';
  signal tmp_0082 : std_logic := '0';
  signal tmp_0083 : std_logic := '0';
  signal tmp_0084 : std_logic := '0';
  signal tmp_0085 : std_logic := '0';
  signal tmp_0086 : std_logic := '0';
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
  signal tmp_0087 : std_logic := '0';
  signal tmp_0088 : std_logic := '0';
  signal tmp_0089 : std_logic := '0';
  signal tmp_0090 : std_logic := '0';
  signal tmp_0091 : std_logic := '0';
  signal tmp_0092 : std_logic := '0';
  signal tmp_0093 : std_logic := '0';
  signal tmp_0094 : std_logic := '0';
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
  signal tmp_0095 : std_logic := '0';
  signal tmp_0096 : std_logic := '0';
  signal tmp_0097 : std_logic := '0';
  signal tmp_0098 : std_logic := '0';
  signal tmp_0099 : std_logic := '0';
  signal tmp_0100 : std_logic := '0';
  signal tmp_0101 : std_logic := '0';
  signal tmp_0102 : std_logic := '0';

begin

  clk_sig <= clk;
  reset_sig <= reset;
  checkECC_data_sig <= checkECC_data;
  checkECC_ecc_sig <= checkECC_ecc;
  doEcc_data_sig <= doEcc_data;
  doEcc_ecc_sig <= doEcc_ecc;
  checkECC_return <= checkECC_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_return_sig <= '0';
      else
        if checkECC_method = checkECC_method_S_0006 then
          checkECC_return_sig <= method_result_00006;
        elsif checkECC_method = checkECC_method_S_0009 then
          checkECC_return_sig <= method_result_00007;
        elsif checkECC_method = checkECC_method_S_0012 then
          checkECC_return_sig <= method_result_00008;
        elsif checkECC_method = checkECC_method_S_0014 then
          checkECC_return_sig <= '1';
        end if;
      end if;
    end if;
  end process;

  checkECC_busy <= checkECC_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_busy_sig <= '1';
      else
        if checkECC_method = checkECC_method_S_0000 then
          checkECC_busy_sig <= '0';
        elsif checkECC_method = checkECC_method_S_0001 then
          checkECC_busy_sig <= tmp_0006;
        end if;
      end if;
    end if;
  end process;

  checkECC_req_sig <= checkECC_req;
  doEcc_return <= doEcc_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_return_sig <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0006 then
          doEcc_return_sig <= method_result_00016;
        elsif doEcc_method = doEcc_method_S_0009 then
          doEcc_return_sig <= method_result_00017;
        elsif doEcc_method = doEcc_method_S_0012 then
          doEcc_return_sig <= method_result_00018;
        elsif doEcc_method = doEcc_method_S_0014 then
          doEcc_return_sig <= doEcc_data_0010;
        end if;
      end if;
    end if;
  end process;

  doEcc_busy <= doEcc_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_busy_sig <= '1';
      else
        if doEcc_method = doEcc_method_S_0000 then
          doEcc_busy_sig <= '0';
        elsif doEcc_method = doEcc_method_S_0001 then
          doEcc_busy_sig <= tmp_0032;
        end if;
      end if;
    end if;
  end process;

  doEcc_req_sig <= doEcc_req;

  -- expressions
  tmp_0001 <= checkECC_req_local or checkECC_req_sig;
  tmp_0002 <= doEcc_req_local or doEcc_req_sig;
  tmp_0003 <= not checkECC_req_flag_d;
  tmp_0004 <= checkECC_req_flag and tmp_0003;
  tmp_0005 <= checkECC_req_flag or checkECC_req_flag_d;
  tmp_0006 <= checkECC_req_flag or checkECC_req_flag_d;
  tmp_0007 <= '1' when checkECC_ecc_0001 = X"00000000" else '0';
  tmp_0008 <= '1' when checkECC_ecc_0001 = X"00000001" else '0';
  tmp_0009 <= '1' when checkECC_ecc_0001 = X"00000002" else '0';
  tmp_0010 <= '1' when checkECC_ecc_0001 = X"00000003" else '0';
  tmp_0011 <= '1' when checkReedSolomon_busy = '0' else '0';
  tmp_0012 <= '1' when checkReedSolomon_req_local = '0' else '0';
  tmp_0013 <= tmp_0011 and tmp_0012;
  tmp_0014 <= '1' when tmp_0013 = '1' else '0';
  tmp_0015 <= '1' when checkHamming_busy = '0' else '0';
  tmp_0016 <= '1' when checkHamming_req_local = '0' else '0';
  tmp_0017 <= tmp_0015 and tmp_0016;
  tmp_0018 <= '1' when tmp_0017 = '1' else '0';
  tmp_0019 <= '1' when checkParity_busy = '0' else '0';
  tmp_0020 <= '1' when checkParity_req_local = '0' else '0';
  tmp_0021 <= tmp_0019 and tmp_0020;
  tmp_0022 <= '1' when tmp_0021 = '1' else '0';
  tmp_0023 <= '1' when checkECC_method /= checkECC_method_S_0000 else '0';
  tmp_0024 <= '1' when checkECC_method /= checkECC_method_S_0001 else '0';
  tmp_0025 <= tmp_0024 and checkECC_req_flag_edge;
  tmp_0026 <= tmp_0023 and tmp_0025;
  tmp_0027 <= checkECC_data_sig when checkECC_req_sig = '1' else checkECC_data_local;
  tmp_0028 <= checkECC_ecc_sig when checkECC_req_sig = '1' else checkECC_ecc_local;
  tmp_0029 <= not doEcc_req_flag_d;
  tmp_0030 <= doEcc_req_flag and tmp_0029;
  tmp_0031 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0032 <= doEcc_req_flag or doEcc_req_flag_d;
  tmp_0033 <= '1' when doEcc_ecc_0011 = X"00000000" else '0';
  tmp_0034 <= '1' when doEcc_ecc_0011 = X"00000001" else '0';
  tmp_0035 <= '1' when doEcc_ecc_0011 = X"00000002" else '0';
  tmp_0036 <= '1' when doEcc_ecc_0011 = X"00000003" else '0';
  tmp_0037 <= '1' when doReedSolomon_busy = '0' else '0';
  tmp_0038 <= '1' when doReedSolomon_req_local = '0' else '0';
  tmp_0039 <= tmp_0037 and tmp_0038;
  tmp_0040 <= '1' when tmp_0039 = '1' else '0';
  tmp_0041 <= '1' when doHamming_busy = '0' else '0';
  tmp_0042 <= '1' when doHamming_req_local = '0' else '0';
  tmp_0043 <= tmp_0041 and tmp_0042;
  tmp_0044 <= '1' when tmp_0043 = '1' else '0';
  tmp_0045 <= '1' when doParity_busy = '0' else '0';
  tmp_0046 <= '1' when doParity_req_local = '0' else '0';
  tmp_0047 <= tmp_0045 and tmp_0046;
  tmp_0048 <= '1' when tmp_0047 = '1' else '0';
  tmp_0049 <= '1' when doEcc_method /= doEcc_method_S_0000 else '0';
  tmp_0050 <= '1' when doEcc_method /= doEcc_method_S_0001 else '0';
  tmp_0051 <= tmp_0050 and doEcc_req_flag_edge;
  tmp_0052 <= tmp_0049 and tmp_0051;
  tmp_0053 <= doEcc_data_sig when doEcc_req_sig = '1' else doEcc_data_local;
  tmp_0054 <= doEcc_ecc_sig when doEcc_req_sig = '1' else doEcc_ecc_local;
  tmp_0055 <= not doReedSolomon_req_flag_d;
  tmp_0056 <= doReedSolomon_req_flag and tmp_0055;
  tmp_0057 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0058 <= doReedSolomon_req_flag or doReedSolomon_req_flag_d;
  tmp_0059 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0000 else '0';
  tmp_0060 <= '1' when doReedSolomon_method /= doReedSolomon_method_S_0001 else '0';
  tmp_0061 <= tmp_0060 and doReedSolomon_req_flag_edge;
  tmp_0062 <= tmp_0059 and tmp_0061;
  tmp_0063 <= not doHamming_req_flag_d;
  tmp_0064 <= doHamming_req_flag and tmp_0063;
  tmp_0065 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0066 <= doHamming_req_flag or doHamming_req_flag_d;
  tmp_0067 <= '1' when doHamming_method /= doHamming_method_S_0000 else '0';
  tmp_0068 <= '1' when doHamming_method /= doHamming_method_S_0001 else '0';
  tmp_0069 <= tmp_0068 and doHamming_req_flag_edge;
  tmp_0070 <= tmp_0067 and tmp_0069;
  tmp_0071 <= not doParity_req_flag_d;
  tmp_0072 <= doParity_req_flag and tmp_0071;
  tmp_0073 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0074 <= doParity_req_flag or doParity_req_flag_d;
  tmp_0075 <= '1' when doParity_method /= doParity_method_S_0000 else '0';
  tmp_0076 <= '1' when doParity_method /= doParity_method_S_0001 else '0';
  tmp_0077 <= tmp_0076 and doParity_req_flag_edge;
  tmp_0078 <= tmp_0075 and tmp_0077;
  tmp_0079 <= not checkReedSolomon_req_flag_d;
  tmp_0080 <= checkReedSolomon_req_flag and tmp_0079;
  tmp_0081 <= checkReedSolomon_req_flag or checkReedSolomon_req_flag_d;
  tmp_0082 <= checkReedSolomon_req_flag or checkReedSolomon_req_flag_d;
  tmp_0083 <= '1' when checkReedSolomon_method /= checkReedSolomon_method_S_0000 else '0';
  tmp_0084 <= '1' when checkReedSolomon_method /= checkReedSolomon_method_S_0001 else '0';
  tmp_0085 <= tmp_0084 and checkReedSolomon_req_flag_edge;
  tmp_0086 <= tmp_0083 and tmp_0085;
  tmp_0087 <= not checkHamming_req_flag_d;
  tmp_0088 <= checkHamming_req_flag and tmp_0087;
  tmp_0089 <= checkHamming_req_flag or checkHamming_req_flag_d;
  tmp_0090 <= checkHamming_req_flag or checkHamming_req_flag_d;
  tmp_0091 <= '1' when checkHamming_method /= checkHamming_method_S_0000 else '0';
  tmp_0092 <= '1' when checkHamming_method /= checkHamming_method_S_0001 else '0';
  tmp_0093 <= tmp_0092 and checkHamming_req_flag_edge;
  tmp_0094 <= tmp_0091 and tmp_0093;
  tmp_0095 <= not checkParity_req_flag_d;
  tmp_0096 <= checkParity_req_flag and tmp_0095;
  tmp_0097 <= checkParity_req_flag or checkParity_req_flag_d;
  tmp_0098 <= checkParity_req_flag or checkParity_req_flag_d;
  tmp_0099 <= '1' when checkParity_method /= checkParity_method_S_0000 else '0';
  tmp_0100 <= '1' when checkParity_method /= checkParity_method_S_0001 else '0';
  tmp_0101 <= tmp_0100 and checkParity_req_flag_edge;
  tmp_0102 <= tmp_0099 and tmp_0101;

  -- sequencers
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
            if tmp_0005 = '1' then
              checkECC_method <= checkECC_method_S_0002;
            end if;
          when checkECC_method_S_0002 => 
            if tmp_0007 = '1' then
              checkECC_method <= checkECC_method_S_0014;
            elsif tmp_0008 = '1' then
              checkECC_method <= checkECC_method_S_0011;
            elsif tmp_0009 = '1' then
              checkECC_method <= checkECC_method_S_0008;
            elsif tmp_0010 = '1' then
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
        if (tmp_0023 and tmp_0025) = '1' then
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
            if tmp_0031 = '1' then
              doEcc_method <= doEcc_method_S_0002;
            end if;
          when doEcc_method_S_0002 => 
            if tmp_0033 = '1' then
              doEcc_method <= doEcc_method_S_0014;
            elsif tmp_0034 = '1' then
              doEcc_method <= doEcc_method_S_0011;
            elsif tmp_0035 = '1' then
              doEcc_method <= doEcc_method_S_0008;
            elsif tmp_0036 = '1' then
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
        if (tmp_0049 and tmp_0051) = '1' then
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
            if tmp_0057 = '1' then
              doReedSolomon_method <= doReedSolomon_method_S_0002;
            end if;
          when doReedSolomon_method_S_0002 => 
            doReedSolomon_method <= doReedSolomon_method_S_0000;
          when others => null;
        end case;
        doReedSolomon_req_flag_d <= doReedSolomon_req_flag;
        if (tmp_0059 and tmp_0061) = '1' then
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
            if tmp_0065 = '1' then
              doHamming_method <= doHamming_method_S_0002;
            end if;
          when doHamming_method_S_0002 => 
            doHamming_method <= doHamming_method_S_0000;
          when others => null;
        end case;
        doHamming_req_flag_d <= doHamming_req_flag;
        if (tmp_0067 and tmp_0069) = '1' then
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
            if tmp_0073 = '1' then
              doParity_method <= doParity_method_S_0002;
            end if;
          when doParity_method_S_0002 => 
            doParity_method <= doParity_method_S_0000;
          when others => null;
        end case;
        doParity_req_flag_d <= doParity_req_flag;
        if (tmp_0075 and tmp_0077) = '1' then
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
            if tmp_0081 = '1' then
              checkReedSolomon_method <= checkReedSolomon_method_S_0002;
            end if;
          when checkReedSolomon_method_S_0002 => 
            checkReedSolomon_method <= checkReedSolomon_method_S_0000;
          when others => null;
        end case;
        checkReedSolomon_req_flag_d <= checkReedSolomon_req_flag;
        if (tmp_0083 and tmp_0085) = '1' then
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
            if tmp_0089 = '1' then
              checkHamming_method <= checkHamming_method_S_0002;
            end if;
          when checkHamming_method_S_0002 => 
            checkHamming_method <= checkHamming_method_S_0000;
          when others => null;
        end case;
        checkHamming_req_flag_d <= checkHamming_req_flag;
        if (tmp_0091 and tmp_0093) = '1' then
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
            if tmp_0097 = '1' then
              checkParity_method <= checkParity_method_S_0002;
            end if;
          when checkParity_method_S_0002 => 
            checkParity_method <= checkParity_method_S_0000;
          when others => null;
        end case;
        checkParity_req_flag_d <= checkParity_req_flag;
        if (tmp_0099 and tmp_0101) = '1' then
          checkParity_method <= checkParity_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_data_0000 <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0001 then
          checkECC_data_0000 <= tmp_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkECC_ecc_0001 <= (others => '0');
      else
        if checkECC_method = checkECC_method_S_0001 then
          checkECC_ecc_0001 <= tmp_0028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00006 <= '0';
      else
        if checkECC_method = checkECC_method_S_0005_wait then
          method_result_00006 <= checkReedSolomon_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00007 <= '0';
      else
        if checkECC_method = checkECC_method_S_0008_wait then
          method_result_00007 <= checkHamming_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00008 <= '0';
      else
        if checkECC_method = checkECC_method_S_0011_wait then
          method_result_00008 <= checkParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_data_0010 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_data_0010 <= tmp_0053;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doEcc_ecc_0011 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0001 then
          doEcc_ecc_0011 <= tmp_0054;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00016 <= (others => '0');
      else
        if doEcc_method = doEcc_method_S_0005_wait then
          method_result_00016 <= doReedSolomon_return;
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
        if doEcc_method = doEcc_method_S_0008_wait then
          method_result_00017 <= doHamming_return;
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
        if doEcc_method = doEcc_method_S_0011_wait then
          method_result_00018 <= doParity_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_data_0019 <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0001 then
          doReedSolomon_data_0019 <= doReedSolomon_data_local;
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
          doReedSolomon_data_local <= doEcc_data_0010;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doHamming_data_0020 <= (others => '0');
      else
        if doHamming_method = doHamming_method_S_0001 then
          doHamming_data_0020 <= doHamming_data_local;
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
          doHamming_data_local <= doEcc_data_0010;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doParity_data_0021 <= (others => '0');
      else
        if doParity_method = doParity_method_S_0001 then
          doParity_data_0021 <= doParity_data_local;
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
          doParity_data_local <= doEcc_data_0010;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkReedSolomon_data_0022 <= (others => '0');
      else
        if checkReedSolomon_method = checkReedSolomon_method_S_0001 then
          checkReedSolomon_data_0022 <= checkReedSolomon_data_local;
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
          checkReedSolomon_data_local <= checkECC_data_0000;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkHamming_data_0024 <= (others => '0');
      else
        if checkHamming_method = checkHamming_method_S_0001 then
          checkHamming_data_0024 <= checkHamming_data_local;
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
          checkHamming_data_local <= checkECC_data_0000;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        checkParity_data_0026 <= (others => '0');
      else
        if checkParity_method = checkParity_method_S_0001 then
          checkParity_data_0026 <= checkParity_data_local;
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
          checkParity_data_local <= checkECC_data_0000;
        end if;
      end if;
    end if;
  end process;

  checkECC_req_flag <= tmp_0001;

  doEcc_req_flag <= tmp_0002;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        doReedSolomon_return <= (others => '0');
      else
        if doReedSolomon_method = doReedSolomon_method_S_0002 then
          doReedSolomon_return <= doReedSolomon_data_0019;
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
          doReedSolomon_busy <= tmp_0058;
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
          doHamming_return <= doHamming_data_0020;
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
          doHamming_busy <= tmp_0066;
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
          doParity_return <= doParity_data_0021;
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
          doParity_busy <= tmp_0074;
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
          checkReedSolomon_busy <= tmp_0082;
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
          checkHamming_busy <= tmp_0090;
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
          checkParity_busy <= tmp_0098;
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

  checkECC_req_flag_edge <= tmp_0004;

  checkReedSolomon_call_flag_0005 <= tmp_0014;

  checkHamming_call_flag_0008 <= tmp_0018;

  checkParity_call_flag_0011 <= tmp_0022;

  doEcc_req_flag_edge <= tmp_0030;

  doReedSolomon_call_flag_0005 <= tmp_0040;

  doHamming_call_flag_0008 <= tmp_0044;

  doParity_call_flag_0011 <= tmp_0048;

  doReedSolomon_req_flag_edge <= tmp_0056;

  doHamming_req_flag_edge <= tmp_0064;

  doParity_req_flag_edge <= tmp_0072;

  checkReedSolomon_req_flag_edge <= tmp_0080;

  checkHamming_req_flag_edge <= tmp_0088;

  checkParity_req_flag_edge <= tmp_0096;



end RTL;
