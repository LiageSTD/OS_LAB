#!/bin/bash

# Создаем временный файл для результатов
tempfile=$(mktemp)

# Объявляем переменные для отслеживания текущего PPID и суммы ART
current_ppid=""
sum_art=0
count=0

# Цикл для обхода всех процессов в /proc
for pid_dir in /proc/*/; do
    pid=$(basename "$pid_dir")

    # Проверяем, является ли текущий элемент директорией и состоит ли его имя из цифр (PID)
    if [ -d "$pid_dir" ] && [[ "$pid" =~ ^[0-9]+$ ]]; then
        # Получаем PPID из файла status
        ppid=$(grep -E '^PPid:' "$pid_dir/status" | awk '{print $2}')

        # Получаем sum_exec_runtime из файла sched
        sum_exec_runtime=$(grep -E '^sum_exec_runtime' "$pid_dir/sched" | awk '{print $3}')
        
        # Получаем nr_switches из файла sched
        nr_switches=$(grep -E '^nr_switches' "$pid_dir/sched" | awk '{print $3}')

        # Вычисляем ART (Average Running Time)
        if [ -n "$sum_exec_runtime" ] && [ -n "$nr_switches" ] && [ "$nr_switches" -ne 0 ]; then
            ART=$(echo "scale=2; $sum_exec_runtime / $nr_switches" | bc)
        else
            ART=0.00
        fi

        # Если PPID изменился, добавляем строку "Average_Running_Children_of_ParentID=N is M"
        if [ "$ppid" != "$current_ppid" ]; then
            if [ -n "$current_ppid" ]; then
                avg_art=$(echo "scale=2; $sum_art / $count" | bc)
                echo "Average_Running_Children_of_ParentID=$current_ppid is $avg_art" >> "$tempfile"
            fi
            current_ppid="$ppid"
            sum_art=0
            count=0
        fi

        # Добавляем информацию во временный файл
        echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$ART" >> "$tempfile"
        
        # Обновляем сумму ART и счетчик
        sum_art=$(echo "scale=2; $sum_art + $ART" | bc)
        count=$((count + 1))
    fi
done

# Добавляем последнюю группу, если она существует
if [ -n "$current_ppid" ]; then
    avg_art=$(echo "scale=2; $sum_art / $count" | bc)
    echo "Average_Running_Children_of_ParentID=$current_ppid is $avg_art" >> "$tempfile"
fi

# Сортируем строки по идентификаторам родительских процессов
sort -t '=' -k5 -n "$tempfile" > sorted_results.txt

# Выводим результат в консоль
cat sorted_results.txt

# Удаляем временный файл
rm "$tempfile"
