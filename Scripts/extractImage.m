image_name = '../Data/test_pattern.png';
output_name = 'test_pattern.hex';
fin1 = fopen(output_name, 'wt');
img = imread(image_name);
img = imresize(img, [256 256]);
img = permute(img, [3 1 2]);
img = dec2hex(img);
img = permute(img, [2 1]);
img = convertCharsToStrings(img);
fprintf(fin1, '%s', img);
fclose(fin1);

