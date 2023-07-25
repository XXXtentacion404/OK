FIFO_ADC_DATA	FIFO_ADC_DATA_inst (
	.data ( data_sig ),
	.rdclk ( rdclk_sig ),
	.rdreq ( rdreq_sig ),
	.wrclk ( wrclk_sig ),
	.wrreq ( wrreq_sig ),
	.q ( q_sig ),
	.wrempty ( wrempty_sig ),
	.wrusedw ( wrusedw_sig )
	);
