Vagrant.configure("2") do |config|
  title = 'debian-wine'
  
  config.vm.define :controller do |c|
    c.vm.provider :docker do |d|
      d.name = title+'-controller'
      d.build_dir = 'controller'
    end
    c.vm.provision :ansible, type: :ansible_local do |ansible|
      ansible.install = 'false'
      ansible.verbose = 'v'
      ansible.playbook = 'playbook.yml'
    end
  end

  # config.vm.define :main do |ans|
  #   main.vm.box = "andreazuccherelli/debian-stable"
  #   main.vm.box_architecture = "amd64"
  #   main.vm.hostname = 'debian-wine'

  #   main.vm.provider :libvirt do |libvirt|
  #     libvirt.driver = 'kvm'
  #     libvirt.title = 'debian-wine'
  #     libvirt.memory = 2048
  #     libvirt.cpus = 4
  #   end
  # end
end
