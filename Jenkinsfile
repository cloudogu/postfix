@Library([
  'pipe-build-lib@develop',
  'ces-build-lib',
  'dogu-build-lib'
]) _

def pipe = new com.cloudogu.sos.pipebuildlib.DoguPipe(this, [
    doguName           : "postfix",
    shellScripts       : "./resources/logging.sh ./resources/startup.sh ./resources/mask2cidr.sh",
    checkMarkdown      : true,
])

pipe.setBuildProperties()
pipe.addDefaultStages()
pipe.run()