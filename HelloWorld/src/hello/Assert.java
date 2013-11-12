package hello;

public abstract class Assert {
	public Assert() {
		assert(true==false||true);
		assert true==false||true;
		assert true==false||true : "message";
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	
	public int i() {
		return 0;
	}

	public boolean b() {
		return true;
	}

}
