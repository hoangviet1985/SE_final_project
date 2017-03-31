#include "Neural_Network.h"

using namespace std;
using namespace cv;

Neural_Network::Neural_Network(int l[], int size) {
	layer_sizes = l;
	layer_number = size;
	weight_matrices = new Mat*[size];

	//@TODO do this as loop
	for (int i = 0; i < size - 1; i++) {
		weight_matrices[i] = new Mat(layer_sizes[i+1], layer_sizes[i] + 1, CV_64F);
	}

	initialize_weights();
}

Neural_Network::~Neural_Network() {

}

void Neural_Network::initialize_weights() {
	for (int i = 0; i < layer_number - 1; i++) {
		for (int j = 0; j < layer_sizes[i+1]; j++) {
			for (int k = 0; k < layer_sizes[i] + 1; k++) {
				weight_matrices[i]->at<double>(j, k) = ((double)rand() / RAND_MAX);
			}
		}
	}
}