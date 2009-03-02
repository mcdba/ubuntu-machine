# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ubuntu-machine}
  s.version = "0.4.41"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Johnson"]
  s.date = %q{2009-03-01}
  s.description = %q{TODO}
  s.email = %q{github@brianjohnson.cc}
  s.files = ["VERSION.yml", "lib/capistrano", "lib/capistrano/ext", "lib/capistrano/ext/ubuntu-machine", "lib/capistrano/ext/ubuntu-machine/apache.rb", "lib/capistrano/ext/ubuntu-machine/aptitude.rb", "lib/capistrano/ext/ubuntu-machine/gems.rb", "lib/capistrano/ext/ubuntu-machine/git.rb", "lib/capistrano/ext/ubuntu-machine/helpers.rb", "lib/capistrano/ext/ubuntu-machine/iptables.rb", "lib/capistrano/ext/ubuntu-machine/machine.rb", "lib/capistrano/ext/ubuntu-machine/mysql.rb", "lib/capistrano/ext/ubuntu-machine/php.rb", "lib/capistrano/ext/ubuntu-machine/ruby.rb", "lib/capistrano/ext/ubuntu-machine/sphinx.rb", "lib/capistrano/ext/ubuntu-machine/ssh.rb", "lib/capistrano/ext/ubuntu-machine/svn.rb", "lib/capistrano/ext/ubuntu-machine/templates", "lib/capistrano/ext/ubuntu-machine/templates/apache2.erb", "lib/capistrano/ext/ubuntu-machine/templates/iptables.erb", "lib/capistrano/ext/ubuntu-machine/templates/my.cnf.erb", "lib/capistrano/ext/ubuntu-machine/templates/new_db.erb", "lib/capistrano/ext/ubuntu-machine/templates/passenger.conf.erb", "lib/capistrano/ext/ubuntu-machine/templates/passenger.load.erb", "lib/capistrano/ext/ubuntu-machine/templates/sshd_config.erb", "lib/capistrano/ext/ubuntu-machine/templates/svn_servers.erb", "lib/capistrano/ext/ubuntu-machine/templates/vhost.erb", "lib/capistrano/ext/ubuntu-machine/utils.rb", "lib/capistrano/ext/ubuntu-machine.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/johnsbrn/ubuntu-machine}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
