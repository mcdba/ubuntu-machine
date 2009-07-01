namespace :monit do
  desc "Installs monit and uploads the config files"
  task :install do
    sudo "aptitude install -y monit"
    enable
    update_generic_configs
    update_monitd_configs
  end

  desc "Uploads the generic monit config files and restarts the daemon"
  task :update_generic_configs do
    _cset(:monit_mail_password) {Capistrano::CLI.ui.ask("Monit mail password: ")}
    put render("monitrc", binding), "monitrc.tmp"
    sudo "mv monitrc.tmp /etc/monit/monitrc"
    sudo "chown root:root /etc/monit/monitrc"
    put render("monit_main.conf", binding), "monit_main.conf.tmp"
    sudo "mkdir -p /etc/monit.d"
    sudo "mv monit_main.conf.tmp /etc/monit.d/main.conf"
    restart
  end

  desc "Uploads the monit.d config files in config/monit.d for all the services and restarts the daemon"
  task :update_monitd_configs do
    _cset(:monitd_configs_path) {File.expand_path('config/monit.d')}
    monitd_configs = Dir.glob(File.join(monitd_configs_path,'*.conf'))
    run "mkdir -p monit.d"
    monitd_configs.each do |monitd_config|
      upload(monitd_config, 'monit.d/', :via => :scp, :recursive => false)
    end
    sudo "mkdir -p /etc/monit.d"
    sudo "mv monit.d/*.conf /etc/monit.d/"
    restart
  end

  desc "Enable monit by setting startup=1 in /etc/default/monit"
  task :enable do
    sudo_add_to_file('/etc/default/monit',['startup=1','CHECK_INTERVALS=10'])
  end

  desc "Start Monit"
  task :start do
    sudo "/etc/init.d/monit start"
  end

  desc "Restart Monit"
  task :restart do
    sudo "/etc/init.d/monit restart"
  end

  desc "Stop Monit"
  task :stop do
    sudo "/etc/init.d/monit stop"
  end
end