#pragma once
#include <opencv2/core.hpp>

class Neural_Network
{
private:
	int* layers;

	cv::Mat first_weighted_matrix;
	cv::Mat second_weighted_matrix;

	cv::Mat forward_propigation(const cv::Mat& input_matrix);  // Will call linearly_combine and sigmoid
	void initialize_weights();		// Initialize weights to random values between 0 and 1
	void linearly_combine(int index_of_weight_matrix, cv::Mat input);
	void sigmoid(cv::Mat m);
public:
	Neural_Network(int l[]);
	~Neural_Network();
};

