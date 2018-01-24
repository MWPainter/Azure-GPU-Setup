#!/bin/bash 

#if [ "$EUID" -ne 0 ]; then
#	echo "Please run as root (with sudo)"
#	exit
#fi

# Make a directory as a workspace
# dirname "$0" gets the directory that this file is in
SETUP_DIR="$( dirname "$0" )"
mkdir -p $SETUP_DIR
cd $SETUP_DIR

# install python libraries
sudo apt-get -y install python-numpy python-dev python-wheel python-mock python-matplotlib python-pip

# Update nvidia drivers to the latest versions
sudo apt-get purge nvidia*
sudo add-apt-repository -y ppa:graphics-drivers
sudo apt-get -y update
sudo apt-get -y install nvidia-390

# install cuda drivers
if [ ! -f "cuda_8.0.61_375.26_linux-run" ]; then 
	wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
fi
chmod +x cuda_8.0.61_375.26_linux-run
sudo sh cuda_8.0.61_375.26_linux-run --silent --verbose --driver

echo "Setup requires a reboot to continue."
echo "The VM will reboot now. Login after it restarts and continue installation from part2."

sudo reboot

