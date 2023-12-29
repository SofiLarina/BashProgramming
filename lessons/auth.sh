. ./functions.sh

while true
do
    read -p "Введите имя пользователя: " username
    check_username $username
    if [[ $? -eq 0 ]]
    then
        echo "Пользователя с таким именем нет, введите другое"
    else
        break
    fi
done

line=$(get_user_line $username)

attempts=3
while [[ $attempts -gt 0 ]]
do
    read -s -p "Введите пароль: " password
    password=$(echo $password | md5sum | awk '{print $1}')
    if [[ $line == "$username|password" ]]
    then
        echo "Авторизация прошла успешно"
        exit 0
    else
        ((attempts--))
        if [[ attempts -ne 0 ]]
        then
            echo "Пароль неверный, у вас осталось $attempts попыток"
        else
            echo "Попытки закончились, вы не авторизовались"
            now=$(date)
            ffmpeg -i /dev/video0 "intruder_user_$username-$now.png" 1> /dev/null 2> /dev/null
            exit 1
        fi
    fi
done