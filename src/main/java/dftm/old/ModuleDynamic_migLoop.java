package dftm.old;

public class ModuleDynamic_migLoop {

	// MOD MIGRATION
	public void migration(int ecc, int pageSize) {
		int initialAddress = 0;

		for (int i = 0; i < pageSize; i++) {
			int read = read(initialAddress + i, ecc);
			write(initialAddress + i, read, ecc + 1);
		}
	}

	private void write(int address, int data, int ecc) {
		int newData = doEcc(data, ecc);
		switch (ecc) {
		default:
		case 1:
			writeRAM(address, newData);
			break;
		case 2:
			writeRAM(address, newData);
			break;
		case 3:
			writeRAM(address, newData);
			break;
		}
	}

	private static int read(int address, int ecc) {
		int data = readRAM(address);
		return doEcc(data, ecc);
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
	// END MOD MIGRATION

	private static int doEcc(int data, int ecc) {
		switch (ecc) {
		default:
		case 0:
			return data;
		case 1:
			return doParity(data);
		case 2:
			return doHamming(data);
		case 3:
			return doReedSolomon(data);
		}

	}

	/**
	 * @param data
	 */
	private static int doReedSolomon(int data) {
		return data;
	}

	/**
	 * @param data
	 */
	private static int doHamming(int data) {
		return data;
	}

	/**
	 * @param data
	 */
	private static int doParity(int data) {
		return data;
	}


}
