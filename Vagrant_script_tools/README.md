# Vagrant_script_tools

The `Vagrant_script_tools` folder is a set of scripts written in `Bash` and `PowerShell` to be run on both `Linux` and `Windows` OS.

There are two Bash scripts `common_vagrant_box_setup.sh` and `install_guest_additions.sh`, to be executed from a VirtualBox VM (with Linux Ubuntu/Debian systems) to fulfill the configuration requirements necessary to pack a Vagrant Box according to the official documentation :

[Creating a Base Box | Vagrant by HashiCorp](https://www.vagrantup.com/docs/boxes/base)

##### VM scripts:

- common_vagrant_box_setup.sh

- install_guest_additions.sh

The other scripts will be executed from the Host machine later (Linux/Windows), in order to create our Vagrant Box from the previously configured VirtualBox VM, which we can create with `Add_VirtualBoxVM_CLI.sh` / `Add_VirtualBoxVM_CLI.ps1` using the VirtualBox command line:

[Creating a Base Box | Vagrant by HashiCorp](https://www.vagrantup.com/docs/cli)

[Oracle VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/6.0/user/vboxmanage-intro.html)

##### Host scripts:

`Windows:`

- create_Vagrantfile.ps1                                                                

- create_info_json.ps1                                                                  

- create_vagrant_box.ps1                                                                 

- create_metadata_json.ps1                                                              

- add_vagrant_box.ps1

- main.ps1

`Linux:`

- create_Vagrantfile.sh

- create_info_json.sh

- create_vagrant_box.sh

- create_metadata_json.sh

- add_vagrant_box.sh

- main.sh

You can run each script one by one, but to simplify the process and create all the necessary files at once run `main.sh/main.ps1` depending on the system of the Host machine.

##### VirtualBox scripts:

These scripts create a VirtualBox VM from the command line and boot it up for the installation process to begin.

`Windows:`

- Add_VirtualBoxVM_CLI.ps1

`Linux:`

- Add_VirtualBoxVM_CLI.sh

## Author Information

Juan Manuel Payán Barea    (IT Technician)    st4rt.fr0m.scr4tch@gmail.com
https://github.com/jpaybar
https://es.linkedin.com/in/juanmanuelpayan
