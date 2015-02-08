require 'spec_helper'

module JiraReport
  describe ConfigLoader do
    it 'raise error if wrong path to configuration file' do
      expect{ ConfigLoader.new('wrong/path') }.to raise_error RuntimeError
    end
  end
end
