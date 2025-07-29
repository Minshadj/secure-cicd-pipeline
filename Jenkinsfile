pipeline {
    agent any

    environment {
        // The BUILD_NUMBER is a variable provided automatically by Jenkins.
        IMAGE_NAME = "local/realworld-app:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout from Git') {
            steps {
                echo 'Checking out the main branch into the workspace...'
                // This checks out the repo content (app/, scripts/, Jenkinsfile)
                // directly into the root of the workspace.
                checkout scm
                
                echo "Workspace content after checkout:"
                sh 'ls -lR'
            }
        }

        stage('SAST Scan') {
            steps {
                echo "Running SAST scan..."
                // We explicitly point the volume mount to the 'app' subdirectory
                // within the Jenkins workspace.
                 sh '''
                 /usr/bin/docker run --rm --memory="1g" -v "${WORKSPACE}/app":/src returntocorp/semgrep:latest semgrep --config "p/default" --error
                    '''
            }
        }

        stage('Local Build and Deploy to Staging') {
            steps {
                echo "Building Docker image locally: ${IMAGE_NAME}"
                // The build context is now correctly pointed to the 'app' subdirectory
                sh "/usr/bin/docker build -t ${IMAGE_NAME} ./app"

                echo "Deploying to staging environment..."
                sh "chmod +x ./scripts/deploy-staging-local.sh"
                sh "./scripts/deploy-staging-local.sh ${IMAGE_NAME}"
            }
        }
    }
}
