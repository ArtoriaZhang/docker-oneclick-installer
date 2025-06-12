#!/bin/sh
def stage1() {
	echo 'stage1'
}

def stage2() {

	withCredentials([usernamePassword(credentialsId: 'OrcaMesGit', passwordVariable: 'PAS', usernameVariable: 'USER')]) {
	echo 'Execute remotely'
            sh '${MAVEN_HOME}/bin/mvn -s ./quality-alarm-engine/orca-settings.xml -pl "!bff,!data-acquisition,!manual-entry-system,!miot-interface,!multisystem-data-integration,!platform-data-monitor,!quality-alarm,!operation-monitor,!quality-archives,!quality-base-setting,!quality-monitor-board,!quality-statistics-analyze,!quality-statistics-analyze"  -Dnexus.pass=public -Dnexus.user=public clean deploy '
            sh 'cd quality-alarm-engine && pwd'
            sh 'pwd'
            
        }
	echo 'stage2'
}

return this
