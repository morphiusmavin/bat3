######################################################################################
# GNU GCC ARM Embeded Toolchain base directories and binaries 
######################################################################################
#GCC_BASE = /home/dan/dev/arm/opt/crosstool/gcc-3.4.4-glibc-2.3.2/arm-linux/
GCC_BASE = /home/dan/dev/arm/crosstool/gcc3/arm-linux/
GCC_BIN  = $(GCC_BASE)bin/
GCC_LIB  = $(GCC_BASE)arm-linux/lib/
GCC_INC  = $(GCC_BASE)arm-linux/include/
AS       = $(GCC_BIN)arm-linux-as
CC       = $(GCC_BIN)arm-linux-gcc
CPP      = $(GCC_BIN)arm-linux-g++
LD       = $(GCC_BIN)arm-linux-gcc
OBJCOPY  = $(GCC_BIN)arm-linux-objcopy

#TS-7200_CC_FLAGS = -mcpu=arm920t -march=armv5t
#TS-7200_CC_FLAGS = -mcpu=arm920t -mapcs-32 -mthumb-interwork
#TS-7200_CC_FLAGS = -mcpu=arm920t
TS-7200_CC_FLAGS = -mcpu=arm920t -mapcs-32 -mthumb-interwork
ASM_FLAGS = -almns=listing.txt
PROJECT_INC_LIB = -I$(PORT) -I$(SOURCE)

# to debug use: make print-<variable_name>
# e.g. make print-GCC_BASE
print-%:
	@echo '$*=$($*)'
#	@echo $(.SOURCE)
#	@echo $(.TARGET)

######################################################################################
# Main makefile project configuration
#    PROJECT      = <name of the target to be built>
#    MCU_CC_FLAGS = <one of the CC_FLAGS above>
#    MCU_LIB_PATH = <one of the LIB_PATH above>
#    OPTIMIZE_FOR = < SIZE or nothing >
#    DEBUG_LEVEL  = < -g compiler option or nothing >
#    OPTIM_LEVEL  = < -O compiler option or nothing >
######################################################################################
PROJECT           = main
MCU_CC_FLAGS      = $(TS-7200_CC_FLAGS)
MCU_LIB_PATH      = $(TS-7200_LIB_PATH)
OPTIMIZE_FOR      = 
DEBUG_LEVEL       = 
OPTIM_LEVEL       = 
PROJECT_OBJECTS   = main.o
PROJECT_LIB_PATHS = -L.
PROJECT_LIBRARIES =
PROJECT_SYMBOLS   = -DTOOLCHAIN_GCC_ARM -DNO_RELOC='0'  

######################################################################################
# Main makefile system configuration
######################################################################################
SYS_OBJECTS = 
SYS_LIB_PATHS = -L$(MCU_LIB_PATH)
ifeq (OPTIMIZE_FOR, SIZE)
SYS_LIBRARIES = -lstdc++_s -lsupc++_s -lm -lc_s -lg_s -lnosys
SYS_LD_FLAGS  = --specs=nano.specs -u _printf_float -u _scanf_float
else 
SYS_LIBRARIES = -lstdc++ -lsupc++ -lm -lc -lg -lnosys
SYS_LD_FLAGS  = 
endif

############################################################################### 
# Command line building
###############################################################################
ifdef DEBUG_LEVEL
CC_DEBUG_FLAGS = -g$(DEBUG_LEVEL)
CC_SYMBOLS = -DDEBUG $(PROJECT_SYMBOLS)
else
CC_DEBUG_FLAGS =
CC_SYMBOLS = -DNODEBUG $(PROJECT_SYMBOLS)
endif 

ifdef OPTIM_LEVEL
CC_OPTIM_FLAGS = -O$(OPTIM_LEVEL)
else 
CC_OPTIM_FLAGS = 
endif

INCLUDE_PATHS = -I.$(GCC_INC)
LIBRARY_PATHS = $(PROJECT_LIB_LIB) $(SYS_LIB_PATHS)
#CC_FLAGS = $(MCU_CC_FLAGS) $(CC_OPTIM_FLAGS) $(CC_DEBUG_FLAGS) -Wall -fno-exceptions -ffunction-sections -fdata-sections 
#-pthread -static-libgcc
# use -static-libgcc instead of -static to get rid of warning: "Using getprotobyname in statically linked apps requires
# at runtime the shared libraries from the glibc version used for linking"
LD_FLAGS = $(MCU_CC_FLAGS) -Wl,--gc-sections $(SYS_LD_FLAGS) -Wl,-Map=$(PROJECT).map 
LD_SYS_LIBS = $(SYS_LIBRARIES)

#GNUCFLAGS = -g -ansi -Wstrict-prototypes	doesn't compile "// ..comments.."
#CC_FLAGS = -static -g -Wstrict-prototypes -mcpu=arm920t -mapcs-32 -mthumb-interwork
CC_FLAGS = -g -Wstrict-prototypes -mcpu=arm920t -mapcs-32
GNULDFLAGS_T = ${GNULDFLAGS} -pthread
#CC_FLAGST = ${CC_FLAGS} + GNULDFLAGS_T
GNUSFLAGS = -D_SVID_SOURCE -D_XOPEN_SOURCE
GNUNOANSI = -g -gnu99 -Wstrict-prototypes

#####################################################
#CFLAGS = ${GNUCFLAGS}
#LDFLAGS = ${GNULDFLAGS}

BULD_TARGET = $(PROJECT)

all : bat3 bat3dump ups-monitor server client # server_udp client_udp

server.o: server.c
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c server.c

client.o: client.c
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c client.c

#server_udp.o: server_udp.c
#	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c server_udp.c

client.o: client.c
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c client.c

#client_udp.o: client_udp.c
#	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c client_udp.c

avr.o: avr.c avr.h file1.h term1.h 
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c avr.c

ups-monitor.o: ups-monitor.c file1.h bat3.h net1.h process1.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c ups-monitor.c

bat3dump.o: bat3dump.c bat3.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c bat3dump.c 

bat3.o: bat3.c ByteArray.h IntArray.h file1.h bat3.h net1.h process1.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c bat3.c

file1.o: file1.c base.h IntArray.h ByteArray.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c file1.c

IntArray.o: IntArray.c IntArray.h 
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c IntArray.c 

ByteArray.o: ByteArray.c ByteArray.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c ByteArray.c 

serial1.o: serial1.c serial1.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c serial1.c

term1.o: term1.c
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c term1.c

net1.o: net1.c net1.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c net1.c

process1.o: process1.c process1.h
	${CC} ${INCLUDE_PATHS} ${CC_FLAGS} -c process1.c

bat3: bat3.o avr.o file1.o IntArray.o ByteArray.o serial1.o term1.o net1.o process1.o
	${CC} -static bat3.o avr.o file1.o IntArray.o ByteArray.o serial1.o term1.o net1.o process1.o -o bat3
		 
ups-monitor: ups-monitor.o avr.o file1.o IntArray.o ByteArray.o serial1.o term1.o net1.o process1.o
	${CC} -static ups-monitor.o avr.o file1.o IntArray.o ByteArray.o serial1.o term1.o net1.o process1.o -o ups-monitor

bat3dump: bat3dump.o
	${CC} -static bat3dump.o -o bat3dump

client: client.o
	${CC} -static client.o -o client
	 
server: server.o
	${CC} -static server.o -o server
	 
#client_udp: client_udp.o
#	${CC} -static client_udp.o -o client_udp
	 
#server_udp: server_udp.o
#	${CC} -static server_udp.o -o server_udp
	 
clean :
	rm -f *.o *~ *# core  \
	bat3 bat3dump ups-monitor client server # client_udp server_udp

#base.h bat3.c bat3dump.c bat3.h ByteArray.c ByteArray.h file1.c file1.h IntArray.c IntArray.h net1.c net1.h process1.c
#process1.h serial1.c serial1.h term1.c term1.h ups-monitor.c 
