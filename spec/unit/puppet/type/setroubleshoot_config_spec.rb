require 'puppet'
require 'puppet/type/setroubleshoot_config'

describe 'Puppet::Type.type(:setroubleshoot_config)' do
  before :each do
    @setroubleshoot_config = Puppet::Type.type(:setroubleshoot_config).new(:name => 'vars/foo', :value => 'bar')
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:setroubleshoot_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:setroubleshoot_config).new(:name => 'f oo')
    }.to raise_error(Puppet::Error, /Invalid setroubleshoot_config/)
  end

  it 'should fail when there is no section' do
    expect {
      Puppet::Type.type(:setroubleshoot_config).new(:name => 'foo')
    }.to raise_error(Puppet::Error, /Invalid setroubleshoot_config/)
  end

  it 'should not require a value when ensure is absent' do
    Puppet::Type.type(:setroubleshoot_config).new(:name => 'vars/foo', :ensure => :absent)
  end

  it 'should require a value when ensure is present' do
    expect {
      Puppet::Type.type(:setroubleshoot_config).new(:name => 'vars/foo', :ensure => :present)
    }.to raise_error(Puppet::Error, /Property value must be set/)
  end

  it 'should accept a valid value' do
    @setroubleshoot_config[:value] = 'bar'
    @setroubleshoot_config[:value].should == 'bar'
  end

  it 'should not accept a value with whitespace' do
    @setroubleshoot_config[:value] = 'b ar'
    @setroubleshoot_config[:value].should == 'b ar'
  end

  it 'should accept valid ensure values' do
    @setroubleshoot_config[:ensure] = :present
    @setroubleshoot_config[:ensure].should == :present
    @setroubleshoot_config[:ensure] = :absent
    @setroubleshoot_config[:ensure].should == :absent
  end

  it 'should not accept invalid ensure values' do
    expect {
      @setroubleshoot_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  describe 'autorequire File resources' do
    it 'should autorequire /etc/setroubleshoot/setroubleshoot.conf' do
      conf = Puppet::Type.type(:file).new(:name => '/etc/setroubleshoot/setroubleshoot.conf')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource @setroubleshoot_config
      catalog.add_resource conf
      rel = @setroubleshoot_config.autorequire[0]
      rel.source.ref.should == conf.ref
      rel.target.ref.should == @setroubleshoot_config.ref
    end
  end
end
