CROSS_COMPILE ?= arm-none-eabi-
CC            := $(CROSS_COMPILE)gcc
LD            := $(CROSS_COMPILE)ld
ELF2UF2       := ./elf2uf2

CPU_FLAGS     := -mcpu=cortex-m0plus -mthumb

CFLAGS        := $(CPU_FLAGS) -Wall -Wextra -O1 -ffreestanding -nostdlib
ASFLAGS       := $(CPU_FLAGS)
LDFLAGS       := -T linker.ld -nostdlib --gc-sections

TARGET        := kernel
OBJS          := boot2.o boot.o kernel.o
LINKER_SCRIPT := linker.ld

PICO_MOUNT    ?= /run/media/$(USER)/RPI-RP2

.PHONY: all clean flash disassemble symbols

all: $(TARGET).uf2

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(ASFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(ASFLAGS) -c $< -o $@

$(TARGET).elf: $(OBJS) $(LINKER_SCRIPT)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

$(TARGET).uf2: $(TARGET).elf $(ELF2UF2)
	$(ELF2UF2) $< $@

flash: $(TARGET).uf2
	@if [ -d "$(PICO_MOUNT)" ]; then \
		echo "Flashing $< to $(PICO_MOUNT)..."; \
		cp $< "$(PICO_MOUNT)/" && sync; \
		echo "Done!"; \
	else \
		echo "Error: $(PICO_MOUNT) not found. Hold BOOTSEL and plug in."; \
		exit 1; \
	fi

symbols: $(TARGET).elf
	arm-none-eabi-nm $< | grep -E "_start|vectors|text|boot2"

disassemble: $(TARGET).elf
	arm-none-eabi-objdump -d $< | less

clean:
	rm -f $(OBJS) $(TARGET).elf $(TARGET).uf2
