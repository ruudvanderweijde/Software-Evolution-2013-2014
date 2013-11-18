package test.series.first.SMM.Duplication;

public class Duplication34 {

	int partition(int arr[], int left, int right) {
		int i = left, j = right;
		int tmp;
		int pivot = arr[(left + right) / 2];

		while (i <= j) {
			while (arr[i] < pivot)
				i++;
			while (arr[j] > pivot)
				j--;
			if (i <= j) {
				tmp = arr[i];
				arr[i] = arr[j];
				arr[j] = tmp;
				i++;
				j--;
				j--;
			}
		}
		;

		return i;
	}

	void quickSort(int arr[], int left, int right) {
		int index = partition(arr, left, right);
		if (left < index - 1)
			quickSort(arr, left, index - 1);
		if (index < right)
			quickSort(arr, index, right);
	}

	int duplication(int arr[], int left, int right) {
		int i = left, j = right;
		int tmp; /* comment in duplicate code */
		int pivot = arr[(left + right) / 2];
		// this is still duplicate

		while (i <= j) {
			while (arr[i] < pivot)
				i++;
			while (arr[j] > pivot)
				j--;
			if (i <= j) {
				tmp = arr[i];
				arr[i] = arr[j];
				arr[j] = tmp;
				i++;
				j--;
				j--;
			}
		}
		;

		return i;
	}

	int noDuplication(int arr[], int left, int right) {
		int i = left, j = right;
		int tmp2;
		int pivot = arr[(left + right) / 2];
		System.out.println("extra to fore no litarel dupe");
		while (i <= j) {
			String dummy = "no duplicate code, because it is only 5 lines";
			while (arr[i] < pivot)
				i++;
		}
		;

		return i;
	}

	/* this function contains no duplication */
	int duplicationTestFunction(int arr[], int left, int right) {
		int i = left, j = right;
		System.out.println("This");
		int tmp;
		int pivot = arr[(left + right) / 2];

		System.out.println("is");
		while (i <= j) {
			while (arr[i] < pivot)
				i++;
			while (arr[j] > pivot)
				j--;
			System.out.println("no");
			if (i <= j) {
				tmp = arr[i];
				arr[i] = arr[j];
				System.out.println("duplicate");
				arr[j] = tmp;
				i++;
				j--;
				System.out.println("code.");
			}
			System.out.println("!");
		}
		return i;
	}
}