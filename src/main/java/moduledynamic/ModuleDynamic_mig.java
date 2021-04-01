package moduledynamic;

public class ModuleDynamic_mig {
	// MEM ACCESS
	private static final int DEFAULT_MEMORY_SIZE_PER_BLOCK = 256000;


	private boolean[] data1 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];
	private boolean[] data2 = new boolean[DEFAULT_MEMORY_SIZE_PER_BLOCK];


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
	public void migration(int address, int ecc, int pageSize) {
		if (ecc == 3)
			return;

		int position = address / pageSize;
		int initialAddress = position * pageSize;

		incrementEcc(position, ecc+1);
	}


}
