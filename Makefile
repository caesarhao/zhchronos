# makefile for msp430
# Jungle

export CROSS_COMPILE = msp430-elf-
export CC 		= $(CROSS_COMPILE)gcc
export CPP 		= $(CROSS_COMPILE)g++
export AS 		= $(CROSS_COMPILE)gcc
export AR 		= $(CROSS_COMPILE)ar
export RANLIB 	= $(CROSS_COMPILE)ranlib
export NM		= $(CROSS_COMPILE)nm
export STRIP 	= $(CROSS_COMPILE)strip
export OBJCOPY 	= $(CROSS_COMPILE)objcopy
export OBJDUMP 	= $(CROSS_COMPILE)objdump
export SIZE 	= $(CROSS_COMPILE)size
export READELF 	= $(CROSS_COMPILE)readelf
export LD 		= $(CROSS_COMPILE)ld

MAKETXT  = srec_cat
# MSP430Flasher name
MSPFLASHER = MSP430Flasher

export CP = cp -p
export MV = mv
export RM = rm


TARGET = zhchronos

MCU    = cc430f6137

SOURCES = 

# all the libraries here
LIBS = 
# Include are located in the following directory
INCLUDES = -IInclude
# Add or subtract whatever MSPGCC flags you want. There are plenty more
#######################################################################################
CFLAGS   = -mmcu=$(MCU) -g -Os -Wall -Wunused $(INCLUDES)
ASFLAGS  = -mmcu=$(MCU) -x assembler-with-cpp -Wa,-gstabs
LDFLAGS  = -mmcu=$(MCU) -Wl,-Map=$(TARGET).map
########################################################################################

DEPEND = $(SOURCES:.c=.d)
# all the object files
OBJECTS = $(SOURCES:.c=.o)
all: $(TARGET).elf $(TARGET).hex $(TARGET).txt
$(TARGET).elf: $(OBJECTS)
	echo "Linking $@"
	$(CC) $(OBJECTS) $(LDFLAGS) $(LIBS) -o $@
	echo
	echo ">>>> Size of Firmware <<<<"
	$(SIZE) $(TARGET).elf
	echo

%.hex: %.elf
	$(OBJCOPY) -O ihex $< $@

%.txt: %.hex
	$(MAKETXT) -O $@ -TITXT $< -I
#	unix2dos $@

%.o: %.c
	echo "Compiling $<"
	$(CC) -c $(CFLAGS) -o $@ $<

# rule for making assembler source listing, to see the code
%.lst: %.c
	$(CC) -c $(ASFLAGS) -Wa,-anlhd $< > $@
# include the dependencies unless we're going to clean, then forget about them.
ifneq ($(MAKECMDGOALS), clean)
-include $(DEPEND)
endif

# dependencies file
# includes also considered, since some of these are our own
# (otherwise use -MM instead of -M)
%.d: %.c
	echo "Generating dependencies $@ from $<"
	$(CC) -M ${CFLAGS} $< >$@

.SILENT:
.PHONY: clean
clean:
	-$(RM) $(OBJECTS)
	-$(RM) $(TARGET).*
	-$(RM) $(SOURCES:.c=.lst)
	-$(RM) $(DEPEND)

install: $(TARGET).txt
	$(MSPFLASHER) -n $(MCU) -w "$(TARGET).txt" -v -z [VCC]

