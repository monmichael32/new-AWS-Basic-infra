pipeline 
{
  agent any
  stages 
  {
    stage ('Terraform Shit') 
    {
        steps
        {
          sh '/usr/local/bin/terraform init'
          sh '/usr/local/bin/terraform apply --auto-approve'
         
          sh './inventory.sh'
          sh 'cd ansible-apache; ansible-playbook -vvv -i hosts apache.yml'
        }
    }  
  }
}
