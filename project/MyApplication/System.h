#ifndef __System_H__
#define __System_H__


#include "main.h"

//定义结构体类型
typedef struct
{
	void (*Run)(void);
	void (*Error_Handler)(void);
	void (*Assert_Failed)(void);
} System_t;

extern System_t System;
extern uint8_t flag1,flag2;
void PHA_TEST (void);

#endif

