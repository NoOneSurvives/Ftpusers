#!/usr/bin/env groovy

def test_print() {
a = "test"
}

timestamps {
        node('testLabel') {

            stage('test') {
            def fp = 'file.groovy'
            writeFile file: fp, text: '''#!/usr/bin/env groovy

def call() { 
   checkout scm
   println(test_print.a)
   
}

return this;
'''
            def external = load(fp)
            external()
        }
    }
}
