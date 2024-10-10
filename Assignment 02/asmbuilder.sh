#!/bin/bash


# Created by Owen Sterling
# Github @JOwen-ster
# Make sure your assembly file and this script are in the same folder/directory
# Make sure you are inside that directory
# Run the following command in your terminal (dont include the #)

#chmod 700 asmasmbuilder.sh

echo "Usage
bash asmbuilder.sh <FILENAME> <RUN> <DEBUG>

REQUIRED:
       <FILENAME>

#OPTIONS:
       <RUN>: y OR n
       <DEBUG>: y OR n
------------------------------"
# Credit to Patrick Smith for showing me command line positional arguemnts within bash
# Follow him on Github @ThisGuyBlink
filename_arg="$1"
run_arg="$2"
debug_arg="$3"


# check if yasm is installed
if ! command -v yasm &> /dev/null; then
    echo "yasm is required to run this script"
    read -p "yasm was not found, would you like to install it? [Y/n]: " install
    # to use regex in a conditional use [[]]
    if [[ "$install" =~ ^[yY]$ ]]; then
    # IMPORTANT - If you are using a different linux distro than Ubuntu/Debian
    # IMPORTANT - Replace the following command with what package manager you uses to install packages
        # install yasm (apt is the Debian/Ubuntu pacakge manager)
        sudo apt install yasm
    else
    # exit program as unsuccessful if yasm was not installed
        exit 1
    fi
fi

# prompt for assembly filename
#read -p "Enter in your assembly filename (without extension): " filename
if [[ -z "$filename_arg" ]]; then
    # exit program as unsuccessful if no filename was given
    echo "No filename specified."
    exit 1
fi

# assemble the .asm file
if ! yasm -g dwarf2 -f elf64 "$filename_arg.asm" -l "$filename_arg.lst"; then
    # exit program as unsuccessful if the filename/current directory is incorrect
    echo "No such file or directory."
    echo "HINT: remove file extension from argument."
    echo "HINT: change directory to where the file is located."
    exit 1
fi

echo "WROTE TO: $filename_arg.lst"
echo "WROTE TO: $filename_arg.o"

# link the .o file to an executable
if ! ld -g -o "$filename_arg" "$filename_arg.o"; then
# exit program as unsuccessful if the linker could not run
    echo "Could not link $filename_arg.o"
    exit 1
fi

echo "LINKED: $filename_arg.o to $filename_arg"

if [[ -z "$run_arg" ]]; then
    # prompt the user to run the executable
    read -p "Would you like to run $filename_arg? [Y/n]: " run
    if [[ "$run" =~ ^[yY]$ ]]; then
        if ! ./"$filename_arg"; then
        # exit program as unsuccessful if the executable could not be ran
            echo "Could not run executable"
            exit 1
        fi
    fi
else
    if [[ "$run_arg" =~ ^[yY]$ ]]; then
        if ! ./"$filename_arg"; then
        # exit program as unsuccessful if the executable could not be ran
            echo "Could not run executable"
            exit 1
        fi
    fi
fi

# ask to open DDD (Data Display Debugger)
if [[ -z "$debug_arg" ]]; then
    read -p "Would you like to open DDD (Data Display Debugger)? [Y/n]: " debug
    if [[ "$debug" =~ ^[yY]$ ]]; then
        if ! ddd "$filename_arg"; then
        # exit program as unsuccessful if the debugger could not open
            echo 'Could not open ddd debugger'
            exit 1
        fi
    fi
else
    if [[ "$debug_arg" =~ ^[yY]$ ]]; then
        if ! ddd "$filename_arg"; then
        # exit program as unsuccessful if the debugger could not open
            echo 'Could not open ddd debugger'
            exit 1
        fi
    fi
fi

# exit code 0 if the program was executed successfully
exit 0