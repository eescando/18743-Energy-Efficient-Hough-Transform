module top(
  input logic CLOCK_50,
  output logic [8:0] LEDG
  );
  
  assign LEDG[8] = res[29];
  assign LEDG[6] = res[24];
  assign LEDG[5] = res[1];

  logic clock;
  assign clock = CLOCK_50;  
endmodule : top

module grey(
  input logic [23:0] rgb_in,
  output logic [7:0] grey_out);
  
  assign grey_out = (rgb_in[7:0] >> 2) + 
                    (rgb_in[23:14] >> 2) + 
                    (rgb_in[13:8] >> 1);
endmodule : grey

module #(parameter p = 1) grey_pipe(
  input logic clock,
  input logic reset, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col,
  input logic [255:0][23:0] data_in,
  output logic data_rdy_out,
  output logic [255:0][7:0] data_out,
  output logic data_req_out);
  logic [255:0][23:0] reg_in;
  logic [255:0][7:0] grey_out;
  logic [7:0] cycle_c; 
  logic done; 
  assign data_req_out = data_req_in & data_rdy_in & (~last_col) & done;  
  assign done = cycle_c == p;
  assign 
  genvar i;
  generate
    for(i = 0; i< 256; i++) begin : alu
      if((i % p) == 0) begin
        grey conv (.rgb_in(reg_in[i]), .grey_out(grey_out[i]));
      end
    end
  endgenerate


  always_ff @(posedge clock) begin
    if(reset) begin
      cycle_c <= p;
    end
    end else if(data_req_out) begin
      reg_in <= data_in;
      cycle_c <= 8'b0;
    end
    end else if (~done) begin
      cycle_c <= cycle_c + 1'b1;
      generate
        for(i = 0; i<256; i++) begin
          if((i%p) != 0) begin
            reg_in[i-1] <= reg_in[i];
            data_out[i+1] <= data_out[i];
          end else begin
            data_out[i] <= grey_out[i];
          end
        end
      endgenerate
    end
  end
    
      
          
        
         
                    

         
   
  
  

module #(parameter r_w = 32, w = 24) input_col(
  input logic clock,
  input logic reset, 
  input logic data_req_in,
  input logic data_rdy_in,
  output logic data_rdy_out,
  output logic data_req_out,
  output logic last_col,
  output logic [255:0][(w-1):0] data_out);
  logic [7:0] addr, next_addr;
  logic [255:0][(w-1):0] data_out_n;
  logic [255:0][(r_w - w -1):0] junk;
  assign data_req_out = 1'b1;

  genvar i;
  generate
    for(i = 0; i < 256; i++) begin : ram
      logic [7:0] byte100, byte10, byte1;
      byte100 = "0" + (i/100);
      byte10  = "0" + ((i%100)/10); 
      byte1   = "0" + (i%10);
      inputRAM block #(R = {byte100, byte10, byte1}) (.clock, .q({data_out_n[i],junk[i]}),
                                                      .rdaddress(addr));
    end : ram
  endgenerate
 
  always_comb begin
    if(data_req_in) begin 
      next_addr = addr + 1'b1;
    end
    last_col = addr == 8'd255;
    data_rdy_out = 1'b1;
  end

  always_ff @(posedge clock) begin
    if(reset) begin
      addr <= 8'd0;
      data_rdy_out <= 1'b0;
    end else begin
      data_out <= data_out_n;
      data_rdy_out <= 1'b1;
      addr <= next_addr;
    end
  end
endmodule : input_col
  
