package dftm;

public class DFTM_noRecoding {
	private static final int DEFAULT_PAGE_SIZE = 32000;
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;
	private static final int BYTE_SIZE = 8;

	private int pageSize = DEFAULT_PAGE_SIZE;
	
	private final static int ENCODER_MODE = 1;
	private final static int DECODER_MODE = 0;

	private boolean[] memory0 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] memory1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] memory2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];

	// INIT COMPUTER
	public DFTM_noRecoding(int newPageSize) {
		// start in hamming and dynamic
		for (int i = 0; i < DEFAULT_PAGE_SIZE; i++) {
			this.memory0[i] = true;
			this.memory1[i] = false;
			this.memory2[i] = true;
		}

		this.pageSize = newPageSize;
	}

	// READ AND WRITE
	public int write(int address, int data) {
		int ecc = blockFinder(address);
		return eccSelector(data, ecc, ENCODER_MODE);
	}

	public int read(int address, int data) {
		int ecc = blockFinder(address);
		return eccSelector(data, ecc, DECODER_MODE);
	}
	// END READ AND WRITE

	private int getPosition(int address) {
		return address / (pageSize * BYTE_SIZE);
	}

	private int blockFinder(int address) {
		int dataPosition = getPosition(address);
		int currentData1 = memory1[dataPosition] == true ? 1 : 0;
		int currentData2 = memory2[dataPosition] == true ? 2 : 0;
		return currentData1 + currentData2;
	}

	// MOD ECC
	private static int eccSelector(int data, int ecc, int encoder) {
		switch (ecc) {
			default:
			case 0: return 1;
			case 1: return encoder == 1 ? ECC_ENCODE_PARITY(data) : ECC_DECODE_PARITY(data);
			case 2: return encoder == 1 ? ECC_ENCODE_HAMMING(data) : ECC_DECODE_HAMMING(data);
			case 3: return encoder == 1 ? ECC_ENCODE_REEDSOLOMON(data) : ECC_DECODE_REEDSOLOMON(data);
		}
	}
	
	//INIT EXTERNAL
	//ECC
	private static int ECC_DECODE_REEDSOLOMON(int data)  { return 1; }
	private static int ECC_DECODE_HAMMING(int data)  { return 1; }
	private static int ECC_DECODE_PARITY(int data)  { return 1; }
	private static int ECC_ENCODE_REEDSOLOMON(int data)  { return 1; }
	private static int ECC_ENCODE_HAMMING(int data)  { return 1; }
	private static int ECC_ENCODE_PARITY(int data)  { return 1; }
	//END EXTERNAL
}
