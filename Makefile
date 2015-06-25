# Project name.
PROJECT = nucleo

# Find all source files.
SRCS = $(shell find src lib -name '*.c')
OBJS = $(SRCS:.c=.o)

# Compiler flags.
CFLAGS  = -mcpu=cortex-m4 -march=armv7e-m -mthumb
CFLAGS += -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16 -std=c99 -O2
CFLAGS += -ffunction-sections -fdata-sections -g -T "lib/linker.ld" -Xlinker
CFLAGS += --gc-sections -Wl,-Map,$(PROJECT).map --specs=rdimon.specs
CFLAGS += -lc -lrdimon -I"include" -I"lib" -I"lib/CMSIS/core"
CFLAGS += -I"lib/CMSIS/device" -I"lib/HAL/include"
CFLAGS += -DSTM32F303xE -DNUCLEO_F303RE -DUSE_HAL_DRIVER -DSTM32F303RETx

FILE_BUILD = -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c
STARTUP = lib/startup_stm32f303xe.s

%.o: %.c
	@echo 'Building file: $<'
	arm-none-eabi-gcc $(CFLAGS) $(FILE_BUILD) -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

all: $(PROJECT).bin

$(PROJECT).bin: $(OBJS)
	@echo 'Building $(PROJECT) project...'
	arm-none-eabi-gcc $(CFLAGS) -o $(PROJECT).elf $(OBJS) $(STARTUP)
	@echo ' '
	@echo 'Generating binary...'
	arm-none-eabi-objcopy -O binary $(PROJECT).elf $(PROJECT).bin
	arm-none-eabi-size $(PROJECT).elf

clean:
	@echo 'Cleaning up...'
	find ./ -name '*~' | xargs rm -f
	find ./ -name '*.o' | xargs rm -f
	find ./ -name '*.d' | xargs rm -f
	find ./ -name '*.elf' | xargs rm -f
	find ./ -name '*.bin' | xargs rm -f
	find ./ -name '*.map' | xargs rm -f

install: $(PROJECT).bin
	@echo 'Flashing device...'
	st-flash write $(PROJECT).bin 0x8000000
