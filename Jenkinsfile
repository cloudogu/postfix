#!groovy
@Library([
  'pipe-build-lib',
  'ces-build-lib',
  'dogu-build-lib'
]) _

def pipe = new com.cloudogu.sos.pipebuildlib.DoguPipe(this, [
    doguName           : "postfix",
    shellScripts        : "./resources/logging.sh ./resources/mask2cidr.sh ./resources/startup.sh",
    checkMarkdown       : false,
])

pipe.setBuildProperties()
pipe.addDefaultStages()
pipe.run()
