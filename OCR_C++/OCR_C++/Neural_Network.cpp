#include "Neural_Network.h"
#include <math.h>
#include <iostream>
#include <ctime>

using namespace std;
using namespace cv;

Neural_Network::Neural_Network(size_t l[], const size_t &size) {
	layer_sizes = l;
	layer_number = size;
	weight_matrices = new Mat*[size - 1];

	for (size_t i = 0; i < size - 1; i++) {
		weight_matrices[i] = new Mat(layer_sizes[i + 1], layer_sizes[i] + 1, CV_64F);
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
	srand(time(NULL));
	for (size_t i = 0; i < layer_number - 1; i++) {
		for (size_t j = 0; j < layer_sizes[i + 1]; j++) {
			for (size_t k = 0; k < layer_sizes[i] + 1; k++) {
				weight_matrices[i]->at<double>(j, k) = ((double)rand() / RAND_MAX)*4 - 2;
			}
		}
	}
}

void Neural_Network::sigmoid(double &a) {
	a = 1 / (1 + exp(-a));
}


void Neural_Network::train(const Mat &input_matrix, const Mat &label, const double &lambda, const double &epsilon, const size_t &iter) {
	Mat input = input_matrix;
	double cost = 10;
	double alpha, nomi_beta;
	int sample_number = input_matrix.rows;
	Mat arrMat[] = { Mat(sample_number, 1, CV_64F, Scalar(1)), input };
	hconcat(arrMat, 2, input);
	size_t iter_num = 0;
	Mat **sigmoid_matrices = new Mat*[layer_number - 1];
	Mat **delta = new Mat*[layer_number - 1];
	Mat **theta_grad = new Mat*[layer_number - 1];
	Mat **p = new Mat*[layer_number - 1];
	Mat **old_p = new Mat*[layer_number - 1];

	for (int i = 0; i < layer_number - 1; ++i) {
		sigmoid_matrices[i] = new Mat(sample_number, layer_sizes[i + 1], CV_64F);
		delta[i] = new Mat(sample_number, layer_sizes[i + 1], CV_64F);
		theta_grad[i] = new Mat(layer_sizes[i + 1], layer_sizes[i] + 1, CV_64F);
		p[i] = new Mat(layer_sizes[i + 1], layer_sizes[i] + 1, CV_64F);
		old_p[i] = new Mat(layer_sizes[i + 1], layer_sizes[i] + 1, CV_64F);
	}
	/*
	 * Training loop
	 */
	while (iter_num < iter && cost > epsilon) {
		//compute sigmoid value matrices
		for (int i = 0; i < layer_number - 1; i++) {
			if (i == 0) {
				*sigmoid_matrices[i] = input * (*weight_matrices[i]).t();
				for (int j = 0; j < sigmoid_matrices[i]->rows; j++) {
					for (int k = 0; k < sigmoid_matrices[i]->cols; k++) {
						sigmoid(sigmoid_matrices[i]->at<double>(j, k));
					}
				}
			}
			else {
				Mat arrMat[] = { Mat(sample_number, 1, CV_64F, Scalar(1)), *sigmoid_matrices[i - 1] };
				hconcat(arrMat, 2, *sigmoid_matrices[i - 1]);
				*sigmoid_matrices[i] = (*sigmoid_matrices[i - 1]) * (*weight_matrices[i]).t();
				for (int j = 0; j < sigmoid_matrices[i]->rows; j++) {
					for (int k = 0; k < sigmoid_matrices[i]->cols; k++) {
						sigmoid(sigmoid_matrices[i]->at<double>(j, k));
					}
				}
			}
		}

		//compute delta matrices
		for (int i = layer_number - 2; i >= 0; --i) {
			if (i == layer_number - 2) {
				*delta[i] = label - (*sigmoid_matrices[i]);
			}
			else if (i == layer_number - 3) {
				*delta[i] = (*sigmoid_matrices[i]).mul(((*sigmoid_matrices[i]) - 1).mul((*delta[i + 1])*(*weight_matrices[i + 1])));
			}
			else {
				Mat temp(sample_number, layer_sizes[i + 2], CV_64F);
				size_t temp_size = layer_sizes[i + 2] + 1;
				for (int j = 1; j < temp_size; ++j) {
					(delta[i + 1]->col(j)).copyTo(temp.col(j - 1));
				}
				*delta[i] = (*sigmoid_matrices[i]).mul(((*sigmoid_matrices[i]) - 1).mul(temp*(*weight_matrices[i + 1])));
			}
		}

		//compute theta gradients of weight matrices
		for (int i = 0; i < layer_number - 2; ++i) {
			if (i != 0) {
				if (i == layer_number - 2) {
					*theta_grad[i] = (delta[i]->t() * (*sigmoid_matrices[i - 1])) / sample_number;
				}
				else {
					Mat temp(delta[i]->rows, delta[i]->cols - 1, CV_64F);
					for (int j = 1; j < delta[i]->cols; ++j) {
						(delta[i]->col(j)).copyTo(temp.col(j - 1));
					}
					*theta_grad[i] = (temp.t() * (*sigmoid_matrices[i - 1])) / sample_number;
				}
			}
			else {
				Mat temp(delta[i]->rows, delta[i]->cols - 1, CV_64F);
				for (int j = 1; j < delta[i]->cols; ++j) {
					(delta[i]->col(j)).copyTo(temp.col(j - 1));
				}
				*theta_grad[i] = (temp.t() * input) / sample_number;
			}
			
			//add nomalization term
			for (int j = 0; j < theta_grad[i]->rows; ++j) {
				for (int k = 1; k < theta_grad[i]->cols; ++k) {
					theta_grad[i]->at<double>(j, k) = theta_grad[i]->at<double>(j, k) + (lambda * (weight_matrices[i]->at<double>(j, k))) / sample_number;
				}
			}	
		}


		//compute cost
		Mat logSigmoid, mlogSigmoid, costMatrix;
		double norm_term = 0;
		cv::log(*sigmoid_matrices[layer_number - 2], logSigmoid);
		cv::log(1 - *sigmoid_matrices[layer_number - 2], mlogSigmoid);
		costMatrix = ((label - 1).mul(mlogSigmoid) - label.mul(logSigmoid)) / sample_number;
		cost = cv::sum(costMatrix)[0];
		for (int i = 0; i < layer_number - 1; ++i) {
			norm_term += (lambda * sum(weight_matrices[i]->mul(*weight_matrices[i]))[0]) / 2 / sample_number;
		}
		cost += norm_term;
		std::cout << iter_num + 1 << "--Error: " << cost << endl;
		
		//update alpha

		//update weights using conjugate gradient decent
		if (iter_num == 0) {
			nomi_beta = 0;
			for (int i = 0; i < layer_number - 1; ++i) {
				*p[i] = -(*theta_grad[i]);
				alpha = 0.5;
				*weight_matrices[i] = *weight_matrices[i] + alpha * (*p[i]);
				*old_p[i] = *p[i];
				nomi_beta += sum(theta_grad[i]->mul(*theta_grad[i]))[0];
			}
		}
		else {
			double deno_beta = 0;
			for (int i = 0; i < layer_number - 1; ++i) {
				deno_beta += sum(theta_grad[i]->mul(*theta_grad[i]))[0];
			}
			double beta = deno_beta / nomi_beta;
			nomi_beta = deno_beta;
			for (int i = 0; i < layer_number - 1; ++i) {
				*p[i] = -(*theta_grad[i]) + beta * (*old_p[i]);
				alpha = 0.5;
				*weight_matrices[i] = *weight_matrices[i] + alpha * (*p[i]);
				*old_p[i] = *p[i];
			}
		}

		++iter_num;
	}

	//clean up
	for (size_t i = 0; i < layer_number - 1; i++) {
		delete sigmoid_matrices[i];
	}
	delete[] sigmoid_matrices;
	for (int i = layer_number - 2; i >= 0; --i) {
		delete delta[i];
		delete theta_grad[i];
		delete old_p[i];
		delete p[i];
	}
	delete[] delta;
	delete[] theta_grad;
	delete[] old_p;
	delete[] p;
}