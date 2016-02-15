cookbook_file "docker.list" do
  path "/etc/apt/sources.list.d/docker.list"
  owner "root"
  group "root"
  mode "0644"
  action :create
end

execute "add_new_docker_gpg_key" do
  command 'apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D'
end

execute "apt_update_for_docker" do
  command "sudo apt-get update"
end

execute "apt_purge_old_docker" do
  command "apt-get purge lxc-docker* -y"
end

execute "remove phpbeanstalkdadmin" do
  command "rm -rf /vagrant/apps/phpbeanstalkdadmin.local.dev"
end

execute "git_clone_phpbeanstalkdadmin" do
  command "git clone https://github.com/mnapoli/phpBeanstalkdAdmin.git /vagrant/apps/phpbeanstalkdadmin.local.dev"
end

apt_package "linux-image-generic-lts-trusty" do
  action :install
end

apt_package "linux-headers-generic-lts-trusty" do
  action :install
end

apt_package "docker-engine" do
  action :install
end

script "fix_docker_networking" do
  interpreter "bash"
  code <<-EOH
    service docker stop
    iptables -t nat -F POSTROUTING
    ip link set dev docker0 down
    ip addr del $(ip addr | grep docker0 | grep scope | awk '{printf $2}') dev docker0 > /dev/null 2>&1
    ip addr del 172.17.0.1/16 dev docker0
    ip addr add 172.17.42.1/24 dev docker0
    ip link set dev docker0 up
    service docker start
    iptables -t nat -L -n
  EOH
end

include_recipe "docker::reset"
