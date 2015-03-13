require 'spec_helper_acceptance'

describe 'setroubleshoot class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp = "class { 'setroubleshoot': }"

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe package('setroubleshoot-server') do
      it { should be_installed }
    end

    describe file('/etc/setroubleshoot/setroubleshoot.conf') do
      its(:content) { should match /^recipients_filepath = \/var\/lib\/setroubleshoot\/email_alert_recipients$/ }
      its(:content) { should match /^smtp_port = 25$/ }
      its(:content) { should match /^smtp_host = localhost$/ }
      its(:content) { should match /^from_address = SELinux_Troubleshoot$/ }
    end

    describe service('messagebus') do
      it { should be_running }
      it { should be_enabled }
    end

    describe service('auditd') do
      it { should be_running }
      it { should be_enabled }
    end
  end
end
