shared_examples 'setroubleshoot::install' do
  it do
    should contain_package('setroubleshoot').with({
      :ensure => 'present',
      :name   => 'setroubleshoot-server',
    })
  end

  context 'ensure => absent' do
    let(:params) {{ :ensure => 'absent' }}
    it { should contain_package('setroubleshoot').with_ensure('absent') }
  end
end
