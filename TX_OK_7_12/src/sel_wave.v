// 波形选择
module sel_wave(
	input clk,
	input rst_n,
	input [2:0] sel,
	input [13:0] da_ina,
	input [13:0] da_inb,
	input [13:0] da_inc,
	output [13:0] da_out
);

reg [13:0] da_out_reg;
assign da_out = da_out_reg;

always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		da_out_reg <= 14'd0;
	end
	else
	begin
		case(sel)
			3'b110 : da_out_reg <= da_ina;
			3'b101 : da_out_reg <= da_inb;
			3'b011 : da_out_reg <= da_inc;
			default: da_out_reg <= da_ina;
		endcase
	end
end

endmodule 