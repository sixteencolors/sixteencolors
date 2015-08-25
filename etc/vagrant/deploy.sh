#!/bin/bash

apt-get install -y build-essential libarchive-dev libgd-dev git vlc-nox mono-runtime libmono-system-core4.0-cil libmono-system-xaml4.0-cil libmono-system-windows-forms4.0-cil xvfb unzip

wget -q -O - http://install.perlbrew.pl | PERLBREW_ROOT=/var/www/sixteencolors.net/perl5 bash
source /var/www/sixteencolors.net/perl5/etc/bashrc

perlbrew install --notest stable
perlbrew switch `perlbrew list|head -n1`
perlbrew install-cpanm

cd /var/www/sixteencolors.net/app/
cpanm --notest --installdeps .
cpanm --notest Starman

chown -R vagrant:vagrant /var/www/sixteencolors.net/perl5
echo 'source /var/www/sixteencolors.net/perl5/etc/bashrc' >> /home/vagrant/.bash_profile
sudo -i -u vagrant perlbrew switch `sudo -i -u vagrant perlbrew list|head -n1`

if [ ! -f /var/www/sixteencolors.net/app/sixteencolors.db ]; then
  ./bin/deploy_schema.pl
fi

wget -qO- -O tmp.zip http://download.picoe.ca/pablodraw/3.2/PabloDraw.Console-3.2.1.zip && unzip tmp.zip && rm tmp.zip
chmod +x PabloDraw.Console.exe
mv PabloDraw.Console.exe /usr/local/bin

ln -s /var/www/sixteencolors.net/app/t/archive/ /var/www/sixteencolors.net/
./bin/indexer.pl ../archive/

mkdir -p /etc/catalyst/apps-enabled
echo 'export PERLBREW_ROOT=/var/www/sixteencolors.net/perl5' >> /etc/catalyst/envvars
echo 'export PERLBREW_HOME=/home/vagrant/.perlbrew' >> /etc/catalyst/envvars
echo 'source /var/www/sixteencolors.net/perl5/etc/bashrc' >> /etc/catalyst/envvars
ln -s /var/www/sixteencolors.net/app/etc/vagrant/sixteencolors.conf /etc/catalyst/apps-enabled/
wget -q -O /etc/init.d/catalyst https://raw.githubusercontent.com/kassi/catalyst-init/master/etc/init.d/catalyst
chmod +x /etc/init.d/catalyst
update-rc.d catalyst defaults
service catalyst start sixteencolors