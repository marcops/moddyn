///*
// * This Java source file was generated by the Gradle 'init' task.
// */
//package moduledynamic;
//
//import static org.junit.Assert.assertTrue;
//
//import org.junit.Test;
//
//import moduledynamic.ModuleDynamic;
//
//public class LibraryTest {
//	@Test
//	public void test() {
//		ModuleDynamic mod = new ModuleDynamic();
//		int address = 64000;
//		boolean s = mod.isReedSolomonEcc(address);
//		mod.checkEcc(address, true);
//		boolean s2 = mod.isReedSolomonEcc(address);
//
//		boolean s3 = mod.isReedSolomonEcc(32000);
//		System.out.println(s + "-" + s2 + "---" + s3);
//		assertTrue("someLibraryMethod should return 'true'", classUnderTest.someLibraryMethod());
//	}
//}
