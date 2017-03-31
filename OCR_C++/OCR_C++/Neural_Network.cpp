#include "Neural_Network.h"

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
				weight_matrices[i]->at<double>(j, k) = ((double)rand() / RAND_MAX);
			}
		}
	}
}