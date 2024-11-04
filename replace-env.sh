#!/bin/bash

throw_error_if_need() {
    if [ $? -ne 0 ]; then
        echo "$1"
        exit 1
    fi
}

output_file=".env"

ct_monitor_slave=$(bash get-env.sh "containers_monitor_slave")
ct_monitor_appname=$(bash get-env.sh "containers_monitor_appname")
ct_monitor_containers=$(bash get-env.sh "containers_monitor_containers")
ct_monitor_timeout=$(bash get-env.sh "containers_monitor_timeout")
ct_monitor_sleep_time=$(bash get-env.sh "containers_monitor_sleep_time")

echo "containers_monitor_slave=\"$ct_monitor_slave\"" > $output_file
throw_error_if_need "Erro ao substituir variáveis no arquivo .env.template"
echo "containers_monitor_appname=\"$ct_monitor_appname\"" >> $output_file
throw_error_if_need "Erro ao substituir variáveis no arquivo .env.template"
echo "containers_monitor_containers=\"$ct_monitor_containers\"" >> $output_file
throw_error_if_need "Erro ao substituir variáveis no arquivo .env.template"
echo "containers_monitor_timeout=\"$ct_monitor_timeout\"" >> $output_file
throw_error_if_need "Erro ao substituir variáveis no arquivo .env.template"
echo "containers_monitor_sleep_time=\"$ct_monitor_sleep_time\"" >> $output_file
throw_error_if_need "Erro ao substituir variáveis no arquivo .env.template"

echo "Variáveis substituídas com sucesso no arquivo .env."
echo "Conteúdo do arquivo .env:"
cat $output_file
