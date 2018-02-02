require '/tmp/kitchen/roles/fabiogoma.common/tests/spec/spec_helper.rb'

packages = ['nss-mdns', 'net-tools', 'telnet', 'tcpdump', 'lsof', 'strace', 'wget', 'mlocate', 'setroubleshoot', 'setroubleshoot-server']

describe 'Common packages' do
  packages.each do |item|
    context package(item) do
      it { should be_installed }
    end
  end
end

describe service 'avahi-daemon' do
  it { should be_enabled }
  it { should be_running }
end

describe interface('eth1') do
  it { should exist }
  it { should be_up }
end

describe selinux do
  it { should be_enforcing }
  it { should be_enforcing.with_policy('targeted') }
end
