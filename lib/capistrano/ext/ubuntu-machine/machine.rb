namespace :machine do

  desc "Change the root password, create a new user and allow him to sudo and to SSH"
  task :initial_setup do
    set :user_to_create , user
    set :user, 'root'
    
    run_and_watch_prompt("passwd", [/Enter new UNIX password/, /Retype new UNIX password:/])
    
    run_and_watch_prompt("adduser #{user_to_create}", [/Enter new UNIX password/, /Retype new UNIX password:/, /\[\]\:/, /\[y\/N\]/i])
    
    # force the non-interactive mode
    add_to_file('/etc/environment','DEBIAN_FRONTEND=noninteractive')
    # prevent this env variable to be skipped by sudo
    sudoers_lines = ['Defaults env_keep = "DEBIAN_FRONTEND"']
    sudoers_lines << "#{user_to_create} ALL=(ALL)ALL"
    add_to_file('/etc/sudoers',sudoers_lines)

    add_to_file('/etc/ssh/sshd_config',"AllowUsers #{user_to_create}")
    run "/etc/init.d/ssh reload"
  end
  
  task :configure do
    ssh.setup
    iptables.configure
    aptitude.setup
  end
  
  task :install_dev_tools do
    _cset :default_to_ruby_enterprise, true

    mysql.install
    apache.install
    ruby.install
    postfix.install
    gems.install_rubygems
    gems.add_nodocs_to_gemrc
    ruby.install_enterprise
    ruby.make_enterprise_default if default_to_ruby_enterprise
    ruby.install_passenger
    git.install
    php.install
  end
  
  desc = "Ask for a user and change his password"
  task :change_password do
    user_to_update = Capistrano::CLI.ui.ask("Name of the user whose you want to update the password : ")
    
    run_and_watch_prompt("passwd #{user_to_update}", [/Enter new UNIX password/, /Retype new UNIX password:/])
  end
end
