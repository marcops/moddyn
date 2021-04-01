package moduledynamic;

public class ModuleDynamic_happyCase {
	//ModuleDynamic
	public void setPageSize(int newPageSize) {
		pageSize = newPageSize;
	}

	public int writeFlow(int address, int data) {
		int ecc = getEcc(address);
		return doEcc(data, ecc);
	}

	public int readFlow(int address, int data) {
		int ecc = getEcc(address);
		boolean isOk = checkECC(data, ecc);
		if (isOk) return data;
		return 0;
	}
	//END ModuleDynamic
	
	
	// MEM ACCESS
	private static final int DEFAULT_PAGE_SIZE = 32000;
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;
	private static final int BYTE_SIZE = 8;

	private int pageSize = DEFAULT_PAGE_SIZE;

	private boolean[] data1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];

	public ModuleDynamic_happyCase() {
		// inicia em hamming
		for (int i = 0; i < DEFAULT_PAGE_SIZE; i++)
			data2[i] = true;
	}

	private int getEcc(int address) {
		int dataPosition = getPosition(address);
		boolean currentData1 = data1[dataPosition];
		boolean currentData2 = data2[dataPosition];

		return (currentData1 ? 1 : 0) + (currentData2 ? 2 : 0);
	}

	private int getPosition(int address) {
		return address / (pageSize * BYTE_SIZE);
	}


	// MOD ECC
	private static boolean checkECC(int data, int ecc) {
		switch (ecc) {
		default:
		case 0:
			return true;
		case 1:
			return checkParity(data);
		case 2:
			return checkHamming(data);
		case 3:
			return checkReedSolomon(data);
		}
	}

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
	private static boolean checkReedSolomon(int data) {
		return true;
	}

	/**
	 * @param data
	 */
	private static boolean checkHamming(int data) {
		return true;
	}

	/**
	 * @param data
	 */
	private static boolean checkParity(int data) {
		return true;
	}

//		public int set(int value, int bit) {
//			return value | (1 << bit);
//		}
	// END ECC

}
