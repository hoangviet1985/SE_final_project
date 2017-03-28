#pragma once
#include <opencv2/core/core.hpp>
#include <vector>

class Neural_Network
{
private:
	const int num_input_layer = 784;		// 28 * 28
	const int num_nodes_second_layer = 25;		// Why 25? Verify this with Viet
	const int num_output_layer = 2;		// Either 'digit' or 'not digit' 

	cv::Mat first_weighted_matrix;
	cv::Mat second_weighted_matrix;

	void initialize_weights();		// Initialize weights to random values between 0 and 1
	void linearly_combine(int index_of_weight_matrix, cv::Mat input);
	void sigmoid(cv::Mat m);
public:
	Neural_Network();
	~Neural_Network();
};

