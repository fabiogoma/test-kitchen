require '/tmp/kitchen/roles/fabiogoma.tomcat/tests/spec/spec_helper.rb'

java_packages = ['java-1.8.0-openjdk', 'java-1.8.0-openjdk-devel']

describe 'Java installation' do
  java_packages.each do |item|
    context package(item) do
      it { should be_installed }
    end
  end
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
end

describe file('/opt/tomcat/') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'tomcat' }
  it { should be_grouped_into 'tomcat' }
  it { should be_mode 750 }
end

describe file('/opt/tomcat/conf/server.xml') do
  it { should exist }
  it { should be_file }
  it { should be_owned_by 'tomcat' }
  it { should be_grouped_into 'tomcat' }
  it { should be_mode 600 }
  it { should contain '<Context docBase="/opt/tomcat/characters" path="/characters" />' }
end

static_content = ['index.html', 'images/shaggy.png', 'images/velma.png', 'images/fred.png', 'images/daphne.png', 'images/scooby.png', 'images/mystery_machine.png']

static_content.each do |static|
  file_name = '/opt/tomcat/characters/' + static
  describe file(file_name) do
    it { should exist }
    it { should be_owned_by 'tomcat' }
    it { should be_grouped_into 'tomcat' }
    it { should be_mode 644 }
  end
end

if os[:family] == 'redhat'
  if os[:release].start_with?('6')
    describe service('supervisord') do
      it { should be_running }
      it { should be_enabled }
    end
    describe service('tomcat') do
      it { should be_running.under('supervisor') }
    end
    describe host('base-centos-6.local') do
      it { should be_resolvable }
    end
  end

  if os[:release].start_with?('7')
    describe service('tomcat') do
      it { should be_running.under('systemd') }
    end
    describe host('base-centos-7.local') do
      it { should be_resolvable }
    end
  end
end

describe port(8080) do
  it { should be_listening }
end
