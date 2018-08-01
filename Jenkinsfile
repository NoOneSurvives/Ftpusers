#!/usr/bin/env groovy


def test_print = "x"
this.test_print = test_print

timestamps {
        node('testLabel') {

            stage('test') {
            def fp = 'file.groovy'
            writeFile file: fp, text: '''#!/usr/bin/env groovy
            

def called(ctx) { 
   checkout scm
   echo pwd()
   
   println(this.test_print)
   
}

return called;
'''
            load(fp)(this)
        }
    }
}
