#!/bin/bash

# Функция для проверки совпадения паролей
check_passwords_match() {
    password1=$1
    password2=$2
    
    if [ "$password1" == "$password2" ]; then
        return 0
    else
        return 1
    fi
}

# Функция для регистрации пользователя
register() {
    echo "Регистрация нового пользователя"
    read -p "Введите логин: " username
    read -s -p "Введите пароль: " password
    echo
    read -s -p "Повторите пароль: " password_confirm
    echo

    if check_passwords_match $password $password_confirm; then
        echo "$username:$password" >> users.txt
        echo "Регистрация успешно завершена"
    else
        echo "Пароли не совпадают. Попробуйте еще раз"
        register # Повторная попытка регистрации
    fi
}

# Функция для авторизации пользователя
login() {
    echo "Авторизация"
    read -p "Введите логин: " username
    read -s -p "Введите пароль: " password
    echo

    while IFS=':' read -r stored_username stored_password; do
        if [ "$username" == "$stored_username" ] && [ "$password" == "$stored_password" ]; then
            echo "Авторизация успешна"
            return
        fi
    done < users.txt

    echo "Неверный логин или пароль"
    login # Повторная попытка авторизации
}

# Функция для создания файла
create_file() {
    read -p "Введите имя файла: " filename
    touch "$filename"
    echo "Файл \"$filename\" создан"
    echo "Заполните файл. Нажмите Ctrl+D, когда закончите."

    cat > "$filename"

    read -p "Хотите создать бекап файла? (yes/no): " backup_choice
    if [ "$backup_choice" == "yes" ]; then
        cp "$filename" "$filename.bak"
        echo "Бекап файла \"$filename.bak\" создан"
    fi

    read -p "Хотите конвертировать файл в формат PDF или DOC? (yes/no): " conversion_choice
    if [ "$conversion_choice" == "yes" ]; then
        read -p "Введите формат: " format
        # pandoc -f plain -t pdf/docx "$filename" -o "$converted_filename"
        libreoffice --convert-to $format $filename
        if [[ $? -eq 0 ]]
        then
            echo "Файл \"$filename\" успешно сконвертирован в \"$filename.$format\""
        else
            echo "Файл не был конвертирован"
        fi
    fi
}

# Основной код

echo "Добро пожаловать в систему!"

while true; do
    echo "Выберите действие:"
    echo "1. Регистрация"
    echo "2. Авторизация"
    echo "3. Выход"
    
    read -p "Введите номер действия: " choice
    
    case $choice in
        1)
            register
            ;;
        2)
            login
            create_file
            break
            ;;
        3)
            echo "До свидания!"
            exit 0
            ;;
        *)
            echo "Неверный ввод. Попробуйте еще раз"
            ;;
    esac
done