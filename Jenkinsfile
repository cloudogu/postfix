#!groovy
@Library([
  'pipe-build-lib',
  'ces-build-lib',
  'dogu-build-lib'
]) _

import com.cloudogu.ces.cesbuildlib.K3d
import com.cloudogu.ces.cesbuildlib.Makefile

def pipe = new com.cloudogu.sos.pipebuildlib.DoguPipe(this, [
    doguName           : "postfix",
    shellScripts        : "./resources/logging.sh ./resources/mask2cidr.sh ./resources/startup.sh",
    checkMarkdown       : false,
    defaultBranch : "master"
])

def componentRegistry = "registry.cloudogu.com"
def componentRegistryNamespace = "k8s"
def componentChartTargetDir = "target/k8s/helm"
def componentBuildImageRepository = "registry.cloudogu.com/official/postfix"
def componentReleaseName = "postfix"
def goVersion = "1.26.0"

pipe.setBuildProperties()
pipe.addDefaultStages()
com.cloudogu.ces.dogubuildlib.EcoSystem ecoSystem = pipe.ecoSystem

def runMakeInGoContainer = { target ->
    new com.cloudogu.ces.cesbuildlib.Docker(this)
        .image("golang:${goVersion}")
        .mountJenkinsUser()
        .inside("--volume ${WORKSPACE}:/workdir -w /workdir") {
            sh "make ${target}"
        }
}

String getDoguVersion(boolean withVersionPrefix) {
    def doguJson = this.readJSON file: 'dogu.json'
    String version = doguJson.Version

    if (withVersionPrefix) {
        return "v" + version
    } else {
        return version
    }
}

def componentStages = { group ->
    group.stage('Component Checkout') {
        checkout scm
    }

    group.stage('Component Build') {
        runMakeInGoContainer("install-yq")
        docker.withRegistry('https://registry.cloudogu.com/', 'cesmarvin-setup') {
            sh "make docker-build"
        }
    }

    group.stage('Component Lint') {
        runMakeInGoContainer("helm-lint")
    }

    group.stage('Component Smoke Test (k3d)') {
        K3d k3d = new K3d(this, "${WORKSPACE}", "${WORKSPACE}/k3d", env.PATH)
        String imageTag = getDoguVersion(false)

        try {
            echo "[Component k3d] Start cluster"
            k3d.startK3d()

            echo "[Component k3d] Generate helm chart"
            runMakeInGoContainer("helm-generate")

            echo "[Component k3d] Retag image for local smoke test"
            sh "docker tag ${componentBuildImageRepository}:${imageTag} local-smoke/postfix:${imageTag}"

            echo "[Component k3d] Import previously built image"
            sh "sudo ${WORKSPACE}/k3d/.k3d/bin/k3d image import local-smoke/postfix:${imageTag} -c ${k3d.registryName}"

            echo "[Component k3d] Deploy component via helm"
            k3d.helm("upgrade --install ${componentReleaseName} ${componentChartTargetDir}"
            + " --namespace default --set containers.postfix.image.registry=''"
            + " --set containers.postfix.image.repository=local-smoke/postfix"
            + " --set containers.postfix.image.tag=${imageTag}"
            + " --set containers.postfix.imagePullPolicy=Never"
            + " --wait --timeout 5m")

            echo "[Component k3d] Verify component startup"
            k3d.kubectl("rollout status deployment/${componentReleaseName} --timeout=300s")
            k3d.kubectl("wait --for=condition=ready pod -l app.kubernetes.io/instance=${componentReleaseName} --timeout=300s")
        } catch (Exception e) {
            k3d.collectAndArchiveLogs()
            throw e as java.lang.Throwable
        } finally {
            k3d.deleteK3d()
        }
    }

    if (pipe.gitflow.isReleaseBranch()) {
        group.stage('Push Component Chart to Harbor') {
            sh "make helm-package"

            def componentChartFile = sh(returnStdout: true, script: "ls -1t ${componentChartTargetDir}/*.tgz 2>/dev/null | head -n 1").trim()
            if (!componentChartFile) {
                error("No packaged component chart found in ${componentChartTargetDir}")
            }

            withCredentials([usernamePassword(credentialsId: 'harborhelmchartpush', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD')]) {
                sh ".bin/helm registry login ${componentRegistry} --username '${HARBOR_USERNAME}' --password '${HARBOR_PASSWORD}'"
                sh ".bin/helm push ${componentChartFile} oci://${componentRegistry}/${componentRegistryNamespace}/"
                sh ".bin/helm registry logout ${componentRegistry}"
            }
        }
    }
}

pipe.addStageGroup('component', pipe.agentMultinode, componentStages)
pipe.run()
