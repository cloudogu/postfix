#!groovy
@Library(['github.com/cloudogu/ces-build-lib@1.64.2', 'github.com/cloudogu/dogu-build-lib@v2.1.0'])
import com.cloudogu.ces.cesbuildlib.*
import com.cloudogu.ces.dogubuildlib.*

timestamps {
    properties([
            // Keep only the last x builds to preserve space
            buildDiscarder(logRotator(numToKeepStr: '10')),
            // Don't run concurrent builds for a branch, because they use the same workspace directory
            disableConcurrentBuilds(),
            // Parameter to activate dogu upgrade test on demand
            parameters([
                    booleanParam(defaultValue: false, description: 'Test dogu upgrade from latest release or optionally from defined version below', name: 'TestDoguUpgrade'),
                    string(defaultValue: '', description: 'Old Dogu version for the upgrade test (optional; e.g. 2.222.1-1)', name: 'OldDoguVersionForUpgradeTest'),
                    choice(name: 'TrivyScanLevels', choices: [TrivyScanLevel.CRITICAL, TrivyScanLevel.HIGH, TrivyScanLevel.MEDIUM, TrivyScanLevel.ALL], description: 'The levels to scan with trivy'),
                    choice(name: 'TrivyStrategy', choices: [TrivyScanStrategy.UNSTABLE, TrivyScanStrategy.FAIL, TrivyScanStrategy.IGNORE], description: 'Define whether the build should be unstable, fail or whether the error should be ignored if any vulnerability was found.')
            ])
    ])

    node('docker') {
        stage('Checkout') {
            checkout scm
        }

        stage('Lint') {
            lintDockerfile()
        }

        stage('Check Markdown Links') {
            Markdown markdown = new Markdown(this)
            markdown.check()
        }

        stage('Shellcheck') {
            shellCheck()
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

            stage('Trivy scan') {
                Trivy trivy = new Trivy(this, ecoSystem)
                trivy.scanDogu("/dogu", TrivyScanFormat.HTML, params.TrivyScanLevels, params.TrivyStrategy)
                trivy.scanDogu("/dogu", TrivyScanFormat.JSON,  params.TrivyScanLevels, params.TrivyStrategy)
                trivy.scanDogu("/dogu", TrivyScanFormat.PLAIN, params.TrivyScanLevels, params.TrivyStrategy)
            }

            stage('Provision') {
                ecoSystem.provision("/dogu")
            }

            stage('Setup') {
                ecoSystem.loginBackend('cesmarvin-setup')
                ecoSystem.setup()
            }

            stage('Build') {
                ecoSystem.build("/dogu")
            }

            stage('Verify') {
                ecoSystem.verify("/dogu")
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

                stage('Add Github-Release') {
                    github.createReleaseWithChangelog(releaseVersion, changelog)
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
