pipeline {
    agent {
        label 'linux_ansible'
    }
    stages {
        stage('Checkout') {
            steps{
                git branch: 'main', credentialsId: 'a988e83e-63f3-47fb-9751-d1abef0706f0', url: 'git@github.com:E-zh/vector-role.git'
            }
        }
        stage('Install molecule') {
            steps{
                sh 'pip3 install --user "molecule==3.5.2" "molecule_docker" "ansible-lint<6.0.0" flake8'
                //sh 'docker --version && ansible --version && ansible-lint --version && molecule --version'
                sh 'pwd'
            }
        }
    stage('Run Molecule'){
            steps{
                withEnv(['PATH+EXTRA=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/egor/.local/bin:/home/egor/bin:/home/jenkins/.local/bin']) {
                    sh 'molecule test ubuntu_latest'
                }
                // Clean workspace after testing
                cleanWs()
            }
        }
    }
}
