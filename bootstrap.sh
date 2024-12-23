#!/usr/bin/env bash


#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
# This script is intended to be run like this:
#
#   curl https://raw.githubusercontent.com/cryptopool-builders/Multi-Pool-Installer/master/bootstrap.sh | bash
#
#########################################################
if [ -z "${TAG}" ]; then
	TAG="v2.62"
fi


# Clone the MultiPool repository if it doesn't exist.
if [ ! -d $HOME/multipool ]; then
	if [ ! -f /usr/bin/git ]; then
		echo Installing git . . .
		apt-get -q -q update
		DEBIAN_FRONTEND=noninteractive apt-get -q -q install -y git < /dev/null
		echo
	fi
    echo Creating the MultiPool directory. . .
	mkdir -p $HOME/multipool
	mkdir -p $HOME/multipool/install
	echo Downloading MultiPool Installer ${TAG}. . .
	git clone https://github.com/Casraw/multipool_setup.git "$HOME"/multipool/install
	cd $HOME/multipool/install
	git checkout tags/${TAG}
    cd -
	echo
fi

# Set permission and change directory to it.
cd $HOME/multipool/install

# Update it.
sudo chown -R $USER $HOME/multipool/install/.git/
if [ "${TAG}" != `git describe --tags` ]; then
	echo Updating MultiPool Installer to ${TAG} . . .
	git fetch --depth 1 --force --prune origin tag ${TAG}
	if ! git checkout -q ${TAG}; then
		echo "Update failed. Did you modify something in `pwd`?"
		exit
	fi
	echo
fi

# Start setup script.
bash $HOME/multipool/install/start.sh
