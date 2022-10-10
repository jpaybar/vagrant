## How to create a Vagrant Box from scratch (VirtualBox)

This is a brief guide on `how to create a Vagrant Box from a VirtualBox VM`. For this, we will follow the official documentation of `Oracle VirtualBox` and `HashiCorp Vagrant`:

[Creating a Base Box | Vagrant by HashiCorp](https://www.vagrantup.com/docs/boxes/base)

[Managing Oracle VM VirtualBox from the Command Line](https://www.oracle.com/technical-resources/articles/it-infrastructure/admin-manage-vbox-cli.html)

All the scripts mentioned below can be downloaded and modified at your convenience from the following repository:

[GitHub - jpaybar/Vagrant: About Vagrant](https://github.com/jpaybar/Vagrant)

## Creating the VirtualBox VM:

##### Disk Space

When creating a base box, make sure the user will have enough disk space to do interesting things, without being annoying. For example, in VirtualBox, you should create a dynamically resizing drive with a large maximum size.

##### Memory

Like disk space, finding the right balance of the default amount of memory is important. For most providers, the user can modify the memory with the Vagrantfile, so do not use too much by default. It would be a poor user experience (and mildly shocking) if a `vagrant up` from a base box instantly required many gigabytes of RAM. Instead, choose a value such as 512MB, which is usually enough to play around and do interesting things with a Vagrant machine, but can easily be increased when needed.

##### Peripherals (Audio, USB, etc.)

Disable any non-necessary hardware in a base box such as audio and USB controllers. These are generally unnecessary for Vagrant usage and, again, can be easily added via the Vagrantfile in most cases.

##### Virtual Machine

The virtual machine created in VirtualBox can use any configuration you would like, but Vagrant has some hard requirements:

- The first network interface (adapter 1) *must* be a NAT adapter. Vagrant uses this to connect the first time.

- A "port forwarding" rule must be added to the network card.

- [x] Name: ssh

- [x] Protocol: TCP

- [x] Host IP: 127.0.0.1

- [x] Host Port: 2222

- [x] Guest IP: leave this field blank

- [x] Guest Port: 22

##### OS Installation

We will do a minimal installation using the `Ubuntu 20.4 (Focal Fossa) LTS` installation disk `mini.iso`. The installation will be quick, we enter the `install option` and start with the installation. We select the `Language, Location and Keyboard`, later we are asked for the `name for the machine`. The next step will be to choose the `replicas for our repositories` and configure the `proxy if we are in a corporate network`.

We enter the `username` and `password`, they should be `vagrant / vagrant` and confirm that we want to use a weak password.

We select the location of the `time zone`.
The next step is partitioning, it is convenient to choose LVM instead of traditional partitioning, due to the future options that working with logical volumes can offer us. `We partition the entire drive and save the LVM changes`.

And with all this, the installation of the base system begins. When `choosing the programs to install`, we select `OpenSSH Server`.

Finally, we `install the GRUB bootloader`, we `choose the UTC clock` and the `installation will have finished` asking us to remove the installation CD.

##### **NOTE:**

The process of creating the VM can be done with the script called `Add_VirtualBoxVM_CLI.ps1/Add_VirtualBoxVM_CLI.sh` (depending on the OS where you have VirtualBox installed), which will download the iso image if we don't have it, create the virtual machine in VirtualBox with the necessary features and start the installation process.

You will see a screen similar to this:

![Add_VirtualBoxVM_CLI.ps1.PNG](https://github.com/jpaybar/Vagrant/blob/main/How_to_create_a_Vagrant_Box_from_scratch_(VirtualBox)/images/Add_VirtualBoxVM_CLI.ps1.PNG)

Installation is finished:

![installation_completed.PNG](https://github.com/jpaybar/Vagrant/blob/main/How_to_create_a_Vagrant_Box_from_scratch_(VirtualBox)/images/installation_completed.PNG)

## Configuring the VM to create the Vagrant Box:

Once we have installed the operating system, the next step will be to make the corresponding changes to meet the requirements when creating our Vagrant Box.

##### Default User Settings

Just about every aspect of Vagrant can be modified. However, Vagrant does expect some defaults which will cause your base box to "just work" out of the box. You should create these as defaults if you intend to publicly distribute your box.

##### "vagrant" User

By default, Vagrant expects a "vagrant" user to SSH into the machine as. This user should be setup with the [insecure keypair](https://github.com/hashicorp/vagrant/tree/main/keys) that Vagrant uses as a default to attempt to SSH. Also, even though Vagrant uses key-based authentication by default, it is a general convention to set the password for the "vagrant" user to "vagrant". This lets people login as that user manually if they need to.

To configure SSH access with the insecure keypair, place the public key into the `~/.ssh/authorized_keys` file for the "vagrant" user. Note that OpenSSH is very picky about file permissions. Therefore, make sure that `~/.ssh` has `0700` permissions and the authorized keys file has `0600` permissions.

When Vagrant boots a box and detects the insecure keypair, it will automatically replace it with a randomly generated keypair for additional security while the box is running.

##### Root Password: "vagrant"

Vagrant does not actually use or expect any root password. However, having a generally well known root password makes it easier for the general public to modify the machine if needed.

Publicly available base boxes usually use a root password of "vagrant" to keep things easy.

##### Password-less Sudo

This is **important!**. Many aspects of Vagrant expect the default SSH user to have passwordless sudo configured. This lets Vagrant configure networks, mount synced folders, install software, and more.

To begin, some minimal installations of operating systems do not even include `sudo` by default. Verify that you install `sudo` in some way.

After installing sudo, configure it (usually using `visudo`) to allow passwordless sudo for the "vagrant" user. This can be done with the following line at the end of the configuration file:

```bash
vagrant ALL=(ALL) NOPASSWD: ALL
```

##### "/vagrant" directory

We will create the `/vagrant` directory whose owner will be the vagrant user and vagrant group with permissions 777. In this directory we will synchronize the folders of our Host computer which we can configure in the `Vagrantfile` file.

```bash
sudo mkdir /vagrant
```

```bash
sudo chown vagrant:vagrant /vagrant
```

```bash
sudo chmod 777 /vagrant
```

##### VirtualBox Guest Additions

[VirtualBox Guest Additions](https://www.virtualbox.org/manual/ch04.html) must be installed so that things such as shared folders can function. Installing guest additions also usually improves performance since the guest OS can make some optimizations by knowing it is running within VirtualBox.

Before installing the guest additions, you will need the Linux kernel headers and the basic developer tools. On Ubuntu, you can easily install these like so:

```bash
sudo apt-get install linux-headers-$(uname -r) build-essential dkms
```

##### To install via the command line:

You can find the appropriate guest additions version to match your VirtualBox version by selecting the appropriate version [here](http://download.virtualbox.org/virtualbox/). The examples below use 4.3.8, which was the latest VirtualBox version at the time of writing.

```bash
wget http://download.virtualbox.org/virtualbox/4.3.8/VBoxGuestAdditions_4.3.8.iso
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_4.3.8.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm VBoxGuestAdditions_4.3.8.iso
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions
```

##### **NOTE:**

We can automate this whole process using the scripts `common_vagrant_box_setup.sh` and `install_guest_additions.sh`.

You can connect to the virtual machine from a console by running the following command:

```bash
ssh vagrant@127.0.0.1 -p 2222
```

![conexion_ssh.PNG](https://github.com/jpaybar/Vagrant/blob/main/How_to_create_a_Vagrant_Box_from_scratch_(VirtualBox)/images/conexion_ssh.PNG)

```bash
wget https://raw.githubusercontent.com/jpaybar/Vagrant/main/Vagrant_script_tools/linux/scripts/common_vagrant_box_setup.sh
wget https://raw.githubusercontent.com/jpaybar/Vagrant/main/Vagrant_script_tools/linux/scripts/install_guest_additions.sh
```

After logging in via ssh, we download the scripts and give them execution permissions (to run the scripts you need to be the "root" user, since one of the steps is to change the superuser password).

```bash
chmod +x common_vagrant_box_setup.sh install_guest_additions.sh
```

You will see a screen similar to this once the scripts run:

![running_common_vagrant_box_setup.sh.PNG](https://github.com/jpaybar/Vagrant/blob/main/How_to_create_a_Vagrant_Box_from_scratch_(VirtualBox)/images/running_common_vagrant_box_setup.sh.PNG)

## The VM is ready to be packaged and create our Vagrant Box:

##### Packaging the Box

Vagrant includes a simple way to package VirtualBox base boxes. Once you've installed all the software you want to install, you can run this command:

```bash
vagrant package --base my-virtual-machine
```

##### Raw Contents

This section documents the actual raw contents of the box file. This is not as useful when creating a base box but can be useful in debugging issues if necessary.

A VirtualBox base box is an archive of the resulting files of [exporting](https://www.virtualbox.org/manual/ch08.html#vboxmanage-export) a VirtualBox virtual machine. Here is an example of what is contained in such a box:

```bash
$ tree
.
|-- Vagrantfile
|-- box-disk1.vmdk
|-- box.ovf
|-- metadata.json

0 directories, 4 files
```

At this point, we could execute the following command and generate our Vagrant Box:

```bash
vagrant package --base ubuntu2004 --output ubuntu2004.box
```

Where the `--base` parameter would be the name or UID of our VM in VirtualBox and `--output` the Vagrant Box output file.

The Vagrant Box is a compressed file that contains a series of default archives as shown in the result of the tree command above. We can customize these to modify our Box and maintain a series of relevant data, such as the version, author, general information and the configuration of the public and private keys, etc...

For this, I have developed a series of scripts (`Vagrant_script_tools`) that generate the necessary files to customize and package our Vagrant Box (`Windows / Linux`):

- create_Vagrantfile.ps1 / create_Vagrantfile.sh

- create_info_json.ps1 / create_info_json.sh

- create_vagrant_box.ps1 / create_vagrant_box.sh

- create_metadata_json.ps1 / create_metadata_json.sh

- add_vagrant_box.ps1 / create_metadata_json.sh

- main.ps1 / main.sh

##### **NOTE:**

You can run each script one by one, but to simplify the process and create all the necessary files at once run `main.sh/main.ps1` depending on the system of the Host machine.

Once you have run `main.ps1 / main.sh` from the `scripts` directory, the following files will be created in the `boxes` directory:

```powershell
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----        10/10/2022      9:48            117 info.json
-a----        10/10/2022      9:51      903843593 ubuntu2004-version_1.0.box
-a----        10/10/2022      9:51            524 ubuntu2004-version_1.0.json
-a----        10/10/2022      9:47            547 ubuntu2004-version_1.0.Vagrantfile
```

The content of our Vagrant Box will be the following:

```bash
$ tree
.
├── box-disk001.vmdk
├── box.ovf
├── include
│   └── _Vagrantfile
├── info.json
├── metadata.json
└── Vagrantfile
```

When executing the following command to list our Boxes we observe the output of the info.json file:

```bash
vagrant box list -i
```

```bash
rockylinux85                           (virtualbox, 0)
ubuntu1804                             (virtualbox, 0)
ubuntu2004                             (virtualbox, 0)
ubuntu2004                             (virtualbox, 1.0)
  - author: jpaybar
  - homepage: https://github.com/jpaybar
  - mail: st4rt.fr0m.scr4tch@gmail.com
ubuntu2204                             (virtualbox, 0)
```

You can download and see what each one does from the following repository:

[GitHub - jpaybar/Vagrant: About Vagrant](https://github.com/jpaybar/Vagrant)

## Author Information

Juan Manuel Payán Barea    (IT Technician)    [st4rt.fr0m.scr4tch@gmail.com](mailto:st4rt.fr0m.scr4tch@gmail.com) [jpaybar (Juan M. Payán Barea) · GitHub](https://github.com/jpaybar) https://es.linkedin.com/in/juanmanuelpayan
