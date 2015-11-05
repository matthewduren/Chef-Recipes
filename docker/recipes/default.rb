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
  command "apt-get purge lxc-docker*"
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