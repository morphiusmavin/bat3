// copyright (c)2006 Technologic Systems
#ifndef __INT_ARRAY_Z
#define __INT_ARRAY_Z
#include <string.h>
#include <stdio.h>
#include "base.h"

#warning "INT_ARRAY_Z defined"

STRUCT(IntArrayRef);

struct IntArrayRef
{
	int len;
	int *arr;
};

#define IAref IntArrayRef

IAref IAR(void *ptr,int len);
//inline IAref IAR(void *ptr,int len);
#else
#warning "BYTE_ARRAY_Z not defined"
#endif

