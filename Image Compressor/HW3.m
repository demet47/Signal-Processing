image = imread("test_image.jpg", "jpg");

% BELOW IS COMPRESSION
quantization_matrix_size = 8;
quantization_matrix = [64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64; 64 64 64 64 64 64 64 64];


originalSize = size(image);
newHeight = floor(originalSize(1) / quantization_matrix_size) * quantization_matrix_size;
newWidth = floor(originalSize(2) / quantization_matrix_size) * quantization_matrix_size;
croppedImage = image(1:newHeight, 1:newWidth, :);
croppedImage = im2double(croppedImage);

croppedImageNonTruncated = zeros(newHeight, newWidth, 3);


%below divide image into blocks
for i = 1:quantization_matrix_size:newHeight
    for j = 1:quantization_matrix_size:newWidth
        % Extract the block
        block = croppedImage(i:i+quantization_matrix_size-1, j:j+quantization_matrix_size-1, :);

        transformedRed = dct2(block(:,:,1));
        truncatedRed = transformedRed ./ quantization_matrix;

        transformedGreen = dct2(block(:,:,2));
        truncatedGreen = transformedGreen ./quantization_matrix;
        
        transformedBlue = dct2(block(:,:,3));
        truncatedBlue = transformedBlue ./ quantization_matrix;
        block = cat(3, truncatedRed, truncatedGreen, truncatedBlue);
        block_old = cat(3, transformedRed, transformedGreen, transformedBlue);

        croppedImage(i:i+quantization_matrix_size-1, j:j+quantization_matrix_size-1, :) = block;
        croppedImageNonTruncated(i:i+quantization_matrix_size-1, j:j+quantization_matrix_size-1, :) = block_old;
    end
end

% Convert the reconstructed image back to the range of uint8
reconstructedImage = im2uint8(croppedImage);
imwrite(reconstructedImage, "compressed_image.jpg");




%BELOW IS DECOMPRESSION

for i = 1:quantization_matrix_size:newHeight
    for j = 1:quantization_matrix_size:newWidth
        % Extract the block
        block = croppedImage(i:i+quantization_matrix_size-1, j:j+quantization_matrix_size-1, :);

        retransformedRed = idct2(block(:,:,1));
        retransformedRed = retransformedRed .* quantization_matrix;
        
        retransformedGreen = idct2(block(:,:,2));
        retransformedGreen = retransformedGreen .* quantization_matrix;
        
        retransformedBlue = idct2(block(:,:,3));
        retransformedBlue = retransformedBlue .* quantization_matrix;
        
        block = cat(3, retransformedRed, retransformedGreen, retransformedBlue);
        croppedImage(i:i+quantization_matrix_size-1, j:j+quantization_matrix_size-1, :) = block;
    end
end

% Convert the reconstructed image back to the range of uint8
reconstructedImage = im2uint8(croppedImage);
imwrite(reconstructedImage, "decompressed_image.jpg");

