video = VideoReader("test.avi");
fin1 = fopen('chicago_1.hex', 'wt');
fin2 = fopen('chicago_2.hex', 'wt');
fin3 = fopen('chicago_3.hex', 'wt');

for f = [1:1:600]
    f
    img = readFrame(video);
    img = imresize(img, [256 256]);
    img = permute(img, [3 1 2]);
    img = dec2hex(img);
    img = permute(img, [2 1]);
    img = convertCharsToStrings(img);
    if(f <= 200)
        fprintf(fin1, "%s", img);
    elseif (f <= 400) 
        fprintf(fin2, "%s", img);
    else 
        fprintf(fin3, "%s", img);
    end
end
fclose(fin1);
fclose(fin2);
fclose(fin3); 