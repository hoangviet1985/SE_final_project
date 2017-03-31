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

	for (int i = 0; i < 60000; i++) {
		for (int j = 0; j < 784; j++) {
			fileIn >> input_matrix.at<double>(i, j);
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

	char c;
	for (int i = 0; i < 60000; i++) {
		fileIn >> c;
		switch (c) {
		case 0: label_matrix.at<double>(i, 0) = 1; break;
		case 1: label_matrix.at<double>(i, 1) = 1; break;
		case 2: label_matrix.at<double>(i, 2) = 1;
			break;
		case 3:
			label_matrix.at<double>(i, 3) = 1;
			break;
		case 4:
			label_matrix.at<double>(i, 4) = 1;
			break;
		case 5:
			label_matrix.at<double>(i, 5) = 1;
			break;
		case 6:
			label_matrix.at<double>(i, 6) = 1;
			break;
		case 7:
			label_matrix.at<double>(i, 7) = 1;
			break;
		case 8:
			label_matrix.at<double>(i, 8) = 1;
			break;
		default:
			label_matrix.at<double>(i, 9) = 1;
			break;
		}
	}

	for (int i = 0; i < 10; i++)
		cout << label_matrix.at<double>(0, i) << endl;
}

int main() {
	load_files();
	size_t number_layer = 3;
	size_t layer_sizes[] = {784, 25, 10};
	Neural_Network nn(layer_sizes, number_layer);
	cout << "End of program" << endl;
}