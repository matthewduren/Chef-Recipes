execute "remove_old_database_folder" do
  command 'rm -rf /vagrant/database'
end

script "reset_docker" do
  interpreter "bash"
  code <<-resetscript
    for container in $(docker ps -a | awk '{print $1}' | grep -v "CONTAINER"); do
      docker rm -f "$container"
    done
  resetscript
end
