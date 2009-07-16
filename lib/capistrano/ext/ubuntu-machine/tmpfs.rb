namespace :tmpfs do
  _cset(:tmpfs_directories) do
    abort "Please specify the tmpfs directories:\n  set :tmpfs_directories do\n{\n'/tmpfs' => {:size => '2G', :mode => '0744'},\n}\nend"
  end

  desc "Create tmpfs directories"
  task :create_directories, :roles => :app do
    tmpfs_directories.each do |dir,options|
      options[:size] ||= '2G'
      options[:mode] ||= '0744'
      sudo "mkdir -p #{dir}"
      fstab_line = "tmpfs #{dir} tmpfs size=#{options[:size]},mode=#{options[:mode]} 0 0"
      sudo_add_to_file('/etc/fstab',fstab_line)
      sudo "mount #{dir}"
    end
  end

  desc "Create ftp directories within :vsftpd_tmpfs_directory for each user defined in :vsftpd_users and symlink in their homedirs"
  task :create_vsftpd_tmpfs_dirs, :roles => :app do
    cron_commands = []
    vsftpd_users.each do |target_user|
      target_tmpfs_dir = File.join(vsftpd_tmpfs_directory,target_user)
      target_ftp_dir = File.join('/home',target_user,'ftp')
      cmds = []
      cmds << "mkdir -p #{target_tmpfs_dir}"
      cmds << "chown #{target_user}:#{vsftpd_group} #{target_tmpfs_dir}"
      cmds << "chmod 0777 #{target_tmpfs_dir}"
      cmds.each{|cmd| sudo cmd}
      cron_commands << cmds.join(' && ')
      sudo_add_to_file('/etc/fstab',"#{target_tmpfs_dir} #{target_ftp_dir} none rw,bind,noauto,noatime 0 0")
      sudo "mkdir -p #{target_ftp_dir} && sudo chown 0777 #{target_ftp_dir} && sudo chown #{target_user}:#{vsftpd_group} #{target_ftp_dir}"
      sudo cmd = "mount #{target_ftp_dir}"
      cron_commands << cmd
    end
    sudo_add_to_crontab(cron_commands.flatten.compact,'@reboot')
  end
end