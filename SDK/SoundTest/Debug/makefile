################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include subdir.mk
-include src/subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
SoundTest.elf.size \

ELFCHECK += \
SoundTest.elf.elfcheck \


# All Target
all: SoundTest.elf secondary-outputs

# Tool invocations
SoundTest.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo Building target: $@
	@echo Invoking: MicroBlaze gcc linker
	mb-gcc -Wl,-T -Wl,../src/lscript.ld -L../../hello_world_bsp_0/microblaze_0/lib -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -o"SoundTest.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo Finished building target: $@
	@echo ' '

SoundTest.elf.size: SoundTest.elf
	@echo Invoking: MicroBlaze Print Size
	mb-size SoundTest.elf  |tee "SoundTest.elf.size"
	@echo Finished building: $@
	@echo ' '

SoundTest.elf.elfcheck: SoundTest.elf
	@echo Invoking: Xilinx ELF Check
	elfcheck SoundTest.elf -hw ../../427_hw_platform/system.xml -pe microblaze_0  |tee "SoundTest.elf.elfcheck"
	@echo Finished building: $@
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) SoundTest.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
