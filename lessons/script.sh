#!/bin/bash

# a=$1
# b=$2 # доллар цифра это атрибут, как input
# # $0 - это название скрипта
# c=a+b
# sum1=$a+$b #$ - это указатель
# sum2=$(($a+$b)) # правильная сумма
# date=$(date)
# snd_date=`date`
# echo "а равно $a, b равно $b, сумма равна $sum2" #пробел - это разделитель
# echo "при этом дата и время сейчас равны: $date"
# echo "дата и время другим способом: $snd_date"

# if [[ $a -gt $b ]] # >
# then
#     echo "a is greater than b"
# elif [[ $a -eq $b ]] # ==
# then
#     echo "a is equal to b"
# else
#     echo "a is less than b"
# fi

# i=1
# for student in Vanya Petya Vasya
# do #{ стабильнее do done
#     echo "Очередной студент №$1: $student"
#     i=$(($i+1)) 
#     ((i++))
# done #}

# for ((i=0;i<4;i+=1))
# do 
#     echo $i # это i+=1
# done

# i=1
# while [[ $i < 5 ]]
# do
#     echo $i
#     ((i++))
# done

# while read student
# do
#     echo $student
# done < students # в конце файла всегда должна быть пустая строчка


# read -s -t 5 -p "your message: " message # -p - пронт, -t 5 - ждет 5 секунд, -s - тайное сообщение
# echo "message: $message "
# #echo Vanya >> students в терминале, + Ваня в файл в конце

echo "Выводим только отличников"
while read line
do
    if [[ $line == *5 ]] # * - впереди любой текст, заканчивается на 5
    then
        echo $line
    fi
done < students # перенаправление ввода


# printf "student\nword\n" - для переноса строки