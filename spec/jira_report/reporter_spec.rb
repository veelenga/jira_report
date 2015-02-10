require 'spec_helper'

module JiraReport
  describe JiraReport do
    let(:jrep) { Reporter.new('url', 'admin', '*****') }

    describe '#query_issues' do
      it 'should throw exception' do
        begin
          jrep.query_issues('my_jql')
          fail
        rescue SocketError => e
          expect(e.message).not_to be nil
        end
      end
    end

    describe '#jira_api_url' do
      def jira_api_url(url=nil, user=nil, pass=nil)
        jrep.send(:jira_api_url, url, user, pass)
      end

      it 'is an http url' do
        url = jira_api_url
        expect(url).not_to be nil
        expect(url).to start_with 'http'
      end

      it 'uses rest api' do
        expect(jira_api_url).to include('rest/api/2/search')
      end

      context 'when we use url, username and password' do
        let(:usr) { 'admin_username' }
        let(:url) { 'jira.mycompany.url' }
        let(:pas) { '*****' }
        it 'contains url, username and password' do
          url = jira_api_url(url, usr, pas)
          expect(url).to include(url)
          expect(url).to include(usr)
          expect(url).to include(pas)
        end
      end
    end

=begin
    describe '#jql_*' do
      describe '#jql_created' do
        it 'returns query' do
          expect(jrep.send(:jql_created)).not_to be nil
        end
      end
      describe '#jql_resolved' do
        it 'returns query' do
          expect(jrep.send(:jql_resolved)).not_to be nil
        end
      end
      describe '#jql_closed' do
        it 'returns query' do
          expect(jrep.send(:jql_closed)).not_to be nil
        end
      end
      describe '#jql_reopened' do
        it 'returns query' do
          expect(jrep.send(:jql_reopened)).not_to be nil
        end
      end
    end
=end
  end
end
