#!/usr/bin/env groovy

def test_print() {
def a = "test"
}

timestamps {
        node('testLabel') {

            stage('test') {
            def fp = 'file.groovy'
            writeFile file: fp, text: '''#!/usr/bin/env groovy

def call(ctx) { 
   ctx.checkout ctx.scm
   ctx.echo ctx.pwd()
   
   println(ctx.test_print.a)
   
}

return this;
'''
            def external = load(fp)
            external.call(this)
        }
    }
}
