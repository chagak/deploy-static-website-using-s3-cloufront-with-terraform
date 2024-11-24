pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        BUCKET_NAME = 'chaganote-static-honey' // Specify your bucket name here
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/chagak/deploy-static-website-using-s3-cloufront-with-terraform.git'
            }
        }
        stage('Install AWS CLI') {
            steps {
                sh 'curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip'
                sh 'unzip awscliv2.zip'
                sh 'sudo ./aws/install'
            }
        }
        stage('Terraform Init & Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Upload to S3') {
            steps {
                // Use the environment variable for the bucket name
                sh 'aws s3 sync honey-static-webapp s3://$BUCKET_NAME --acl private'
            }
        }
    }
    post {
        always {
            // Run terraform destroy in case of success or failure
            sh 'terraform destroy -auto-approve'
            cleanWs() // Optional: Cleans up the workspace
        }
    }
}
