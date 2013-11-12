package test.series.first.SMM.Duplication;

public class Duplication0 {
	public void Dummy() {
		int a = 0;
		int b = 0;
		int c = 0;
		int d = 0;
		int e = 0;
		int f = 0;
		
		a += b;
		b += c;
		c += d;
		d += e;
		e += f;
		f += a;
		
		a += b;
		b += c;
		c += d;
		d += e;
		e += f; f += a;
	}
}
