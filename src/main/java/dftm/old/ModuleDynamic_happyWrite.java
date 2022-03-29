package dftm.old;

public class ModuleDynamic_happyWrite {
	//ModuleDynamic
	public void setPageSize(int newPageSize) {
		pageSize = newPageSize;
	}

	public int writeFlow(int address, int data) {
		int ecc = getEcc(address);
		return doEcc(data, ecc);
	}

	
	// MEM ACCESS
	private static final int DEFAULT_PAGE_SIZE = 32000;
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;
	private static final int BYTE_SIZE = 8;

	private int pageSize = DEFAULT_PAGE_SIZE;

	private boolean[] data1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];

	public ModuleDynamic_happyWrite() {
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
