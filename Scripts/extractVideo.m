num_frames = 200;
video_name = "test.avi";
output_name = 'chicago.hex'

video = VideoReader("test.avi");
fin1 = fopen(output_name, 'wt');

for f = [1:1:200]
    f
    img = readFrame(video);
    img = imresize(img, [256 256]);
    img = permute(img, [3 1 2]);
    img = dec2hex(img);
    img = permute(img, [2 1]);
    img = convertCharsToStrings(img);
    fprintf(fin1, "%s", img);
end
fclose(fin1);

