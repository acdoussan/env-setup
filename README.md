# Env Setup Ansible Playbook

This playbook installs and configures most of the software I use for web and software development. Some things in macOS are slightly difficult to automate, so I still have a few manual installation steps, but at least it's all documented here.

## Installation

  1. Ensure Apple's command line tools are installed (`xcode-select --install` to launch the installer).
  2. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html):

     1. Run the following command to add Python 3 to your $PATH: `export PATH="$HOME/Library/Python/3.8/bin:/opt/homebrew/bin:$PATH"`
     2. Upgrade Pip: `sudo pip3 install --upgrade pip`
     3. Install Ansible: `pip3 install ansible`

  3. Generate an ssh key and add it to gitlab
  4. Clone or download this repository to your local drive.
  5. Allow apps from unidentified developers `sudo spctl --master-disable`
     1. This is used to install the solarized terminal theme
  6. Run `ansible-galaxy install -r requirements.yml` inside this directory to install required Ansible roles.
  7. Run `ansible-playbook main.yml --ask-become-pass -i inventory/{desired env}` inside this directory. Enter your account password when prompted for the 'BECOME' password.

> Note: If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run `brew doctor` to see if this is the case.

### Use with a remote Mac

You can use this playbook to manage other Macs as well; the playbook doesn't even need to be run from a Mac at all! If you want to manage a remote Mac, either another Mac on your network, or a hosted Mac like the ones from [MacStadium](https://www.macstadium.com), you just need to make sure you can connect to it with SSH:

  1. (On the Mac you want to connect to:) Go to System Preferences > Sharing.
  2. Enable 'Remote Login'.

> You can also enable remote login on the command line:
>
>     sudo systemsetup -setremotelogin on

Then edit the `inventory` file in this repository and change the line that starts with `127.0.0.1` to:

```
[ip address or hostname of mac]  ansible_user=[mac ssh username]
```

If you need to supply an SSH password (if you don't use SSH keys), make sure to pass the `--ask-pass` parameter to the `ansible-playbook` command.

### Running a specific set of tagged tasks

You can filter which part of the provisioning process to run by specifying a set of tags using `ansible-playbook`'s `--tags` flag. The tags available are `dotfiles`, `homebrew`, `mas`, `extra-packages` and `osx`.

    ansible-playbook main.yml -K --tags "dotfiles,homebrew"

## Future additions

### Things that still need to be done manually

#### Post install on all mac
Rerun playbook until there are no changes

Reboot

Run again - ensure no changes

Reblock unidentified developers System Preferences -> Security & Privacy -> General -> Allow apps to be downloaded from App Store & identified developers

Update terminal default to Solarized-Dark Terminal -> Preferences -> default at bottom with Solarized-Dark selected

add the following to System Preferences -> Security & Privacy -> privacy -> Full Disk Access
- Emacs.app
- /usr/bin/ruby (cmd + shift + g to enter arbitrary path)
- Terminal

Update Finder to show hard drives in the side bar: Finder -> Preferences -> Sidebar -> Hard Disks
Update Finder to show the home directory in the side bar: Finder -> Preferences -> Sidebar -> acdoussan (or other username)

Enable battery percentage in menu bar System Preferences -> Dock & Menu Bar -> Battery -> Show Percentage
System Preferences -> dock & menu bar -> Spotlight -> uncheck show in menu bar

Configure battery settings System Preferences -> Battery
- Battery -> Display off after 15 mins
- Power Adapter -> Display off after 30 mins

Configure screen saver System Preferences -> Desktop & Screen Saver -> Screen Saver -> Show screen saver after 5 minutes

System Preferences -> Siri -> uncheck show siri in menu bar

Open emacs & allow it to install, might take two opens, save created file

Open Stats & disable battery, enable start a login, order in header (right to left) CPU %, GPU %, RAM %, SSD, SSD R/W #s w/ pictogram characters, NET, Network #s w/ pictogram characters


#### Personal post install on mac
set up new wireguard client in router & setup wireguard app

Set up samba network shares
- connect via finder -> go -> connect to server... and browse network for the truenas share
- add login items by going to System Preferences -> Users & Groups -> user -> login items, clicking the +, and selecting all of the folders in the truenas server

## Testing the Playbook

Many people have asked me if I often wipe my entire workstation and start from scratch just to test changes to the playbook. Nope! Instead, I posted instructions for how I build a [Mac OS X VirtualBox VM](https://github.com/geerlingguy/mac-osx-virtualbox-vm), on which I can continually run and re-run this playbook to test changes and make sure things work correctly.

Additionally, this project is [continuously tested on GitHub Actions' macOS infrastructure](https://github.com/geerlingguy/mac-dev-playbook/actions?query=workflow%3ACI).

## Ansible for DevOps

Check out [Ansible for DevOps](https://www.ansiblefordevops.com/), which teaches you how to automate almost anything with Ansible.

## Author

This project was inspired by [Jeff Geerling](https://www.jeffgeerling.com/) (originally inspired by [MWGriffin/ansible-playbooks](https://github.com/MWGriffin/ansible-playbooks)).

Original Repository: https://github.com/geerlingguy/mac-dev-playbook/

## TODO / Known Issues
dockutil adds items too quickly, see if there is an open issue on github for this - workaround, run playbook multiple times until it passes
Ansible says dockutil made some change, but it is not reflected in the dock -> restart laptop
Emacs install needs to happen before dockutil - workaround, run playbook again
May need to set ANSIBLE_EXECUTABLE on systems with locked down sudo access. Ex: `ANSIBLE_EXECUTABLE=/bin/logbash ansible-playbook main.yml --ask-become-pass -i inventory/linux --tags "emacs"`
Nix may have issues with ipv6, can disable it with the following on redhat based systems
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
