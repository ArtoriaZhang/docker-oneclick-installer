#!/bin/sh
def stage1() {
	echo 'Execute remotely stage1'
	        environment {

                    NEXUS_CREDS = credentials('OrcaMesGit')
                    NEXUS_USER = "$NEXUS_CREDS_USR"
                    NEXUS_PASSWORD = "$NEXUS_CREDS_PSW"
                }
                // git branch: '${B}', credentialsId: 'OrcaMesGit', url: 'http://gitlab.ieccloud.hollicube.com/seres/quality-management-platform-two.git'
		dir('seres-function-test') {
                    git branch: '${B}', credentialsId: 'OrcaMesGit', url: 'http://192.168.200.54:8929/seres/seres-function-test.git'
                }
		dir('seres-function-test-ui') {
                    git branch: '${B}', credentialsId: 'OrcaMesGit', url: 'http://192.168.200.54:8929/seres/seres-function-test-ui.git'
                }

                git branch: '${B}', credentialsId: 'OrcaMesGit', url: 'http://192.168.200.54:8929/seres/quality-management-platform-one.git'
}

def stage2() {
	withCredentials([usernamePassword(credentialsId: 'OrcaMesGit', passwordVariable: 'PAS', usernameVariable: 'USER')]) {
	echo 'Execute remotely'
	sh 'cd seres-function-test-ui && npm install && npm run build'
        sh '${MAVEN_HOME}/bin/mvn -s ./quality-alarm-engine/orca-settings.xml -pl "!bff,!data-acquisition,!manual-entry-system,!miot-interface,!multisystem-data-integration,!platform-data-monitor,!quality-alarm,!operation-monitor,!quality-archives,!quality-base-setting,!quality-statistics-analyze,!quality-statistics-analyze"  -Dnexus.pass=public -Dnexus.user=public clean deploy '
        sh 'cd seres-function-test && ${MAVEN_HOME}/bin/mvn  -Dnexus.pass=public -Dnexus.user=public clean package '
	sh 'cd quality-alarm-engine && pwd'
	echo 'Stage2 end.'
        }
}

def stage3() {
	def aliyun = 'registry.cn-hangzhou.aliyuncs.com/orca_zhang'
	def docker = 'docker.io'
	sh 'echo ${buildImage}. Execute remotely'
                if (buildImage) {
                   if (registry == 'aliyun') {
                       withCredentials([usernamePassword(credentialsId: 'OrcaAli', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            // sh "cd quality-service/quality-server && docker build --load -t ${aliyun}/hollysys-seres-quality-server:${imageV} ./"
                            sh 'docker login -u ${USERNAME} -p ${PASSWORD} registry.cn-hangzhou.aliyuncs.com'
                            // sh "docker push ${aliyun}/hollysys-seres-quality-server:${imageV} "
                            
                            sh "cd quality-alarm-engine/engine-data-process && docker build --load -t ${aliyun}/hollysys-seres1-quality-engine-data:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-quality-engine-data:${engineV} "
                            
                            sh "cd quality-alarm-engine/engine-passrate-alarm && docker build --load -t ${aliyun}/hollysys-seres1-quality-engine-passrate:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-quality-engine-passrate:${engineV} "
                            
                            sh "cd quality-data-process && docker build --load -t ${aliyun}/hollysys-seres1-quality-data-process:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-quality-data-process:${engineV} "

                            sh "cd quality-monitor-board && docker build --load -t ${aliyun}/hollysys-seres1-quality-monitor-board:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-quality-monitor-board:${engineV} "
			    
                            sh "cd quality-data-process && docker build --load -t ${aliyun}/hollysys-seres1-quality-data-process:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-quality-data-process:${engineV} "

                            sh "cd seres-function-test && docker build --load -t ${aliyun}/hollysys-seres1-function-test:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-function-test:${engineV} "

                            sh "cd seres-function-test-ui && docker build --load -t ${aliyun}/hollysys-seres1-function-test-ui:${engineV} ./"
                            sh "docker push ${aliyun}/hollysys-seres1-function-test-ui:${engineV} "
                        }
	}
                   } else {
                       withCredentials([usernamePassword(credentialsId: 'OrcaDocker', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh "build image false"
                            sh "docker build --load -t $USERNAME/hollysys-jiahua-mes-server-dev:${b} ./"
                            sh "docker push $USERNAME/hollysys-jiahua-mes-server-dev:${b}" 
                        }
                   }
   }

return this
