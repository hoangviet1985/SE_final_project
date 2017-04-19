#pragma once
#include <opencv2/core.hpp>
#include <cstddef>

class Neural_Network
{
private:
	size_t layer_number; //number of layers
	size_t *layer_sizes; //pointer pointing to an integer prepresents size of a layer
	cv::Mat **weight_matrices; //pointer to pointer poiting to a weight matrix

	void initialize_weights();		// Initialize weights to random values between -2 and 2
	void sigmoid(double &a);
public:
	Neural_Network(size_t l[], const size_t &size);
	void train(const cv::Mat& input_matrix, const cv::Mat &label, const double &lambda, const double &epsilon, const size_t &iter);  // Will call linearly_combine and sigmoid
	~Neural_Network();
};

