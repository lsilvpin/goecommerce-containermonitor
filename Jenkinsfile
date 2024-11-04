pipeline {
    agent {
        label "${env.containers_monitor_slave}"
    }
    stages {
        stage ('Print') {
            steps {
                sh "bash ./print-vars.sh"
            }
        }
        stage ('Replace') {
            steps {
                sh "bash ./replace-env.sh"
            }
        }
        stage ('Install') {
            steps {
                sh "bash ./install-in-host.sh ${env.containers_monitor_appname}"
            }
        }
        stage ('Run') {
            steps {
                sh "bash ./run-in-host.sh ${env.containers_monitor_appname}"
            }
        }
    }
}
