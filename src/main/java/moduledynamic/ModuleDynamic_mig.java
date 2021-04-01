package moduledynamic;

public class ModuleDynamic_mig {
	// MEM ACCESS
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;


	private boolean[] data1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];

	public ModuleDynamic_mig() {
	}


	private void incrementEcc(int position, int ecc) {
		switch (ecc) {
		default:
		case 0:
			data1[position] = false;
			data2[position] = false;
			break;
		case 1:
			data1[position] = true;
			data2[position] = false;
			break;
		case 2:
			data1[position] = false;
			data2[position] = true;
			break;
		case 3:
			data1[position] = true;
			data2[position] = true;
			break;
		}

	}
	// END MEM ACCESS

	// MOD MIGRATION
	public void migration(int address, int ecc, int pageSize) {
		if (ecc == 3)
			return;

		int position = address / pageSize;
		int initialAddress = position * pageSize;

		for (int i = 0; i < pageSize; i++) {
			int read = read(initialAddress + i, ecc);
			write(initialAddress + i, read, ecc + 1);
		}
		incrementEcc(position, ecc+1);
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

	// MOD ECC

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
//			int y = data ^ (data >> 1);
//			y = y ^ (y >> 2);
//			y = y ^ (y >> 4);
//			y = y ^ (y >> 8);
//			y = y ^ (y >> 16);
		//
//			// Rightmost bit of y holds the parity value
//			// if (y&1) is 1 then parity is odd else even
//			if ((y & 1) == 0) return data;
//			return set(data, 32);
	}

	/**
	 * @param data
	 */

//		public int set(int value, int bit) {
//			return value | (1 << bit);
//		}
	// END ECC

}
