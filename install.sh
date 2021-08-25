#!/bin/bash

# packages to check for before install
pkg_check=("figlet" "unzip")

# place holder variable
pkg_missing=()

# check for missing packages
for pkg in "${pkg_check[@]}"; do
	dpkg -s "$pkg" &> /dev/null

	if [ $? -eq 1 ]; then
		pkg_missing+=($pkg)
	fi
done

# install the missing packages
if [ ${#pkg_missing[*]} -ne 0 ]; then
     echo "Installing missing packages.."
	sudo apt install -y ${pkg_missing[*]}
fi

echo "Downlading the zip file"
wget https://github.com/Ramos04/MOTD-Scripts/archive/refs/heads/main.zip

echo "Unzipping the file.."
unzip main.zip

echo "Creating backup folder.."
sudo mkdir /etc/update-motd.d/backup

echo "Moving files to backup folder.."
sudo mv /etc/update-motd.d/* /etc/update-motd.d/backup/

echo "Creating tarball.."
sudo tar -C /etc/update-motd.d/ -cvzf /etc/update-motd.d/backup.tgz backup

echo "Removing temp directory.."
sudo rm -rf /etc/update-motd.d/backup/

echo "Copying scripts.."
sudo mv ./MOTD-Scripts-main/scripts/* /etc/update-motd.d/

echo "Copying the figlet font.."
sudo cp ./MOTD-Scripts-main/larry3d.flf /usr/share/figlet
