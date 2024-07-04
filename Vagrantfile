Vagrant.configure("2") do |config|
  config.vm.box = "andreazuccherelli/debian-stable"
  config.vm.box_architecture = "amd64"
  config.vm.hostname = 'debian-steam'
  current_dir = Dir.getwd

  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = 'kvm'
    libvirt.title = 'debian-steam'
    libvirt.memory = 2048
    libvirt.cpus = 4
  end
end
