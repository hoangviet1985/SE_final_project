function applying_filters(source, destination)
img = imread(source); % Reading in file
img = rgb2gray(img); % Converting from rgb to grayscale
[s, img] = histogram_based_filter(img); % Applying histogram filter

if s ~= 0
    error('Histogram filter failed') 
end

img = threshold_filter(img); % Applying threshold filter

img = imcomplement(img); % Compliment image so background is black and writing is white

imwrite(img, destination); % Writing filtered image to file
end