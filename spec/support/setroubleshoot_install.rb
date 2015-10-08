shared_examples 'setroubleshoot::install' do
  it do
    should contain_package('setroubleshoot').with({
      :ensure => 'present',
      :name   => 'setroubleshoot-server',
      :notify => 'Service[auditd]',
    })
  end

  context 'manage_services => false' do
    let(:params) {{ :manage_services => false }}
    it { should contain_package('setroubleshoot').without_notify }
  end

  context 'ensure => absent' do
    let(:params) {{ :ensure => 'absent' }}
    it { should contain_package('setroubleshoot').with_ensure('absent') }
    it { should contain_package('setroubleshoot').without_notify }
  end
end
