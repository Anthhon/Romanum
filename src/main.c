#include <stddef.h>
#include <stdio.h>
#include <errno.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

//#define TOGGLE_DEBUG
#ifdef TOGGLE_DEBUG
#define LOG_DBG(fmt, ...) printf("[DEBUG:%s] " fmt, __func__, ##__VA_ARGS__)
#else
#define LOG_DBG(fmt, ...)
#endif

#define FLAG_TO_INT "-i" 
#define FLAG_TO_INT_LEN 2 
#define FLAG_TO_INT_LONG "--to-int" 
#define FLAG_TO_INT_LONG_LEN 8 

#define FLAG_TO_ROMAN "-r"
#define FLAG_TO_ROMAN_LEN 2
#define FLAG_TO_ROMAN_LONG "--to-roman"
#define FLAG_TO_ROMAN_LONG_LEN 10

typedef enum {
    RN_I = 1,
    RN_V = 5,
    RN_X = 10,
    RN_L = 50,
    RN_C = 100,
    RN_D = 500,
    RN_M = 1000,
} roman_numerals_t;

uintmax_t roman_transliterate(char* value)
{
    uintmax_t result = 0;
    for (size_t i = 0; i < strlen(value); ++i) {
        uint16_t curr = value[i];
        uint16_t next = 0;
        if (i + 1 <= strlen(value)-1) {
            next = value[i + 1];
            LOG_DBG("next: %c\n", (char)next);
        }

        LOG_DBG("result: %i\n", result);
        switch (curr) {
            // Casos de valores que subtraem outros
            case 'I': case 'i':
                if (next == 'V' || next == 'v') {
                    result += RN_V - RN_I;
                    LOG_DBG("subtracting: V - I\n");
                    ++i;
                } else if (next == 'X' || next == 'x') {
                    result += RN_X - RN_I;
                    LOG_DBG("subtracting: X - I\n");
                    ++i;
                } else {
                    LOG_DBG("adding: 'I'\n");
                    result += RN_I;
                }
                break;
            case 'X': case 'x':
                if (next == 'L' || next == 'l') {
                    result += RN_L - RN_X;
                    LOG_DBG("subtracting: L - X\n");
                    ++i;
                } else if (next == 'C' || next == 'c') {
                    result += RN_C - RN_X;
                    LOG_DBG("subtracting: C - X\n");
                    ++i;
                } else {
                    LOG_DBG("adding: 'X'\n");
                    result += RN_X;
                }
                break;
            case 'C': case 'c':
                if (next == 'D' || next == 'd') {
                    result += RN_D - RN_C;
                    LOG_DBG("subtracting: D - C\n");
                    ++i;
                } else if (next == 'M' || next == 'm') {
                    result += RN_M - RN_C;
                    LOG_DBG("subtracting: M - C\n");
                    ++i;
                } else {
                    LOG_DBG("adding: 'C'\n");
                    result += RN_C;
                }
                break;
            // Casos de valores que não subtraem nenhum outro
            case 'V': case 'v':
                result += RN_V;
                LOG_DBG("adding: 'V'\n");
                break;
            case 'L': case 'l':
                result += RN_L;
                LOG_DBG("adding: 'L'\n");
                break;
            case 'D': case 'd':
                result += RN_D;
                LOG_DBG("adding: 'D'\n");
                break;
            case 'M': case 'm':
                result += RN_M;
                LOG_DBG("adding: 'M'\n");
                break;
            default: // Avoid errors by ignoring any other char
                break;
        }
    }
    return result;
}

void print_usage(char* program_name)
{
    fprintf(stderr, "Usage: ./%s [OPTION] [VALUE]\n", program_name);
    fprintf(stderr, "\t-i\t--to-int\tConvert roman to integer\n");
    fprintf(stderr, "\t-r\t--to-roman\tConvert integer to roman\n");
    exit(EXIT_FAILURE);
}

int main(int argc, char **argv)
{
    (void)argv;
    if (argc != 3) {
        print_usage(argv[0]);
    }

    char* program_name = argv[0];
    char* flag = argv[1];
    char* value = argv[2];

    // Check conversion-to flag type
    if (strcmp(FLAG_TO_INT, flag) == 0 ||
            strcmp(FLAG_TO_INT_LONG, flag) == 0) {
        LOG_DBG("converting to int\n");
        printf("%ld\n", roman_transliterate(value));
    } else if (strcmp(FLAG_TO_ROMAN, flag) == 0 || 
            strcmp(FLAG_TO_ROMAN_LONG, flag) == 0) {
        LOG_DBG("converting to roman\n");
        // Get value from string
        uintmax_t num = strtoumax(value, NULL, 10);
        if (num == UINTMAX_MAX && errno == ERANGE) {
            print_usage(program_name);
        }
        LOG_DBG("TO BE IMPLEMENTED\n");
    }

    return 0;
}
