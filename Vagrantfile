Vagrant::Config.run do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "mongo"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://box.ignition.hk/mongo.box"
  
  # Assign this VM to a host only network IP, allowing you to access it
  # via the IP.
  # config.vm.network :hostonly, "33.33.33.10"
  # config.vm.share_folder "v-root", "/vagrant", ".", :nfs => true

  # Forward a port from the guest to the host, which allows for outside
  # computers to access the VM, whereas host only networking does not.
  config.vm.forward_port 27017, 27017
  config.vm.forward_port 28017, 28017
  config.vm.forward_port 6379, 6379  
  config.vm.forward_port 11211, 11211
  
  # config.vm.boot_mode = :gui
  config.ssh.max_tries = 30
    
  # customzie VM
  config.vm.customize [
    "modifyvm", :id,
    "--memory", "384"
  ]
end
