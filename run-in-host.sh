#!/bin/bash

throw_error_if_need() {
    if [ $? -ne 0 ]; then
        echo "$1"
        exit 1
    fi
}

# Nome da aplicação obtida do argumento
solution_name=$(bash get-env.sh "containers_monitor_appname")

# Reinicia o serviço do monitoramento
echo "Reiniciando o serviço $solution_name..."
sudo systemctl restart $solution_name.service
throw_error_if_need "Erro ao reiniciar o serviço $solution_name"
echo "Serviço reiniciado com sucesso."

# Verifica o status do serviço
echo "Verificando o status do serviço $solution_name..."
sudo systemctl status $solution_name.service --no-pager
throw_error_if_need "Erro ao verificar o status do serviço $solution_name"
echo "Status do serviço verificado com sucesso."
