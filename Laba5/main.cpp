#include <iostream>
#include "omp.h"

using namespace std;

const int arr_rows = 100'000;
const int arr_cols = 2000;

int* arr2[arr_rows];

void init_arr();
long long part_sum(int, int, int);
long long part_min(int, int, int);

int main() {
	
	init_arr();

	omp_set_nested(1);
	double t1 = omp_get_wtime();

	#pragma omp parallel sections
	{
		#pragma omp section
		{
			cout << part_min(0, arr_rows, 1) << endl;
			cout << part_min(0, arr_rows, 2) << endl;
			cout << part_min(0, arr_rows, 3) << endl;
			cout << part_min(0, arr_rows, 4) << endl;
			cout << part_min(0, arr_rows, 8) << endl;
			cout << part_min(0, arr_rows, 10) << endl;
			cout << part_min(0, arr_rows, 16) << endl;
			cout << part_min(0, arr_rows, 32) << endl;
		}
		
		#pragma omp section
		{
			cout << part_sum(0, arr_rows, 1) << endl;
			cout << part_sum(0, arr_rows, 2) << endl;
			cout << part_sum(0, arr_rows, 3) << endl;
			cout << part_sum(0, arr_rows, 4) << endl;
			cout << part_sum(0, arr_rows, 8) << endl;
			cout << part_sum(0, arr_rows, 10) << endl;
			cout << part_sum(0, arr_rows, 16) << endl;
			cout << part_sum(0, arr_rows, 32) << endl;
		}
	}
	double t2 = omp_get_wtime();
	
	cout << "Total time - " << t2 - t1 << " seconds" << endl;
	return 0;
}

void init_arr() {

	for(int i = 0; i < arr_rows; i++){
		arr2[i] = new int[arr_cols];
	}

	for (int i = 0; i < arr_rows; i++) {
		for(int j = 0; j < arr_cols; j++){
			arr2[i][j] = 1;
		}
	}

	arr2[arr_rows / 2][arr_cols / 2] = -100;
}

long long part_sum(int start_index, int finish_index, int num_threads) {
	long long sum = 0;
	double t1 = omp_get_wtime();

	#pragma omp parallel for \
				reduction(+: sum) \
				num_threads(num_threads)
	for (int i = start_index; i < finish_index; i++) {
		for(int j = 0; j < arr_cols; j++){
			sum += arr2[i][j];
		}	
	}
	
	double t2 = omp_get_wtime();

	cout << "sum " << num_threads << " threads worked - " << t2 - t1 << " seconds" <<  endl;

	return sum;
}

long long part_min(int start_index, int finish_index, int num_threads) {
    int min = arr2[0][0];
	string indexMin = "-1";

    double t1 = omp_get_wtime();

    #pragma omp parallel num_threads(num_threads)
    {
        int local_min = arr2[0][0];
        string local_indexMin = "";

        #pragma omp for
        for (int i = start_index; i < finish_index; i++) {
            for(int j = 0; j < arr_cols; j++) {
                
                if (local_min > arr2[i][j]) {
                    local_min = arr2[i][j];
                    local_indexMin = "Index row: " + to_string(i) + " col: " + to_string(j);
                }
            }
        }

        #pragma omp critical
        {
            if (local_min < min) {
                min = local_min;
                indexMin = local_indexMin;
            }
        }
    }

    double t2 = omp_get_wtime();

    cout << "min " << num_threads << " threads worked - " << t2 - t1 << " seconds " << "| min position: " << indexMin << endl;

    return min;
}