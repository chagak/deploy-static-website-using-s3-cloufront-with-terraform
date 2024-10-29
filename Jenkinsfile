pipeline {
    agent any  // Run on any available Jenkins agent
    environment {
        // Set AWS credentials to access your AWS account
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout') {
            steps {
                // Clone the GitHub repository containing Terraform files
                git branch: 'main', "https://github.com/chagak/deploy-static-website-using-s3-cloufront-with-terraform.git"
            }
        }
        
        stage('Terraform Init & Plan') {
            steps {
                // Run Terraform commands in the root folder
                sh 'terraform init'  // Initialize Terraform
                sh 'terraform plan -out=tfplan'  // Generate a plan for changes
                sh 'terraform show -no-color tfplan > tfplan.txt'  // Save the plan in text format
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Apply the Terraform plan to create the infrastructure
                sh 'terraform apply -auto-approve'
            }
        }
    }
    post {
        always {
            // Clean up workspace files after the pipeline run
            cleanWs()
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