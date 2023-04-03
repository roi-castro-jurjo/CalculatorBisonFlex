cmake_minimum_required(VERSION 3.16)
project(CalculatorBF C)

set(CMAKE_C_STANDARD 17)

add_executable(CalculatorBF src/main.c src/commands.c src/commands.h src/syntax.c src/syntax.h src/error.c src/error.h)
