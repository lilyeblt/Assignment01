% TJ Lilyeblade
% 9/6/2017
% CEC 495A

% This program is to track an ant moving through a maze

clear all;
close all;
clc;

% Loop to use all images
StartingFrame = 1;
EndingFrame = 448;
rgbp = imread('ant/img001.jpg');

Xcentroid = [];
Ycentroid = [];

for k = StartingFrame : EndingFrame-1
    rgb = imread(['ant/img',sprintf('%2.3d',k),'.jpg']);
    
    diff = rgb - rgbp;
    
    % Convert to hsv
    hsv = rgb2hsv(diff);
    I = hsv(:,:,3);

    % Threshold to get only the difference
    Ithresh = I > 0.035;

    % Make structuring element
    SE1 = strel('disk',4,0);
    SE2 = strel('disk',2,0);

    % Run opening and closing
    Iopen = imopen(Ithresh,SE1);
    Iclose = imclose(Iopen,SE2);

    [labels, number] = bwlabel(Iclose,8);
    
    if number > 0
        
        % Get basic stats
        Istats = regionprops(labels,'basic','Centroid');

        [maxVal, maxIndex] = max([Istats.Area]);

        Xcentroid = [Xcentroid Istats(maxIndex).Centroid(1)];
        Ycentroid = [Ycentroid Istats(maxIndex).Centroid(2)];
    
    end
    
    rgbp = rgb;
end
pic = imread('ant/img001.jpg');
imshow(pic);
hold on;
plot(Xcentroid, Ycentroid);