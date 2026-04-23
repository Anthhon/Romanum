# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -Werror -pedantic
LDFLAGS =

# Paths
SRC_DIR = src
BUILD_DIR = build
TARGET = $(BUILD_DIR)/romanus

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

# Default target
all: $(BUILD_DIR) $(TARGET)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Link object files into final executable
$(TARGET): $(OBJECTS)
	@echo "[LINK] Creating executable: $(TARGET)"
	$(CC) $(OBJECTS) -o $(TARGET) $(LDFLAGS)

# Compile source files into object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo "[COMPILE] $<"
	$(CC) $(CFLAGS) -c $< -o $@

# Run the program
run: $(TARGET)
	@echo "[RUN] Executing $(TARGET)"
	./$(TARGET)

# Rebuild everything
rebuild: all

# Phony targets (not actual files)
.PHONY: all run clean rebuild
