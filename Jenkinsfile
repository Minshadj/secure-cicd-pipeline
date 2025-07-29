pipeline {
    agent any

    environment {
        // Define a local-only image name.
        // The BUILD_NUMBER is a variable provided automatically by Jenkins.
        IMAGE_NAME = "local/realworld-app:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout from Git') {
            steps {
                echo 'Checking out the main branch...'
                checkout scm
            }
        }

        stage('SAST Scan') {
            steps {
                sh '''
                  /usr/bin/docker run --rm -v "${WORKSPACE}/app":/src returntocorp/semgrep:latest semgrep --config "p/default" --error
                   '''
            }
        }

        // === NEW STAGE: LOCAL BUILD AND DEPLOY ===
        stage('Local Build and Deploy to Staging') {
            steps {
                echo "Building Docker image locally: ${IMAGE_NAME}"
                // Build the image and tag it with our defined name.
                // The image will only exist on the machine Jenkins is running on.
                sh "/usr/bin/docker build -t ${IMAGE_NAME} ./app"

                echo "Deploying to staging environment..."
                // Make the script executable
                sh "chmod +x ./scripts/deploy-staging-local.sh"
                // Run the script, passing the image name as an argument
                sh "./scripts/deploy-staging-local.sh ${IMAGE_NAME}"
            }
        }
    }
}
