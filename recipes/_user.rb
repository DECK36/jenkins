# Create the Jenkins user
user node['jenkins']['master']['user'] do
  home node['jenkins']['master']['home']
  system node['jenkins']['master']['use_system_accounts'] # ~FC048
end

# Create the Jenkins group
group node['jenkins']['master']['group'] do
  members node['jenkins']['master']['user']
  system node['jenkins']['master']['use_system_accounts'] # ~FC048
end

# Create the home directory
directory node['jenkins']['master']['home'] do
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
  recursive true
end

# Create the log directory
directory node['jenkins']['master']['log_directory'] do
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
  recursive true
end

# Create the cache directory
directory node['jenkins']['master']['cache_directory'] do
  owner     node['jenkins']['master']['user']
  group     node['jenkins']['master']['group']
  mode      '0755'
  recursive true
end

# fix cache dir ownership (necessary if it already existed)
execute "chown_#{node['jenkins']['master']['cache_directory']}" do
  command "chown -R #{node['jenkins']['master']['user']}:#{node['jenkins']['master']['group']} #{node['jenkins']['master']['cache_directory']}"
  not_if { !File.exists?("#{node['jenkins']['master']['cache_directory']}/war") \
        || Etc.getpwuid(File.stat("#{node['jenkins']['master']['cache_directory']}/war").uid).name != "node['jenkins']['master']['user']" }
end
