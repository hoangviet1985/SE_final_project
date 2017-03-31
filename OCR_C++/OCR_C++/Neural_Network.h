#pragma once
#include <opencv2/core.hpp>
#include <cstddef>

class Neural_Network
{
private:
	size_t layer_number; //number of layers
	size_t *layer_sizes; //pointer pointing to an integer prepresents size of a layer
	cv::Mat **weight_matrices; //pointer to pointer poiting to a weight matrix

	cv::Mat forward_propigation(const cv::Mat& input_matrix);  // Will call linearly_combine and sigmoid
	void initialize_weights();		// Initialize weights to random values between -2 and 2
	void linearly_combine(int index_of_weight_matrix, cv::Mat input);
	void sigmoid(cv::Mat m);
public:
	Neural_Network(size_t l[], const size_t &size);
	~Neural_Network();
};

