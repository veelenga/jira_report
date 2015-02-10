require 'spec_helper'
require 'jira_report/config_loader'

module JiraReport
  describe ConfigLoader do
    it 'raise error if wrong path to configuration file' do
      expect{ ConfigLoader.load_config('wrong/path') }.to raise_error RuntimeError
    end
  end
end
