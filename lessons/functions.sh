#!/bin/bash

# function name () {body function}
# function name {body function}

# function main {
#     echo "сейчас: $(date)"
# }
# echo "Привет, $USER!"
# output=$(main)
# echo "Результат main: $output"
# echo "Твоя домашняя директория - $HOME"

# function main {
#     echo "сейчас: $(date) на ОС $1" # $1 первый аргумент функции, а не скрипта
# }
# echo "Привет, $USER!"
# main Linux
# echo "Твоя домашняя директория - $HOME"

# function sum {
#     echo $(($1 + $2))
# }
# a=5
# b=5
# sum $a $b

# function sum {
#     return $(($1 + $2))
# }
# a=100
# b=170 # выделено 8 бит на $? exit, всего 256, поэтому вывод 14
# sum $a $b
# echo $?

# function div {
#     if [[ $2 -eq  0 ]]
#     then
#         return 1
#     else
#         echo $(($1 / $2))
#         return 0
#     fi
# }
# result=$(div 100 0)
# echo $?
# echo $result

db_filename=users

function check_username {
    while read line
    do
        if [[ $line == "$1|"* ]]
        then
            return 1
        fi
    done < $db_filename
    return 0
}

function get_user_line {
    while read line
    do
        if [[ $line == "$1|"* ]]
        then
            echo $line
        fi
    done < $db_filename
}