// copyright (c)2006 Technologic Systems
#ifndef _SERIAL_Z
#define _SERIAL_Z
#include "ByteArray.h"

inline int serialEscape(byte b);				  // PURE
int serialFrameOverhead(ByteArrayRef pkt);		  // PURE
// CLEAN
int serialFrame(ByteArrayRef src,ByteArrayRef dst);
ByteArrayRef serialUnframe(ByteArrayRef src);	  // IMPURE
// PURE-SE
inline int serialFramedSend(FILE *f,ByteArrayRef src);
#endif
