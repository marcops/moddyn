package moduledynamic;

public class MemoryAccess {
	private static final int DEFAULT_PAGE_SIZE = 32000;
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;
	private static final int BYTE_SIZE = 8;

	public int pageSize = DEFAULT_PAGE_SIZE;

	private boolean[] data1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];

	public MemoryAccess() {
		//inicia em hamming
		for (int i = 0; i < DEFAULT_PAGE_SIZE; i++) 
			data2[i] = true;
	}
	
	public int getEcc(int address) {
		int dataPosition = getPosition(address);
		boolean currentData1 = data1[dataPosition];
		boolean currentData2 = data2[dataPosition];

		return (currentData1 ? 1 : 0 ) + (currentData2 ? 2 : 0);
	}

	private int getPosition(int address) {
		return address / (pageSize * BYTE_SIZE);
	}
	
	public void incrementEcc(int address) {
		int dataPosition = getPosition(address);
		int ecc = getEcc(address);
		switch(ecc) {
		default:
		case 0:
			data1[dataPosition] = false;
			data2[dataPosition] = false;
			break;
		case 1:
			data1[dataPosition] = true;
			data2[dataPosition] = false;
			break;
		case 2:
			data1[dataPosition] = false;
			data2[dataPosition] = true;
			break;
		case 3:
			data1[dataPosition] = true;
			data2[dataPosition] = true;
			break;
		}
		
	}

}
