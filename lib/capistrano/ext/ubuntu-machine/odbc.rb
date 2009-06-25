namespace :odbc do
  _cset(:odbc_sourcename)  { abort "Please specify the odbc sourcename:\n  set :odbc_sourcename, 'MyFirstSQLServer'" }
  _cset(:odbc_database)    { abort "Please specify the odbc database:\n  set :odbc_database, 'MyDB'" }
  _cset(:odbc_host)        { abort "Please specify the odbc host:\n  set :odbc_host, '127.0.0.1'" }
  _cset :odbc_port,       '1433'

  desc "Install ODBC/FreeTDS"
  task :install, :roles => :app do
    profile_lines = ["export ODBCINI=/etc/odbc.ini",
      "export ODBCSYSINI=/etc",
      "export FREETDSCONF=/etc/freetds/freetds.conf"]
    sudo_add_to_file('/etc/profile',profile_lines)

    freetds = "freetds-0.82"
    sudo "sudo apt-get install unixodbc unixodbc-dev tdsodbc -y"
    run "wget -nv ftp://ftp.ibiblio.org/pub/Linux/ALPHA/freetds/stable/#{freetds}.tar.gz"
    run "tar xvzf #{freetds}.tar.gz && cd #{freetds} && ./configure && make"
    sudo_keepalive
    run "cd #{freetds} && sudo make install"
    run "rm #{freetds}.tar.gz && rm -Rf #{freetds}"
  end

  desc "Install the ruby ODBC library"
  task :install_rubyodbc, :roles => :app do
    rubyodbc = "ruby-odbc-0.9996"
    run "wget -nv http://www.ch-werner.de/rubyodbc/#{rubyodbc}.tar.gz"
    run "tar xvzf #{rubyodbc}.tar.gz && cd #{rubyodbc} && ruby extconf.rb && make"
    sudo_keepalive
    run "cd #{rubyodbc} && sudo make install"
    run "rm #{rubyodbc}.tar.gz && rm -Rf #{rubyodbc}"
  end

  desc "Install FreeTDS/ODBC configuration files"
  task :config_files, :roles => :app do
    put render("odbc.ini", binding), "odbc.ini"
    sudo "mv odbc.ini /etc/odbc.ini"
    put render("odbcinst.ini", binding), "odbcinst.ini"
    sudo "mv odbcinst.ini /etc/odbcinst.ini"
    put render("freetds.conf", binding), "more_freetds.conf"
    run "cat /etc/freetds/freetds.conf more_freetds.conf > freetds.conf"
    sudo "mv freetds.conf /etc/freetds/freetds.conf"
    run "rm more_freetds.conf"
  end
end
