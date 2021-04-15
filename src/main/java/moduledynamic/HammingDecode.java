package moduledynamic;

public class HammingDecode {
	private static int calcParity(int[] created) {
		int v = 0;
		for (int i = 0; i < created.length - 1; i++) {
			v ^= created[i];
		}
		return v;
	}

	private static int pow(int x, int y) {
		int r=x;
		for(int i=0;i<y;i++)
			r*=x;
		return r;
	}

	int []generatedCode = new int [40];
	
	public int decode() {
		boolean soft = false;
		int parityCount = 7;
		int power;
		int parity[] = new int[parityCount];
		int error_location = 0;

		for (power = 0; power < parityCount; power++) {
			for (int i = 0; i < generatedCode.length - 1; i++) {

				int k = i + 1;

//				String s = Integer.toBinaryString(k);

//				int bit = ((Integer.parseInt(s)) / (pow(10, power))) % 10;
				int bit = (k / (pow(10, power))) % 10;
				if (bit == 1) {
					if (generatedCode[i] == 1) {
						parity[power] = (parity[power] + 1) % 2;
					}
				}
			}
			error_location = parity[power] + error_location;
		}

		
		if (error_location != 0) {
			generatedCode[error_location - 1] = (generatedCode[error_location - 1] + 1) % 2;
//			System.out.println("fix at =" + (error_location - 1));
			if (generatedCode[generatedCode.length - 1] != calcParity(generatedCode)) {
//				System.out.println("Double Error");
//				System.out.println(generatedCode[generatedCode.length - 1] + " - " + calcParity(generatedCode));
				return 2;
			}
			soft = true;
//			throw new SoftError();
		} 

		power = parityCount - 1;
		for (int i = generatedCode.length - 1; i > 0; i--) {
			if (pow(2, power) != i) {
				original += generatedCode[i - 1];
			} else {
				power--;
			}
		}
		int re[] = new int[original.length()];
		for (int i = 0; i < original.length(); i++)
			re[original.length() - i - 1] = original.charAt(i) == '1' ? 1 : 0;
		if(soft) return 1;
		return 0;
	}


}
