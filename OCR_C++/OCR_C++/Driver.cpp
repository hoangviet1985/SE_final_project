#include <opencv2/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <fstream>
#include <iostream>

using namespace std;
using namespace cv;

Mat input_matrix(60000, 784, CV_8UC1);

void read_in_binary_input(std::string file_path) {
	ifstream fileIn;
	fileIn.open(file_path, ios::binary);
	fileIn.seekg(16);

	for (int i = 0; i < 60000; i++) {
		for (int j = 0; j < 784; j++) {
			fileIn >> input_matrix.at<char>(i, j);
		}
	}
	fileIn.close();
}

int main() {
	read_in_binary_input("..\nn\train_labels.idx1-ubyte");
	Mat m = input_matrix.row(10);
	m = m.reshape(1, 28);
	cout.flush();
	cout << "Test" << std::flush;
	for (int i = 0; i < 28; i++) {
		for (int j = 0; j < 28; j++)
			cout << m.at<char>(i, j) << '\t';
		cout << endl;
	}
	cout << "End of program" << endl;
}