package moduledynamic;

public class ModuleDynamic_happyRead {
	//ModuleDynamic
	public void setPageSize(int newPageSize) {
		pageSize = newPageSize;
	}

	public int readFlow(int address, int data) {
		int ecc = getEcc(address);
		int isOk = checkECC(data, ecc);
		if (isOk == 1) return data;
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

	public ModuleDynamic_happyRead() {
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
