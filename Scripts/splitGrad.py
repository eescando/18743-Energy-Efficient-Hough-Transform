import os
image_path_x = "../Android-CPU/grad_x.txt"
image_path_y = "../Android-CPU/grad_y.txt"
output_path = "../Data/split_single_bar_frame_grad"

if not os.path.exists(output_path):
  print ("Make directory first");
  exit();

w, h = 256, 256;
x_vals = [[0 for x in range(w)] for y in range(h)]
with open(image_path_x) as fx:
  for i in range (0, 256):
    for j in range(0, 256):
      x_vals[i][j] = int(0.5*float(fx.readline()));

with open(image_path_y) as fy:
  for i in range (0, 256):
    ss = "00000" + str(i)
    o = open(output_path + "/r" +  ss[-3:] + ".mif", "w");
    o.write("DEPTH = 256;\nWIDTH=18;\nADDRESS_RADIX = HEX;\nDATA_RADIX = DEC;\nCONTENT\nBEGIN\n00:");
    for j in range (0,256):
      y = int(0.5*float(fy.readline()));
      y_val = (abs(y) & 0xFF) | ((y < 0) << 8);
      x_val = (abs(x_vals[i][j]) & 0xFF) | ((x_vals[i][j] < 0) << 8);
      out = int((x_val << 9) | y_val);
      s = str(out);
      o.write(" " + s);
    o.write(";\nEND;"); 
    o.close()
 
