##
## PROJECT TYPE, YEAR
## PROJECT NAME
## File description:
## Makefile C
##

CC ?= gcc

SRC +=

MAIN ?=

OBJ += $(SRC:.c=.o)

CFLAGS += -Wall -Wextra

INCLUDE_DIR += ./include

CPPFLAGS += $(foreach inc, $(INCLUDE_DIR), -iquotes$(inc))

LIB +=

LIB_DIR +=

LIB_TO_MAKE +=

LDFLAGS += $(foreach lib, $(LIB_DIR), -L$(lib))
LDLIBS += $(foreach lib, $(LIB), -l$(lib))

TEST_DIR = ./tests

TESTFLAGS += --coverage -lcriterion

TESTFILES =

TESTS += $(foreach test, $(TESTFILES), $(TEST_DIR)/$(test))

NAME = a.out

TEST_NAME = $(NAME)-unit-test

all: $(NAME)

make_lib:
	$(foreach lib, $(LIB_TO_MAKE), make -i -C $(lib);)

$(NAME): make_lib $(OBJ) $(MAIN:.c=.o)
	$(CC) $(OBJ) $(MAIN:.c=.o) -o $(NAME) $(CFLAGS) $(LDFLAGS) $(LDLIBS)

clean:
	$(foreach lib, $(LIB_TO_MAKE), make clean -i -C $(lib);)
	rm -f $(OBJ)

fclean: clean
	$(foreach lib, $(LIB_TO_MAKE), make fclean -i -C $(lib);)
	rm -f $(NAME)

$(TEST_NAME): re
	$(CC) -o $(TEST_NAME) $(TESTS) $(OBJ) $(CFLAGS) $(LDFLAGS) $(LDLIBS)\
	$(TESTFLAGS)

tests_run: $(TEST_NAME)
	./$(TEST_NAME)
	gcovr $(foreach test, $(TESTS), --exclude $(test))
	gcovr $(foreach test, $(TESTS), --exclude $(test)) -b

re: fclean all

.PHONY	: clean fclean re all make_lib
