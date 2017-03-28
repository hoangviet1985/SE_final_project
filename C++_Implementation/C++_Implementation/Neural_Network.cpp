#include "Neural_Network.h"


using namespace std;
using namespace cv;

Neural_Network::Neural_Network(){
	first_weighted_matrix = Mat(num_nodes_second_layer, num_input_layer, CV_8U);
	second_weighted_matrix = Mat(num_output_layer, num_nodes_second_layer, CV_8U);

	initialize_weights();
}

Neural_Network::~Neural_Network(){

}

void Neural_Network::initialize_weights(){
	// First Matrix
	for (int i = 0; i < num_nodes_second_layer; i++) {
		for (int j = 0; j < num_input_layer; j++) {
			first_weighted_matrix.at<float>(i, j) = ((double)rand() / RAND_MAX);
		}
	}

	// Second Matrix
	for (int i = 0; i < num_output_layer; i++) {
		for (int j = 0; j < num_nodes_second_layer; j++) {
			second_weighted_matrix.at<float>(i, j) = ((double)rand() / RAND_MAX);
		}
	}
}