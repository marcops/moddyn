package moduledynamic;

public class ModuleMigration {
	private ModuleECC moduleECC = new ModuleECC();
	public void migration(int address, int ecc, int pageSize) {
		if (ecc == 3) return;
		
		int position = address / pageSize;
		int initialAddress = position * pageSize;

		for (int i = 0; i < pageSize; i++) {
			int read = read(initialAddress + i, ecc);
			write(initialAddress + i, read, ecc+1);
		}
	}


	private void write(int address, int data, int ecc) {
		int newData = moduleECC.doEcc(data, ecc);
		switch (ecc) {
		default: case 1: writeRAM(address, newData); break;
		case 2: writeRAM(address, newData); break;
		case 3: writeRAM(address, newData); break;
		}
	}

	private int read(int address, int ecc) {
		int data = readRAM(address);
		return moduleECC.doEcc(data, ecc);
	}
	/**
	 * @param address  
	 * @param data 
	 */
	private void writeRAM(int address, int data) {
		
	}
	/**
	 * @param address  
	 * @param data 
	 */	
	private static int readRAM(int address) {
		return 0;
	}
}
