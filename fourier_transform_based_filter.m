function [args, angles] = fourier_transform_based_filter(image)
    img = image;
    m = 2^nextpow2(size(img,1));
    pad1_dim_m = m - size(img,1);
    pad1 = ones(pad1_dim_m, size(img,2)) * 255;
    n = 2^nextpow2(size(img,2));
    img = [img; pad1];
    pad2_dim_n = n - size(img,2);
    pad2 = ones(size(img,1), pad2_dim_n) * 255;
    img = [img pad2];
    %img = imcomplement(img);
    %figure;
    %imshow(img);
    FFT = fft(img,n,2);
    FFT = fft(FFT,m,1);
    FFT = fftshift(FFT);
    
    args = abs(FFT);
    max_val = max(max(args,[],1));
    c = 255/log(1+max_val);
    args = c*log(1+args);
    args = uint8(args);
    
    angles = angle(FFT);
    max_val = max(max(angles,[],1));
    angles = abs(angles);
    c = 255/log(1+max_val);
    angles = c*log(1+angles);
    angles = uint8(angles);
end