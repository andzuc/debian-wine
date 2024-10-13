Vagrant.configure("2") do |config|
  title = 'debian-wine'

  config.vm.define :controller do |c|
    c.vm.provider :docker do |d|
      d.name = title+'-controller'
      d.image = 'ghcr.io/andzuc/ansible-ee:3.20.20241001.11'
      d.has_ssh = true
      d.compose = true
      d.compose_configuration = {
        "version" => "3.4",
        "services" => {
          "controller" => {
            "container_name" => d.name,
            "networks" => {
              "extnet" => {
              },
              "intnet" => {
                "ipv4_address" => "172.20.1.254"
              }
            }
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
    
    c.vm.provision :ansible, type: :ansible_local do |ansible|
      ansible.install = 'false'
      ansible.verbose = 'v'
      ansible.playbook = 'playbook.yml'
    end
  end
    
  config.vm.define :main do |main|
    main.vm.box = "andreazuccherelli/debian-stable"
    main.vm.box_architecture = "amd64"
    main.vm.hostname = title
    main.vm.network :public_network,
                    :ip => "172.20.1.2",
                    :netmask => "255.255.255.0",
                    :dev => "intnet",
                    :mode => "bridge",
                    :type => "bridge"
    main.vm.provider :libvirt do |libvirt|
      libvirt.driver = 'kvm'
      libvirt.title = 'debian-wine'
      libvirt.memory = 2048
      libvirt.cpus = 4
    end
  end
end
