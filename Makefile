# makefile configuration
# Hao ZHANG
export CROSS_COMPILE = msp430-
export CC = $(CROSS_COMPILE)gcc
export CPP = $(CROSS_COMPILE)g++
export AR = $(CROSS_COMPILE)ar
export RANLIB = $(CROSS_COMPILE)ranlib
export STRIP = $(CROSS_COMPILE)strip
export OBJCOPY = $(CROSS_COMPILE)objcopy
export OBJDUMP = $(CROSS_COMPILE)objdump
export SIZE = $(CROSS_COMPILE)size
export LD = $(CROSS_COMPILE)ld
RM = rm
MAKETXT  = srec_cat

TARGET=zhchronos
all: $(TARGET).elf $(TARGET).hex $(TARGET).txt 

$(TARGET).elf: bin/Release/$(TARGET).elf
	cp -rf $< $@
	echo ">>>> Size of Firmware <<<<"
	$(SIZE) $@
	$(STRIP) $@
	$(SIZE) $@

%.hex: %.elf
	$(OBJCOPY) -O ihex $< $@
%.txt: %.hex
	$(MAKETXT) -O $@ -TITXT $< -I
#	unix2dos $@

.PHONY:	clean
clean:
	-$(RM) $(TARGET).*

