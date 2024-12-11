title = 'debian-wine'

machines = {
  "controller" => {
    "name" => "controller" ,
    "ip" => "172.20.1.254",
    "netmask" => "255.255.255.0"
  },
  "main" => {
    "name" => "main" ,
    "ip" => "172.20.1.2",
    "netmask" => "255.255.255.0"
  }
}

Vagrant.configure("2") do |config|
  config.vm.define :controller do |c|
    c.vm.synced_folder '.', '/vagrant', disabled: false

    c.vm.provider :docker do |d|
      machine = machines["controller"]
      d.image = 'ghcr.io/andzuc/ansible-ee:3.20.20241001.11'
      d.name = machine["name"]
      d.has_ssh = true
      d.compose = true
      d.compose_configuration = {
        "version" => "3.4",
        "services" => {
          machine["name"] => {
            "container_name" => d.name,
            "networks" => {
              "extnet" => {
              },
              "intnet" => {
                "ipv4_address" => machine["ip"]
              }
            },
            "extra_hosts" => [
              "main=#{machines["main"]["ip"]}"
            ]
          }
        },
        "networks" => {
          "extnet" => {
            "driver" => "bridge"
          },
          "intnet" => {
            "driver" => "bridge",
            "driver_opts" => {
              "com.docker.network.bridge.name" => "intnet"
            },
            "ipam" => {
              "config" => [
                {
                  "subnet" => "172.20.1.0/24"
                }
              ]
            }
          }
        }
      }
    end
    
    # c.vm.provision :ansible, type: :ansible_local do |ansible|
    #   ansible.compatibility_mode = "2.0"
    #   ansible.install = 'false'
    #   ansible.verbose = 'v'
    #   ansible.limit = "all"
    #   ansible.playbook = "provisioning/playbook.yml"
    #   ansible.inventory_path= 'provisioning/inventory/vagrant'
    # end
    c.vm.provision :shell,
                   :name => "ANSIBLE provisioner",
                   :privileged => false,
                   :inline => "source ansible-ee/bin/activate && cd /vagrant/ansible && ANSIBLE_CONFIG=config/vagrant/ansible.cfg bin/provision #{ENV['ANSIBLE_ARGS']}"
  end
    
  config.vm.define :main do |main|
    machine = machines["main"]
    main.vm.box = "andreazuccherelli/debian-stable"
    main.vm.box_architecture = "amd64"
    main.vm.hostname = machine["ame"]
    main.vm.synced_folder '.', '/vagrant', disabled: true
    main.vm.network :public_network,
                    :ip => machine["ip"],
                    :netmask => machine["netmask"],
                    :dev => "intnet",
                    :mode => "bridge",
                    :type => "bridge"

    main.vm.provider :libvirt do |libvirt|
      libvirt.driver = 'kvm'
      libvirt.title = title
      libvirt.memory = 2048
      libvirt.cpus = 4
      libvirt.graphics_type = 'spice'
      libvirt.video_type = 'qxl'
      libvirt.channel :type => 'unix', :target_name => 'org.qemu.guest_agent.0', :target_type => 'virtio'
      libvirt.channel :type => 'spicevmc', :target_name => 'com.redhat.spice.0', :target_type => 'virtio'
    end
  end
end
