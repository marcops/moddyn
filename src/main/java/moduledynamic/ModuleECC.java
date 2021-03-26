package moduledynamic;

public class ModuleECC {
	
	public boolean checkECC(int data, int ecc) {
		switch (ecc) {
		default: case 0: return true; 
		case 1: return checkParity(data); 
		case 2: return checkHamming(data); 
		case 3: return checkReedSolomon(data); 
		}
	}
	
	public int doEcc(int data, int ecc) {
		switch (ecc) {
		default: case 0: return data; 
		case 1: return doParity(data); 
		case 2: return doHamming(data); 
		case 3: return doReedSolomon(data); 
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
//		int y = data ^ (data >> 1);
//		y = y ^ (y >> 2);
//		y = y ^ (y >> 4);
//		y = y ^ (y >> 8);
//		y = y ^ (y >> 16);
//
//		// Rightmost bit of y holds the parity value
//		// if (y&1) is 1 then parity is odd else even
//		if ((y & 1) == 0) return data;
//		return set(data, 32);
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

//	public int set(int value, int bit) {
//		return value | (1 << bit);
//	}
		
}
