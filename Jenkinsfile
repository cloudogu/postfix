#!groovy
@Library([
  'pipe-build-lib',
  'ces-build-lib',
  'dogu-build-lib@feature/74-fix-dogu-build-lib-multinode-verify_wget'
]) _

def pipe = new com.cloudogu.sos.pipebuildlib.DoguPipe(this, [
    doguName           : "postfix",
    shellScripts        : "./resources/logging.sh ./resources/mask2cidr.sh ./resources/startup.sh",
    checkMarkdown       : true,
])

pipe.setBuildProperties()
pipe.addDefaultStages()
pipe.run()
