img = imread('test_pattern.png');
gray = (0.25*img(:,:,1) + 0.5*img(:,:,2) + 0.25*img(:,:,3));
BW = edge(gray,'canny');
[H,T,R] = hough(BW);
P  = houghpeaks(H,50,'threshold',ceil(0.3*max(H(:)))); % 5 -> 15
x = T(P(:,2)); y = R(P(:,1));

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7); % 7 -> 20
figure, imshow(img*0.5), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

%plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan');