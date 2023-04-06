cmake_minimum_required(VERSION 3.16)
project(CalculatorBF C)

set(CMAKE_C_STANDARD 17)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,--no-as-needed -ldl")

add_executable(CalculatorBF src/main.c src/commands.c src/commands.h src/syntax.c src/syntax.h src/error.c src/error.h src/tabla_simbolos.h src/tabla_simbolos.c src/abb.c src/lex.yy.h src/lex.yy.c src/syntax.tab.c)
