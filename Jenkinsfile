#!/usr/bin/env groovy

def test_print
this.test_print = "x"

echo this.test_print.toString()

timestamps {
        node('testLabel') {

            stage('test') {
            def fp = 'file.groovy'
            writeFile file: fp, text: '''#!/usr/bin/env groovy
            

def call(ctx) { 
   ctx.checkout ctx.scm
   ctx.echo ctx.pwd()
   
   ctx.println(ctx.test_print)
   
}

return call;
'''
            load(fp)(this.test_print)
        }
    }
}
