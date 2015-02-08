require 'spec_helper'

module JiraReport
  describe Options do
    def check_field(opts, s, v)
      o = Options.new(opts)
      expect(o.get(s)).to eq(v)
      expect(o.options.include?(s)).to be true
      expect(o.include?(s)).to be true
    end

    def check_flag(opts, s)
      o = Options.new(opts)
      expect(o.include?(s)).to be true
    end

    def check_field_err(opts, err=Exception)
      expect{ Options.new(opts) }.to raise_error err
    end

    context 'when non-option passed' do
      it 'should throw error if wrong option' do
        check_field_err(['-1', 'value'], OptionParser::InvalidOption)
      end
      it 'should throw error if nil passed' do
        check_field_err(nil, ArgumentError)
      end
    end

    context 'when no arguments passed' do
      let(:opt) { Options.new([]) }

      it 'should have no options' do
        expect(opt.options.empty?).to be true
      end
    end

    describe '-h' do
      before(:each) do
        $stdout = StringIO.new
        $stderr = StringIO.new
      end
      after(:each) do
        $stdout = STDOUT
        $stderr = STDERR
      end

      it 'exits clearly' do
        expect{ Options.new(['-h']) }.to raise_error SystemExit
        expect{ Options.new(['--help']) }.to raise_error SystemExit
      end
    end

    describe '-v' do
      it 'is accepted' do
        check_flag(['-v'], :version)
        check_flag(['--version'], :version)
      end
    end

    describe '-u' do
      it 'is accepted' do
        usr = 'JohnDoe'
        check_field(['-u', usr], :username, usr)
        check_field(['--username', usr], :username, usr)
      end
      it 'is expected an error when argument not given' do
        check_field_err(['-u'], OptionParser::MissingArgument)
        check_field_err(['--username'], OptionParser::MissingArgument)
      end
    end

    describe '-c' do
      it 'is accepted' do
        file = './test'
        check_field(['-c', file], :config, file)
        check_field(['--config', file], :config, file)
      end
      it 'is expected an error when argument not given' do
        check_field_err(['-c'])
        check_field_err(['--config'])
      end
    end
  end
end
