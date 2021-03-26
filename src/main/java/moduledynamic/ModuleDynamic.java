package moduledynamic;

public class ModuleDynamic {
	private MemoryAccess memoryAccess = new MemoryAccess();
	private ModuleECC moduleECC = new ModuleECC();
	private ModuleMigration moduleMigration = new ModuleMigration();

	public void setPageSize(int newPageSize) {
		memoryAccess.pageSize = newPageSize;
	}

	public int writeFlow(int address, int data) {
		int ecc = memoryAccess.getEcc(address);
		return moduleECC.doEcc(data, ecc);
	}
	
	public int readFlow(int address, int data) {
		int ecc = memoryAccess.getEcc(address);
		boolean isOk = moduleECC.checkECC(data, ecc);
		if(isOk) return data;
		moduleMigration.migration(address, ecc, memoryAccess.pageSize);
		return 0;
	}


}