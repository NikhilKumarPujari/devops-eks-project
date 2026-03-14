pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        IMAGE_NAME = 'devops-app'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git 'https://github.com/NikhilKumarPujari/devops-eks-project.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME ./app'
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin <ACCOUNT-ID>.dkr.ecr.ap-south-1.amazonaws.com

                docker tag $IMAGE_NAME:latest <ECR-URL>
                docker push <ECR-URL>
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks update-kubeconfig --name devops-cluster --region $AWS_REGION
                kubectl apply -f kubernetes/
                '''
            }
        }

    }
}
