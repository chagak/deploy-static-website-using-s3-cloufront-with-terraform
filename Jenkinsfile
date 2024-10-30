pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/chagak/deploy-static-website-using-s3-cloufront-with-terraform.git'
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
                // Update the folder path and bucket name accordingly
                sh 'aws s3 sync ./Webfile/honey-static-webapp s3://${aws_s3_bucket.chaganote_static_honey_web.bucket} --acl private'
            }
        }
    }
    post {
        always {
            stage('Terraform Destroy') {
                steps {
                    sh 'terraform destroy -auto-approve'
                }
            }
            cleanWs() // Optional: Cleans up the workspace
        }
    }
}

// pipeline {
//     agent any

//     parameters {
//             booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
//             booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
//             booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
//     }

//     stages {
//         stage('Clone Repository') {
//             steps {
//                 // Clean workspace before cloning (optional)
//                 deleteDir()

//                 // Clone the Git repository
//                 git branch: 'main',
//                     url: 'https://github.com/chagak/.git'

//                 sh "ls -lart"
//             }
//         }

//         stage('Terraform Init') {
//                     steps {
//                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentials-chaganote']]){
//                             dir('') {
//                             sh 'echo "=================Terraform Init=================="'
//                             sh 'terraform init'
//                         }
//                     }
//                 }
//         }

//         stage('Terraform Plan') {
//             steps {
//                 script {
//                     if (params.PLAN_TERRAFORM) {
//                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentials-chaganote']]){
//                             dir() {
//                                 sh 'echo "=================Terraform Plan=================="'
//                                 sh 'terraform plan'
//                             }
//                         }
//                     }
//                 }
//             }
//         }

//         stage('Terraform Apply') {
//             steps {
//                 script {
//                     if (params.APPLY_TERRAFORM) {
//                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentials-chaganote']]){
//                             dir() {
//                                 sh 'echo "=================Terraform Apply=================="'
//                                 sh 'terraform apply -auto-approve'
//                             }
//                         }
//                     }
//                 }
//             }
//         }

//         stage('Terraform Destroy') {
//             steps {
//                 script {
//                     if (params.DESTROY_TERRAFORM) {
//                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentials-chaganote']]){
//                             dir() {
//                                 sh 'echo "=================Terraform Destroy=================="'
//                                 sh 'terraform destroy -auto-approve'
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }