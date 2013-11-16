package a;

import junit.framework.TestCase;

public class LibrariesTest extends  TestCase {
	public void test() {
		Chart c = new Chart();
		
		Pair p1 = new Pair(3,5);
		c.addPair(p1);
		
		Pair p2 = new Pair(3,5);
		c.checkForPair(p2);
	}
}
