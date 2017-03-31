#pragma once
#include <opencv2/core.hpp>

class Neural_Network
{
private:
	int layer_number; //number of layers
	int *layer_sizes; //pointer pointing to an integer prepresents size of a layer
	cv::Mat **weight_matrices; //pointer to pointer poiting to a weight matrix

	cv::Mat forward_propigation(const cv::Mat& input_matrix);  // Will call linearly_combine and sigmoid
	void initialize_weights();		// Initialize weights to random values between 0 and 1
	void linearly_combine(int index_of_weight_matrix, cv::Mat input);
	void sigmoid(cv::Mat m);
public:
	Neural_Network(int l[], int size);
	~Neural_Network();
};

