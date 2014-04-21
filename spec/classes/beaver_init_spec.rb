require 'spec_helper'

describe 'beaver', :type => 'class' do

  context "On Debian" do

    let :facts do {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
      :concat_basedir  => '/dne',
    } end

    # init.pp
    it { should contain_class('beaver::package') }
    it { should contain_class('beaver::config') }
    it { should contain_class('beaver::service') }

    # package.pp
    it { should contain_package('Beaver') }

    # service.pp
    it { should contain_service('beaver') }

    # config.pp
  
  end

  context "On Redhat" do

    let :facts do {
      :operatingsystem => 'Redhat',
      :osfamily        => 'RedHat',
      :concat_basedir  => '/dne',
    } end

    # init.pp
    it { should contain_class('beaver::package') }
    it { should contain_class('beaver::config') }
    it { should contain_class('beaver::service') }

    # package.pp
    it { should contain_package('Beaver') }

    # service.pp
    it { should contain_service('beaver') }

    # config.pp
   
  end


end
