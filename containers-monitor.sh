#!/bin/bash

install_dir="/usr/local/bin/containers-monitor"
cd $install_dir

# Obtém o nome da solução, a lista de containers e o timeout via script externo
solution_name=$(bash get-env.sh "containers_monitor_appname")
containers_str=$(bash get-env.sh "containers_monitor_containers")
timeout=$(bash get-env.sh "containers_monitor_timeout")
sleep_time=$(bash get-env.sh "containers_monitor_sleep_time")

# Lança erro se o último comando falhar
throw_error_if_need() {
    if [ $? -ne 0 ]; then
        echo "$1"
        exit 1
    fi
}

if [ -z "$solution_name" ]; then
    echo "Variável 'solution_name' não encontrada"
    exit 1
fi

if [ -z "$containers_str" ]; then
    echo "Variável 'containers_for_monitor' não encontrada"
    exit 1
fi

if [ -z "$timeout" ]; then
    echo "Variável 'containers_monitor_timeout' não encontrada"
    exit 1
fi

# Defina o nome dos containers em uma ordem específica
IFS=' ' read -r -a containers <<< "$containers_str"

# Criação do diretório de log com o nome da solução
log_dir="/var/log/$solution_name"
mkdir -p "$log_dir"
throw_error_if_need "Erro ao criar o diretório de log: $log_dir"

# Função para gerar o nome do arquivo de log com a data
generate_log_file_name() {
    local log_date=$(date '+%Y-%m-%d')
    echo "$log_dir/${solution_name}_$log_date.log"
}

# Função para logar mensagens no arquivo de log diário
log_message() {
    local message="$1"
    local log_file=$(generate_log_file_name)

    # Verifica se o arquivo de log foi criado hoje, se não, insere um cabeçalho
    if [ ! -f "$log_file" ]; then
        log_file_header "$log_file"
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$log_file"
}

# Função para logar o início de um novo arquivo de log diário com destaque
log_file_header() {
    local log_file="$1"
    local log_date=$(date '+%Y-%m-%d %H:%M:%S')
    echo "==================================================" >> "$log_file"
    echo "Arquivo de log '$solution_name' criado em $log_date" >> "$log_file"
    echo "==================================================" >> "$log_file"
}

# Função para logar o início da execução do script com destaque
log_execution_start() {
    local start_time=$(date '+%Y-%m-%d %H:%M:%S')
    echo "=================================================="
    echo "Execução do script '$solution_name' iniciada em $start_time"
    echo "=================================================="
}

# Função para verificar e subir containers
check_and_start_containers() {
    for container_sufix in "${containers[@]}"; do
        container=""
        if [[ $container_sufix == jenkins* ]]; then
            container="$container_sufix"
        else
            container="tibiaot-$container_sufix"
        fi

        log_message "Verificando se o container $container existe..."
        # Verifica se o container já existe
        if [[ $(docker ps -a --filter "name=$container" --format '{{.Names}}') == "$container" ]]; then
            log_message "Container $container encontrado."
            # Verifica se o container está rodando
            if [[ $(docker inspect -f '{{.State.Running}}' "$container") == "false" ]]; then
                log_message "Container $container está parado. Tentando iniciar..."
                
                # Inicia o container
                docker start "$container"
                throw_error_if_need "Erro ao tentar iniciar o container $container"
                log_message "Iniciando container $container..."
                
                # Espera até que o container esteja rodando, com timeout configurado
                elapsed=0
                while [[ $(docker inspect -f '{{.State.Running}}' "$container") == "false" ]]; do
                    log_message "Aguardando container $container iniciar..."
                    sleep 2
                    elapsed=$((elapsed + 2))
                    if [[ $elapsed -ge $timeout ]]; then
                        log_message "Erro: Timeout ao tentar iniciar o container $container."
                        break
                    fi
                done

                if [[ $(docker inspect -f '{{.State.Running}}' "$container") == "true" ]]; then
                    log_message "Container $container iniciado com sucesso."
                fi
            else
                log_message "Container $container já está rodando."
            fi
        else
            # Se o container não existir, loga um erro
            log_message "Erro: Container $container não existe."
        fi
        log_message "Finalizado processo de verificação para $container."
    done
}

# Executa o monitoramento em loop
log_execution_start
while true; do
    log_message "=================================================="
    log_message "Iniciando verificação dos containers..."
    log_message "=================================================="
    echo "Verificando containers: ${containers[@]}"
    check_and_start_containers
    log_message "Verificação completa. Aguardando $sleep_time segundos antes da próxima execução."
    sleep "$sleep_time"  # Intervalo de tempo entre as checagens
done
