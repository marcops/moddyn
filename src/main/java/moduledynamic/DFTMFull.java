package moduledynamic;

public class DFTMFull {
	private static final int DEFAULT_PAGE_SIZE = 32000;
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;
	private static final int BYTE_SIZE = 8;

	private int pageSize = DEFAULT_PAGE_SIZE;
	
	private final static int ENCODER_MODE = 1;
	private final static int DECODER_MODE = 0;

	private boolean[] data0 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];

	// INIT COMPUTER
	public DFTMFull(int newPageSize) {
		// start in hamming and dynamic
		for (int i = 0; i < DEFAULT_PAGE_SIZE; i++) {
			this.data0[i] = true;
			this.data1[i] = false;
			this.data2[i] = true;
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
		int status = eccSelector(data, ecc, DECODER_MODE);
		if(eccEvaluator(data, status)) return 0;
		recoding(address, ecc, pageSize);
		return 0;
	}
	// END READ AND WRITE

	private boolean eccEvaluator(int data, int status) {
		return status == 1;
	}

	private int getPosition(int address) {
		return address / (pageSize * BYTE_SIZE);
	}

	private int blockFinder(int address) {
		int dataPosition = getPosition(address);
		int currentData1 = data1[dataPosition] == true ? 1 : 0;
		int currentData2 = data2[dataPosition] == true ? 2 : 0;
		return currentData1 + currentData2;
	}

	// MOD MIGRATION
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

	private void recoding(int address, int ecc, int pageSize) {
		if (ecc == 3)
			return;

		int position = address / pageSize;
		int initialAddress = position * pageSize;

		for (int i = 0; i < pageSize; i++) {
			int read = recodingRead(initialAddress + i, ecc);
			recodingWrite(initialAddress + i, read, ecc + 1);
		}
		incrementEcc(position, ecc + 1);
	}
	// END MOD MIGRATION
	
	private void recodingWrite(int address, int data, int ecc) {
		int newData = eccSelector(data, ecc, ENCODER_MODE);
		switch (ecc) {
			default:
			case 1: SCHEDULER_WRITE(address, newData); break;
			case 2: SCHEDULER_WRITE(address, newData); break;
			case 3: SCHEDULER_WRITE(address, newData); break;
		}
	}

	private static int recodingRead(int address, int ecc) {
		int data = SCHEDULER_READ(address);
		return eccSelector(data, ecc, DECODER_MODE);
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
	//SCHEDULER
	private void SCHEDULER_WRITE(int address, int data) {}
	private static int SCHEDULER_READ(int address) { return 1; }
	//ECC
	private static int ECC_DECODE_REEDSOLOMON(int data)  { return 1; }
	private static int ECC_DECODE_HAMMING(int data)  { return 1; }
	private static int ECC_DECODE_PARITY(int data)  { return 1; }
	private static int ECC_ENCODE_REEDSOLOMON(int data)  { return 1; }
	private static int ECC_ENCODE_HAMMING(int data)  { return 1; }
	private static int ECC_ENCODE_PARITY(int data)  { return 1; }
	//END EXTERNAL
}
