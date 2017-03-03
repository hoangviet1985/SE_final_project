img = imread('../imgs2/sample14.png'); % Reading in image
img = rgb2gray(img); % In case there is extra information
result = zeros(1,784); % 0 vector

for i=0:28:size(img,1)-28
	for j=0:28:size(img,2)-28
		window = img(i+1:i+28, j+1:j+28);
		window = reshape(window, 1, []);
		result = [result; window];
	end
end

result = logical(result);
sample14 = double(result);