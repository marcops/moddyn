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
  signal binary_expr_00041 : signed(32-1 downto 0) := (others => '0');
  signal incrementEcc_busy : std_logic := '0';
  signal incrementEcc_req_flag : std_logic := '0';
  signal incrementEcc_req_local : std_logic := '0';
  signal migration_req_flag : std_logic := '0';
  signal migration_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
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
    migration_method_S_0012_body,
    migration_method_S_0012_wait  
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
  signal incrementEcc_call_flag_0012 : std_logic := '0';
  signal tmp_0020 : std_logic := '0';
  signal tmp_0021 : std_logic := '0';
  signal tmp_0022 : std_logic := '0';
  signal tmp_0023 : std_logic := '0';
  signal tmp_0024 : std_logic := '0';
  signal tmp_0025 : std_logic := '0';
  signal tmp_0026 : std_logic := '0';
  signal tmp_0027 : std_logic := '0';
  signal tmp_0028 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0029 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0030 : signed(32-1 downto 0) := (others => '0');
  signal tmp_0031 : std_logic := '0';
  signal tmp_0032 : signed(32-1 downto 0) := (others => '0');

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
  tmp_0020 <= '1' when incrementEcc_busy = '0' else '0';
  tmp_0021 <= '1' when incrementEcc_req_local = '0' else '0';
  tmp_0022 <= tmp_0020 and tmp_0021;
  tmp_0023 <= '1' when tmp_0022 = '1' else '0';
  tmp_0024 <= '1' when migration_method /= migration_method_S_0000 else '0';
  tmp_0025 <= '1' when migration_method /= migration_method_S_0001 else '0';
  tmp_0026 <= tmp_0025 and migration_req_flag_edge;
  tmp_0027 <= tmp_0024 and tmp_0026;
  tmp_0028 <= migration_address_sig when migration_req_sig = '1' else migration_address_local;
  tmp_0029 <= migration_ecc_sig when migration_req_sig = '1' else migration_ecc_local;
  tmp_0030 <= migration_pageSize_sig when migration_req_sig = '1' else migration_pageSize_local;
  tmp_0031 <= '1' when migration_ecc_0031 = X"00000003" else '0';
  tmp_0032 <= migration_ecc_0031 + X"00000001";

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
            migration_method <= migration_method_S_0012_body;
          when migration_method_S_0012_body => 
            migration_method <= migration_method_S_0012_wait;
          when migration_method_S_0012_wait => 
            if incrementEcc_call_flag_0012 = '1' then
              migration_method <= migration_method_S_0000;
            end if;
          when others => null;
        end case;
        migration_req_flag_d <= migration_req_flag;
        if (tmp_0024 and tmp_0026) = '1' then
          migration_method <= migration_method_S_0001;
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
        if migration_method = migration_method_S_0012_body and migration_method_delay = 0 then
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
        if migration_method = migration_method_S_0012_body and migration_method_delay = 0 then
          incrementEcc_ecc_local <= binary_expr_00041;
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
          migration_address_0030 <= tmp_0028;
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
          migration_ecc_0031 <= tmp_0029;
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
          migration_pageSize_0032 <= tmp_0030;
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
          binary_expr_00034 <= tmp_0031;
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
        binary_expr_00041 <= (others => '0');
      else
        if migration_method = migration_method_S_0010 then
          binary_expr_00041 <= tmp_0032;
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
        if migration_method = migration_method_S_0012_body then
          incrementEcc_req_local <= '1';
        else
          incrementEcc_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  migration_req_flag <= tmp_0001;

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

  incrementEcc_call_flag_0012 <= tmp_0023;


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
