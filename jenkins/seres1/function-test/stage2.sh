#!/bin/sh
def stage1() {
	echo 'stage1'
}

def stage2() {
	withCredentials([usernamePassword(credentialsId: 'OrcaMesGit', passwordVariable: 'PAS', usernameVariable: 'USER')]) {
	echo 'Execute remotely'
        // sh '${MAVEN_HOME}/bin/mvn -s ./quality-alarm-engine/orca-settings.xml -pl "!bff,!data-acquisition,!manual-entry-system,!miot-interface,!multisystem-data-integration,!platform-data-monitor,!quality-alarm,!operation-monitor,!quality-archives,!quality-base-setting,!quality-monitor-board,!quality-statistics-analyze,!quality-statistics-analyze"  -Dnexus.pass=public -Dnexus.user=public clean deploy '
	sh 'cd quality-alarm-engine && pwd'
	sh 'pwd'
	echo 'stage2'
        }
}

def stage3() {
	def aliyun = 'registry.cn-hangzhou.aliyuncs.com/orca_zhang'
	def docker = 'docker.io'
	sh 'echo ${buildImage}'
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
