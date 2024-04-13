NAME = hello_usart
OUTELF = $(NAME).elf
OBJS = \
	ch32v20x_it.o \
	system_ch32v20x.o \
	main.o 

SYSOBJS = \
	ch32v20x_gpio.o \
	ch32v20x_usart.o \
	ch32v20x_rcc.o \
	ch32v20x_dbgmcu.o \
	ch32v20x_misc.o \
	debug.o \
	startup_ch32v20x_D6.o

CH32V20X_SDK=/home/koron/work/ch32v203/sdk

INCLUDES = \
	-I $(CH32V20X_SDK)/Core \
	-I $(CH32V20X_SDK)/Peripheral/inc \
	-I $(CH32V20X_SDK)/Debug \
	-I .

CC = /mingw64/bin/riscv32-unknown-elf-gcc

CFLAGS = \
	$(INCLUDES) \
	-fsigned-char \
	-ffunction-sections \
	-fdata-sections \
	-fno-common \
	-Os -g

TARGET_ARCH = \
	-msmall-data-limit=8 \
	-msave-restore \
	-march=rv32imaczicsr \
	-mabi=ilp32

LDFLAGS = \
	-nostartfiles \
	-Xlinker \
	--gc-sections \
	--specs=nano.specs \
	--specs=nosys.specs \
	-Wl,-Map,"$(NAME).map" \
	-T $(CH32V20X_SDK)/Ld/Link.ld

default: $(OUTELF)

$(OUTELF): $(OBJS) $(SYSOBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(TARGET_ARCH) $(OBJS) $(SYSOBJS) -o $@

debug.o: $(CH32V20X_SDK)/Debug/debug.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<

ch32v20x_misc.o: $(CH32V20X_SDK)/Peripheral/src/ch32v20x_misc.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<
ch32v20x_dbgmcu.o: $(CH32V20X_SDK)/Peripheral/src/ch32v20x_dbgmcu.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<
ch32v20x_rcc.o: $(CH32V20X_SDK)/Peripheral/src/ch32v20x_rcc.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<
ch32v20x_gpio.o: $(CH32V20X_SDK)/Peripheral/src/ch32v20x_gpio.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<
ch32v20x_usart.o: $(CH32V20X_SDK)/Peripheral/src/ch32v20x_usart.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<

startup_ch32v20x_D6.o: $(CH32V20X_SDK)/Startup/startup_ch32v20x_D6.s
	$(CC) $(CFLAGS) $(TARGET_ARCH) -c -o $@ $<

clean:
	rm -f *.o
	rm -f *.elf *.map
