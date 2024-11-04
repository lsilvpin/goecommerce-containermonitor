#!/bin/bash

throw_error_if_need() {
    if [ $? -ne 0 ]; then
        echo "$1"
        exit 1
    fi
}

# Nome da aplicação obtida do argumento
solution_name=$(bash get-env.sh "containers_monitor_appname")

# Diretório onde os scripts serão instalados
install_dir="/usr/local/bin/$solution_name"
service_file="/etc/systemd/system/$solution_name.service"

# Cria o diretório de instalação, se não existir
echo "Criando diretório de instalação em $install_dir..."
sudo mkdir -p $install_dir
throw_error_if_need "Erro ao criar o diretório de instalação: $install_dir"

# Copia o script principal para o diretório de instalação
echo "Copiando script de monitoramento para $install_dir..."
sudo cp ./goecommercecontainersmonitor.sh $install_dir/goecommercecontainersmonitor.sh
throw_error_if_need "Erro ao copiar o script de monitoramento para $install_dir"
sudo chmod +x $install_dir/goecommercecontainersmonitor.sh
throw_error_if_need "Erro ao definir permissões de execução para o script de monitoramento"

# Copia arquivo .env para o diretório de instalação
echo "Copiando arquivo .env para $install_dir..."
sudo cp ./.env $install_dir/.env
throw_error_if_need "Erro ao copiar o arquivo .env para $install_dir"

# Copia arquivo de serviços para o systemd
echo "Copiando arquivo de serviço para $service_file..."
sudo cp ./$solution_name.service $service_file
throw_error_if_need "Erro ao copiar o arquivo de serviço para $service_file"

# Copia script de leitura de variáveis de ambiente para o diretório de instalação
echo "Copiando script de leitura de variáveis de ambiente para $install_dir..."
sudo cp ./get-env.sh $install_dir/get-env.sh
throw_error_if_need "Erro ao copiar o script de leitura de variáveis de ambiente para $install_dir"

# Habilita e reinicia o serviço
echo "Habilitando e iniciando o serviço $solution_name..."
sudo systemctl daemon-reload
throw_error_if_need "Erro ao recarregar o daemon do systemd"
sudo systemctl enable $solution_name.service
throw_error_if_need "Erro ao habilitar o serviço $solution_name"
sudo systemctl restart $solution_name.service
throw_error_if_need "Erro ao reiniciar o serviço $solution_name"

echo "Instalação completa."
