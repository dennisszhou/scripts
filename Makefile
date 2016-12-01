CXX = gcc
CXXFLAGS = -O2 -Wall -Werror
DEBUGFLAGS = -g -DDEBUG
INCLUDES =
LDFLAGS :=

SRC =
OBJS = $(SRC:.c=.o)

all: <target>

<target>: $(OBJS)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

debug: CXXFLAGS += $(DEBUGFLAGS)
debug: <target>

%.o: %.c
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $<

.PHONY: clean
clean:
	rm <target> $(OBJS)
