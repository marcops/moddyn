library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity moduledynamic_ModuleDynamic is
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
end moduledynamic_ModuleDynamic;

architecture RTL of moduledynamic_ModuleDynamic is

  attribute mark_debug : string;
  attribute keep : string;
  attribute S : string;

  component moduledynamic_MemoryAccess
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
  end component moduledynamic_MemoryAccess;
  component moduledynamic_ModuleECC
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
  end component moduledynamic_ModuleECC;
  component moduledynamic_ModuleMigration
    port (
      clk : in std_logic;
      reset : in std_logic;
      migration_address : in signed(32-1 downto 0);
      migration_ecc : in signed(32-1 downto 0);
      migration_pageSize : in signed(32-1 downto 0);
      migration_busy : out std_logic;
      migration_req : in std_logic
    );
  end component moduledynamic_ModuleMigration;

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

  signal class_memoryAccess_0000_clk : std_logic := '0';
  signal class_memoryAccess_0000_reset : std_logic := '0';
  signal class_memoryAccess_0000_pageSize_in : signed(32-1 downto 0) := (others => '0');
  signal class_memoryAccess_0000_pageSize_we : std_logic := '0';
  signal class_memoryAccess_0000_pageSize_out : signed(32-1 downto 0) := (others => '0');
  signal class_memoryAccess_0000_getEcc_address : signed(32-1 downto 0) := (others => '0');
  signal class_memoryAccess_0000_incrementEcc_address : signed(32-1 downto 0) := (others => '0');
  signal class_memoryAccess_0000_getEcc_return : signed(32-1 downto 0) := (others => '0');
  signal class_memoryAccess_0000_getEcc_busy : std_logic := '0';
  signal class_memoryAccess_0000_getEcc_req : std_logic := '0';
  signal class_memoryAccess_0000_incrementEcc_busy : std_logic := '0';
  signal class_memoryAccess_0000_incrementEcc_req : std_logic := '0';
  signal class_moduleECC_0002_clk : std_logic := '0';
  signal class_moduleECC_0002_reset : std_logic := '0';
  signal class_moduleECC_0002_checkECC_data : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0002_checkECC_ecc : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0002_doEcc_data : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0002_doEcc_ecc : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0002_checkECC_return : std_logic := '0';
  signal class_moduleECC_0002_checkECC_busy : std_logic := '0';
  signal class_moduleECC_0002_checkECC_req : std_logic := '0';
  signal class_moduleECC_0002_doEcc_return : signed(32-1 downto 0) := (others => '0');
  signal class_moduleECC_0002_doEcc_busy : std_logic := '0';
  signal class_moduleECC_0002_doEcc_req : std_logic := '0';
  signal class_moduleMigration_0004_clk : std_logic := '0';
  signal class_moduleMigration_0004_reset : std_logic := '0';
  signal class_moduleMigration_0004_migration_address : signed(32-1 downto 0) := (others => '0');
  signal class_moduleMigration_0004_migration_ecc : signed(32-1 downto 0) := (others => '0');
  signal class_moduleMigration_0004_migration_pageSize : signed(32-1 downto 0) := (others => '0');
  signal class_moduleMigration_0004_migration_busy : std_logic := '0';
  signal class_moduleMigration_0004_migration_req : std_logic := '0';
  signal setPageSize_newPageSize_0006 : signed(32-1 downto 0) := (others => '0');
  signal setPageSize_newPageSize_local : signed(32-1 downto 0) := (others => '0');
  signal field_access_00007 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_address_0008 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_address_local : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_data_0009 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00011 : signed(32-1 downto 0) := (others => '0');
  signal writeFlow_ecc_0010 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00012 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_address_0013 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_address_local : signed(32-1 downto 0) := (others => '0');
  signal readFlow_data_0014 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_data_local : signed(32-1 downto 0) := (others => '0');
  signal method_result_00016 : signed(32-1 downto 0) := (others => '0');
  signal readFlow_ecc_0015 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00018 : std_logic := '0';
  signal readFlow_isOk_0017 : std_logic := '0';
  signal field_access_00020 : signed(32-1 downto 0) := (others => '0');
  signal setPageSize_req_flag : std_logic := '0';
  signal setPageSize_req_local : std_logic := '0';
  signal tmp_0001 : std_logic := '0';
  signal writeFlow_req_flag : std_logic := '0';
  signal writeFlow_req_local : std_logic := '0';
  signal tmp_0002 : std_logic := '0';
  signal readFlow_req_flag : std_logic := '0';
  signal readFlow_req_local : std_logic := '0';
  signal tmp_0003 : std_logic := '0';
  type Type_setPageSize_method is (
    setPageSize_method_IDLE,
    setPageSize_method_S_0000,
    setPageSize_method_S_0001,
    setPageSize_method_S_0002,
    setPageSize_method_S_0003  
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
  signal class_memoryAccess_0000_getEcc_ext_call_flag_0002 : std_logic := '0';
  signal tmp_0017 : std_logic := '0';
  signal tmp_0018 : std_logic := '0';
  signal tmp_0019 : std_logic := '0';
  signal tmp_0020 : std_logic := '0';
  signal class_moduleECC_0002_doEcc_ext_call_flag_0004 : std_logic := '0';
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
    readFlow_method_S_0012,
    readFlow_method_S_0002_body,
    readFlow_method_S_0002_wait,
    readFlow_method_S_0004_body,
    readFlow_method_S_0004_wait,
    readFlow_method_S_0011_body,
    readFlow_method_S_0011_wait  
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
  signal class_moduleECC_0002_checkECC_ext_call_flag_0004 : std_logic := '0';
  signal tmp_0035 : std_logic := '0';
  signal tmp_0036 : std_logic := '0';
  signal tmp_0037 : std_logic := '0';
  signal tmp_0038 : std_logic := '0';
  signal tmp_0039 : std_logic := '0';
  signal tmp_0040 : std_logic := '0';
  signal class_moduleMigration_0004_migration_ext_call_flag_0011 : std_logic := '0';
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
          writeFlow_return_sig <= method_result_00012;
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
          readFlow_return_sig <= readFlow_data_0014;
        elsif readFlow_method = readFlow_method_S_0012 then
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
  tmp_0017 <= '1' when class_memoryAccess_0000_getEcc_busy = '0' else '0';
  tmp_0018 <= '1' when class_memoryAccess_0000_getEcc_req = '0' else '0';
  tmp_0019 <= tmp_0017 and tmp_0018;
  tmp_0020 <= '1' when tmp_0019 = '1' else '0';
  tmp_0021 <= '1' when class_moduleECC_0002_doEcc_busy = '0' else '0';
  tmp_0022 <= '1' when class_moduleECC_0002_doEcc_req = '0' else '0';
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
  tmp_0035 <= '1' when class_moduleECC_0002_checkECC_busy = '0' else '0';
  tmp_0036 <= '1' when class_moduleECC_0002_checkECC_req = '0' else '0';
  tmp_0037 <= tmp_0035 and tmp_0036;
  tmp_0038 <= '1' when tmp_0037 = '1' else '0';
  tmp_0039 <= '1' when readFlow_isOk_0017 = '1' else '0';
  tmp_0040 <= '1' when readFlow_isOk_0017 = '0' else '0';
  tmp_0041 <= '1' when class_moduleMigration_0004_migration_busy = '0' else '0';
  tmp_0042 <= '1' when class_moduleMigration_0004_migration_req = '0' else '0';
  tmp_0043 <= tmp_0041 and tmp_0042;
  tmp_0044 <= '1' when tmp_0043 = '1' else '0';
  tmp_0045 <= '1' when readFlow_method /= readFlow_method_S_0000 else '0';
  tmp_0046 <= '1' when readFlow_method /= readFlow_method_S_0001 else '0';
  tmp_0047 <= tmp_0046 and readFlow_req_flag_edge;
  tmp_0048 <= tmp_0045 and tmp_0047;
  tmp_0049 <= readFlow_address_sig when readFlow_req_sig = '1' else readFlow_address_local;
  tmp_0050 <= readFlow_data_sig when readFlow_req_sig = '1' else readFlow_data_local;

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
            setPageSize_method <= setPageSize_method_S_0003;
          when setPageSize_method_S_0003 => 
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
            if class_memoryAccess_0000_getEcc_ext_call_flag_0002 = '1' then
              writeFlow_method <= writeFlow_method_S_0003;
            end if;
          when writeFlow_method_S_0004_body => 
            writeFlow_method <= writeFlow_method_S_0004_wait;
          when writeFlow_method_S_0004_wait => 
            if class_moduleECC_0002_doEcc_ext_call_flag_0004 = '1' then
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
            readFlow_method <= readFlow_method_S_0011;
          when readFlow_method_S_0011 => 
            readFlow_method <= readFlow_method_S_0011_body;
          when readFlow_method_S_0012 => 
            readFlow_method <= readFlow_method_S_0000;
          when readFlow_method_S_0002_body => 
            readFlow_method <= readFlow_method_S_0002_wait;
          when readFlow_method_S_0002_wait => 
            if class_memoryAccess_0000_getEcc_ext_call_flag_0002 = '1' then
              readFlow_method <= readFlow_method_S_0003;
            end if;
          when readFlow_method_S_0004_body => 
            readFlow_method <= readFlow_method_S_0004_wait;
          when readFlow_method_S_0004_wait => 
            if class_moduleECC_0002_checkECC_ext_call_flag_0004 = '1' then
              readFlow_method <= readFlow_method_S_0005;
            end if;
          when readFlow_method_S_0011_body => 
            readFlow_method <= readFlow_method_S_0011_wait;
          when readFlow_method_S_0011_wait => 
            if class_moduleMigration_0004_migration_ext_call_flag_0011 = '1' then
              readFlow_method <= readFlow_method_S_0012;
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


  class_memoryAccess_0000_clk <= clk_sig;

  class_memoryAccess_0000_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memoryAccess_0000_pageSize_in <= (others => '0');
      else
        if setPageSize_method = setPageSize_method_S_0003 then
          class_memoryAccess_0000_pageSize_in <= setPageSize_newPageSize_0006;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memoryAccess_0000_pageSize_we <= '0';
      else
        if setPageSize_method = setPageSize_method_S_0003 then
          class_memoryAccess_0000_pageSize_we <= '1';
        else
          class_memoryAccess_0000_pageSize_we <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memoryAccess_0000_getEcc_address <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0002_body and writeFlow_method_delay = 0 then
          class_memoryAccess_0000_getEcc_address <= writeFlow_address_0008;
        elsif readFlow_method = readFlow_method_S_0002_body and readFlow_method_delay = 0 then
          class_memoryAccess_0000_getEcc_address <= readFlow_address_0013;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_memoryAccess_0000_getEcc_req <= '0';
      else
        if writeFlow_method = writeFlow_method_S_0002_body then
          class_memoryAccess_0000_getEcc_req <= '1';
        elsif readFlow_method = readFlow_method_S_0002_body then
          class_memoryAccess_0000_getEcc_req <= '1';
        else
          class_memoryAccess_0000_getEcc_req <= '0';
        end if;
      end if;
    end if;
  end process;

  class_moduleECC_0002_clk <= clk_sig;

  class_moduleECC_0002_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0002_checkECC_data <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0004_body and readFlow_method_delay = 0 then
          class_moduleECC_0002_checkECC_data <= readFlow_data_0014;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0002_checkECC_ecc <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0004_body and readFlow_method_delay = 0 then
          class_moduleECC_0002_checkECC_ecc <= readFlow_ecc_0015;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0002_doEcc_data <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0004_body and writeFlow_method_delay = 0 then
          class_moduleECC_0002_doEcc_data <= writeFlow_data_0009;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0002_doEcc_ecc <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0004_body and writeFlow_method_delay = 0 then
          class_moduleECC_0002_doEcc_ecc <= writeFlow_ecc_0010;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0002_checkECC_req <= '0';
      else
        if readFlow_method = readFlow_method_S_0004_body then
          class_moduleECC_0002_checkECC_req <= '1';
        else
          class_moduleECC_0002_checkECC_req <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleECC_0002_doEcc_req <= '0';
      else
        if writeFlow_method = writeFlow_method_S_0004_body then
          class_moduleECC_0002_doEcc_req <= '1';
        else
          class_moduleECC_0002_doEcc_req <= '0';
        end if;
      end if;
    end if;
  end process;

  class_moduleMigration_0004_clk <= clk_sig;

  class_moduleMigration_0004_reset <= reset_sig;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleMigration_0004_migration_address <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0011_body and readFlow_method_delay = 0 then
          class_moduleMigration_0004_migration_address <= readFlow_address_0013;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleMigration_0004_migration_ecc <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0011_body and readFlow_method_delay = 0 then
          class_moduleMigration_0004_migration_ecc <= readFlow_ecc_0015;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleMigration_0004_migration_pageSize <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0011_body and readFlow_method_delay = 0 then
          class_moduleMigration_0004_migration_pageSize <= field_access_00020;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        class_moduleMigration_0004_migration_req <= '0';
      else
        if readFlow_method = readFlow_method_S_0011_body then
          class_moduleMigration_0004_migration_req <= '1';
        else
          class_moduleMigration_0004_migration_req <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        setPageSize_newPageSize_0006 <= (others => '0');
      else
        if setPageSize_method = setPageSize_method_S_0001 then
          setPageSize_newPageSize_0006 <= tmp_0012;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        field_access_00007 <= (others => '0');
      else
        if setPageSize_method = setPageSize_method_S_0002 then
          field_access_00007 <= class_memoryAccess_0000_pageSize_out;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_address_0008 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0001 then
          writeFlow_address_0008 <= tmp_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_data_0009 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0001 then
          writeFlow_data_0009 <= tmp_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00011 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0002_wait then
          method_result_00011 <= class_memoryAccess_0000_getEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        writeFlow_ecc_0010 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0003 then
          writeFlow_ecc_0010 <= method_result_00011;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00012 <= (others => '0');
      else
        if writeFlow_method = writeFlow_method_S_0004_wait then
          method_result_00012 <= class_moduleECC_0002_doEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_address_0013 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0001 then
          readFlow_address_0013 <= tmp_0049;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_data_0014 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0001 then
          readFlow_data_0014 <= tmp_0050;
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
        if readFlow_method = readFlow_method_S_0002_wait then
          method_result_00016 <= class_memoryAccess_0000_getEcc_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_ecc_0015 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0003 then
          readFlow_ecc_0015 <= method_result_00016;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        method_result_00018 <= '0';
      else
        if readFlow_method = readFlow_method_S_0004_wait then
          method_result_00018 <= class_moduleECC_0002_checkECC_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        readFlow_isOk_0017 <= '0';
      else
        if readFlow_method = readFlow_method_S_0005 then
          readFlow_isOk_0017 <= method_result_00018;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        field_access_00020 <= (others => '0');
      else
        if readFlow_method = readFlow_method_S_0010 then
          field_access_00020 <= class_memoryAccess_0000_pageSize_out;
        end if;
      end if;
    end if;
  end process;

  setPageSize_req_flag <= tmp_0001;

  writeFlow_req_flag <= tmp_0002;

  readFlow_req_flag <= tmp_0003;

  setPageSize_req_flag_edge <= tmp_0005;

  writeFlow_req_flag_edge <= tmp_0014;

  class_memoryAccess_0000_getEcc_ext_call_flag_0002 <= tmp_0020;

  class_moduleECC_0002_doEcc_ext_call_flag_0004 <= tmp_0024;

  readFlow_req_flag_edge <= tmp_0032;

  class_moduleECC_0002_checkECC_ext_call_flag_0004 <= tmp_0038;

  class_moduleMigration_0004_migration_ext_call_flag_0011 <= tmp_0044;


  inst_class_memoryAccess_0000 : moduledynamic_MemoryAccess
  port map(
    clk => clk,
    reset => reset,
    pageSize_in => class_memoryAccess_0000_pageSize_in,
    pageSize_we => class_memoryAccess_0000_pageSize_we,
    pageSize_out => class_memoryAccess_0000_pageSize_out,
    getEcc_address => class_memoryAccess_0000_getEcc_address,
    incrementEcc_address => class_memoryAccess_0000_incrementEcc_address,
    getEcc_return => class_memoryAccess_0000_getEcc_return,
    getEcc_busy => class_memoryAccess_0000_getEcc_busy,
    getEcc_req => class_memoryAccess_0000_getEcc_req,
    incrementEcc_busy => class_memoryAccess_0000_incrementEcc_busy,
    incrementEcc_req => class_memoryAccess_0000_incrementEcc_req
  );

  inst_class_moduleECC_0002 : moduledynamic_ModuleECC
  port map(
    clk => clk,
    reset => reset,
    checkECC_data => class_moduleECC_0002_checkECC_data,
    checkECC_ecc => class_moduleECC_0002_checkECC_ecc,
    doEcc_data => class_moduleECC_0002_doEcc_data,
    doEcc_ecc => class_moduleECC_0002_doEcc_ecc,
    checkECC_return => class_moduleECC_0002_checkECC_return,
    checkECC_busy => class_moduleECC_0002_checkECC_busy,
    checkECC_req => class_moduleECC_0002_checkECC_req,
    doEcc_return => class_moduleECC_0002_doEcc_return,
    doEcc_busy => class_moduleECC_0002_doEcc_busy,
    doEcc_req => class_moduleECC_0002_doEcc_req
  );

  inst_class_moduleMigration_0004 : moduledynamic_ModuleMigration
  port map(
    clk => clk,
    reset => reset,
    migration_address => class_moduleMigration_0004_migration_address,
    migration_ecc => class_moduleMigration_0004_migration_ecc,
    migration_pageSize => class_moduleMigration_0004_migration_pageSize,
    migration_busy => class_moduleMigration_0004_migration_busy,
    migration_req => class_moduleMigration_0004_migration_req
  );


end RTL;
