require '/tmp/kitchen/roles/fabiogoma.nginx/tests/spec/spec_helper.rb'

describe package('nginx') do
  it { should be_installed }
end

describe group('nginx') do
  it { should exist }
end

describe user('nginx') do
  it { should exist }
end

describe file('/etc/nginx/') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 755 }
end

describe file('/etc/nginx/conf.d/default.conf') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  it { should contain 'upstream characters' }
  it { should contain 'server 127.0.0.1:8080;' }
  it { should contain 'location /characters' }
  it { should contain 'proxy_pass http://characters;' }
end

if os[:family] == 'redhat'
  if os[:release].start_with?('6')
    describe service('nginx') do
      it { should be_running }
      it { should be_enabled }
    end
  end

  if os[:release].start_with?('7')
    describe service('nginx') do
      it { should be_enabled }
      it { should be_running.under('systemd') }
    end
  end
end

describe port(80) do
  it { should be_listening }
end
