shared_examples 'setroubleshoot::config' do
  it do
    should contain_file('/etc/setroubleshoot/setroubleshoot.conf').with({
      :ensure => 'file',
      :path   => '/etc/setroubleshoot/setroubleshoot.conf',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644',
    })
  end

  it do
    should contain_file('setroubleshoot-email_alert_recipients').with({
      :ensure => 'file',
      :path   => '/var/lib/setroubleshoot/email_alert_recipients',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0600',
    })
  end

  it 'should define no recipients' do
    verify_exact_file_contents(catalogue, 'setroubleshoot-email_alert_recipients', [])
  end

  it { should have_setroubleshoot_config_resource_count(4) }

  it { should contain_setroubleshoot_config('email/recipients_filepath').with_value('/var/lib/setroubleshoot/email_alert_recipients') }
  it { should contain_setroubleshoot_config('email/smtp_port').with_value('25') }
  it { should contain_setroubleshoot_config('email/smtp_host').with_value('localhost') }
  it { should contain_setroubleshoot_config('email/from_address').with_value('SELinux_Troubleshoot') }

  context 'when email_recipients defined' do
    let(:params) do
      {
        :email_recipients => {
          'foo@example.com' => {
            'filter_type' => 'always',
          },
          'bar@example.com' => {}
        }
      }
    end

    it 'should define recipients' do
      verify_exact_file_contents(catalogue, 'setroubleshoot-email_alert_recipients', [
        'bar@example.com filter_type=after_first',
        'foo@example.com filter_type=always',
      ])
    end
  end

  context 'ensure => absent' do
    let(:params) {{ :ensure => 'absent' }}
    it { should_not contain_file('/etc/setroubleshoot/setroubleshoot.conf') }
    it { should have_setroubleshoot_config_resource_count(0) }
    it { should_not contain_setroubleshoot_config('email/recipients_filepath') }
    it { should_not contain_setroubleshoot_config('email/smtp_port') }
    it { should_not contain_setroubleshoot_config('email/smtp_host') }
    it { should_not contain_setroubleshoot_config('email/from_address') }
  end
end
