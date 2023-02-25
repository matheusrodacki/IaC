#! /bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOF
- hosts: localhost
  tasks: 

  - name: Install Python 3 and Virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes

  - name: Git Clone
    ansible.builtin.git:
      repo: https://github.com/alura-cursos/clientes-leo-api.git
      dest: /home/ubuntu/tcc
      version: master
      force: yes
      
  - name: Install Django and Django Rest
    pip:
      virtualenv: /home/ubuntu/tcc/venv
      requirements: /home/ubuntu/tcc/requirements.txt

  - name: Alter hosts on settings
    lineinfile: 
      path: /home/ubuntu/tcc/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: "ALLOWED_HOSTS = ['*']"
      backrefs: yes

  - name: DB Config
    shell: 'cd ~/tcc; 
            . venv/bin/activate;  
            python /home/ubuntu/tcc/manage.py migrate'

  - name: Load data
    shell: 'cd ~/tcc; 
            . venv/bin/activate;  
            python /home/ubuntu/tcc/manage.py loaddata clientes.json'          

  - name: Run Server
    shell: 'cd ~/tcc; 
            . venv/bin/activate; 
            nohup python manage.py runserver 0.0.0.0:8000 &'
EOF
ansible-playbook playbook.yml