function [ image ] = threshold_filter( img )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
level = multithresh(img);
image = imquantize(img, level);
image(image == 1) = 0;
image(image == 2) = 255;
image = uint8(image);
end

