require 'spec_helper'

module JiraReport
  describe JiraReport do
    let(:jrep) { Reporter.new('site', 'admin', '*****') }

    describe '#query_issues' do
      it 'should throw exception' do
        begin
          jrep.query_issues('my_jql')
          fail Exception, 'exception expected'
        rescue => e
          expect(e.message).not_to be nil
        end
      end
    end

    describe '#jira_api_url' do
      def jira_api_url(site=nil, user=nil, pass=nil)
        jrep.send(:jira_api_url, site, user, pass)
      end

      it 'ends with jira rest api search url' do
        expect(jira_api_url 'url', 'usr', 'pas').
          to end_with Reporter::REST_API_SEARCH_URL
      end

      describe 'scheme' do
        ['http', 'https'].each do |s|
          it 'correctly detects scheme' do
            site = "jira.mycom.com"
            url = jira_api_url("#{s}://#{site}")
            expect(url).to start_with "#{s}://"
            expect(url).to include site
          end
        end

        it 'is ok when no scheme passed' do
          site = 'jira.mycom.com'
          expect(jira_api_url(site)).to include site
        end
      end

      context 'when we define all parameters' do
        let(:usr)    { 'admin_username' }
        let(:pas)    { 'password' }
        let(:host)   { 'localhost' }
        let(:port)   {  8000 }
        let(:path)   { 'myjira' }

        it 'is correctly prepares http url' do
          site = "http://#{host}:#{port}/#{path}"
          url = jira_api_url(site, usr, pas)
          expect(url).to eq (
            "http://#{usr}:#{pas}@#{host}:#{port}/#{path}/#{Reporter::REST_API_SEARCH_URL}"
          )
        end
      end
    end
  end

  describe '#queries' do
    let(:usr) { 'JohnDoe' }
    let(:from) { '-3w' }
    let(:till) { '-1w' }

    mocked_rep = Reporter.new('url', 'usr', 'pas')

    before(:example) do
      allow(mocked_rep).to receive(:query_issues) do |arg|
        arg
      end
    end

    describe '#created' do
      it 'has from, till and reporter' do
        expect(mocked_rep.created(usr, from, till)).to eql(
          "jql=created>=#{from} AND created<=#{till} AND reporter=#{usr}"
        )
      end
      it 'has from and reporter' do
        expect(mocked_rep.created(usr, from)).to eql(
          "jql=created>=#{from} AND reporter=#{usr}"
        )
      end
      it 'has till and reporter' do
        expect(mocked_rep.created(usr, nil, till)).to eql(
          "jql=created<=#{till} AND reporter=#{usr}"
        )
      end
      it 'has only reporter' do
        expect(mocked_rep.created(usr)).to eql(
          "jql=reporter=#{usr}"
        )
      end
      it 'has not parameters' do
        expect(mocked_rep.created(nil)).to eql(
          "jql=reporter="
        )
      end
    end

    describe '#resolved' do
      it 'has from, till and reporter' do
        expect(mocked_rep.resolved(usr, from, till)).to eql(
          "jql=resolved>=#{from} AND resolved<=#{till} AND 'First Resolution User'=#{usr}"
        )
      end
      it 'has from and reporter' do
        expect(mocked_rep.resolved(usr, from)).to eql(
          "jql=resolved>=#{from} AND 'First Resolution User'=#{usr}"
        )
      end
      it 'has till and reporter' do
        expect(mocked_rep.resolved(usr, nil, till)).to eql(
          "jql=resolved<=#{till} AND 'First Resolution User'=#{usr}"
        )
      end
      it 'has only reporter' do
        expect(mocked_rep.resolved(usr)).to eql(
          "jql='First Resolution User'=#{usr}"
        )
      end
      it 'has not parameters' do
        expect(mocked_rep.resolved(nil)).to eql(
          "jql='First Resolution User'="
        )
      end
    end

    describe '#reopened' do
      it 'has from, till and reporter' do
        expect(mocked_rep.reopened(usr, from, till)).to eql(
          "jql='First Reopened Date'>=#{from} "\
          "AND 'First Reopened Date'<=#{till} "\
          "AND 'First Reopened User'=#{usr}"
        )
      end
      it 'has from and reporter' do
        expect(mocked_rep.reopened(usr, from)).to eql(
          "jql='First Reopened Date'>=#{from} "\
          "AND 'First Reopened User'=#{usr}"
        )
      end
      it 'has till and reporter' do
        expect(mocked_rep.reopened(usr, nil, till)).to eql(
          "jql='First Reopened Date'<=#{till} "\
          "AND 'First Reopened User'=#{usr}"
        )
      end
      it 'has only reporter' do
        expect(mocked_rep.reopened(usr)).to eql(
          "jql='First Reopened User'=#{usr}"
        )
      end
      it 'has not parameters' do
        expect(mocked_rep.reopened(nil)).to eql(
          "jql='First Reopened User'="
        )
      end
    end

    describe '#closed' do
      it 'has from, till and reporter' do
        expect(mocked_rep.closed(usr, from, till)).to eql(
          "jql='First Closed Date'>=#{from} "\
          "AND 'First Closed Date'<=#{till} "\
          "AND 'First Closed User'=#{usr}"
        )
      end
      it 'has from and reporter' do
        expect(mocked_rep.closed(usr, from)).to eql(
          "jql='First Closed Date'>=#{from} "\
          "AND 'First Closed User'=#{usr}"
        )
      end
      it 'has till and reporter' do
        expect(mocked_rep.closed(usr, nil, till)).to eql(
          "jql='First Closed Date'<=#{till} "\
          "AND 'First Closed User'=#{usr}"
        )
      end
      it 'has only reporter' do
        expect(mocked_rep.closed(usr)).to eql(
          "jql='First Closed User'=#{usr}"
        )
      end
      it 'has not parameters' do
        expect(mocked_rep.closed(nil)).to eql(
          "jql='First Closed User'="
        )
      end
    end
  end

end
