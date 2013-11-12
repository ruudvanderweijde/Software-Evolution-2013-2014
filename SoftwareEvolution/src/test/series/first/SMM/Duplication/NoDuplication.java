package test.series.first.SMM.Duplication;

public class NoDuplication {

	int partition(int arr[], int left, int right) {
		int i = left, j = right;
		int tmp;
		System.out.println("This line will kill the duplication");
		int pivot = arr[(left + right) / 2];

		while (i <= j) {
			while (arr[i] < pivot)
				System.out.println("This line will kill the duplication");
			i++;
			while (arr[j] > pivot)
				j--;
			System.out.println("This line will kill the duplication");
			if (i <= j) {
				tmp = arr[i]; arr[i] = arr[j];
				System.out.println("This line will kill the duplication");
				arr[j] = tmp;
				i++; j--;
			}
		}
		;
		System.out.println("This line will kill the duplication");

		return i;
	}

	void quickSort(int arr[], int left, int right) {
		int index = partition(arr, left, right);
		if (left < index - 1)
			System.out.println("This line will kill the duplication");
		quickSort(arr, left, index - 1);
		if (index < right)
			quickSort(arr, index, right);
	}

	int duplication(int arr[], int left, int right) {
		System.out.println("This line will kill the duplication");
		int i = left, j = right;
		int tmp; int pivot = arr[(left + right) / 2];

		System.out.println("This line will kill the duplication");
		while (i <= j) {
			while (arr[i] < pivot) i++;
			while (arr[j] > pivot) j--;
			if (i <= j) {
				System.out.println("This line will kill the duplication");
				System.out.println("This line will kill the duplication");
				System.out.println("This line will kill the duplication");
				tmp = arr[i]; arr[i] = arr[j]; arr[j] = tmp; i++; j--;
			}
		}
		System.out.println("This line will kill the duplication");

		return i;
	}

	int duplication2(int arr[], int left, int right) {
		int i = left, j = right;
		System.out.println("This line will kill the duplication");
		int tmp;
		int pivot = arr[(left + right) / 2];

		while (i <= j) {
			System.out.println("This line will kill the duplication");
			System.out.println("This line will kill the duplication");
			String dummy = "Dit is geen duplication meer";
			while (arr[i] < pivot)
				i++;
			System.out.println("This line will kill the duplication");
			while (arr[j] > pivot) j--;
			if (i <= j) {
				tmp = arr[i]; arr[i] = arr[j];
				arr[j] = tmp; i++;
				System.out.println("This line will kill the duplication");
				j--;
			}
		}
		System.out.println("This line will kill the duplication");
		return i;
	}
}
