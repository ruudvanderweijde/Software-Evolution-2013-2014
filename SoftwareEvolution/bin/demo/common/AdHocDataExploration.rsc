module demo::common::AdHocDataExploration

import IO;

public int fact (int n) {
    if (n <= 1) {
	        return 1;
    } else {
	        return n * fact (n-1);
    }
}

public int countZeros (int n) {
    if (n < 10) {
	        return 0;
    } else if (n % 10 == 0) {
        return 1 + countZeros (n / 10);
    } else {
	        return countZeros (n / 10);
    }   
}

public int countTrailingZeros (int n) {
    if (n < 10) {
	        return 0;
    } else if (n % 10 == 0) {
        return 1 + countTrailingZeros (n / 10);
    } else {
	        return 0 ;
    }   
}

public void printLastTwenty (int n){
    for(int i <- [n-19..n]) {
        println ("<i>! has <countTrailingZeros(fact(i))> ? + ?trailing zeros.");
    }
}

// Printout all i in [0..n] where i! has more trailing zeros than (i-1)!
public void findLumps (int n) {
    int iMinusOneFactZeros = 0;
    for (int i <- [1..n]) {
        int iFactZeros = countTrailingZeros(fact(i));
        int diff = iFactZeros - iMinusOneFactZeros ;
        if (diff >= 1) {
        		    println ("<diff> more zeros at <i>!");
        }
        iMinusOneFactZeros = iFactZeros;
    }
}

// We can parameterize the threshold to look for jumps of 2, 3, or 4 zeros
public void findLumps2 (int n, int tao) {
    int iMinusOneFactZeros = 0;
    for (int i <- [1..n]) {
        int iFactZeros = countTrailingZeros(fact(i));
        int diff = iFactZeros - iMinusOneFactZeros ;
        if (diff >= tao) {
            println ("<diff> more zeros at <i>!");
        }
        iMinusOneFactZeros = iFactZeros;
    }
}

public int predictZeros (int N) {
    int k = floorLogBase(N, 5);  // I wrote this
    int nz = 0;
    for (int i <- [1..N] ){
	        int p5 = 1;
        for (int j <- [1..k]) {
    	        p5 *= 5;
    	        if (i % p5 == 0) {
		                nz += 1;
	            } else {
    	            	break;
	            }
        	}
    }
    return nz; 
}

public void verifyTheory (int N) {
    int checkInterval = 100; // for printing
    bool failed = false;
    for (int i <- [1..N]) {
        ifact=fact(i);
    	    int p = predictZeros(i);
    	    int c = countTrailingZeros(ifact);
    	    if (p != c) {
	            failed = true;
	            println ("Found a counter example at i=<i>");
	            break;
    	    } else {
	            if (i % checkInterval == 0) {
		                 println ("<i>! has <p> trailing zeros");
	            }
    	    }
    }
    if (!failed) {
	        println ("The theory works for i: 1..<N>?);
    }
}

// Log for an arbitrary base
public real logB(real a, real base) {
    return log(a) / log(base);
}

public real floor (real a) {
    return toReal(round (a - 0.5));
}

public int floorLogBase (int a, int b) {
    return toInt(floor(logB(toReal(a), toReal(b))));
}

public real floor (real a) {
    return toReal(round (a - 0.5 + 0.00001));
}

// Also change predictZeros to call this version
public int floorLogBase2 (int a, int b) {
    int remaining = a;
    int ans = 0;
    while (remaining >= b) {
        																					ans += 1;
        																																																																														remaining /= b;
    }
    return ans;		
}