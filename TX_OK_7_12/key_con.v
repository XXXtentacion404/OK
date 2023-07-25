module key_con (
	input clk, 
	input rst_n,
	input key1_in,  // 开始扫频按键
	input key2_in,		//切换波形
	input	 [31:0]	SPI_fre,
	input  [31:0]	SPI_sel_wave,
	output [2:0] 	sel_wave,
	output [31:0]  fre_k
);

reg  [31:0]   	fre_start;
reg  [31:0]		wave_sel;
reg  [1:0]		cnt;
reg  [1:0] 		status;
reg  [2:0]     sel;

initial begin
	cnt <= 2'd0;
	status <= 2'd0;
	wave_sel <= 32'd0;
end

wire             key1_out;
wire             key2_out;

	
	// delay 
key_delay u_key1_delay (
		.clk(clk),
		.kin(key1_in),
		.kout(key1_out)
	);
key_delay u_key2_delay (
		.clk(clk),
		.kin(key2_in),
		.kout(key2_out)
	);
always @(negedge key1_out) 
begin //完成初始化
		if(status < 3) 
		begin
			status <= status + 1;
		end 
		else begin 
			status <= 2'd0;
		end
end
always @(posedge clk) begin
    if (status == 0) begin
        fre_start <= 32'd34300 * 3;
        wave_sel <= 32'd1;
    end else if (status == 1) begin
        fre_start <= SPI_fre;
        wave_sel <= SPI_sel_wave;
    end else if (status == 2) begin
        fre_start <= 32'd34300 * 4;
        wave_sel <= 32'd2;
	 end else if (status == 3) begin
        fre_start <= 32'd34300 * 5;
        wave_sel <= 32'd0;
    end
end
always @(posedge clk) begin 
	case (wave_sel)
		32'd0 : sel <= 3'b110;
		32'd1 : sel <= 3'b101;
		32'd2 : sel <= 3'b011;
		default : sel <= 3'b110;
	endcase
end
	assign fre_k = fre_start;
	assign sel_wave = sel;

endmodule
