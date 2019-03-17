# Force the version-generation script to run before
# anything else, generating version.c
_VERSION := $(shell sh version.sh)

# Source files
SRC :=       \
	app      \
	backdrop \
	camera   \
	instance \
	loader   \
	log      \
	main     \
	mat      \
	model    \
	shader   \
	window   \
	worker   \
	# end of source files

# Generated files
GEN :=       \
	sphere   \
	version  \
	# end of generated files

BUILD_DIR := build

CFLAGS := -Wall -Werror -g -O3 -pedantic
LDFLAGS := -lglfw -lglew -framework OpenGL $(CFLAGS)

# Platform detection
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
	SRC := $(SRC) platform_unix platform_darwin
	LDFLAGS := $(LDFLAGS) -framework Foundation -framework Cocoa
	PLATFORM := -DPLATFORM_DARWIN
endif

OBJ := $(SRC:=.o) $(GEN:=.o)
OBJ := $(addprefix build/,$(OBJ))
DEP := $(OBJ:.o=.d)

all: hedgehog

hedgehog: $(OBJ)
	$(CC) -o $@ $(LDFLAGS) $^

build/%.o: %.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(PLATFORM) -c -o $@ -std=c99 $<
build/%.o: %.mm | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(PLATFORM) -c -o $@ $<

-include $(DEP)
build/%.d: %.c | $(BUILD_DIR)
	$(CC) $< $(PLATFORM) -MM -MT $(@:.d=.o) > $@
build/%.d: %.mm | $(BUILD_DIR)
	$(CC) $< $(PLATFORM) -MM -MT $(@:.d=.o) > $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

sphere.c: sphere.stl
	xxd -i $< > $@

.PHONY: clean
clean:
	rm -rf $(OBJ) $(DEP) $(GEN:=.c)
	rmdir $(BUILD_DIR)
