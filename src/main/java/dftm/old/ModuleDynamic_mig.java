package dftm.old;

public class ModuleDynamic_mig {
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
		int isOk = checkECC(data, ecc);
		if (isOk == 1) return data;
		migration(address, ecc, pageSize);
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

	public ModuleDynamic_mig() {
		// inicia em hamming
		for (int i = 0; i < DEFAULT_PAGE_SIZE; i++)
			data2[i] = true;
	}

	private int getEcc(int address) {
		int dataPosition = getPosition(address);
		int currentData1 = data1[dataPosition] == true ? 1 : 0;
		int currentData2 = data2[dataPosition] == true ? 2 : 0;

		return currentData1 + currentData2;
	}

	private int getPosition(int address) {
		return address / (pageSize * BYTE_SIZE);
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
	private void migration(int address, int ecc, int pageSize) {
		if (ecc == 3)
			return;

		int position = address / pageSize;
		int initialAddress = position * pageSize;

		
		incrementEcc(position, ecc+1);
	}

	// END MOD MIGRATION

	// MOD ECC
	private static int checkECC(int data, int ecc) {
		switch (ecc) {
		default:
		case 0:
			return 1;
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
	private static int checkReedSolomon(int data) {
		return 1;
	}

	/**
	 * @param data
	 */
	private static int checkHamming(int data) {
		return 1;
	}

	/**
	 * @param data
	 */
	private static int checkParity(int data) {
		return 1;
	}

//		public int set(int value, int bit) {
//			return value | (1 << bit);
//		}
	// END ECC

}
