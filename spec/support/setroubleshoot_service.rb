shared_examples 'setroubleshoot::service' do
  it do
    should contain_service('messagebus').with({
      :ensure => 'running',
      :enable => 'true',
      :before => 'Service[auditd]',
    })
  end

  it do
    should contain_service('auditd').with({
      :ensure   => 'running',
      :enable   => 'true',
      :provider => 'redhat',
    })
  end

  context 'manage_services => false' do
    let(:params) {{ :manage_services => false }}
    it { should_not contain_service('messagebus') }
    it { should_not contain_service('auditd') }
  end

  context 'ensure => absent' do
    let(:params) {{ :ensure => 'absent' }}
    it { should_not contain_service('messagebus') }
    it { should_not contain_service('auditd') }
  end
end
