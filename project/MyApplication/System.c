#include "MyApplication.h"

static void Run(void); 
static void Error_Handler(void);
static void Assert_Failed(void);
/* Private define-------------------------------------------------------------*/
//uint8_t flag1=0;
//uint8_t flag2=0;

//u32 rece_date_0;
//u32 rece_date_1;
//u32 rece_date_2;
//u32 rece_date_3;
//	u8 i,j,buf[16];
//	u8 Errors[8];
//	u8 Right[8];

 uint8_t key;
 uint32_t i=0;
//					LED0(0);   
/*
*@���� Systemָ��ṹ��
*@���� ͨ������ָ�������ú���
*@���� Run,���к���
			Error_Handler,������ʾ����
			Assert_Failed
*/

////����ṹ��������.h�ļ���
//typedef struct
//{
//	void (*Run)(void);
//	void (*Error_Handler)(void);
//	void (*Assert_Failed)(void);
//} System_t;


System_t System = //�ṹ����������Կ������������õ�
{
	Run,
	Error_Handler,
	Assert_Failed
};



/*
*@���� �������к���
*@���� 
*@���� ��
*/


void Run(void)
{


//					SPI_Communication_Send_Cmd_Data(0, 10*30000000);			// ��������	SPI_fre		34300=1K hz
						

	key = key_scan(0);                  /* �õ���ֵ */
        if (key)
        {
            switch (key)
            {
							
								case WKUP_PRES:             /* KEY1��1���� */
                   LED1_TOGGLE();          /* LED1״̬ȡ�� */
								SPI_Communication_Send_Cmd_Data(0, 1000*34300);			// ��������	SPI_fre		34300=1K hz
								delay_ms(10);
                    break;
								
                case KEY0_PRES:             /* KEY2��2����*/
                         LED0_TOGGLE();          /* LED1״̬ȡ�� */
									 SPI_Communication_Send_Cmd_Data(1,0);			// ��������	SPI_fre		34300=1K hz
                    break;
								
                default : break;
             }
					}
				    else
        {
            delay_ms(10);
				}
}
/*
*@���� Error_Handler
*@���� 
*@���� ��
*/
void Error_Handler(void)
{

}



/*
*@���� Assert_Failed
*@���� 
*@���� ��
*/	

void Assert_Failed(void)
{

}




void PHA_TEST (void)
{
	u32 PHA_CNT;						// ��λ���������ֵ
	u32 FRE_CNT;						// Ƶ�ʲ�������ֵ
	u32 CYC_CNT;						// �������ڸ�������ֵ
	u32 ADV_CNT;						// ��ǰ���ڼ���ֵ
	u32 LAG_CNT;						// �ͺ����ڼ���ֵ
	unsigned char display_buf[16];		// ��ʾ����
	uint32_t FREQUENCY;									// Ƶ��ֵ
	uint32_t DUTY_RATIO; 								// ��λ��ֵ
	
	// ������ʼ��
	PHA_CNT = 0;
	FRE_CNT = 0;
	CYC_CNT = 0;
	ADV_CNT = 0;
	LAG_CNT = 0;
	FREQUENCY  = 0;
	DUTY_RATIO = 0;
	// ��ȡ����ֵ
	SPI_Communication_Send_Cmd_Data (1, 1);				// ��ֹ����ֵ����
	FRE_CNT = SPI_Communication_Rece_Cmd_Data (2);	// ��ȡƵ�ʼ���ֵ
	PHA_CNT = SPI_Communication_Rece_Cmd_Data (3);	// ��ȡ��λ�����ֵ
	CYC_CNT = SPI_Communication_Rece_Cmd_Data (4);	// ��ȡ�������ڸ���ֵ
	ADV_CNT = SPI_Communication_Rece_Cmd_Data (5);	// ��ȡ��ǰ���ڼ���ֵ
	LAG_CNT = SPI_Communication_Rece_Cmd_Data (6);	// ��ȡ�ͺ����ڼ���ֵ
	SPI_Communication_Send_Cmd_Data (1, 0);				// �������ֵ����
	// Ƶ�ʼ���λ�����
	/******************************************************************
	f = 1/t = (c_cnt * 10^8) / (f_cnt * 2)
	t = (f_cnt / c_cnt) * 20 ns = (f_cnt * 20) / (c_cnt * 10^9) s
	******************************************************************/
//	FREQUENCY  = (CYC_CNT * 200000000.00) / FRE_CNT;
//	DUTY_RATIO = PHA_CNT * 360.00 / FRE_CNT;
	FREQUENCY  = (CYC_CNT * 300000000.00 / 1.0000182) / FRE_CNT;
	DUTY_RATIO = PHA_CNT * 360.00 / FRE_CNT;
		printf("%d\n",DUTY_RATIO);
	
	// ��ǰ�ͺ��ж�
	if (ADV_CNT <= LAG_CNT)						// �ͺ�
	{
		DUTY_RATIO = 360 - DUTY_RATIO;	// ����Ϊ��ǰ
	}
	// ��ʾƵ�ʼ���λ��
	
//	printf("pinglvjishu:%10d\r\n",FRE_CNT);						// Ƶ�ʲ�������ֵ
//	printf("xiangweijishu:%10d\r\n",PHA_CNT);					// ��λ���������ֵ
//	printf("zhouqijishu:%10d\r\n",CYC_CNT);						// �������ڸ�������ֵ
//	printf("chaoqianjishu:%10d\r\n",ADV_CNT);	      	// ��ǰ���ڼ���ֵ
//	printf("zhihoujishu:%10d\r\n",LAG_CNT);	    			// �ͺ����ڼ���ֵ
//	printf("pinglvjishu  :%10.3fHZ\r\n",FREQUENCY);			// Ƶ��ֵ
//	printf("xiangweicha:	%10.3f\r\n",DUTY_RATIO);			// ��λ��ֵ

	
}








