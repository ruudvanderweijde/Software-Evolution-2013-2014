package a;

import java.util.HashSet;
import java.util.Set;

class Chart {
	Set pairs;
	
	public Chart() { pairs = new HashSet(); }
	
	public void addPair(Pair p) {
		pairs.add(p);
	}
	public void checkForPair(Pair p) {
		// the code of this example is invalid...
		//return pairs.contains(p);
	}
}
