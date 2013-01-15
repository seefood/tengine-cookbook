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

memc_nginx_module_version="0.13rc3"
memc_nginx_module_filename = "v#{memc_nginx_module_version}.tar.gz"
memc_nginx_module_filepath = "#{Chef::Config['file_cache_path']}/#{memc_nginx_module_filename}"
memc_nginx_module_extract_path = "#{Chef::Config['file_cache_path']}/memc-nginx-module-#{memc_nginx_module_version}/"

remote_file memc_nginx_module_filepath do
  source "https://github.com/agentzh/memc-nginx-module/archive/v#{memc_nginx_module_version}.tar.gz"
  owner    'root'
  group    'root'
  mode     00644
end

bash 'extract_http_memc-nginx-module' do
  cwd ::File.dirname(memc_nginx_module_filepath)
  code <<-EOH
    mkdir -p #{memc_nginx_module_extract_path}
    tar xzf #{memc_nginx_module_filename} -C #{memc_nginx_module_extract_path}
    mv #{memc_nginx_module_extract_path}/*/* #{memc_nginx_module_extract_path}/.
  EOH

  not_if { ::File.exists?(memc_nginx_module_extract_path) }
end

node.run_state['nginx_configure_flags'] =
      node.run_state['nginx_configure_flags'] | ["--add-module=#{memc_nginx_module_extract_path}"]
