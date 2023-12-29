. ./functions.sh
# проверяем, что файл существует
if [[ ! -f $db_filename ]]
then
    # создаем, если файла с базой пользователей нет
    touch $db_filename
fi


while true
do
    read -p "Введите имя пользователя: " username
    check_username $username
    if [[ $? -ne 0 ]]
    then
        echo "Пользователь с таким именем существует"
    else
        break
    fi
done

read -s -p "Введите пароль: " password
password=$(echo $password | md5sum | awk '{print $1}')
echo "$username|$password" >> $db_filename
echo "Пользователь $username будет записан в базу"
