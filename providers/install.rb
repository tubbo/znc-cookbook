action :install do
  if @new_resource.from == 'package'
    %w[znc znc-dev].each { |name| package name }
  else
    configure_options = @new_resource.configure_options.join(" ")

    include_recipe 'build-essential'

    value_for_platform(
      ["debian", "ubuntu"] => {"default" => %w{ libssl-dev libperl-dev pkg-config libc-ares-dev }},
      "default" => %w{ libssl-dev libperl-dev pkg-config libc-ares-dev }
    ).each { |dependency| package dependency }

    remote_file "#{Chef::Config[:file_cache_path]}/znc-#{@new_resource.version}.tar.gz" do
      source "#{@new_resource.url}/znc-#{@new_resource.version}.tar.gz"
      checksum @new_resource.checksum
      mode "0644"
      not_if "which znc"
    end

    bash "build znc" do
      cwd Chef::Config[:file_cache_path]
      code <<-EOF
      tar -zxvf znc-#{@new_resource.version}.tar.gz
      (cd znc-#{@new_resource.version} && ./configure #{configure_options})
      (cd znc-#{@new_resource.version} && make && make install)
      EOF
      not_if "which znc"
    end
  end
end
