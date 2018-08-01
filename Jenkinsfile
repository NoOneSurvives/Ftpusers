#!/usr/bin/env groovy

def test_print
this.test_print = "x"

echo this.test_print.toString()

timestamps {
        node('testLabel') {

            stage('test') {
            def fp = 'file.groovy'
            writeFile file: fp, text: '''#!/usr/bin/env groovy
            

def call(test_print) { 
   checkout scm
   echo pwd()
   
   println(test_print.x)
   
}

return this;
'''
            load(fp)(this)
        }
    }
}
return this;
