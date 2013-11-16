package a;

import junit.framework.TestCase;

public class DynamicDispatchTest extends TestCase {
	public void test() {
		ParentBar p = new ChildBar1();
		p.barMethod();
	}
}
