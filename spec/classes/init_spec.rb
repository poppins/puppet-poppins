require 'spec_helper'
describe 'poppins' do

  context 'with defaults for all parameters' do
    it { should contain_class('poppins') }
  end
end
