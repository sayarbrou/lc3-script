# compiler settings
CXX = clang++
CXXFLAGS = -std=c++17 -Wall -fopenmp=libomp -I./include

# directories
SRC_DIR = src
INCLUDE_DIR = include
BUILD_DIR = build
BIN_DIR = bin

# source and object files
SRCS = $(wildcard $(SRC_DIR)/*.cpp)
OBJS = $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))

# target executable
TARGET = $(BIN_DIR)/lc3-script

# phony targets
.PHONY: all clean directories

# default target
all: directories $(TARGET)

# create necessary directories
directories:
	mkdir -p $(BUILD_DIR) $(BIN_DIR)

# compile executable
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

# compile source to object
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# include deps
-include $(OBJS:.o=.d)

# gen dep files
$(BUILD_DIR)/%.d: $(SRC_DIR)/%.cpp
	@set -e; rm -f $@; \
	$(CXX) -MM $(CXXFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,$(BUILD_DIR)/\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

# clean up build artifacts
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

# debug info
debug:
	@echo "Sources: $(SRCS)"
	@echo "Objects: $(OBJS)"
	@echo "Target: $(TARGET)"
