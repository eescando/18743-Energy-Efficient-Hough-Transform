import os
image_path = "../Android-CPU/angle.txt"
output_path = "../Data/split_single_bar_frame_combined"
image_path_2 = "../Android-CPU/mag.txt"
if not os.path.exists(output_path):
  print ("Make directory first");
  exit();

with open(image_path) as f, open(image_path_2) as f2:
  for i in range (0, 256):
    ss = "00000" + str(i)
    o = open(output_path + "/r" +  ss[-3:] + ".mif", "w");
    o.write("DEPTH = 256;\nWIDTH=16;\nADDRESS_RADIX = HEX;\nDATA_RADIX = DEC;\nCONTENT\nBEGIN\n00:");
    for j in range (0,256):
      v = int(float(f.readline())/45.0);
      mag_sat = min(pow(int((float(f2.readline()))*255),2), 2*255*255);
      mag = int(mag_sat) >> 9;
      s = str(((v << 8) + mag)<<6);
      o.write(" " + s);
    o.write(";\nEND;"); 
    o.close()
 
