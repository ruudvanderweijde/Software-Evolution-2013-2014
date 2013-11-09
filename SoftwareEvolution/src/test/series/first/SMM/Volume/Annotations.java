package test.series.first.SMM.Volume;

/**
 * Annotations code copied from:
 * http://en.wikipedia.org/wiki/Java_annotation
 * @author rvdw
 *
 */
public class Annotations {
	public void speak() {
	}

	public String getType() {
		return "Generic animal";
	}

	public class BuildInAnnotation extends Annotations {

		@Override
		public void speak() { // This is a good override.
			System.out.println("Meow.");
		}

		public String gettype() { // compile-time error due to mistyped name.
			return "Cat";
		}
	}

	// @Twizzle is an annotation to method toggle().
	@Twizzle
	public void toggle() {
	}

	// Declares the annotation Twizzle.
	public @interface Twizzle {
	}

	// Same as: @Edible(value = true)
	@Edible(true)
	Carrot item = new Carrot();

	public @interface Edible {
		boolean value() default false;
	}

	@Author(first = "Oompah", last = "Loompah")
	Book book = new Book();

	public @interface Author {
		String first();

		String last();
	}

	public class Item {
	}

	public class Carrot {
	}

	public class Book {
	}
}