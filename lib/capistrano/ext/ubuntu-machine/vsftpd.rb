namespace :vsftpd do
  set :vsftpd_user_shell, '/usr/sbin/nologin'
  set :vsftpd_group, 'ftpusers'
  _cset :vsftpd_users { abort "Please specify the VSFTPd users:\n  set :vsftpd_users, ['user1', 'user2']" }

  desc "Install VSFTPd"
  task :install do
    sudo "aptitude install -y vsftpd"
    configure
    add_nologin_shell
    create_group
    add_user_to_group
    create_users
  end

  desc "Install VSFTPd configuration file"
  task :configure do
    # TODO: Don't use a template for the config, or append it to the existing config.
    # TODO: Other solution could be to allow setting a local config file which will be uploaded.
    put render("vsftpd.conf", binding), "vsftpd.conf"
    sudo "mv vsftpd.conf /etc/vsftpd.conf"
    restart
  end

  desc "Add the :vsftpd_user_shell to /etc/shells"
  task :add_nologin_shell do
    puts "If this fails, then the '#{vsftpd_user_shell}'-shell is already in /etc/shells"
    run "test -z `grep #{vsftpd_user_shell} /etc/shells`"
    run "cp /etc/shells ~/shells.tmp"
    run "echo '#{vsftpd_user_shell}' >> ~/shells.tmp"
    sudo "mv ~/shells.tmp /etc/shells"
  end

  desc "Create VSFTPd-only users"
  task :create_users do
    vsftpd_users.each do |user_to_create|
      sudo "useradd --shell #{vsftpd_user_shell} --groups #{vsftpd_group} -m #{user_to_create}"
      puts "Changing password for #{user_to_create}:"
      sudo_and_watch_prompt("passwd #{user_to_create}", [/Enter new UNIX password/, /Retype new UNIX password:/, /\[\]\:/, /\[y\/N\]/i])
    end
  end

  desc "Create VSFTPd group"
  task :create_group do
    sudo "groupadd -f #{vsftpd_group}"
  end

  desc "Adds current user to VSFTPd group"
  task :add_user_to_group do
    sudo "usermod -a -G #{vsftpd_group} #{user}"
  end

  desc "Start the vsftpd server"
  task :start do
    sudo "/etc/init.d/vsftpd start"
  end

  desc "Restart the vsftpd server"
  task :restart do
    sudo "/etc/init.d/vsftpd restart"
  end

  desc "Stop the vsftpd server"
  task :stop do
    sudo "/etc/init.d/vsftpd stop"
  end
end
