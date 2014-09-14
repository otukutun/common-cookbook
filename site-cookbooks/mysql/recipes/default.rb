#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{mysql-community-server mysql-community-devel mysql-community-client}.each do |pkg|
  package pkg do
    action :install
  end
end

service "mysqld" do
  action [:enable, :start]
end

execute "set root password" do
  command "mysqladmin -u root password '#{node['mysql']['server_root_password']}'"
  only_if "mysql -u root -e 'show databases;'"
end

#template "create user sql" do
#  path "/home/#{node['mysql']['user']}/create_user.sql"
#  source "create_user.sql.erb"
#  owner node['mysql']['user']
#  group node['mysql']['group']
#  mode 0644
#end

template "my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[mysqld]"
end
