require 'yaml'
namespace :ntp do
  set :ntp_default_ntpd_opts, "NTPD_OPTS='-g'"
  set :ntp_pool_servers, (0..2).map {|num| "#{num}.pool.ntp.org"}

  desc "Install NTP"
  task :install do
    sudo "aptitude install -y ntp"
    configure
  end

  desc "Configure NTP"
  task :configure do
    put render("ntpdate", binding), "ntpdate.tmp"
    sudo "mv ntpdate.tmp /etc/default/ntpdate"
    put render("ntp.conf", binding), "ntp.conf.tmp"
    sudo "mv ntp.conf.tmp /etc/ntp.conf"
    run "echo '#{ntp_default_ntpd_opts}' > ntp.tmp"
    sudo "mv ntp.tmp /etc/default/ntp"
    restart
  end

  desc "Start the NTP server"
  task :start do
    sudo "/etc/init.d/ntp start"
  end

  desc "Restart the NTP server"
  task :restart do
    sudo "/etc/init.d/ntp restart"
  end

  desc "Stop the NTP server"
  task :stop do
    sudo "/etc/init.d/ntp stop"
  end
end