# Como comprobar scripts de Cloud-init y Playbooks de Ansible en un entorno local con Vagrant

###### By Juan Manuel Payán / jpaybar

st4rt.fr0m.scr4tch@gmail.com

#### Intro

Este `Lab` trata de mostrar la posibilidad de probar nuestros scripts de `Cloud-init` y playbooks de `Ansible` en un entorno local con `Vagrant` antes de ser lanzados a nuestras instancias en la nube.

`Vagrant` nos ofrece esta posibilidad gracias a poder usar `cloud-init` en nuestro fichero `Vagrantfile` aunque está en fase experimental como nos advierten en su web

[Cloud-Init | Vagrant | HashiCorp Developer](https://developer.hashicorp.com/vagrant/docs/cloud-init), asi mismo podemos hacer uso también del aprovisionamiento con `Ansible-local` [Ansible Local - Provisioning | Vagrant | HashiCorp Developer](https://developer.hashicorp.com/vagrant/docs/provisioning/ansible_local) desde el mismo `Vagrantfile` sin necesidad de tener instalado `Ansible` en nuestro `Host`.

Una vez comprobado que funcionan en nuestro entorno local con `Vagrant` podremos ejecutarlos en cualquier instancia de cualquier proveedor en la nube (privado o público) AWS, Azure, Openstack, etc...

#### ¿Qué es Vagrant?

`Vagrant` es una herramienta de línea de comandos escrita en `Ruby` desarrollada por la empresa https://www.hashicorp.com/ , es multiplataforma y la podemos ejecutar en `Windows, GNU/Linux o MacOS X`. Este software nos permite generar entornos de desarrollo reproducibles y compartibles de forma muy sencilla. Para la creación de estas máquinas virtuales, `Vagrant` crea un fichero de configuración `Vagrantfile`, que podemos llevar de un entorno a otro. Esta herramienta nos facilita enormemente el trabajo cuando tenemos que trabajar con `entornos de desarrollo virtuales portables`.

Trabajar con diferentes `Hipervisiores` como `VMware, VirtualBox, Hyper-V, KVM, AWS, Openstack` e incluso también con contenedores de `Docker`. Además dispone de una gran diversidad de plugins que nos pueden facilitar enormemente muchas tareas a la hora de configurar nuestras MV.

https://www.vagrantup.com/

#### ¿Qué es Cloud-init?

`Cloud-init` es una herramienta que automatiza la inicialización de las instancias en la `nube` durante el arranque del sistema. Podemos usar `cloud-init` para que realice una extensa variedad de tareas configurando nuestras `instancias en el primer arranque`.

[cloud-init 22.4.2 documentation](https://cloudinit.readthedocs.io/en/latest/index.html)

###### **NOTA:**

Para ello es necesario que la imagen de nuestra instancia tenga instalado el paquete `cloud-init` o en este caso nuestro `Box de Vagrant`. En las instancias no hay problema con eso, pero si podemos encontrar muchisimos `Boxes` de `Vagrant` que no lo traen instalado, por lo que para hacer dichas pruebas deberiamos instalar el paquete, levantar los servicios y reempaquetar de nuevo el `Box` con un simple comando desde el directorio de trabajo de la MV actual:

```bash
vagrant package --output mynew.box
```

#### ¿Qué es Ansible?

Ansible es un motor open source que automatiza los procesos para preparar la infraestructura, gestionar la configuración, implementar las aplicaciones y organizar los sistemas, entre otros procedimientos de TI.

https://www.redhat.com/es/topics/automation/learning-ansible-tutorial

#### Directivas del archivo `Vagrantfile`

Hay tres que nos interesan y son la siguientes:

<u>Vagrant-env plugin</u>

```ruby
# https://github.com/gosuri/vagrant-env
config.env.enable # vagrant plugin install vagrant-env
```

Para poder hacer uso de `cloud-init` necesitamos instalar el plugin de `Vagrant` llamado `vagrant-env`:

[GitHub - gosuri/vagrant-env: Vagrant plugin to load environment variables from .env into ENV](https://github.com/gosuri/vagrant-env)

Debemos instalar lo previamente desde el interprete de comandos. Si estamos detrás de un proxy de una red corporativa, también deberemos exportar las variables de entorno `http_proxy` y `https_proxy`.

Linux

```bash
echo 'export http_proxy="http://10.40.56.3:8080"' >> /etc/environment
echo 'export https_proxy="http://10.40.56.3:8080"' >> /etc/environment
```

Windows

```powershell
PS C:\> $ENV:http_proxy="http://10.40.56.3:8080"
PS C:\> $ENV:https_proxy="http://10.40.56.3:8080"
```

```bash
vagrant plugin install vagrant-env
```

Una vez instalado el plugin, añadimos la entrada siguiente a nuestro `Vagrantfile`:

```ruby
# https://github.com/gosuri/vagrant-env
config.env.enable # vagrant plugin install vagrant-env
```

Además debemos de crear un fichero llamado `.env` en la carpeta raiz del proyecto donde se encuentre nuestro archivo `Vagrantfile` con el siguiente contenido:

```textile
VAGRANT_EXPERIMENTAL="cloud_init,disks"
```

Para más info, visitar la pagina oficial

[Vagrant Experimental Feature Flag | Vagrant | HashiCorp Developer](https://developer.hashicorp.com/vagrant/docs/experimental)

<u>Cloud-init</u>

Como hemos comentado anteriormente nuestra imagen `Box` de `Vagrant` debe de tener instalada el paquete `cloud-init` y deberemos crear nuestro script `cloud-config` (Este archivo debe tener una sintaxis YAML válida).  Puede ser un script bash o cualquier otro script siempre que comience con `#!` (la conocida `SheBang`).

https://cloudinit.readthedocs.io/en/latest/topics/format.html

Podemos consultar más ejemplos de uso de `cloud-init` y directivas en la documentacion oficial de `Vagrant`.

https://developer.hashicorp.com/vagrant/docs/cloud-init/usage

```ruby
config.vm.cloud_init do |cloud_init|
    cloud_init.content_type = "text/cloud-config"
    cloud_init.path = "cloud-init/cloud-config"
end
```

<u>Ansible-local</u>

`Vagrant` nos permite la posibilidad de ejecutar playbooks de `Ansible` llamando los desde el propio fichero `Vagrantfile` con la directiva `ansible_local`, esto nos permite probar dichos playbooks o roles sin necesidad de tener instalado `Ansible` en nuestro `Host`, ya que `Vagrant` lo instalará por nosotros en la MV `guest`.

[Ansible Local - Provisioning | Vagrant | HashiCorp Developer](https://developer.hashicorp.com/vagrant/docs/provisioning/ansible_local)

```ruby
config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "lamp/playbook.yml"
    ansible.config_file = "lamp/ansible.cfg"
end
```

#### Contenido de los `scripts`

Como hemos dicho al principio, ejecutaremos un script `cloud-config` en formato `YAML` que personalizará la imagen en su primero arranque. Éste, simplemente agregará un usuario al sistema llamado `jpaybar`, lo añadirá al fichero `sudoers` y configurará el fichero `authorized_keys` con una clave pública que habremos creado previamente para dicho usuario y que nos permita la conexion a la instancia por `SSH`.

```yaml
#cloud-config
# create additonal user
users:
  - name: jpaybar
    gecos: Juan M. Payan Barea (Ansible User)
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJNMRJJOR+fIWelza0jrFUfReY/89zV7DNqVn+qJOhIRyY0Pg9sEtp6GJ60bzP+4w18g/cUsrVSvyzy9PC4jDCgfZGPd//t37LqyTv2/77O8ZaNxMeIlkPGEd1AZUgzIHIUymHRxaVnW61ayLGuw8pjuATGnriOPZqULrXiZZj5xWBRQfDwW+bb9sWSFku5bxNzcbWGepuQxjxkk6p7mnXk8kWlOw5ZinHA0LSNY0InGdIWLpjq4iEJYGsRezyqfhMdaiHeCYCHZKa0RPzw7AL/OdApFHNAJKGZSD45C+UjJqXX4D/X4OBkcBdzBXPAvQOXu/hKcGngo2XnYRJlP1eg29lCRORo11PXBO3zYeUBPpD5IQ1uQGNtHTW3GyyzgAy16kVTBI4jB7VJHfTg3lNRCzh68W5tLmmi1utnkqAxzn3Ev2NDwEeId9+6ca2+B0HYY0lSG7hJbJ2A0IECRMkZyPk5UWbLs4KJCeZi//RDKwrE6XDSNgWCEPZqSr8ohc= vagrant@masterVM
```

Por último, nuestro `Vagrantfile` ejecutará un playbook de `Ansible` que instalará la tipica pila `LAMP` en una imagen `Box` de `Vagrant` con `Ubuntu Bionic Beaver 18.04`

```bash
vagrant@masterVM:$ tree .
lamp
├── ansible.cfg
├── files
│   ├── apache.conf.j2
│   ├── index.html.j2
│   └── info.php.j2
├── MySQL_8_COMMANDS.txt
├── MySQL_8_REQUIREMENTS.txt
├── playbook.yml
├── README.md
└── vars
    └── default.yml
```

El fichero `Vagrantfile` completo quedaria de la siguiente forma:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
    {
        :name => "custom-bionic64", 
        :eth1 => "192.168.56.30",
        :mem => "1024",
        :cpu => "1",
        :box => "bionic64",
        :sshport => "2230",
        :httpport => "80",
        :group => "/customized"
    }
]

Vagrant.configure(2) do |config|

    if Vagrant.has_plugin?("vagrant-proxyconf")
        config.proxy.http     = "http://10.40.56.3:8080"
        config.proxy.https    = "http://10.40.56.3:8080"
        config.proxy.no_proxy = "localhost,127.0.0.1,192.168.56.0/24"
    end

    if Vagrant.has_plugin?("vagrant-vbguest") then
          config.vbguest.auto_update = false
    end

    # https://github.com/gosuri/vagrant-env
    config.env.enable # vagrant plugin install vagrant-env

    boxes.each do |opts|
        config.ssh.insert_key = false
        config.vm.define opts[:name] do |subconfig|
            subconfig.vm.box = opts[:box]
            subconfig.vm.hostname = opts[:name]
            subconfig.vm.network "private_network", ip: opts[:eth1]
            subconfig.vm.network "forwarded_port", guest: 22, host: opts[:sshport], id: "ssh"
            subconfig.vm.network "forwarded_port", guest: 80, host: opts[:httpport], id: "http"
            subconfig.vm.provider "virtualbox" do |vb|
                vb.customize ["modifyvm", :id, "--name", opts[:name]]
                vb.customize ["modifyvm", :id, "--memory", opts[:mem]]
                vb.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
                vb.customize ["modifyvm", :id, "--groups", opts[:group]]
            end
        end
    end
    # Simplified form
    # subconfig.vm.cloud_init content_type: "text/cloud-config", path: "./cloud-init/cloud-config.yml"

    # Block form
    # https://cloudinit.readthedocs.io/en/latest/topics/examples.html
    # https://developer.hashicorp.com/vagrant/docs/cloud-init
    config.vm.cloud_init do |cloud_init|
        cloud_init.content_type = "text/cloud-config"
        cloud_init.path = "cloud-init/cloud-config"
    end

    # https://developer.hashicorp.com/vagrant/docs/provisioning/ansible
    # https://developer.hashicorp.com/vagrant/docs/provisioning/ansible_common
    config.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "lamp/playbook.yml"
        ansible.config_file = "lamp/ansible.cfg"
    end
end
```

y este será el arbol de directorios de nuestro proyecto:

```bash
vagrant@masterVM:$ tree
.
├── cloud-init
│   └── cloud-config
├── _images
│   ├── apache.PNG
│   ├── conexion.PNG
│   ├── mysql.PNG
│   ├── php.PNG
│   └── usuario.PNG
├── lamp
│   ├── ansible.cfg
│   ├── files
│   │   ├── apache.conf.j2
│   │   ├── index.html.j2
│   │   └── info.php.j2
│   ├── MySQL_8_COMMANDS.txt
│   ├── MySQL_8_REQUIREMENTS.txt
│   ├── playbook.yml
│   ├── README.md
│   └── vars
│       └── default.yml
├── oscdimg
│   ├── x64
│   │   ├── checksums.sha1
│   │   ├── efisys.bin
│   │   ├── efisys_noprompt.bin
│   │   ├── etfsboot.com
│   │   ├── oscdimg.exe
│   │   └── README.txt
│   └── x86
│       ├── checksums.sha1
│       ├── efisys.bin
│       ├── efisys_noprompt.bin
│       ├── etfsboot.com
│       └── oscdimg.exe
├── README.md
└── Vagrantfile
```

###### **NOTA:**

En caso de ejecutar `Vagrant` desde `Windows` es posible que nos pida la instalación de la utilidad `oscdimg` que se encuentra en el kit ADK de Microsoft.

https://learn.microsoft.com/es-es/windows-hardware/get-started/adk-install

En dicho caso, solo hay que copiar el contenido del directorio `oscdimg` (x86 o x64) en la ruta `C:\Windows\System32\`

## Quickstart

```bash
vagrant up
```

#### Comprobamos que el usuario `jpaybar` se ha creado y conecta por `SSH`

![usuario.PNG](https://github.com/jpaybar/Vagrant/blob/main/vagrant_cloud-init_ansible/_images/usuario.PNG)

![conexion.PNG](https://github.com/jpaybar/Vagrant/blob/main/vagrant_cloud-init_ansible/_images/conexion.PNG)

El script `cloud-config` se ha ejecutado correctamente.

#### Comprobamos que el playbook de `Ansible` ha instalado la pila `LAMP`

Accedemos a nuestro servidor apache

http://localhost

Accedemos a MySQL (password `vagrant`)

```bash
mysql -u root -p
```

Detalles de la configuración `PHP`

http://localhost/info.php

![apache.PNG](https://github.com/jpaybar/Vagrant/blob/main/vagrant_cloud-init_ansible/_images/apache.PNG)

![mysql.PNG](https://github.com/jpaybar/Vagrant/blob/main/vagrant_cloud-init_ansible/_images/mysql.PNG)

![php.PNG](https://github.com/jpaybar/Vagrant/blob/main/vagrant_cloud-init_ansible/_images/php.PNG)

Ahora podremos lanzar ambos scripts contra una instancia en la nube que use una imagen de `Ubuntu 18.04 LTS` con seguridad de que funcionarán.

## Author Information

Juan Manuel Payán Barea    (IT Technician) [st4rt.fr0m.scr4tch@gmail.com](mailto:st4rt.fr0m.scr4tch@gmail.com)
[jpaybar (Juan M. Payán Barea) · GitHub](https://github.com/jpaybar)
https://es.linkedin.com/in/juanmanuelpayan
