namespace :network do
  _cset :network_interfaces_config do
    abort "Please specify the location of the /etc/network/interfaces config you want to upload.\n For example:\n  set :network_interfaces_config, File.expand_path(File.join(File.dirname(__FILE__),'interfaces'))"
  end
  _cset :resolv_config do
    abort "Please specify the location of the /etc/resolv.conf config you want to upload.\n For example:\n  set :resolv_config, File.expand_path(File.join(File.dirname(__FILE__),'resolv.conf'))"
  end

  desc "Configure /etc/resolv.conf and /etc/network/interfaces"
  task :configure do
    configure_resolv_conf
    configure_network_interfaces
  end

  desc "Configure network interfaces"
  task :configure_network_interfaces do
    put File.read(network_interfaces_config), "interfaces.tmp"
    sudo "mv interfaces.tmp /etc/network/interfaces"
    restart
  end

  desc "Configure /etc/resolv.conf"
  task :configure_resolv_conf do
    put File.read(resolv_config), "resolv.conf.tmp"
    sudo "mv resolv.conf.tmp /etc/resolv.conf"
  end

  desc "Start the network"
  task :start do
    sudo "/etc/init.d/networking start"
  end

  desc "Restart the network"
  task :restart do
    sudo "/etc/init.d/networking restart"
  end

  desc "Stop the network"
  task :stop do
    sudo "/etc/init.d/networking stop"
  end
end
