#
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git "/home/#{node['nodejs']['user']}/.ndenv" do
  repository node["nodejs"]["ndenv_url"]
  action :sync
  user node['nodejs']['user']
  group node['nodejs']['group']
end

template ".bash_profile" do
  source ".bash_profile.erb"
  path "/home/#{node['nodejs']['user']}/.bash_profile_node"
  mode 0644
  owner node['nodejs']['user']
  group node['nodejs']['group']
  not_if "grep ndenv ~/.bash_profile_node", :environment => { :'HOME' => "/home/#{node['nodejs']['user']}" }
end

execute "update bash_profile" do
  command "echo source /home/#{node['nodejs']['user']}/.bash_profile_node >> /home/#{node['nodejs']['user']}/.bash_profile; chmod 0644 /home/#{node['nodejs']['user']}/.bash_profile"
  not_if "grep bash_profile_node ~/.bash_profile", :environment => { :'HOME' => "/home/#{node['nodejs']['user']}" }
end

directory "/home/#{node['nodejs']['user']}/.ndenv/plugins" do
  owner node['nodejs']['user']
  group node['nodejs']['group']
  mode 0755
  action :create
end

git "/home/#{node['nodejs']['user']}/.ndenv/plugins/node-build" do
  repository node["nodejs"]["node-build_url"]
  action :sync
  user node['nodejs']['user']
  group node['nodejs']['group']
end

