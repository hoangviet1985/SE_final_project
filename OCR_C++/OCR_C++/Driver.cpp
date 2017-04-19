#include <opencv2/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <fstream>
#include <iostream>
#include "Neural_Network.h"

using namespace std;
using namespace cv;

Mat input_matrix(60000, 784, CV_64F);
Mat label_matrix(60000, 10, CV_64F);

void load_files() {
	// First file (image file)
	ifstream fileIn("..\\..\\nn\\train-images.idx3-ubyte", ios::binary);
	if (fileIn.fail()) {
		cout << "Error opening file" << endl;
		exit(1);
	}
	fileIn.seekg(16);

	char temp[784];
	for (int i = 0; i < 60000; i++) {
		fileIn.read(temp, 784);
		for (int j = 0; j < 784; j++) { 
			input_matrix.at<double>(i, j) = (unsigned char)temp[j];//range from 0 to 255
			input_matrix.at<double>(i, j) = input_matrix.at<double>(i, j) / 255; //range from 0 to 1;
		}
	}
	fileIn.close();

	// Second file (label file)
	fileIn.open("..\\..\\nn\\train-labels.idx1-ubyte", ios::binary);
	if (fileIn.fail()) {
		cout << "Error opening file" << endl;
		exit(1);
	}

	fileIn.seekg(8);

	char c[1000];
	for (int i = 0; i < 60; ++i) {
		fileIn.read(c, 1000);
		for (int j = 0; j < 1000; j++) {
			switch (c[j]) {
			case 0: label_matrix.at<double>(i * 1000 + j, 0) = 1; break;
			case 1: label_matrix.at<double>(i * 1000 + j, 1) = 1; break;
			case 2: label_matrix.at<double>(i * 1000 + j, 2) = 1; break;
			case 3: label_matrix.at<double>(i * 1000 + j, 3) = 1; break;
			case 4: label_matrix.at<double>(i * 1000 + j, 4) = 1; break;
			case 5: label_matrix.at<double>(i * 1000 + j, 5) = 1; break;
			case 6: label_matrix.at<double>(i * 1000 + j, 6) = 1; break;
			case 7: label_matrix.at<double>(i * 1000 + j, 7) = 1; break;
			case 8: label_matrix.at<double>(i * 1000 + j, 8) = 1; break;
			default:label_matrix.at<double>(i * 1000 + j, 9) = 1; break;
			}
		}
	}
}

int main() {
	cout << "Loading training data ..." << endl;
	load_files();
	cout << "Training ..." << endl;
	size_t number_layer = 3;
	size_t layer_sizes[] = {784, 25, 10};
	Neural_Network nn(layer_sizes, number_layer);
	nn.train(input_matrix, label_matrix, 0.01, 0.001, 10);//traning set, label set, regularization parameter, minimum error
	cout << "Training done." << endl;
	system("pause");//system("read") for Linux -> Press any key to continue...
}