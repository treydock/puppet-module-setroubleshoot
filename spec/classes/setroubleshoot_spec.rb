require 'spec_helper'

describe 'setroubleshoot' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) {{ }}

      it { should create_class('setroubleshoot') }
      it { should contain_class('setroubleshoot::params') }

      it { should contain_anchor('setroubleshoot::start').that_comes_before('Class[setroubleshoot::install]') }
      it { should contain_class('setroubleshoot::install').that_comes_before('Class[setroubleshoot::config]') }
      it { should contain_class('setroubleshoot::config').that_comes_before('Class[setroubleshoot::service]') }
      it { should contain_class('setroubleshoot::service').that_comes_before('Anchor[setroubleshoot::end]') }
      it { should contain_anchor('setroubleshoot::end') }

      it_behaves_like 'setroubleshoot::install'
      it_behaves_like 'setroubleshoot::config'
      it_behaves_like 'setroubleshoot::service'

      # Test boolean validation
      [
        :manage_services,
      ].each do |param|
        context "with #{param} => foo" do
          let(:params) {{ param => 'foo' }}
          it "should raise an error" do
            expect { should compile }.to raise_error(/is not a boolean/)
          end
        end
      end

      # Test string validation
      [
        :package_name,
        :config_path,
        :email_recipients_filepath,
        :email_smtp_port,
        :email_smtp_host,
        :email_from_address,
      ].each do |param|
        context "with #{param} => false" do
          let(:params) {{ param => false }}
          it "should raise an error" do
            expect { should compile }.to raise_error(/is not a string/)
          end
        end
      end

      # Test hash validation
      [
        :setroubleshoot_configs,
        :email_recipients,
      ].each do |param|
        context "with #{param} => 'foo'" do
          let(:params) {{ param => 'foo' }}
          it "should raise an error" do
            expect { should compile }.to raise_error(/is not a Hash/)
          end
        end
      end
    end
  end
end
