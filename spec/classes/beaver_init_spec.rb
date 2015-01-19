require 'spec_helper'

describe 'beaver', :type => 'class' do

  context "On Debian" do

    let :facts do {
      :operatingsystem    => 'Debian',
      :osfamily           => 'Debian',
      :concat_basedir     => '/dne',
      :id                 => 'root',
      :path               => '/bin:/usr/bin:/usr/local/bin',
      :virtualenv_version => '1.11.6',
    } end

    # init.pp
    it { is_expected.to contain_class('beaver::package') }
    it { is_expected.to contain_class('beaver::config') }
    it { is_expected.to contain_class('beaver::service') }

    # package.pp
    it { is_expected.to contain_python__pip('Beaver') }

    # service.pp
    it { is_expected.to contain_service('beaver') }

    # config.pp
  
  end

  context "On Redhat" do

    let :facts do {
      :operatingsystem    => 'Redhat',
      :osfamily           => 'RedHat',
      :concat_basedir     => '/dne',
      :id                 => 'root',
      :path               => '/bin:/usr/bin:/usr/local/bin',
      :virtualenv_version => '1.11.6',
    } end

    # init.pp
    it { is_expected.to contain_class('beaver::package') }
    it { is_expected.to contain_class('beaver::config') }
    it { is_expected.to contain_class('beaver::service') }

    # package.pp
    it { is_expected.to contain_python__pip('Beaver') }

    # service.pp
    it { is_expected.to contain_service('beaver') }

    # config.pp
   
  end


end
