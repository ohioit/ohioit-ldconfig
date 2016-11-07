require 'spec_helper'
describe 'ldconfig' do
  context 'with default values for all parameters' do
    it { should contain_class('ldconfig') }
  end
end
