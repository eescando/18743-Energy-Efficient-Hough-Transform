`define PAR 256

module top(
  input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [17:0] LEDR,
  output logic [8:0] LEDG
  );
  
  parameter W = 8;
  logic clock;
  logic [(W-1):0] no_out;
  assign no_out = 100'd0;
  assign clock = CLOCK_50;
  logic [7:0] test_sum;
  logic [3:0] test_cycle;
  
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
  logic [15:0] mult_res;
  /*assign LEDG = mult_res[15:8];
  mult m1 (.dataa(SW[15:8]),.result(mult_res));*/
  logic [10:0] s_data_req, s_data_rdy, s_last_col;
  logic [255:0][23:0] rgb_data;
  logic [255:0][7:0] grey_data;
  logic [255:0][7:0] blur_data;
  logic [255:0][17:0] grad_data;
  input_col #(18, 18) ii (.clock, .init, .data_req_in(s_data_req[1]), .data_req_out(s_data_req[0]),
                                    .data_rdy_in(1'b1), .data_rdy_out(s_data_rdy[0]), .last_col_out(s_last_col[0]),
												.last_col_in(1'b0), .data_out(grad_data));
  /*assign s_data_req[2] = 1'b1; 
  grey_pipe #(1) gyp (.clock, .init, .data_req_in(s_data_req[2]), .data_req_out(s_data_req[1]),
                                    .data_rdy_in(s_data_rdy[0]), .data_rdy_out(s_data_rdy[1]), .last_col_out(s_last_col[1]),
   											.last_col_in(s_last_col[0]), .data_out(grey_data), .data_in(rgb_data));*/
  
  /*assign s_data_req[3] = 1'b1;
  assign s_data_req[1] = s_data_req[2];
  assign s_data_rdy[1] = s_data_rdy[0];
  assign s_last_col[1] = s_last_col[0];
  blur_pipe      bup (.clock, .init, .data_req_in(s_data_req[3]), .data_req_out(s_data_req[2]),
                                    .data_rdy_in(s_data_rdy[1]), .data_rdy_out(s_data_rdy[2]), .last_col_out(s_last_col[2]),
   											.last_col_in(s_last_col[1]), .data_out(blur_data), .data_in(grey_data),
												.test_sum, .test_cycle);*/								
  
  
  /*assign s_data_req[4] = 1'b1;
  assign s_data_req[1] = s_data_req[3];
  assign s_data_rdy[2] = s_data_rdy[0];
  assign s_last_col[2] = s_last_col[0];
  grad_pipe      gdp (.clock, .init, .data_req_in(s_data_req[4]), .data_req_out(s_data_req[3]),
                                    .data_rdy_in(s_data_rdy[2]), .data_rdy_out(s_data_rdy[3]), .last_col_out(s_last_col[3]),
   											.last_col_in(s_last_col[2]), .data_out(out_data), .data_in(blur_data));*/
  
  
  /*assign s_data_req[5] = 1'b1;
  assign s_data_req[1] = s_data_req[4];
  assign s_data_rdy[3] = s_data_rdy[0];
  assign s_last_col[3] = s_last_col[0];
  mag_pipe #(1)     mp (.clock, .init, .data_req_in(s_data_req[5]), .data_req_out(s_data_req[4]),
                                    .data_rdy_in(s_data_rdy[3]), .data_rdy_out(s_data_rdy[4]), .last_col_out(s_last_col[4]),
   											.last_col_in(s_last_col[3]), .data_out(out_data), .data_in(grad_data));*/
  
  assign s_data_req[6] = 1'b1;
  assign s_data_req[1] = s_data_req[5];
  assign s_data_rdy[4] = s_data_rdy[0];
  assign s_last_col[4] = s_last_col[0];
  atan_pipe #(2)     atp (.clock, .init, .data_req_in(s_data_req[6]), .data_req_out(s_data_req[5]),
                                    .data_rdy_in(s_data_rdy[4]), .data_rdy_out(s_data_rdy[5]), .last_col_out(s_last_col[5]),
   											.last_col_in(s_last_col[4]), .data_out(out_data), .data_in(grad_data));
												
  logic [255:0][(W-1):0] out_data;
endmodule : top

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
    for(i = 0; i < `PAR; i++) begin : ram
      gradRAM #("000"+((i/100)<<16) + (((i%100)/10)<<8) + (i%10)) block (.clock, .q({data_out_n[i],junk[i]}),
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

module grey(
  input logic [23:0] rgb_in,
  output logic [7:0] grey_out);
  
  assign grey_out = ({2'b0,rgb_in[7:2]}) + 
                    ({2'b0,rgb_in[23:16]}) + 
                    ({1'b0,rgb_in[13:9]});
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
            
module blur(
  input logic clock,
  input logic en,
  input logic reset,
  output logic done,
  output logic [7:0] out,
  output logic [7:0] test_sum,
  output logic [3:0] test_cycle,
  input logic [8:0][7:0] in);
  assign test_cycle = cycle_c;
  assign test_sum = n_sum;
  logic [3:0] cycle_c;
  logic [7:0] n_sum;
  
  always_comb begin
    n_sum = 8'd0;
    case (cycle_c)
	   8'd0: n_sum = ({4'b0,in[0][7:4]}) + ({3'b0,in[1][7:3]});
		8'd1: n_sum = (out + ({4'b0, in[2][7:4]}));
		8'd2: n_sum = (out + ({3'b0, in[3][7:3]}));
		8'd3: n_sum = (out + ({2'b0, in[4][7:2]}));
		8'd4: n_sum = (out + ({3'b0, in[5][7:3]}));
		8'd5: n_sum = (out + ({4'b0, in[6][7:4]}));
		8'd6: n_sum = (out + ({3'b0, in[7][7:3]}));
		8'd7: n_sum = (out + ({4'b0, in[8][7:4]}));
	 endcase
  end
  
  always_ff @(posedge clock) begin
    if(reset) begin
	   out <= 8'd0;
		cycle_c <= 4'd0;
		done <= 1'd0;
	 end else if(~done && en) begin
	   cycle_c <= cycle_c + 4'b1;
      out <= n_sum;
		done <= (cycle_c == 4'd7);
    end else if(en) begin
	   done <= 1'b1;
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
  output logic last_col_out,
  output logic [7:0] test_sum,
  output logic [3:0] test_cycle);
  
  logic first_col;
  logic reset_blur;
  logic [255:0] done_blur;
  logic en_blur;
  logic [2:0][257:0][7:0] reg_in;
  logic second_col;
  assign reg_in[0][0] = 8'b0;
  assign reg_in[0][257] = 8'b0;
  assign reg_in[1][0] = 8'b0;
  assign reg_in[1][257] = 8'b0;
  assign reg_in[2][0] = 8'b0;
  assign reg_in[2][257] = 8'b0;
  assign data_rdy_out = done_blur[0];
  assign reset_blur = (data_rdy_out && data_req_in) || init; 
  assign data_req_out = ((data_rdy_out) && (~last_col_out) && (data_req_in)) || (first_col || second_col);
   
  genvar i;
  generate
    for(i = 0; i< `PAR; i++) begin : alu
	     if(i!=0) begin 
			blur bu (.clock, .en(en_blur), .reset(reset_blur), .done(done_blur[i]), .out(data_out[i]),
						.in({reg_in[0][i], reg_in[1][i], reg_in[2][i],reg_in[0][i+1], reg_in[1][i+1],
				     reg_in[2][i+1], reg_in[0][i+2], reg_in[1][i+2], reg_in[2][i+2]}));
		  end else begin
			blur bu (.clock, .en(en_blur), .reset(reset_blur), .done(done_blur[i]), .out(data_out[i]),
						.in({reg_in[0][i], reg_in[1][i], reg_in[2][i],reg_in[0][i+1], reg_in[1][i+1],
				     reg_in[2][i+1], reg_in[0][i+2], reg_in[1][i+2], reg_in[2][i+2]}),.test_sum, .test_cycle);
		  end
	 end
  endgenerate

  always_ff @(posedge clock) begin
    if(init) begin
		reg_in[2][256:1] <= reg_in[1][256:1]; 
		reg_in[1][256:1] <= reg_in[0][256:1];
		reg_in[0][256:1] <= 2048'b0;
		last_col_out <= 1'b0;
		first_col <= 1'b1;
		en_blur <= 1'd0;
    end else if(data_req_out && (data_rdy_in || last_col_in)) begin
	   if(first_col) begin
		  reg_in[2][256:1] <= reg_in[1][256:1]; 
		  reg_in[1][256:1] <= reg_in[0][256:1];
		  reg_in[0][256:1] <= data_in;
		  first_col <= 1'b0;
		  second_col <= 1'b1;
		  last_col_out <= 1'b0;
		  en_blur <= 1'd0;
		end else if (~data_rdy_in && last_col_in) begin
		  reg_in[2][256:1] <= reg_in[1][256:1]; 
		  reg_in[1][256:1] <= reg_in[0][256:1];
		  reg_in[0][256:1] <= 2048'b0;
		  last_col_out <= 1'b1;
		  first_col <= 1'b0;
		  en_blur <= 1'b1;
		end else begin
		  reg_in[2][256:1] <= reg_in[1][256:1]; 
		  reg_in[1][256:1] <= reg_in[0][256:1];
		  reg_in[0][256:1] <= data_in;
	     last_col_out <= 1'b0;
		  en_blur <= 1'b1;
		  first_col <= 1'b0;
		  second_col <= 1'b0;
      end
    end
  end
endmodule : blur_pipe

module grad(
  input logic clock,
  input logic en,
  input logic reset,
  output logic done,
  output logic [8:0] out_x,
  output logic [8:0] out_y,
  input logic [8:0][7:0] in);
  
  logic [3:0] cycle_c;
  logic [8:0] n_sum_x, n_sum_y, neg_sum_x, neg_sum_y, sum_y, sum_x;
  assign neg_sum_x = (~sum_x)+1'b1;
  assign neg_sum_y = (~sum_y)+1'b1;
  assign sum_x = out_x;
  assign sum_y = out_y; 
  
  always_comb begin
    n_sum_x = 9'd0;
	 n_sum_y = 9'd0;
    case (cycle_c)
	   0: begin 
		     n_sum_x = ((in[2]>>1)-(in[0]>>1));
			  n_sum_y = ((in[0]>>1)-(in[6]>>1));
			end
		1: begin 
		     n_sum_x = (sum_x - in[3]);
			  n_sum_y = (sum_y - in[1]);
			end
		2: begin 
		     n_sum_x = (sum_x + in[5]);
			  n_sum_y = (sum_y + in[7]);
			end
		3: begin 
		     n_sum_x = (sum_x - (in[6]>>1));
			  n_sum_y = (sum_y - (in[2]>>1));
			end
		4: begin 
		     n_sum_x = (sum_x + (in[8]>>1));
			  n_sum_y = (sum_y + (in[8]>>1));
			end
		5: begin 
		     n_sum_x = sum_x[8] ? {1'b1, neg_sum_x[7:0]} : {1'b0, sum_x};
			  n_sum_y = sum_y[8] ? {1'b1, neg_sum_y[7:0]} : {1'b0, sum_y};
			end 
	 endcase
  end
  
  always_ff @(posedge clock) begin
    if(reset) begin
	   out_x <= 9'd0;
		out_y <= 9'd0;
		cycle_c <= 4'd0;
		done <= 1'd0;
	 end else if(~done && en) begin
	   out_x <= n_sum_x;
		out_y <= n_sum_y;
	   cycle_c <= cycle_c + 1'b1;
		done <= (cycle_c == 4'd5);
    end else if(en) begin
	   done <= 1'b1;
	 end
  end
endmodule : grad

module grad_pipe(
  input logic clock,
  input logic init, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col_in,
  input logic [255:0][7:0] data_in,
  output logic data_rdy_out,
  output logic [255:0][17:0] data_out,
  output logic data_req_out,
  output logic last_col_out);
  logic second_col;
  logic first_col;
  logic reset_grad;
  logic [255:0] done_grad;
  logic en_grad;
  logic [2:0][257:0][7:0] reg_in; 
  assign reg_in[0][0] = 8'b0;
  assign reg_in[0][257] = 8'b0;
  assign reg_in[1][0] = 8'b0;
  assign reg_in[1][257] = 8'b0;
  assign reg_in[2][0] = 8'b0;
  assign reg_in[2][257] = 8'b0;
  assign data_rdy_out = done_grad[0];
  assign reset_grad = (data_rdy_out && data_req_in) || init; 
  assign data_req_out = ((data_rdy_out) && (~last_col_out) && (data_req_in)) || (first_col || second_col);
  
  genvar i;
  generate
    for(i = 0; i< `PAR; i++) begin : alu
        grad bu (.clock, .en(en_grad), .reset(reset_grad), .done(done_grad[i]), .out_x(data_out[i][8:0]),
		           .out_y(data_out[i][17:9]),
                 .in({reg_in[0][i], reg_in[1][i], reg_in[2][i],reg_in[0][i+1], reg_in[1][i+1],
				     reg_in[2][i+1], reg_in[0][i+2], reg_in[1][i+2], reg_in[2][i+2]}));
	 end
  endgenerate
  
  always_ff @(posedge clock) begin
    if(init) begin
		reg_in[2][256:1] <= reg_in[1][256:1]; 
		reg_in[1][256:1] <= reg_in[0][256:1];
		reg_in[0][256:1] <= 2048'b0;
		last_col_out <= 1'b0;
		first_col <= 1'b1;
		en_grad <= 1'd0;
    end else if(data_req_out && (data_rdy_in || last_col_in)) begin
	   if(first_col) begin
		  reg_in[2][256:1] <= reg_in[1][256:1]; 
		  reg_in[1][256:1] <= reg_in[0][256:1];
		  reg_in[0][256:1] <= data_in;
		  first_col <= 1'b0;
		  second_col <= 1'b1;
		  last_col_out <= 1'b0;
		  en_grad <= 1'd0;
		end else if (~data_rdy_in && last_col_in) begin
		  reg_in[2][256:1] <= reg_in[1][256:1];
		  reg_in[1][256:1] <= reg_in[0][256:1];
		  reg_in[0][256:1] <= 2048'b0;
		  last_col_out <= 1'b1;
		  first_col <= 1'b0;
		  en_grad <= 1'b1;
		end else begin
		  reg_in[2][256:1] <= reg_in[1][256:1];
		  reg_in[1][256:1] <= reg_in[0][256:1];
		  reg_in[0][256:1] <= data_in;
	     last_col_out <= 1'b0;
		  en_grad <= 1'b1;
		  first_col <= 1'b0;
		  second_col <= 1'b0;
      end
    end
  end
endmodule : grad_pipe

module mag(
  input logic [7:0] x_in, y_in,
  output logic [7:0] mag_out);
  
  logic [15:0] x_o, y_o;
  logic [16:0] o_s;
  mult m1 (.dataa(x_in), .datab(x_in), .result(x_o));
  mult m2 (.dataa(y_in), .datab(y_in), .result(y_o));
  assign o_s = x_o + y_o;
  assign mag_out = o_s[16:9];
endmodule : mag
  
module mag_pipe(
  input logic clock,
  input logic init, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col_in,
  input logic [255:0][17:0] data_in,
  output logic data_rdy_out,
  output logic [255:0][7:0] data_out,
  output logic data_req_out,
  output logic last_col_out);
  parameter p = 2;
  
  logic [255:0][7:0] data_out_n;
  logic [255:0][17:0] reg_in, reg_in_n;
  logic [255:0][7:0] top_out;
  logic [7:0] cycle_c; 
   
  assign data_rdy_out = (cycle_c == p);
  assign data_req_out = data_rdy_out && (~last_col_out) && data_req_in;
  
  genvar i;
  generate
    for(i = 0; i< `PAR; i++) begin : alu
      if((i % p) == 0) begin
        mag conv (.x_in(reg_in[i][16:9]), .y_in(reg_in[i][7:0]), .mag_out(top_out[i]));
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
  
  always_ff @(posedge clock) begin
    reg_in <= reg_in_n;
	 data_out <= data_out_n;
  end
  
  generate
    for(i = 0; i<`PAR; i++) begin : shifts
	   if((i%p) == 0) begin
		  assign data_out_n[i] = data_rdy_out ? data_out[i] : top_out[i];
		  assign reg_in_n[i] = data_req_out ? data_in[i] : reg_in[i+1];
		end else if ((i%p) == (p-1)) begin
		  assign data_out_n[i] = data_rdy_out ? data_out[i] : data_out[i-1];
		  assign reg_in_n[i] = data_in[i]; 
	   end else begin
		  assign data_out_n[i] = data_rdy_out ? data_out[i] : data_out[i-1];
		  assign reg_in_n[i] = data_req_out ? data_in[i] : reg_in[i+1];   
		end
    end
  endgenerate
endmodule : mag_pipe

module atan_pipe(
  input logic clock,
  input logic init, 
  input logic data_req_in,
  input logic data_rdy_in,
  input logic last_col_in,
  input logic [255:0][17:0] data_in,
  output logic data_rdy_out,
  output logic [255:0][1:0] data_out,
  output logic data_req_out,
  output logic last_col_out);
  parameter p = 2;
  
  logic [255:0][1:0] data_out_n;
  logic [255:0][17:0] reg_in, reg_in_n;
  logic [255:0][1:0] top_out;
  logic [7:0] cycle_c; 
   
  assign data_rdy_out = (cycle_c == p);
  assign data_req_out = data_rdy_out && (~last_col_out) && data_req_in;
  
  genvar i;
  generate
    for(i = 0; i< `PAR; i++) begin : alu
      if((i % p) == 0) begin
        atan conv (.x(reg_in[i][16:9]), .y(reg_in[i][7:0]), .dir(top_out[i]));
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
  
  always_ff @(posedge clock) begin
    reg_in <= reg_in_n;
	 data_out <= data_out_n;
  end
  
  generate
    for(i = 0; i<`PAR; i++) begin : shifts
	   if((i%p) == 0) begin
		  assign data_out_n[i] = data_rdy_out ? data_out[i] : top_out[i];
		  assign reg_in_n[i] = data_req_out ? data_in[i] : reg_in[i+1];
		end else if ((i%p) == (p-1)) begin
		  assign data_out_n[i] = data_rdy_out ? data_out[i] : data_out[i-1];
		  assign reg_in_n[i] = data_in[i]; 
	   end else begin
		  assign data_out_n[i] = data_rdy_out ? data_out[i] : data_out[i-1];
		  assign reg_in_n[i] = data_req_out ? data_in[i] : reg_in[i+1];   
		end
    end
  endgenerate
endmodule : atan_pipe