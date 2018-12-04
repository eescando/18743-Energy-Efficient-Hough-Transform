import os
from math import atan
from math import tan
from math import pi
file_path = "../FPGA/Source/atan.sv";

with open(file_path, "w") as o: 
  o.write("module atan(input logic [8:0] y, x,\n" +\
          "           output logic [2:0] dir);\n" +\
          "  logic s;\n" +\
          "  assign s = y[8] ^ x[8];\n" +\
          "  always_comb begin\n" +\
          "    case(x)\n");
  
  for j in range (0,256):
    lb = int(float(j)*tan(pi/180.0 * 22.5));
    hb = int(float(j)*tan(pi/180.0 * 67.5));
    if(lb > 255):
      lb = 255;
    if(hb > 255): 
      hb = 255;
    o.write("    8'd" + str(j) + " : begin\n"+\
            "      if(y > 8'd" + str(lb) + ") begin\n"+\
            "        if(y > 8'd" + str(hb) + ") begin\n"+\
            "          dir = 2'd2;\n"+\
            "        end else begin\n"+\
            "          dir = s ? 2'd3 : 2'd1;\n"+\
            "        end\n"+\
            "      end else begin\n"+\
            "        dir = 2'd0;\n"+\
            "      end\n"+\
            "    end\n");
  o.write("    endcase\n"+\
          "  end\n"+\
          "endmodule : atan");
  
  o.close();
     
   
