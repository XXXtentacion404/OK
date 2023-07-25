






module HS_AD9481_IN(
	input		      adc_clk_in,      // max 250MHz
	input		      sys_clk,         // adc_clk_in / 2
	input          sys_rst_n,       // 
	input          dco_p,           // 数据时钟
	input          dco_n,
	
	input  [7:0]   din_a,           // 数据
	input  [7:0]   din_b,
	
	output         adc_clk,         // ADC时钟
	output [15:0]  dout,            // 数据输出，已同步到sys_clk
	output         pdwn             // 掉电控制，高电平有效
);

reg [7:0] din_a_r;
reg [7:0] din_b_r;

wire rdempty_sig;
reg  rdreq_sig;

assign adc_clk = adc_clk_in;
assign pdwn    = ~sys_rst_n;

always @(posedge dco_n) 
begin 
	din_a_r <= din_a;
end 

always @(posedge dco_p) 
begin 
	din_b_r <= din_b;
end 

always @(posedge sys_clk) 
begin 
	if (!sys_rst_n) 
	begin 
		rdreq_sig <= 1'b0;
	end 
	else 
	begin 
		rdreq_sig <= ~rdempty_sig;
	end 
end 

fifo_16to8	fifo_16to8_inst (
	.aclr		( ~sys_rst_n         ),
	.wrclk 	( dco_n              ),
	.wrreq 	( 1'b1               ),
	.data 	( {din_a_r, din_b_r} ),
	
	.rdclk 	( sys_clk            ),
	.rdreq 	( rdreq_sig          ),
	.q 		( dout               ),
	.rdempty ( rdempty_sig        )
);

endmodule 
