namespace :svn do
  
  desc <<-DESC
    Setup SVN
  DESC
  task :setup, :roles => :app do
    upload_keys
    configure_svn_servers
  end
  
  
  desc <<-DESC
    Uploads your local private SVN keys to the server
  DESC
  task :upload_keys, :roles => :app do
    run "mkdir -p ~/.subversion"
    run "chown -R #{user}:#{user} ~/.subversion"
    run "chmod 700 ~/.subversion"

    private_key = svn_options[:keys].collect { |key| File.read("#{key}") }.join("\n")
    put private_key, "./.subversion/client.p12", :mode => 0600
    ca_cert = svn_options[:cert].collect { |cert| File.read("#{cert}") }.join("\n")
    put ca_cert, "./.subversion/ca.pem", :mode => 0600
  end
  
  desc <<-DESC
    Configure SVN servers
  DESC
  task :configure_svn_servers, :roles => :app do
    put render("svn_servers", binding), "svn_servers"
    sudo "mv svn_servers /home/#{user}/.subversion/servers"
  end  
  
end