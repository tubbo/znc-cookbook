action :install do
  if @new_resource.from == 'package'
    %w[znc znc-dev].each do |name|
      package name
    end
  else
    configure_options = @new_resource.configure_options.join(" ")

    include_recipe 'build-essential'

    value_for_platform(
      ["debian", "ubuntu"] => {"default" => %w{ libssl-dev libperl-dev pkg-config libc-ares-dev }},
      "default" => %w{ libssl-dev libperl-dev pkg-config libc-ares-dev }
    ).each { |dependency| package dependency }

    version = node['znc']['version']

    remote_file "#{Chef::Config[:file_cache_path]}/znc-#{version}.tar.gz" do
      source "#{node['znc']['url']}/znc-#{version}.tar.gz"
      checksum node['znc']['checksum']
      mode "0644"
      not_if "which znc"
    end

    bash "build znc" do
      cwd Chef::Config[:file_cache_path]
      code <<-EOF
      tar -zxvf znc-#{version}.tar.gz
      (cd znc-#{version} && ./configure #{configure_options})
      (cd znc-#{version} && make && make install)
      EOF
      not_if "which znc"
    end
  end
end
