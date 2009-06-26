namespace :mediamountain do
  namespace :dirmon do
    desc 'Installs the dirmon script in ~/bin and adds it to the crontab'
    task :install, :roles => :app do
      install_script
      add_to_cron
    end

    desc 'Installs the dirmon script in ~/bin'
    task :install_script, :roles => :app do
      put render("dirmon", binding), "bin/dirmon"
      run "chmod +x bin/dirmon"
    end

    desc 'adds the dirmon calls to the crontab'
    task :add_to_cron, :roles => :app do
       add_to_cron('/home/yoadmin/bin/dirmon ~mediama/ftp 1 rm','0,15,30,45 * * * *')
       add_to_cron('/home/yoadmin/bin/dirmon ~mediamb/ftp 1 rm','5,20,35,50 * * * *')
       add_to_cron('/home/yoadmin/bin/dirmon ~mediamc/ftp 1 rm','10,25,40,55 * * * *')
    end
  end
end