
COMPILE  := $(CXX) -I. -Wall -Wextra -g $(CXXFLAGS)
OPTIMIZE := -DNDEBUG -O2

LIB_BOOST_TEST := -lboost_unit_test_framework-mt

all:
	@echo This library is a C++ header file only.

.bin:
	mkdir -p .bin

test: test/test.cpp timsort.hpp .bin
	$(COMPILE) $(LIB_BOOST_TEST) $< -o .bin/$@
	time ./.bin/$@

test-with-optimization: test/test.cpp timsort.hpp .bin
	$(COMPILE) $(OPTIMIZE) $(LIB_BOOST_TEST) $< -o .bin/$@
	time ./.bin/$@

test-with-std-move: test/test.cpp timsort.hpp .bin
	$(COMPILE) $(LIB_BOOST_TEST) -std=c++11 -DENABLE_STD_MOVE $< -o .bin/$@
	time ./.bin/$@

bench: example/bench.cpp timsort.hpp .bin
	$(COMPILE) $(OPTIMIZE) $< -o .bin/$@
	$(CXX) -v
	./.bin/$@

coverage:
	make test CXXFLAGS="-coverage -O0"
	gcov test.gcda > /dev/null
	mv timsort.hpp.gcov coverage.txt
	rm -rf *.gc*

.PHONY: test bench
