#!/bin/bash

# Функция для отображения меню создания уведомлений
show_notification_menu() {
    local valid_time=false
    while [ "$valid_time" != true ]
    do
        read -p "Введите время в формате ЧЧ:ММ: " notification_time
        check_time_format "$notification_time"
        # Проверка статуса завершения последней выполненной команды
        if [ $? -eq 0 ] 
        then
            valid_time=true
        else
            echo "Некорректный формат времени. Пожалуйста, введите время еще раз."
        fi
    done
    read -p "Введите текст уведомления: " notification_text
    create_notification "$notification_time" "$notification_text"
}

# Функция для создания уведомления
create_notification() {
    local time=$1
    local message=$2
    at "$time" <<< "notify-send 'Уведомление' '$message'"
}

# Функция для создания чек-листа с делами
create_todo_list() {
    local valid_time=false
    while [ "$valid_time" != true ]
    do
        read -p "Введите время дедлайна в формате ЧЧ:ММ: " todo_deadline
        check_time_format "$todo_deadline"
        # Проверка статуса завершения последней выполненной команды
        if [ $? -eq 0 ]
        then
            valid_time=true
        else
            echo "Некорректный формат времени. Пожалуйста, введите время еще раз."
        fi
    done

    read -p "Введите вид дела(учеба, дом, проекты и т.п.): " todo_type
    read -p "Введите текст о деле: " todo_description

    # Получаем текущее количество строк в файле
    local line_count=$(wc -l < todo_list.txt) # wc -l подсчет строк
    # Добавляем запись в файл с порядковым номером
    echo "$((line_count + 1))|$todo_type|$todo_deadline|$todo_description" >> todo_list.txt
}

# Функция для показа всех дел, отсортированных по категориям
show_all_todos() {
    echo "Содержимое чек-листа с делами (отсортировано по категориям):"
    echo "Номер|Вид дела|Время дедлайна|Описание дела"
    # Сортируем чек-лист по второму столбцу (виду дела) и выводим результат
    sort -t"|" -k2 todo_list.txt | column -s"|" -t
    # sort -t"|" -k2 указывает разделитель "|" и что сортировка только по второму столбцу
    # column -s"|" -t -выводит сортировку в виде таблицы с разделителем "|", -t выравнивает текст по колонкам
}

# Функция для удаления дела из чек-листа
delete_todo() {
    show_all_todos
    read -p "Введите номер строки для удаления: " line_number
    if [ -n "$line_number" ] # Проверяем, чтобы переменная line_number была непустой
    then
        # Удаляем строку из файла по указанному номеру
        sed -i "${line_number}d" todo_list.txt  # Удаляем строку с указанным номером
        sed -i 's/..\(.*\)/\1/' todo_list.txt # Удаляет первые два символа в каждой строке файла

        #  - s/ - начало шаблона замены.
        #  - .. - совпадает с первыми двумя символами в строке
        #  - \(.*\) - это группа захвата, которая соответствует оставшейся части строки после первых двух символов
        #  - \1 - обозначает содержимое первой группы захвата (в данном случае, оставшуюся часть строки)
        #  - / - разделитель между шаблоном поиска и шаблоном замены.

        awk '{print (NR "|" $0)}' todo_list.txt > todo_list_temp.txt  # Добавляем новые номера строк к каждой строке во временный файл
        #  - '{print (NR "|" $0)}' - выводит номер строки (NR) с символом "|" и содержимым строки ($0)
        mv todo_list_temp.txt todo_list.txt  # Переименовываем временный файл в исходный файл, заменяя его
        echo "Дело удалено"
    else
        echo "Некорректный выбор"
    fi
}

# Функция для проверки корректности времени в формате ЧЧ:ММ
check_time_format() {
    local time=$1
    if [[ $time =~ ^[0-9]{2}:[0-9]{2}$ ]] # =~ сопоставление; ^ начало строки; 0-9{2} ожидается 2 цифры от 0 до 9
    then
        return 0  # Возвращаем 0, если формат времени корректный
    else
        return 1  # Возвращаем 1, если формат времени некорректный
    fi
}


# Вывод менюшки
while true 
    do
    echo "Выберите действие:"
    echo "1. Создать уведомление"
    echo "2. Добавить дело в чек-лист"
    echo "3. Показать чек-лист"
    echo "4. Удалить дело из чек-листа"
    echo "0. Выйти"
    read -p "Введите номер: " choice
    if [ "$choice" -eq 1 ]
    then
        show_notification_menu
    elif [ "$choice" -eq 2 ]
    then
        create_todo_list
    elif [ "$choice" -eq 3 ]
    then
        show_all_todos
    elif [ "$choice" -eq 4 ]
    then
        delete_todo
    elif [ "$choice" -eq 0 ]
    then
        echo "Выход из программы"
        exit 0
    else
        echo "Некорректный выбор"
    fi
done