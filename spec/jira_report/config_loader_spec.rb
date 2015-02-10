require 'spec_helper'
require 'jira_report/config_loader'

module JiraReport
  describe ConfigLoader do
    it 'raises error if wrong path to configuration file' do
      expect{ ConfigLoader.load_config('wrong/path') }.to raise_error RuntimeError
    end

    context 'when file exists' do
      let(:filename){ 'test.conf' }
      let(:option){ 'username' }
      let(:value){ 'JohnDoe' }

      before do
        FileUtils.touch(filename)
      end

      def add_content(filename, content)
        f = File.new(filename, 'a+')
        f.write(content)
        f.flush
        f.close
      end

      after do
        FileUtils.rm_r(filename)
      end

      it 'reads empty file correctly' do
        config = ConfigLoader.load_config(filename)
        expect(config).not_to be nil
        expect(config).to be_empty
      end

      it 'read file with options' do
        add_content(filename, "#{option}=#{value}")
        config = ConfigLoader.load_config(filename)
        expect(config).to include(option => value)
      end
    end
  end
end
