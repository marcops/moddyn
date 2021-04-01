package moduledynamic;

public class ModuleDynamic_migLOOP {

	public ModuleDynamic_migLOOP() {
	}


	// END MEM ACCESS

	// MOD MIGRATION
	public void migration2( int initialAddress, int ecc, int pageSize) {
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
