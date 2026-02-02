#!groovy
@Library(['github.com/cloudogu/dogu-build-lib@v3.1.0', 'github.com/cloudogu/ces-build-lib@4.1.0']) _
import com.cloudogu.ces.dogubuildlib.*
import com.cloudogu.ces.cesbuildlib.*

timestamps {
    properties([
            // Keep only the last x builds to preserve space
            buildDiscarder(logRotator(numToKeepStr: '10')),
            // Don't run concurrent builds for a branch, because they use the same workspace directory
            disableConcurrentBuilds(),
            // Parameter to activate dogu upgrade test on demand
            parameters([
                       booleanParam(defaultValue: false, description: 'Test dogu upgrade from latest release or optionally from defined version below', name: 'TestDoguUpgrade'),
                        string(defaultValue: '', description: 'Old Dogu version for the upgrade test (optional; e.g. 3.23.0-1)', name: 'OldDoguVersionForUpgradeTest'),
                        choice(name: 'TrivySeverityLevels', choices: [TrivySeverityLevel.CRITICAL, TrivySeverityLevel.HIGH_AND_ABOVE, TrivySeverityLevel.MEDIUM_AND_ABOVE, TrivySeverityLevel.ALL], description: 'The levels to scan with trivy', defaultValue: TrivySeverityLevel.CRITICAL),
                        choice(name: 'TrivyStrategy', choices: [TrivyScanStrategy.UNSTABLE, TrivyScanStrategy.FAIL, TrivyScanStrategy.IGNORE], description: 'Define whether the build should be unstable, fail or whether the error should be ignored if any vulnerability was found.', defaultValue: TrivyScanStrategy.UNSTABLE),
            ])
    ])

    node('docker') {
        stage('Checkout') {
            checkout scm
        }
    }

    node('vagrant') {
        Git git = new Git(this, "cesmarvin")
        git.committerName = 'cesmarvin'
        git.committerEmail = 'cesmarvin@cloudogu.com'
        GitFlow gitflow = new GitFlow(this, git)
        GitHub github = new GitHub(this, git)
        Changelog changelog = new Changelog(this)

        String doguName = "postfix"

        EcoSystem ecoSystem = new EcoSystem(this, "gcloud-ces-operations-internal-packer", "jenkins-gcloud-ces-operations-internal")
        Vagrant vagrant = new Vagrant(this, "gcloud-ces-operations-internal-packer", "jenkins-gcloud-ces-operations-internal")

        try {

            stage('Provision') {
                // change namespace to prerelease_namespace if in develop-branch
                if (gitflow.isPreReleaseBranch()) {
                    sh "make prerelease_namespace"
                }
                ecoSystem.provision("/dogu")
            }

            stage('Setup') {
                ecoSystem.loginBackend('cesmarvin-setup')
                ecoSystem.setup()
            }

            stage('Build') {
                // purge postfix from official namespace to prevent conflicts while building prerelease_official/postfix, keep config to avoid no etcd endpoints error
                if (gitflow.isPreReleaseBranch()) {
                    ecoSystem.purgeDogu("postfix", "--keep-config")
                }
                ecoSystem.build("/dogu")
            }

            stage('Trivy scan') {
                ecoSystem.copyDoguImageToJenkinsWorker("/dogu")
                Trivy trivy = new Trivy(this)
                trivy.scanDogu(".", params.TrivySeverityLevels, params.TrivyStrategy)
                trivy.saveFormattedTrivyReport(TrivyScanFormat.TABLE)
                trivy.saveFormattedTrivyReport(TrivyScanFormat.JSON)
                trivy.saveFormattedTrivyReport(TrivyScanFormat.HTML)
            }

            stage('Verify') {
                ecoSystem.verify("/dogu")
            }

            stage('Finish Release') {
                String releaseVersion = 'v3.9.8-1'
                ecoSystem.push('/dogu')
                github.createReleaseWithChangelog(releaseVersion, changelog, "main")
            }

            if (params.TestDoguUpgrade != null && params.TestDoguUpgrade){
                stage('Upgrade dogu') {
                    String doguVersionForUpgradeTest = params.OldDoguVersionForUpgradeTest
                    purgeAndReinstallDogu(ecoSystem, vagrant, doguName, doguVersionForUpgradeTest, relayhost)

                    ecoSystem.upgradeDogu(ecoSystem)

                    // Wait for upgraded dogu to get healthy
                    ecoSystem.waitForDogu(doguName)
                }
            }

            if (gitflow.isReleaseBranch()) {
                String releaseVersion = git.getSimpleBranchName()

                stage('Finish Release') {
                    gitflow.finishRelease(releaseVersion)
                }

                stage('Push Dogu to registry') {
                    ecoSystem.push("/dogu")
                }

                stage('Add Github-Release'){
                    github.createReleaseWithChangelog(releaseVersion, changelog)
                }
            } else if (gitflow.isPreReleaseBranch()) {
                // push to registry in prerelease_namespace
                stage('Push Prerelease Dogu to registry') {
                    ecoSystem.pushPreRelease("/dogu")
                }
            }

        } finally {
            stage('Clean') {
                ecoSystem.destroy()
            }
        }
    }
}

void purgeAndReinstallDogu(EcoSystem ecoSystem, Vagrant vagrant, String doguName, String doguVersionToInstall, String relayhost) {
    ecoSystem.purgeDogu(doguName)

    // Set etcd entry required for postfix. This entry was removed during the previous purge.
    vagrant.ssh('etcdctl set /config/postfix/relayhost ' + relayhost)

    if (doguVersionToInstall != '' && !doguVersionToInstall.contains('v')){
        println "Installing user defined version of dogu: " + params.OldDoguVersionForUpgradeTest
        ecoSystem.installDogu("official/" + doguName + " " + params.OldDoguVersionForUpgradeTest)
    } else {
        println "Installing latest released version of dogu..."
        ecoSystem.installDogu("official/" + doguName)
    }

    ecoSystem.startDogu(doguName)
    ecoSystem.waitForDogu(doguName)
}
