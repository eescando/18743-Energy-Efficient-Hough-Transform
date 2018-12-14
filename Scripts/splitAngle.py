import os
image_path = "../Android-CPU/angle.txt"
output_path = "../Data/split_single_bar_frame_angle"

if not os.path.exists(output_path):
  print ("Make directory first");
  exit();

with open(image_path) as f:
  for i in range (0, 256):
    ss = "00000" + str(i)
    o = open(output_path + "/r" +  ss[-3:] + ".mif", "w");
    o.write("DEPTH = 256;\nWIDTH=3;\nADDRESS_RADIX = HEX;\nDATA_RADIX = DEC;\nCONTENT\nBEGIN\n00:");
    for j in range (0,256):
      s = str(int(float(f.readline())/45.0));
      o.write(" " + s);
    o.write(";\nEND;"); 
    o.close()
 
