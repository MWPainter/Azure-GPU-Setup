#!/bin/bash 

#if [ "$EUID" -ne 0 ]; then 
#	echo "Please run as root (use sudo)"
#	exit
#fi

SETUP_DIR="$( dirname "$0" )"
if [ ! -d $SETUP_DIR ]; then
	echo "Setup directory not found. Did you run part 1?"
	exit
fi
cd $SETUP_DIR

# install cudnn
SETUP_ABS_DIR=`realpath $SETUP_DIR` 
if [ ! -f "cudnn-8.0-linux-x64-v6.0.tgz" ]; then
    echo "You need to download cudnn-6.0 manually this can be downloaded from https://developer.nvidia.com/compute/machine-learning/cudnn/secure/v6/prod/8.0_20170307/cudnn-8.0-linux-x64-v6.0-tgz you will need to create a NVIDIA Account! Specifically, place it at: $SETUP_ABS_DIR/cudnn-8.0-linux-x64-v6.0.tgz"
    exit
fi

echo "Installing CUDA toolkit and samples"
# install cuda toolkit
if [ ! -f "cuda_8.0.61_375.26_linux-run" ]; then
	echo "CUDA installation file not found. Did you run part 1?"
	exit
fi
sudo sh cuda_8.0.61_375.26_linux-run --silent --verbose --driver --toolkit

echo "Uncompressing cudnn"
tar xzvf cudnn-8.0-linux-x64-v6.0.tgz
sudo cp -P cuda/include/cudnn.h /usr/local/cuda/include/
sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# update bashrc
echo "Updating bashrc"
echo >> $HOME/.bashrc '
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
'

source $HOME/.bashrc

# create bash_profie
echo "Creating bash_profile"
echo > $HOME/.bash_profile '
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
'

# other Tensorflow dependencies
sudo apt-get -y install libcupti-dev

# upgrade pip
sudo pip install --upgrade pip

# install tensorflow 1.0
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.4.1-cp27-none-linux_x86_64.whl

sudo pip install --upgrade $TF_BINARY_URL

# Update nvidia drivers to the latest versions
sudo apt-get purge nvidia*
sudo add-apt-repository -y ppa:graphics-drivers
sudo apt-get -y update
sudo apt-get -y install nvidia-390

echo "Script done"

# Nvidia drivers also need restarting to run
sudo reboot

