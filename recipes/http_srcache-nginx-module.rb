#
# Cookbook Name:: nginx
# Recipe:: http_enhanced_memcached_module
#
# Author:: Ira Abramov (ira@fewbytes.com)
#
# Copyright 2012, Fewbytes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

srcache_nginx_module_version="0.17"
srcache_nginx_module_filename = "v#{srcache_nginx_module_version}.tar.gz"
srcache_nginx_module_filepath = "#{Chef::Config['file_cache_path']}/#{srcache_nginx_module_filename}"
srcache_nginx_module_extract_path = "#{Chef::Config['file_cache_path']}/srcache-nginx-module-#{srcache_nginx_module_version}/"

remote_file srcache_nginx_module_filepath do
  source "https://github.com/agentzh/srcache-nginx-module/archive/v#{srcache_nginx_module_version}.tar.gz"
  owner    'root'
  group    'root'
  mode     00644
end

bash 'extract_http_srcache_nginx_module' do
  cwd ::File.dirname(srcache_nginx_module_filepath)
  code <<-EOH
    mkdir -p #{srcache_nginx_module_extract_path}
    tar xzf #{srcache_nginx_module_filename} -C #{srcache_nginx_module_extract_path}
    mv #{srcache_nginx_module_extract_path}/*/* #{srcache_nginx_module_extract_path}/.
  EOH

  not_if { ::File.exists?(srcache_nginx_module_extract_path) }
end

node.run_state['nginx_configure_flags'] =
      node.run_state['nginx_configure_flags'] | ["--add-module=#{srcache_nginx_module_extract_path}"]
