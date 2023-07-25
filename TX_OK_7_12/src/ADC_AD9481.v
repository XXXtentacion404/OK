module ADC_AD9481(
	input        EXT_RST_N,         // 复位
	input        EXT_CLK,           // 系统时钟
	
	input        KEY,               // 开始采集按键	
	input        RX,                // 串口读
	output       TX,                // 串口写
	
	input        ADC_DCO_P,         // 输入数据时钟
	input        ADC_DCO_N,         // 输入数据时钟
	input  [7:0] ADC_DIN_A,         // 输入数据
	input  [7:0] ADC_DIN_B,         // 输入数据
	
	output       ADC_CLK,           // ADC时钟
	output       ADC_PDWN,           // ADC掉电控制，高电平有效
	
	//DA模块
	input KEY1,//开始扫频按键
	input KEY2,
	output dac_clk1,
	output dac_clk2,
	output [13:0] dac_data1,
	output [13:0] dac_data2,
	//SPI模块
	input  spi_sdi,      // STM32发送数据,FPGA接收
   input  spi_cs_data,  // 数据片选端
   input  spi_cs_cmd,   // 命令片选端
   input  spi_scl,      // spi时钟线
   output spi_sdo       // STM32接收数据,FPGA发送
);

wire adc_clk_in;                  // 250MHz时钟
wire sys_clk;                     // adc_clk_in / 2

wire [15:0] adc_out;              // ADC 连续数据
wire [15:0] FIFO_IN;			       // FIFO输入数据
wire FIFO_RD_CLK;						 // FIFO读时钟
wire FIFO_WR;					       // FIFO写使能
wire WREMPTY;					       // FIFO写空信号
wire [12:0] WRUSEDW;			       // FIFO存储的个数
wire [15:0] FIFO_OUT;		       // FIFO输出数据

wire rst;
wire [2:0] sel;
wire [31:0] fre_k;
wire [11:0] addr;
wire [13:0] wave_z;
wire [13:0] wave_s;
wire [13:0] wave_f;

wire [13:0] dac_data;
reg [13:0] data_buf1;
reg [13:0] data_buf2;
//spi寄存器模块
wire [31:0] fre_k_start;
wire [31:0] spi_sel;

// 锯齿波数据
assign wave_s = {addr,2'b00};

// 方波数据
assign wave_f = addr[11] ? 14'b11_1111_1111_1111 : 14'b00_0000_0000_0000;

assign dac_data1 = data_buf1;
assign dac_data2 = data_buf2;

// PLL
// 50MHz to 250MHz
pll_m	pll_m_inst (
	.areset 		( ~EXT_RST_N 	),   // 复位
	.inclk0 		( EXT_CLK 		),   // PLL输入时钟：50MHz
	.c0 			( sys_clk 		),   // adc_clk_in / 2
	.c1 			( adc_clk_in   ),	  // 250MHz 时钟
	.c2			(	dac_clk1		),
	.c3			(	dac_clk2		),
	.locked 		(  	rst		)
);


// ADC数据处理模块；
// 将A、B端口的数据合并后输出；
// 将ADC合并后数据同步到sys_clk。
HS_AD9481_IN HS_AD9481_IN_u1(
	.adc_clk_in	( adc_clk_in   ),    // ADC时钟 MAX 250MHz
	.sys_clk		( sys_clk		),    // 系统时钟 adc_clk_in / 2
	.sys_rst_n	( EXT_RST_N		),    // 复位
	.dco_p		( ADC_DCO_P		),    // 数据时钟 +
	.dco_n		( ADC_DCO_N		),    // 数据时钟 -
	
	.din_a		( ADC_DIN_A		),    // ADC端口A数据
	.din_b		( ADC_DIN_B		),    // ADC端口B数据
	
	.adc_clk		( ADC_CLK		),    // ADC时钟
	.dout			( adc_out		),    // ADC合并后数据
	.pdwn			( ADC_PDWN		)     // ADC掉电控制，高电平有效
);

// ADC数据处理模块
Data_Processing U_Data_Processing(
	.clk        ( sys_clk      ),    // 时钟
	.rst_n      ( EXT_RST_N    ),    // 复位
	.adc_in     ( adc_out      ),    // ADC输入数据
	.WRUSEDW    ( WRUSEDW      ),    // FIFO存储的个数
	.WREMPTY    ( WREMPTY      ),    // FIFO写空信号
	.FIFO_WR    ( FIFO_WR      ),    // FIFO写使能
	.FIFO_IN    ( FIFO_IN      )     // FIFO数据输入
);

// FIFO
FIFO_ADC_DATA U_FIFO_ADC_DATA(
	.data       ( FIFO_IN      ),    // FIFO数据输入
	.rdclk      ( FIFO_RD_CLK  ),    // FIFO读时钟
	.rdreq      ( 1'b1         ),    // FIFO读使能
	.wrclk      ( sys_clk      ),    // FIFO写时钟
	.wrreq      ( FIFO_WR      ),    // FIFO写使能
	.q          ( FIFO_OUT     ),    // FIFO数据输出
	.wrusedw    ( WRUSEDW      ),    // FIFO存储个数
	.wrempty    ( WREMPTY      )     // FIFO写空信号
);

// 串口传输模块
UART U_UART(
	.clk        ( sys_clk      ),    // 时钟
	.clk_50m    ( EXT_CLK      ),    // 50MHz时钟
	.rst_n      ( EXT_RST_N    ),    // 复位
	.key        ( KEY          ),    // 按键
	.WREMPTY    ( WREMPTY      ),    // FIFO写空信号
	.FIFO_OUT   ( FIFO_OUT     ),    // FIFO数据输出
	.RX         ( RX           ),    // 串口读
	.TX         ( TX           ),    // 串口写
	.FIFO_RD_CLK( FIFO_RD_CLK  )     // FIFO读时钟
);
// 检测控制
key_con	u_key_con(
	.clk				(		sys_clk	),
	.rst_n			(		rst		),
	.key1_in			(		KEY1		),//开始扫频按键
	.key2_in			(		KEY2		),//切换波形
	.sel_wave		(		sel		),
	.SPI_fre			(	fre_k_start ),
	.SPI_sel_wave  (	spi_sel		),
	.fre_k			(		fre_k		)
	
);

spi u_spi(
	.clk					(		sys_clk		),						// 系统时钟
   .rst_n				(		rst			),					// 复位
   .spi_sdi				(		spi_sdi		),			// STM32发送数据,FPGA接收
   .spi_cs_data		(		spi_cs_data	),	// 数据片选端
   .spi_cs_cmd			(		spi_cs_cmd	),	// 命令片选端
   .spi_scl				(		spi_scl		),			// spi时钟线
   .spi_sdo				(		spi_sdo		),			// STM32接收数据,FPGA发送

	 // reg in port
   .read_reg_0(	fre_k_start	),	// STM32 -> FPGA 通道0
   .read_reg_1(	spi_sel		),  // STM32 -> FPGA 通道1
   .read_reg_2(					),  // STM32 -> FPGA 通道2
   .read_reg_3(					),  // STM32 -> FPGA 通道3

);
// 累加器
add_32bit	u_add_32bit(
	.clk(sys_clk),
	.rst(rst),
	.fr_k(fre_k),
	.adder(addr)
);

// 正弦信号表
ROM_Sin	u_ROM_Sin(
	.clock(sys_clk),
	.address(addr),
	.q(wave_z)
);

// 输出波形选择
sel_wave u_sel_wave(
	.clk(sys_clk),
	.rst_n(rst),
	.sel(sel),
	.da_ina(wave_z),
	.da_inb(wave_s),
	.da_inc(wave_f),
	.da_out(dac_data)
);
// 硬件电路输出反相，即数字量0对应最大模拟量输出，数字亮4095对应最小模拟量输出。
// 通过16383-dac_data即可调整过来。
// 两通道数据保持一致输出。
always @(posedge sys_clk) 
begin 
	data_buf1 <= 14'h3FFF - dac_data;
	data_buf2 <= 14'h3FFF - dac_data;
end 
defparam
	u_spi.DATA_WIDTH      = 32,
	u_spi.CHANNEL_NUMBER  = 16;

endmodule 