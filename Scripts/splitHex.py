import os
image_path = "../Data/single_bar_frame.hex"
output_path = "../Data/split_single_bar_frame"

if not os.path.exists(output_path):
  print ("Make directory first");
  exit();

with open(image_path) as f:
  for i in range (0, 256):
    o = open(output_path + "/r" + str(i) + ".hex", "w");
    for j in range (0,256):
      s = f.read(2*3) + "00";
      o.write(s);
    
    o.close()
 
