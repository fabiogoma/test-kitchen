require '/tmp/kitchen/roles/fabiogoma.supervisor/tests/spec/spec_helper.rb'

if os[:family] == 'redhat' && os[:release].start_with?("6")  
  yum_packages = ['python-setuptools', 'python-pip']
  pip_packages = [['meld3','1.0.2'], ['supervisor','3.3.3']]
  
  describe 'Python yum packages' do
    yum_packages.each do |item|
      context package(item) do
        it { should be_installed }
      end
    end
  end
  
  describe 'Python pip packages' do
    pip_packages.each do |item|
      describe package(item[0]) do
        it { should be_installed.by('pip').with_version(item[1]) }
      end
    end
  end
  
  describe file('/etc/supervisor.d/') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_mode 755 }
  end
  
  describe file('/etc/supervisord.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode 644 }
  end
  
  describe service 'supervisord' do
    it { should be_enabled }
    it { should be_running }
  end
end