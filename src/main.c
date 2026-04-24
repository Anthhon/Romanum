#include <stddef.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <ctype.h>
#include <inttypes.h>

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

// Helper function to get numeric value of a Roman numeral character
static int roman_char_value(char c)
{
    switch (c) {
        case 'i': case 'I': return RN_I;
        case 'v': case 'V': return RN_V;
        case 'x': case 'X': return RN_X;
        case 'l': case 'L': return RN_L;
        case 'c': case 'C': return RN_C;
        case 'd': case 'D': return RN_D;
        case 'm': case 'M': return RN_M;
        default: return 0;
    }
}

// Check if a character is a valid subtractive pair
static int is_subtractive_pair(char curr, char next)
{
    int curr_val = roman_char_value(curr);
    int next_val = roman_char_value(next);
    
    // Valid subtractive pairs
    // Ex.: 'I' before 'V' or 'X'
    return (curr_val == RN_I && (next_val == RN_V || next_val == RN_X || next_val == RN_L || next_val == RN_C || next_val == RN_D || next_val == RN_M)) ||
           (curr_val == RN_X && (next_val == RN_L || next_val == RN_C || next_val == RN_D || next_val == RN_M)) ||
           (curr_val == RN_V && (next_val == RN_L || next_val == RN_C || next_val == RN_D || next_val == RN_M)) ||
           (curr_val == RN_C && (next_val == RN_D || next_val == RN_M));
}

// Process a subtractive pair
static int process_subtractive_pair(char curr, char next)
{
    int curr_val = roman_char_value(curr);
    int next_val = roman_char_value(next);
    return next_val - curr_val;
}

uintmax_t roman_transliterate(char* value)
{
    if (value == NULL) {
        LOG_DBG("Empty string given from user\n");
        return 0;
    }
    
    uintmax_t result = 0;
    size_t value_len = strlen(value);

    for (size_t i = 0; i < value_len; ++i) {
        uint16_t curr = value[i];
        if (curr == 0) continue; // Skip invalid characters

        // Check for subtractive pair
        if (i + 1 < value_len && is_subtractive_pair(value[i], value[i + 1])) {
            result += process_subtractive_pair(value[i], value[i + 1]);
            LOG_DBG("subtracting: %c - %c\n", value[i], value[i + 1]);
            ++i;
        } else {
            result += roman_char_value(curr);
            LOG_DBG("adding: %c\n", value[i]);
        }
        LOG_DBG("result: %i\n", result);
    }
    return result;
}

static void print_usage(char* program_name)
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
