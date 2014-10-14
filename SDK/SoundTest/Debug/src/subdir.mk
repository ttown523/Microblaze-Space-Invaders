################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/SoundTest.c \
../src/platform.c \
../src/quad_spi_if_0.c \
../src/wav.c \
../src/waveUtils.c \
../src/xac97_l.c 

LD_SRCS += \
../src/lscript.ld 

OBJS += \
./src/SoundTest.o \
./src/platform.o \
./src/quad_spi_if_0.o \
./src/wav.o \
./src/waveUtils.o \
./src/xac97_l.o 

C_DEPS += \
./src/SoundTest.d \
./src/platform.d \
./src/quad_spi_if_0.d \
./src/wav.d \
./src/waveUtils.d \
./src/xac97_l.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo Building file: $<
	@echo Invoking: MicroBlaze gcc compiler
	mb-gcc -Wall -O0 -g3 -c -fmessage-length=0 -I../../hello_world_bsp_0/microblaze_0/include -mlittle-endian -mxl-barrel-shift -mxl-pattern-compare -mcpu=v8.20.b -mno-xl-soft-mul -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo Finished building: $<
	@echo ' '


