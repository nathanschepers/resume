#!/bin/bash

# Script to install all dependencies required for the resume project

# Import helpers for colored output
. "$(dirname "$0")"/helpers.sh

coloredEcho "Installing dependencies for the resume project..." blue

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    coloredEcho "This script needs to be run as root or with sudo privileges." red
    exit 1
fi

coloredEcho "Updating package lists..." green
apt-get update

coloredEcho "Installing Ruby and development dependencies..." green
apt-get install -y ruby-full build-essential zlib1g-dev

coloredEcho "Installing wkhtmltopdf for PDF generation..." green
apt-get install -y wkhtmltopdf

coloredEcho "Installing Ghostscript for PDF processing..." green
apt-get install -y ghostscript

coloredEcho "Setting up Ruby gems installation path..." green
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

coloredEcho "Installing Bundler..." green
gem install bundler

coloredEcho "Installing Jekyll and dependencies from Gemfile..." green
cd "$(dirname "$0")"/../src
bundle install

coloredEcho "Making the magick AppImage executable..." green
chmod +x "$(dirname "$0")"/magick

coloredEcho "All dependencies have been installed successfully!" blue
coloredEcho "You can now build the resume using: ./bin/build.sh" green