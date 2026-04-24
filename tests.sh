#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Program executable
PROGRAM="./build/romanus"

# Check if program exists
if [ ! -f "$PROGRAM" ]; then
    echo -e "${RED}Error: Program not found at $PROGRAM${NC}"
    echo "Please build the program first"
    exit 1
fi

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to run a test case
run_test() {
    local test_name="$1"
    local flag="$2"
    local input="$3"
    local expected_output="$4"
    local should_fail="${5:-false}"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Run the program
    local output
    output=$($PROGRAM "$flag" "$input" 2>&1)
    local exit_code=$?
    
    # Determine if test passed
    local passed=false
    if [ "$should_fail" = "true" ]; then
        if [ $exit_code -ne 0 ]; then
            passed=true
            PASSED_TESTS=$((PASSED_TESTS + 1))
            echo -e "${GREEN}PASS:${NC} $test_name (Correctly failed on: $input)"
        else
            FAILED_TESTS=$((FAILED_TESTS + 1))
            echo -e "${RED}FAIL:${NC} $test_name (Should have failed but didn't: $input)"
            echo -e "- Output: $output"
        fi
    else
        if [ "$output" = "$expected_output" ] && [ $exit_code -eq 0 ]; then
            passed=true
            PASSED_TESTS=$((PASSED_TESTS + 1))
            echo -e "${GREEN}PASS${NC}: $test_name → $output"
        else
            FAILED_TESTS=$((FAILED_TESTS + 1))
            echo -e "${RED}FAIL${NC}: $test_name ($input)"
            echo -e "- Expected: $expected_output"
            echo -e "- Output:      $output"
        fi
    fi
}

echo -e "${BLUE}=============${NC}"
echo -e "${BLUE}RUNNING TESTS${NC}"
echo -e "${BLUE}=============${NC}\n"

# Roman to Integer Tests
echo -e "${YELLOW}Group 1: Roman → Integer${NC}"
echo -e "${YELLOW}------------------------${NC}"

# Basic single symbols
run_test "Basic: I" "-i" "I" "1"
run_test "Basic: V" "-i" "V" "5"
run_test "Basic: X" "-i" "X" "10"
run_test "Basic: L" "-i" "L" "50"
run_test "Basic: C" "-i" "C" "100"
run_test "Basic: D" "-i" "D" "500"
run_test "Basic: M" "-i" "M" "1000"

# Lowercase variants
run_test "Lowercase: i" "-i" "i" "1"
run_test "Lowercase: v" "-i" "v" "5"
run_test "Lowercase: x" "-i" "x" "10"
run_test "Lowercase: mixed" "-i" "MxVi" "1016"

# Addition cases
run_test "Addition: II" "-i" "II" "2"
run_test "Addition: III" "-i" "III" "3"
run_test "Addition: VI" "-i" "VI" "6"
run_test "Addition: VII" "-i" "VII" "7"
run_test "Addition: VIII" "-i" "VIII" "8"
run_test "Addition: XI" "-i" "XI" "11"
run_test "Addition: XII" "-i" "XII" "12"
run_test "Addition: XIII" "-i" "XIII" "13"
run_test "Addition: XV" "-i" "XV" "15"
run_test "Addition: XX" "-i" "XX" "20"
run_test "Addition: XXX" "-i" "XXX" "30"
run_test "Addition: LX" "-i" "LX" "60"
run_test "Addition: LXX" "-i" "LXX" "70"
run_test "Addition: LXXX" "-i" "LXXX" "80"
run_test "Addition: CX" "-i" "CX" "110"
run_test "Addition: CXX" "-i" "CXX" "120"
run_test "Addition: CXXX" "-i" "CXXX" "130"
run_test "Addition: DC" "-i" "DC" "600"
run_test "Addition: DCC" "-i" "DCC" "700"
run_test "Addition: DCCC" "-i" "DCCC" "800"

# Subtraction cases
run_test "Subtraction: IV" "-i" "IV" "4"
run_test "Subtraction: IX" "-i" "IX" "9"
run_test "Subtraction: XL" "-i" "XL" "40"
run_test "Subtraction: XC" "-i" "XC" "90"
run_test "Subtraction: CD" "-i" "CD" "400"
run_test "Subtraction: CM" "-i" "CM" "900"

# Combined cases
run_test "Combined: XIV" "-i" "XIV" "14"
run_test "Combined: XIX" "-i" "XIX" "19"
run_test "Combined: XLIV" "-i" "XLIV" "44"
run_test "Combined: XLV" "-i" "XLV" "45"
run_test "Combined: XLIX" "-i" "XLIX" "49"
run_test "Combined: XCIV" "-i" "XCIV" "94"
run_test "Combined: XCIX" "-i" "XCIX" "99"
run_test "Combined: CDXCIX" "-i" "CDXCIX" "499"
run_test "Combined: DCCCLXXXVIII" "-i" "DCCCLXXXVIII" "888"
run_test "Combined: CMXCIX" "-i" "CMXCIX" "999"

# Complex/Modern years
run_test "Year: MCMXLVIII" "-i" "MCMXLVIII" "1948"
run_test "Year: MCMLXXXIV" "-i" "MCMLXXXIV" "1984"
run_test "Year: MCMXC" "-i" "MCMXC" "1990"
run_test "Year: MM" "-i" "MM" "2000"
run_test "Year: MMXXIII" "-i" "MMXXIII" "2023"
run_test "Year: MMXXIV" "-i" "MMXXIV" "2024"
run_test "Year: MMMCMXCIX" "-i" "MMMCMXCIX" "3999"

# Edge cases
echo -e "\n${YELLOW}Group 2: Roman → Integer (Edge/Grammatically incorrect cases)${NC}"
echo -e "${YELLOW}-------------------------------------------------------------${NC}"
run_test "Edge: VX" "-i" "VX" "15"
run_test "Edge: VL" "-i" "VL" "45"
run_test "Edge: VC" "-i" "VC" "95"
run_test "Edge: VD" "-i" "VD" "495"
run_test "Edge: VM" "-i" "VM" "995"
run_test "Edge: IL" "-i" "IL" "49"
run_test "Edge: IC" "-i" "IC" "99"
run_test "Edge: ID" "-i" "ID" "499"
run_test "Edge: IM" "-i" "IM" "999"
run_test "Edge: XD" "-i" "XD" "490"
run_test "Edge: XM" "-i" "XM" "990"
run_test "Edge: repeated V" "-i" "VV" "10"
run_test "Edge: repeated L" "-i" "LL" "100"
run_test "Edge: repeated D" "-i" "DD" "1000"
run_test "Edge: IIII" "-i" "IIII" "4"

# Integer to Roman Tests
echo -e "\n${YELLOW}Group 3: Integer → Roman (Valid cases)${NC}"
echo -e "${YELLOW}--------------------------------------${NC}"

run_test "To Roman: 1" "-r" "1" "I"
run_test "To Roman: 4" "-r" "4" "IV"
run_test "To Roman: 5" "-r" "5" "V"
run_test "To Roman: 9" "-r" "9" "IX"
run_test "To Roman: 10" "-r" "10" "X"
run_test "To Roman: 14" "-r" "14" "XIV"
run_test "To Roman: 19" "-r" "19" "XIX"
run_test "To Roman: 40" "-r" "40" "XL"
run_test "To Roman: 44" "-r" "44" "XLIV"
run_test "To Roman: 49" "-r" "49" "XLIX"
run_test "To Roman: 50" "-r" "50" "L"
run_test "To Roman: 90" "-r" "90" "XC"
run_test "To Roman: 94" "-r" "94" "XCIV"
run_test "To Roman: 99" "-r" "99" "XCIX"
run_test "To Roman: 100" "-r" "100" "C"
run_test "To Roman: 400" "-r" "400" "CD"
run_test "To Roman: 444" "-r" "444" "CDXLIV"
run_test "To Roman: 449" "-r" "449" "CDXLIX"
run_test "To Roman: 500" "-r" "500" "D"
run_test "To Roman: 900" "-r" "900" "CM"
run_test "To Roman: 999" "-r" "999" "CMXCIX"
run_test "To Roman: 1000" "-r" "1000" "M"
run_test "To Roman: 1948" "-r" "1948" "MCMXLVIII"
run_test "To Roman: 1984" "-r" "1984" "MCMLXXXIV"
run_test "To Roman: 2000" "-r" "2000" "MM"
run_test "To Roman: 2024" "-r" "2024" "MMXXIV"
run_test "To Roman: 3999" "-r" "3999" "MMMCMXCIX"

# Error Cases (should fail)
echo -e "\n${YELLOW}Group 4: Error Cases (Should fail)${NC}"
echo -e "${YELLOW}----------------------------------${NC}"

run_test "Error: Empty string" "-i" "" "" true
run_test "Error: Invalid char A" "-i" "A" "" true
run_test "Error: Invalid char B" "-i" "MCMXLVIIIB" "" true
run_test "Error: Invalid char 1" "-i" "1" "" true
run_test "Error: Invalid char @" "-i" "@" "" true
run_test "Error: To Roman zero" "-r" "0" "" true
run_test "Error: To Roman negative" "-r" "-5" "" true
run_test "Error: To Roman too large" "-r" "5000" "" true
run_test "Error: To Roman not number" "-r" "abc" "" true
run_test "Error: No flag" "" "MCMXLVIII" "" true

# Mixed Case Tests
echo -e "\n${YELLOW}Group 5: Mixed/Lowercase Tests${NC}"
echo -e "${YELLOW}------------------------------${NC}"

run_test "Mixed: mMxViii" "-i" "mMxViii" "1014"
run_test "Mixed: mCmXcIX" "-i" "mCmXcIX" "1999"
run_test "Mixed: mmmCmVc" "-i" "mmmCmVc" "3405"

# Summary
echo -e "\n${BLUE}========================================${NC}"
echo -e "${BLUE}Test Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo -e "Total tests:  ${TOTAL_TESTS}"
echo -e "${GREEN}Passed:      ${PASSED_TESTS}${NC}"
echo -e "${RED}Failed:      ${FAILED_TESTS}${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "\n${RED}❌ Some tests failed. Please review the output above. ❌${NC}"
    exit 1
fi
