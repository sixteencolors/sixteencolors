Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # VM specs
  config.vm.hostname = "sixteencolors-dev"
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--ioapic", "on"]
    v.customize ["modifyvm", :id, "--memory", "2048"]
    v.customize ["modifyvm", :id, "--cpus", "1"]
    v.customize ["modifyvm", :id, "--iocache", "on"]
  end

  # Forward localhost:1337 to catalyst app
  config.vm.network :forwarded_port, guest: 5000, host: 1337

  # App source
  config.vm.synced_folder ".", "/var/www/sixteencolors.net/app"

  # Ensure apt is up-to-date
  config.vm.provision :shell, :inline => 'apt-get update'

  # Deploy 16c
  config.vm.provision :shell, :path => 'etc/vagrant/deploy.sh'
end
