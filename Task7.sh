#!/bin/bash

# Запустите iostat в фоновом режиме с интервалом 1 секунда в течение 60 секунд
iostat -o JSON 1 60 > iostat_output.json &

# Спим 1 минуту
sleep 60

# Останавливаем iostat
pkill -f "iostat -o JSON"

# Извлекаем три процесса, которые считали максимальное количество байт
top_processes=$(grep -E 'tps|kB_read/s' iostat_output.json | jq -c '.sysstat.hosts[0].statistics[0].disk[]' | sort -t ':' -k2 -n -r | head -n 3)

# Выводим PID, строки запуска и объем считанных данных
while read -r process; do
    pid=$(echo "$process" | jq -r '.name')
    cmd=$(ps -o cmd= -p $pid)
    kb_read=$(echo "$process" | jq -r '.read')
    echo "PID=$pid : Command=$cmd : Data_Read=${kb_read}KB"
done <<< "$top_processes"

# Удаляем временный файл
rm iostat_output.json
