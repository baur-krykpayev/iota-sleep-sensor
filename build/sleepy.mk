DOXYGEN_PROJECT_NAME = Sleepy Sensor

TARGET_NAME := Sleepy

# Define statements for the entire targe. These will be passed to the C and C++ compilers
DEFINES += USE_STDPERIPH_DRIVER
LIBS = Periph
LSCRIPT = sleepy.ld

# Source files
SRC += main.c

#Directories that compiler should look for header files
INCLUDE_DIRS +=

SILENCE = @

OBJS_DIR = bin/$(TARGET_NAME)
OPTIMIZE_FLAGS = -Os

# Stores the target name in the image
DEFINES += __TARGET_NAME__=$(TARGET_NAME)

# ATT!!! This must be updated every time you update GNU Tools for ARM Emb Processors!!
GNU_TOOLS_ARM_EMBEDDED_VERSION_STRING:=[ARM/embedded-4_8-branch revision 213147]

# Override predefined tools with ARM Cross Compiler tools
# C Compiler
CC = arm-none-eabi-gcc

# C++ Compiler
CXX = arm-none-eabi-gcc

# Assembler
AS = arm-none-eabi-gcc

# Linker
LD = arm-none-eabi-g++

# Archiver
AR = arm-none-eabi-ar

OC = arm-none-eabi-objcopy
OD = arm-none-eabi-objdump
SIZE = arm-none-eabi-size

GNU_TOOLS_VERSION_STR = $(shell $(CC) --version)

# If words 11-13 of the version output match the required version, the version is correct
ifeq ("$(wordlist 11, 13, $(GNU_TOOLS_VERSION_STR))","$(GNU_TOOLS_ARM_EMBEDDED_VERSION_STRING)")
$(info $(wordlist 2, 13, $(GNU_TOOLS_VERSION_STR)) has been detected)
# Otherwise, the version is invalid
else
$(warning Warning: An invalid version of the GNU Tools for ARM Embedded Processors has been detected)
$(info Detected version: $(wordlist 11, 13, $(GNU_TOOLS_VERSION_STR)))
$(info Required version: $(GNU_TOOLS_ARM_EMBEDDED_VERSION_STRING))
endif

#Helper Functions
get_src_from_dir = $(wildcard $1/*.cpp) $(wildcard $1/*.c)
get_dirs_from_dirspec = $(wildcard $1)
get_src_from_dir_list = $(foreach dir, $1, $(call_get_src_from_dir,$(dir)))
__src_to = $(subst .c,$1, $(subst .cpp,$1, $(subst .S,$1,$2)))
src_to = $(addprefix $(OBJS_DIR/,$(call __src_to,$1,$2))
src_to_o = $(call src_to,.o,$1)
src_to_obj = $(call src_to,.obj,$1)
src_to_d = $(call src_to,.d,$1)
debug_print_list = $(foreach word,$1,echo " $(word)";) echo;

# Convert include paths to a compiler to switch
INCLUDES_DIRS_EXPANDED = $(call_get_dirs_from_dirspec, $(INCLUDE_DIRS))
INCLUDES += $(foreach dir, $(INCLUDES_DIRS_EXPANDED), -I$(dir))

LD_LIBRARIES = -L$(LIB_DIR) $(foreach lib, $(LIBS), -l$(lib))
LIB_NAMES = $(foreach lib, $(LIBS), $(LIB_DIR)/lib$(lib).a)

# Populate the object and dependancy varaibles from the provided sources
OBJ = $(call src_to_o, $(SRC))
DEP = $(call src_to_d, $(SRC))