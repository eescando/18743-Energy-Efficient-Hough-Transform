module top(
  input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [17:0] LEDR
  );
  parameter W = 8;
  logic clock;
  logic [(W-1):0] no_out;
  assign no_out = 100'd0;
  assign clock = CLOCK_50;

  logic final_rdy, final_last, init;
  assign init = (final_rdy && final_last) | (~KEY[0]);
  
  always_ff @(posedge KEY[1]) begin
    if(SW[16]) begin
      LEDR[(W-1):0] <= out_data[SW[7:0]];
	 end else begin
	   LEDR[(W-1):0] <= no_out;
	 end
  end
  
  assign final_rdy = s_data_rdy[1];
  assign final_last = s_last_col[1];
  
  logic [10:0] s_data_req, s_data_rdy, s_last_col;
  logic [255:0][23:0] rgb_data;
  input_col #(32,24) ii (.clock, .init, .data_req_in(s_data_req[1]), .data_req_out(s_data_req[0]),
                                    .data_rdy_in(1'b1), .data_rdy_out(s_data_rdy[0]), .last_col_out(s_last_col[0]),
												.last_col_in(1'b0), .data_out(rgb_data));
  
  grey_pipe #(1) gp (.clock, .init, .data_req_in(1'b1), .data_req_out(s_data_req[1]),
                                    .data_rdy_in(s_data_rdy[0]), .data_rdy_out(s_data_rdy[1]), .last_col_out(s_last_col[1]),
												.last_col_in(s_last_col[0]), .data_out(out_data), .data_in(rgb_data));
												
  logic [255:0][(W-1):0] out_data; 
  
endmodule : top



module grey(
  input logic [23:0] rgb_in,
  output logic [7:0] grey_out);
  
  assign grey_out = (rgb_in[7:0] >> 2) + 
                    (rgb_in[23:14] >> 2) + 
                    (rgb_in[13:8] >> 1);
endmodule : grey

module grey_pipe(
  input logic clock,
  input logic init, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col_in,
  input logic [255:0][23:0] data_in,
  output logic data_rdy_out,
  output logic [255:0][7:0] data_out,
  output logic data_req_out,
  output logic last_col_out);
  parameter p = 1;
  
  logic [255:0][23:0] reg_in;
  logic [255:0][7:0] grey_out;
  logic [7:0] cycle_c; 
   
  assign data_rdy_out = (cycle_c == p);
  assign data_req_out = data_rdy_out && (~last_col_out) && data_req_in;
  
  genvar i;
  generate
    for(i = 0; i< 256; i++) begin : alu
      if((i % p) == 0) begin
        grey conv (.rgb_in(reg_in[i]), .grey_out(grey_out[i]));
      end
    end
  endgenerate


  always_ff @(posedge clock) begin
    if(init) begin
      cycle_c <= p;
      last_col_out <= 1'b0;
    end else if(data_req_out & data_rdy_in) begin
		last_col_out <= last_col_in;
      cycle_c <= 8'b0;
    end else if (~data_rdy_out) begin
      cycle_c <= cycle_c + 1'b1;
    end
  end

  generate
    for(i = 0; i<256; i++) begin : shifts
	   always_ff @(posedge clock) begin
        if(data_req_out & data_rdy_in) begin
		    reg_in[i] <= data_in[i];
		  end else if(~data_rdy_out) begin
		    if((i%p) != 0) begin
            reg_in[i-1] <= reg_in[i];
            data_out[i+1] <= data_out[i];
          end else begin
            data_out[i] <= grey_out[i];
          end
        end
		end
    end
  endgenerate
endmodule : grey_pipe
            
module input_col(
  input logic clock,
  input logic init, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col_in,
  output logic data_rdy_out,
  output logic data_req_out,
  output logic last_col_out,
  output logic [255:0][(w-1):0] data_out);
  parameter r_w = 32;
  parameter w = 24;
  logic [7:0] addr, next_addr;
  logic [255:0][(w-1):0] data_out_n;
  logic [255:0][(r_w - w -1):0] junk;
  assign data_req_out = 1'b0;

  genvar i, s;
  generate
    for(i = 0; i < 256; i++) begin : ram
      inputRAM #("000"+((i/100)<<16) + (((i%100)/10)<<8) + (i%10)) block (.clock, .q({data_out_n[i],junk[i]}),
                                                      .rdaddress(addr));
    end : ram
  endgenerate
 
  always_comb begin
    next_addr = addr;
	 last_col_out = (addr == 8'd255);
    if(data_req_in) begin 
      next_addr = addr + 1'b1;
    end
  end

  always_ff @(posedge clock) begin
    if(init) begin
      addr <= 8'd0;
      data_rdy_out <= 1'b0;
    end else begin
      data_out <= data_out_n;
      data_rdy_out <= 1'b1;
      addr <= next_addr;
    end
  end
endmodule : input_col

module blur(
  input logic clock,
  input logic reset,
  output logic done,
  output logic [7:0] sum,
  input logic [8:0][7:0] vals);
  
  logic [3:0] cycle_c;
  logic [7:0] n_sum;
  
  always_comb begin
    case (cycle_c)
	   0: n_sum = (vals[0]<<4) + (vals[1]<<3);
		1: n_sum = (n_sum + (vals[2]<<4));
		2: n_sum = (n_sum + (vals[3]<<3));
		3: n_sum = (n_sum + (vals[4]<<2));
		4: n_sum = (n_sum + (vals[5]<<3));
		5: n_sum = (n_sum + (vals[6]<<4));
		6: n_sum = (n_sum + (vals[7]<<3));
		7: n_sum = (n_sum + (vals[8]<<4));
	 endcase
  end
  
  always_ff @(posedge clock) begin
    if(reset) begin
	   sum <= 8'd0;
		cycle_c <= 4'd0;
		done <= 1'd0;
	 end else if(~done)
	   cycle_c <= cycle_c + 1'b1;
      sum <= n_sum;
		done <= (cycle_c == 4'd7);
    end
  end
endmodule : blur 

module blur_pipe(
  input logic clock,
  input logic init, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col_in,
  input logic [255:0][7:0] data_in,
  output logic data_rdy_out,
  output logic [255:0][7:0] data_out,
  output logic data_req_out,
  output logic last_col_out);
  
  logic first_col;
  logic reset_blur;
  logic done_blur; 
  logic [257:0][2:0][7:0] reg_in;
  logic [7:0] cycle_c; 
  assign reg_in[0] = 21'b0;
  assign reg_in[257] = 21'b0;
  assign data_rdy_out = (cycle_c == p);
  assign data_req_out = data_rdy_out && (~last_col_out) && data_req_in;
  
  genvar i;
  generate
    for(i = 0; i< 256; i++) begin : alu
        blur (.clock, .reset(reset_blur), .done(done_blur), .out(data_out[i]),
              .in({reg_in[i][0], reg_in[i][1], reg_in[i][2],reg_in[i+1][0], reg_in[i+1][1],
				       reg_in[i+1][2], reg_in[i+2][0], reg_in[i+2][1], reg_in[i+2][2]}));
	 end
  endgenerate


  always_ff @(posedge clock) begin
    if(init) begin
      cycle_c <= end_c;
      data_req_out <= 1'b1;
		  data_rdy_out <= 1'b0;
		  last_col_out <= 1'b0;
		  first_col <= 1'b1;
	 end
    end else if(data_req_out & (data_rdy_in || last_col_in)) begin
	   if(first_col) begin
		  reg_in[256:1][0] <= data_in;
		  first_col <= 1'b0;
		  data_out_req <= 1'b1;
		end else if (last_col_in) begin
		  reg_in[256:1][0] <= 2048'b0;
		  data_req_out <= 1'b0;
		  last_col_out <= 1'b1;
        cycle_c <= 8'b0;
      end else if (~data_rdy_out) begin
      cycle_c <= cycle_c + 1'b1;
    end
  end

endmodule : blur_pipe
