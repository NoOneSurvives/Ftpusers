#!/usr/bin/env groovy
timestamps {
        node('testLabel') {

            stage('test') {
            def fp = 'file.groovy'
            writeFile file: fp, text: '''#!/usr/bin/env groovy

def run() { 
checkout scm
}

return this;
'''
            def external = load(fp)
            external()
        }
    }
}
