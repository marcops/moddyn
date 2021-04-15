package moduledynamic;


public class HammingCode {
	private  int calcParity() {
		int v = 0;
		for (int i = 0; i < generatedCode.length - 1; i++) {
			v ^= generatedCode[i];
		}
		return v;
	}

	public int[] signal = new int [40];
	public int[] generatedCode = new int[40];


	public int encode() {
		int parityCount = calculateParity();
		allocateBits();
		allocateParityBits(parityCount);
		generatedCode[signal.length + parityCount] = calcParity();
		return parityCount;
	}

	private int calculateParity() {
		int parityCount = 0;
		int i = 0;
		while (i < signal.length) {
			int poweredPos = pow(2, parityCount);
			if (poweredPos == parityCount + i + 1)
				parityCount++;
			else
				i++;
		}
		return parityCount;
	}

	private  void allocateParityBits(int parityCount) {
		for (int i = 0; i < parityCount; i++) {
			generatedCode[((int) pow(2, i)) - 1] = getParity(i);
		}
	}
	private static int pow(int x, int y) {
		int r=x;
		for(int i=0;i<y;i++)
			r*=x;
		return r;
	}
	private  void allocateBits() {
		int j = 0;
		int k = 0;
		for (int i = 1; i <= generatedCode.length - 1; i++) {
			if (pow(2, j) == i) {
				generatedCode[i - 1] = 2;
				j++;
			} else {
				generatedCode[k + j] = signal[k++];
			}
		}
	}

	private  int getParity( int power) {

		int parity = 0;

		for (int i = 0; i < generatedCode.length; i++) {
			if (generatedCode[i] != 2) {
				int k = i + 1;

//				int x = ((Integer.parseInt(s)) / ((int) Math.pow(10, power))) % 10;
				int x = (k / ((int) pow(10, power))) % 10;
				if (x == 1 && generatedCode[i] == 1) {
					parity = (parity + 1) % 2;
				}
			}
		}
		return parity;
	}


}
