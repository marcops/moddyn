library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_MemoryAccess is
  port (
    clk : in std_logic;
    reset : in std_logic;
    pageSize_in : in signed(32-1 downto 0);
    pageSize_we : in std_logic;
    pageSize_out : out signed(32-1 downto 0);
    getEcc_address : in signed(32-1 downto 0);
    incrementEcc_address : in signed(32-1 downto 0);
    getEcc_return : out signed(32-1 downto 0);
    getEcc_busy : out std_logic;
    getEcc_req : in std_logic;
    incrementEcc_busy : out std_logic;
    incrementEcc_req : in std_logic
  );
end moduledynamic_MemoryAccess;

architecture RTL of moduledynamic_MemoryAccess is

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
  signal pageSize_in_sig : signed(32-1 downto 0) := (others => '0');
  signal pageSize_we_sig : std_logic := '0';
  signal pageSize_out_sig : signed(32-1 downto 0) := (others => '0');
  signal getEcc_address_sig : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_address_sig : signed(32-1 downto 0) := (others => '0');
  signal getEcc_return_sig : signed(32-1 downto 0) := (others => '0');
  signal getEcc_busy_sig : std_logic := '1';
  signal getEcc_req_sig : std_logic := '0';
  signal incrementEcc_busy_sig : std_logic := '1';
  signal incrementEcc_req_sig : std_logic := '0';

  signal class_DEFAULT_PAGE_SIZE_0000 : signed(32-1 downto 0) := X"00007d00";
  signal class_DEFAULT_MEMORY_SIZE_PER_BLOCK_0002 : signed(32-1 downto 0) := X"0003e800";
  signal class_BYTE_SIZE_0004 : signed(32-1 downto 0) := X"00000008";
  signal class_pageSize_0006 : signed(32-1 downto 0) := (others => '0');
  signal class_pageSize_0006_mux : signed(32-1 downto 0) := (others => '0');
  signal tmp_0001 : signed(32-1 downto 0) := (others => '0');
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
  signal getEcc_address_0013 : signed(32-1 downto 0) := (others => '0');
  signal getEcc_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00015 : signed(32-1 downto 0) := (others => '0');
  signal getEcc_dataPosition_0014 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00017 : std_logic := '0';
  signal getEcc_currentData1_0016 : std_logic := '0';
  signal array_access_00019 : std_logic := '0';
  signal getEcc_currentData2_0018 : std_logic := '0';
  signal cond_expr_00022 : signed(32-1 downto 0) := (others => '0');
  signal cond_expr_00025 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00026 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_0027 : signed(32-1 downto 0) := (others => '0');
  signal getPosition_address_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00028 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00029 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_address_0030 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_address_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00032 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_dataPosition_0031 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00034 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_ecc_0033 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00040 : std_logic := '0';
  signal array_access_00042 : std_logic := '0';
  signal array_access_00044 : std_logic := '0';
  signal array_access_00046 : std_logic := '0';
  signal array_access_00048 : std_logic := '0';
  signal array_access_00050 : std_logic := '0';
  signal array_access_00052 : std_logic := '0';
  signal array_access_00054 : std_logic := '0';
  signal getEcc_req_flag : std_logic := '0';
  signal getEcc_req_local : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal getPosition_return : signed(32-1 downto 0) := (others => '0');
  signal getPosition_busy : std_logic := '0';
  signal getPosition_req_flag : std_logic := '0';
  signal getPosition_req_local : std_logic := '0';
  signal incrementEcc_req_flag : std_logic := '0';
  signal incrementEcc_req_local : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
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
  signal tmp_0004 : std_logic := '0';
  signal tmp_0005 : std_logic := '0';
  signal tmp_0006 : std_logic := '0';
  signal tmp_0007 : std_logic := '0';
  signal getPosition_call_flag_0002 : std_logic := '0';
  signal tmp_0008 : std_logic := '0';
  signal tmp_0009 : std_logic := '0';
  signal tmp_0010 : std_logic := '0';
  signal tmp_0011 : std_logic := '0';
  signal tmp_0012 : std_logic := '0';
  signal tmp_0013 : std_logic := '0';
  signal tmp_0014 : std_logic := '0';
  signal tmp_0015 : std_logic := '0';
  signal tmp_0016 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0017 : signed(32-1 downto 0) := (others => '0');
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
  type Type_incrementEcc_method is (
    incrementEcc_method_IDLE,
    incrementEcc_method_S_0000,
    incrementEcc_method_S_0001,
    incrementEcc_method_S_0002,
    incrementEcc_method_S_0003,
    incrementEcc_method_S_0004,
    incrementEcc_method_S_0005,
    incrementEcc_method_S_0006,
    incrementEcc_method_S_0009,
    incrementEcc_method_S_0011,
    incrementEcc_method_S_0013,
    incrementEcc_method_S_0015,
    incrementEcc_method_S_0017,
    incrementEcc_method_S_0019,
    incrementEcc_method_S_0021,
    incrementEcc_method_S_0023,
    incrementEcc_method_S_0025,
    incrementEcc_method_S_0027,
    incrementEcc_method_S_0029,
    incrementEcc_method_S_0031,
    incrementEcc_method_S_0002_body,
    incrementEcc_method_S_0002_wait,
    incrementEcc_method_S_0004_body,
    incrementEcc_method_S_0004_wait  
  );
  signal incrementEcc_method : Type_incrementEcc_method := incrementEcc_method_IDLE;
  signal incrementEcc_method_prev : Type_incrementEcc_method := incrementEcc_method_IDLE;
  signal incrementEcc_method_delay : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_req_flag_d : std_logic := '0';
  signal incrementEcc_req_flag_edge : std_logic := '0';
  signal tmp_0028 : std_logic := '0';
  signal tmp_0029 : std_logic := '0';
  signal tmp_0030 : std_logic := '0';
  signal tmp_0031 : std_logic := '0';
  signal getEcc_call_flag_0004 : std_logic := '0';
  signal tmp_0032 : std_logic := '0';
  signal tmp_0033 : std_logic := '0';
  signal tmp_0034 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal tmp_0041 : std_logic := '0';
  signal tmp_0042 : std_logic := '0';
  signal tmp_0043 : std_logic := '0';
  signal tmp_0044 : signed(32-1 downto 0) := (others => '0');

begin

  clk_sig <= clk;
  reset_sig <= reset;
  pageSize_in_sig <= pageSize_in;
  pageSize_we_sig <= pageSize_we;
  pageSize_out <= pageSize_out_sig;
  pageSize_out_sig <= class_pageSize_0006;

  getEcc_address_sig <= getEcc_address;
  incrementEcc_address_sig <= incrementEcc_address;
  getEcc_return <= getEcc_return_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_return_sig <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0011 then
          getEcc_return_sig <= binary_expr_00026;
        end if;
      end if;
    end if;
  end process;

  getEcc_busy <= getEcc_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_busy_sig <= '1';
      else
        if getEcc_method = getEcc_method_S_0000 then
          getEcc_busy_sig <= '0';
        elsif getEcc_method = getEcc_method_S_0001 then
          getEcc_busy_sig <= tmp_0007;
        end if;
      end if;
    end if;
  end process;

  getEcc_req_sig <= getEcc_req;
  incrementEcc_busy <= incrementEcc_busy_sig;
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_busy_sig <= '1';
      else
        if incrementEcc_method = incrementEcc_method_S_0000 then
          incrementEcc_busy_sig <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_busy_sig <= tmp_0031;
        end if;
      end if;
    end if;
  end process;

  incrementEcc_req_sig <= incrementEcc_req;

  -- expressions
  tmp_0001 <= pageSize_in_sig when pageSize_we_sig = '1' else class_pageSize_0006;
  tmp_0002 <= getEcc_req_local or getEcc_req_sig;
  tmp_0003 <= incrementEcc_req_local or incrementEcc_req_sig;
  tmp_0004 <= not getEcc_req_flag_d;
  tmp_0005 <= getEcc_req_flag and tmp_0004;
  tmp_0006 <= getEcc_req_flag or getEcc_req_flag_d;
  tmp_0007 <= getEcc_req_flag or getEcc_req_flag_d;
  tmp_0008 <= '1' when getPosition_busy = '0' else '0';
  tmp_0009 <= '1' when getPosition_req_local = '0' else '0';
  tmp_0010 <= tmp_0008 and tmp_0009;
  tmp_0011 <= '1' when tmp_0010 = '1' else '0';
  tmp_0012 <= '1' when getEcc_method /= getEcc_method_S_0000 else '0';
  tmp_0013 <= '1' when getEcc_method /= getEcc_method_S_0001 else '0';
  tmp_0014 <= tmp_0013 and getEcc_req_flag_edge;
  tmp_0015 <= tmp_0012 and tmp_0014;
  tmp_0016 <= getEcc_address_sig when getEcc_req_sig = '1' else getEcc_address_local;
  tmp_0017 <= X"00000001" when getEcc_currentData1_0016 = '1' else X"00000000";
  tmp_0018 <= X"00000002" when getEcc_currentData2_0018 = '1' else X"00000000";
  tmp_0019 <= cond_expr_00022 + cond_expr_00025;
  tmp_0020 <= not getPosition_req_flag_d;
  tmp_0021 <= getPosition_req_flag and tmp_0020;
  tmp_0022 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0023 <= getPosition_req_flag or getPosition_req_flag_d;
  tmp_0024 <= '1' when getPosition_method /= getPosition_method_S_0000 else '0';
  tmp_0025 <= '1' when getPosition_method /= getPosition_method_S_0001 else '0';
  tmp_0026 <= tmp_0025 and getPosition_req_flag_edge;
  tmp_0027 <= tmp_0024 and tmp_0026;
  tmp_0028 <= not incrementEcc_req_flag_d;
  tmp_0029 <= incrementEcc_req_flag and tmp_0028;
  tmp_0030 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0031 <= incrementEcc_req_flag or incrementEcc_req_flag_d;
  tmp_0032 <= '1' when getEcc_busy_sig = '0' else '0';
  tmp_0033 <= '1' when getEcc_req_local = '0' else '0';
  tmp_0034 <= tmp_0032 and tmp_0033;
  tmp_0035 <= '1' when tmp_0034 = '1' else '0';
  tmp_0036 <= '1' when incrementEcc_ecc_0033 = X"00000000" else '0';
  tmp_0037 <= '1' when incrementEcc_ecc_0033 = X"00000001" else '0';
  tmp_0038 <= '1' when incrementEcc_ecc_0033 = X"00000002" else '0';
  tmp_0039 <= '1' when incrementEcc_ecc_0033 = X"00000003" else '0';
  tmp_0040 <= '1' when incrementEcc_method /= incrementEcc_method_S_0000 else '0';
  tmp_0041 <= '1' when incrementEcc_method /= incrementEcc_method_S_0001 else '0';
  tmp_0042 <= tmp_0041 and incrementEcc_req_flag_edge;
  tmp_0043 <= tmp_0040 and tmp_0042;
  tmp_0044 <= incrementEcc_address_sig when incrementEcc_req_sig = '1' else incrementEcc_address_local;

  -- sequencers
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
            if tmp_0006 = '1' then
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
        if (tmp_0012 and tmp_0014) = '1' then
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
        incrementEcc_method <= incrementEcc_method_IDLE;
        incrementEcc_method_delay <= (others => '0');
      else
        case (incrementEcc_method) is
          when incrementEcc_method_IDLE => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0000 => 
            incrementEcc_method <= incrementEcc_method_S_0001;
          when incrementEcc_method_S_0001 => 
            if tmp_0030 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0002;
            end if;
          when incrementEcc_method_S_0002 => 
            incrementEcc_method <= incrementEcc_method_S_0002_body;
          when incrementEcc_method_S_0003 => 
            incrementEcc_method <= incrementEcc_method_S_0004;
          when incrementEcc_method_S_0004 => 
            incrementEcc_method <= incrementEcc_method_S_0004_body;
          when incrementEcc_method_S_0005 => 
            incrementEcc_method <= incrementEcc_method_S_0006;
          when incrementEcc_method_S_0006 => 
            if tmp_0036 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0027;
            elsif tmp_0037 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0021;
            elsif tmp_0038 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0015;
            elsif tmp_0039 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0009;
            else
              incrementEcc_method <= incrementEcc_method_S_0000;
            end if;
          when incrementEcc_method_S_0009 => 
            incrementEcc_method <= incrementEcc_method_S_0011;
          when incrementEcc_method_S_0011 => 
            incrementEcc_method <= incrementEcc_method_S_0013;
          when incrementEcc_method_S_0013 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0015 => 
            incrementEcc_method <= incrementEcc_method_S_0017;
          when incrementEcc_method_S_0017 => 
            incrementEcc_method <= incrementEcc_method_S_0019;
          when incrementEcc_method_S_0019 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0021 => 
            incrementEcc_method <= incrementEcc_method_S_0023;
          when incrementEcc_method_S_0023 => 
            incrementEcc_method <= incrementEcc_method_S_0025;
          when incrementEcc_method_S_0025 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0027 => 
            incrementEcc_method <= incrementEcc_method_S_0029;
          when incrementEcc_method_S_0029 => 
            incrementEcc_method <= incrementEcc_method_S_0031;
          when incrementEcc_method_S_0031 => 
            incrementEcc_method <= incrementEcc_method_S_0000;
          when incrementEcc_method_S_0002_body => 
            incrementEcc_method <= incrementEcc_method_S_0002_wait;
          when incrementEcc_method_S_0002_wait => 
            if getPosition_call_flag_0002 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0003;
            end if;
          when incrementEcc_method_S_0004_body => 
            incrementEcc_method <= incrementEcc_method_S_0004_wait;
          when incrementEcc_method_S_0004_wait => 
            if getEcc_call_flag_0004 = '1' then
              incrementEcc_method <= incrementEcc_method_S_0005;
            end if;
          when others => null;
        end case;
        incrementEcc_req_flag_d <= incrementEcc_req_flag;
        if (tmp_0040 and tmp_0042) = '1' then
          incrementEcc_method <= incrementEcc_method_S_0001;
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
        class_pageSize_0006 <= class_pageSize_0006_mux;
      end if;
    end if;
  end process;

  class_pageSize_0006_mux <= tmp_0001;

  class_data1_0007_clk <= clk_sig;

  class_data1_0007_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_data1_0007_address_b <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0004 then
          class_data1_0007_address_b <= getEcc_dataPosition_0014;
        elsif incrementEcc_method = incrementEcc_method_S_0009 then
          class_data1_0007_address_b <= incrementEcc_dataPosition_0031;
        elsif incrementEcc_method = incrementEcc_method_S_0015 then
          class_data1_0007_address_b <= incrementEcc_dataPosition_0031;
        elsif incrementEcc_method = incrementEcc_method_S_0021 then
          class_data1_0007_address_b <= incrementEcc_dataPosition_0031;
        elsif incrementEcc_method = incrementEcc_method_S_0027 then
          class_data1_0007_address_b <= incrementEcc_dataPosition_0031;
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
        if incrementEcc_method = incrementEcc_method_S_0009 then
          class_data1_0007_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0015 then
          class_data1_0007_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0021 then
          class_data1_0007_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0027 then
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
        if incrementEcc_method = incrementEcc_method_S_0009 then
          class_data1_0007_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0015 then
          class_data1_0007_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0021 then
          class_data1_0007_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0027 then
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
          class_data2_0010_address_b <= getEcc_dataPosition_0014;
        elsif incrementEcc_method = incrementEcc_method_S_0011 then
          class_data2_0010_address_b <= incrementEcc_dataPosition_0031;
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data2_0010_address_b <= incrementEcc_dataPosition_0031;
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data2_0010_address_b <= incrementEcc_dataPosition_0031;
        elsif incrementEcc_method = incrementEcc_method_S_0029 then
          class_data2_0010_address_b <= incrementEcc_dataPosition_0031;
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
        if incrementEcc_method = incrementEcc_method_S_0011 then
          class_data2_0010_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data2_0010_din_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data2_0010_din_b <= '0';
        elsif incrementEcc_method = incrementEcc_method_S_0029 then
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
        if incrementEcc_method = incrementEcc_method_S_0011 then
          class_data2_0010_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0017 then
          class_data2_0010_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0023 then
          class_data2_0010_we_b <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0029 then
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
        getEcc_address_0013 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0001 then
          getEcc_address_0013 <= tmp_0016;
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
        if incrementEcc_method = incrementEcc_method_S_0004_body and incrementEcc_method_delay = 0 then
          getEcc_address_local <= incrementEcc_address_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00015 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0002_wait then
          method_result_00015 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_dataPosition_0014 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0003 then
          getEcc_dataPosition_0014 <= method_result_00015;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00017 <= '0';
      else
        if getEcc_method = getEcc_method_S_0014 then
          array_access_00017 <= std_logic(class_data1_0007_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_currentData1_0016 <= '0';
      else
        if getEcc_method = getEcc_method_S_0005 then
          getEcc_currentData1_0016 <= array_access_00017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        array_access_00019 <= '0';
      else
        if getEcc_method = getEcc_method_S_0016 then
          array_access_00019 <= std_logic(class_data2_0010_dout_b);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_currentData2_0018 <= '0';
      else
        if getEcc_method = getEcc_method_S_0007 then
          getEcc_currentData2_0018 <= array_access_00019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00022 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0007 then
          cond_expr_00022 <= tmp_0017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        cond_expr_00025 <= (others => '0');
      else
        if getEcc_method = getEcc_method_S_0009 then
          cond_expr_00025 <= tmp_0018;
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
        if getEcc_method = getEcc_method_S_0010 then
          binary_expr_00026 <= tmp_0019;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getPosition_address_0027 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0001 then
          getPosition_address_0027 <= getPosition_address_local;
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
          getPosition_address_local <= getEcc_address_0013;
        elsif incrementEcc_method = incrementEcc_method_S_0002_body and incrementEcc_method_delay = 0 then
          getPosition_address_local <= incrementEcc_address_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00028 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0002 and getPosition_method_delay >= 1 and u_synthesijer_mul32_getPosition_valid = '1' then
          binary_expr_00028 <= u_synthesijer_mul32_getPosition_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        binary_expr_00029 <= (others => '0');
      else
        if getPosition_method = getPosition_method_S_0003 and getPosition_method_delay >= 1 and u_synthesijer_div32_getPosition_valid = '1' then
          binary_expr_00029 <= u_synthesijer_div32_getPosition_quantient;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_address_0030 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0001 then
          incrementEcc_address_0030 <= tmp_0044;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00032 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0002_wait then
          method_result_00032 <= getPosition_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_dataPosition_0031 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0003 then
          incrementEcc_dataPosition_0031 <= method_result_00032;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00034 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0004_wait then
          method_result_00034 <= getEcc_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        incrementEcc_ecc_0033 <= (others => '0');
      else
        if incrementEcc_method = incrementEcc_method_S_0005 then
          incrementEcc_ecc_0033 <= method_result_00034;
        end if;
      end if;
    end if;
  end process;

  getEcc_req_flag <= tmp_0002;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        getEcc_req_local <= '0';
      else
        if incrementEcc_method = incrementEcc_method_S_0004_body then
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
          getPosition_return <= binary_expr_00029;
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
        if getEcc_method = getEcc_method_S_0002_body then
          getPosition_req_local <= '1';
        elsif incrementEcc_method = incrementEcc_method_S_0002_body then
          getPosition_req_local <= '1';
        else
          getPosition_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  incrementEcc_req_flag <= tmp_0003;

  getEcc_req_flag_edge <= tmp_0005;

  getPosition_call_flag_0002 <= tmp_0011;

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
          u_synthesijer_div32_getPosition_a <= getPosition_address_0027;
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
          u_synthesijer_div32_getPosition_b <= binary_expr_00028;
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

  incrementEcc_req_flag_edge <= tmp_0029;

  getEcc_call_flag_0004 <= tmp_0035;


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
