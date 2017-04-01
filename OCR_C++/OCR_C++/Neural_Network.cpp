#include "Neural_Network.h"
#include <math.h>

using namespace std;
using namespace cv;

Neural_Network::Neural_Network(size_t l[], const size_t &size) {
	layer_sizes = l;
	layer_number = size;
	weight_matrices = new Mat*[size-1];

	//@TODO do this as loop
	for (size_t i = 0; i < size - 1; i++) {
		weight_matrices[i] = new Mat(layer_sizes[i+1], layer_sizes[i] + 1, CV_64F);
	}

	initialize_weights();
}

Neural_Network::~Neural_Network() {
	for (size_t i = 0; i < layer_number - 1; i++) {
		delete weight_matrices[i];
	}
	delete[] weight_matrices;
}

void Neural_Network::initialize_weights() {
	for (size_t i = 0; i < layer_number - 1; i++) {
		for (size_t j = 0; j < layer_sizes[i+1]; j++) {
			for (size_t k = 0; k < layer_sizes[i] + 1; k++) {
				weight_matrices[i]->at<double>(j, k) = ((double)rand() / RAND_MAX)*4 - 2;
			}
		}
	}
}

void Neural_Network::sigmoid(double &a) {
	a = 1 / (1 + exp(-a));
}

Mat Neural_Network::forward_propagation(const Mat &input_matrix) {
	Mat output = input_matrix;
	int sample_number = input_matrix.rows;
	for (int i = 0; i < layer_number - 1; i++) {
		Mat arrMat[] = { Mat(sample_number, 1, CV_64F, Scalar(1)), output };
		hconcat(arrMat, 2, output);
		output = output * (*weight_matrices[i]).t();
		for (int j = 0; j < layer_sizes[i]; j++) {
			for (int k = 0; k < layer_sizes[i + 1]; k++) {
				sigmoid(output.at<double>(j, k));
			}
		}
	}
	return output;
}