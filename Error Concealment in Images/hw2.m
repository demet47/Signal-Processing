% Load image

image_names = ["cat", "dog", "otter"];
n_list = [2,3,4,5];
n_list_col = [2;3;4;5];
bit_and_list = [0b11000000,0b11100000,0b11110000,0b11111000];
inverse_bit_list = [0b11111100,0b11111000,0b11110000,0b11100000];
hidden_extractor = [0b00000011,0b00000111,0b00001111,0b00011111];
RMSE_CAT =zeros(length(n_list), 3);
RMSE_DOG =zeros(length(n_list), 3);
RMSE_OTTER =zeros(length(n_list), 3);
iterate = 1;
rng(1); 

for image_index = 1:length(image_names)
    image_name = image_names(image_index);
    image = imread(image_name, "png");
    image = rgb2gray(image);
    % Downscale the images to half the size
    height = size(image, 1);
    width = size(image, 2);
    downsized = zeros(width / 2, height / 2, "uint8");
    downsized = image(1:2:end, 1:2:end);
    
    % concatenate four copies of downsized image into one big image
    patchwork = zeros(width, height, "uint8");
    patchwork(1:width/2, 1:height/2) = downsized;
    patchwork((width/2 + 1):end, 1:height/2) = downsized;
    patchwork((width/2 + 1):end, (height/2 + 1):end) = downsized;
    patchwork(1:width/2, (height/2 + 1):end) = downsized;
  
    % for each value of n
    
    for n_index = 1:length(n_list)
        n = n_list(n_index);
        % get the most significant n bits of the image
        patchwork_temp = bitand(patchwork, bit_and_list(n_index));
        patchwork_temp = bitshift(patchwork_temp, n - 8);
        % hide the data in least significant n bits of the original image
        hidden_image = zeros(width, height);
        hidden_image = bitand(image, inverse_bit_list(n_index));
        hidden_image(:,:) = bitor(hidden_image, patchwork_temp);
        % transmit this new image over a channel 
        imshow(hidden_image);

        DIFF1 = rmse(double(hidden_image(:)),double(image(:)));
        
        % ERROR SIMULATION. my unique corruption row index is 105
        % my student number being 2019400105
        corrupted_image = image;
        corrupted_part = zeros(30, width, "uint8");
        corrupted_part = uint8(255 * rand(30, width));
        corrupted_image(105:134, :) = corrupted_part;
        
        DIFF2 = rmse(double(corrupted_image(:)),double(image(:)));
        
        % resurrect the original part from hidden data
        % I choose the lower right corner instance to utilize
        embedded_piece = bitand(hidden_image(((height/2) + 1):end, ((width/2) + 1):end), hidden_extractor(n_index));
        embedded_piece = bitshift(embedded_piece, 8-n);
        % resize to original size the resurrection image
        upscaled_embedded_piece = zeros(height, width, "uint8");
        upscaled_embedded_piece(1:2:height, 1:2:width) = embedded_piece;
        upscaled_embedded_piece(2:2:height, 2:2:width) = embedded_piece;
        upscaled_embedded_piece(1:2:height, 2:2:width) = embedded_piece;
        upscaled_embedded_piece(2:2:height, 1:2:width) = embedded_piece;
        % Replace corrupted image with the image you got from previous step
        
        DIFF3 = rmse(double(upscaled_embedded_piece(:)), double(image(:)));
        if(image_index == 1)
            RMSE_CAT(n_index,1) = DIFF1;
        elseif(image_index == 2)
            RMSE_DOG(n_index, 1) = DIFF1;
        elseif(image_index == 3)
            RMSE_OTTER(n_index,1) = DIFF1;
        end

        if(image_index == 1)
            RMSE_CAT(n_index,2) = DIFF2;
        elseif(image_index == 2)
            RMSE_DOG(n_index, 2) = DIFF2;
        elseif(image_index == 3)
            RMSE_OTTER(n_index, 2) = DIFF2;
        end

        if(image_index == 1)
            RMSE_CAT(n_index, 3) = DIFF3;
        elseif(image_index == 2)
            RMSE_DOG(n_index, 3) = DIFF3;
        elseif(image_index == 3)
            RMSE_OTTER(n_index, 3) = DIFF3;
        end
        
        iterate = iterate + 3;
    end
end


 
T = array2table([n_list_col, RMSE_CAT(:,1), RMSE_CAT(:,2), RMSE_CAT(:,3)], 'VariableNames', {'N'; 'Rmse1ForHiddenImage';'Rmse2ForCorruptedImage';'Rmse3ForRecoveredImage'});
T = table(T,'VariableNames', "CAT");
disp(T);
    
T = array2table([n_list_col, RMSE_DOG(:,1), RMSE_DOG(:,2), RMSE_DOG(:,3)], 'VariableNames', {'N'; 'Rmse1ForHiddenImage';'Rmse2ForCorruptedImage';'Rmse3ForRecoveredImage'});
T = table(T,'VariableNames', "DOG");
disp(T);

T = array2table([n_list_col, RMSE_OTTER(:,1), RMSE_OTTER(:,2), RMSE_OTTER(:,3)], 'VariableNames', {'N'; 'Rmse1ForHiddenImage';'Rmse2ForCorruptedImage';'Rmse3ForRecoveredImage'});
T = table(T,'VariableNames', "OTTER");
disp(T);

    
    
scatter(n_list, reshape(RMSE_CAT(:,1), 1, length(n_list)));
hold on
scatter(n_list, reshape(RMSE_CAT(:,2), 1, length(n_list)));
scatter(n_list, reshape(RMSE_CAT(:,3), 1, length(n_list)));
hold off


scatter(n_list, reshape(RMSE_DOG(:,1), 1, length(n_list)));
hold on
scatter(n_list, reshape(RMSE_DOG(:,2), 1, length(n_list)));
scatter(n_list, reshape(RMSE_DOG(:,3), 1, length(n_list)));
hold off



scatter(n_list, reshape(RMSE_OTTER(:,1), 1, length(n_list)));
hold on
scatter(n_list, reshape(RMSE_OTTER(:,2), 1, length(n_list)));
scatter(n_list, reshape(RMSE_OTTER(:,3), 1, length(n_list)));
hold off
