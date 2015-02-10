require 'spec_helper'

module JiraReport
  class InitSet
    attr_accessor :url,
      :username, :password,
      :period_from, :period_till

    def initialize
      @url = 'jira.company.com'
      @username = 'admin'
      @password = '*******'
      @period_from = '10/11/2014'
      @period_till = '10/12/2014'
    end
  end

  describe JiraReport do
    let(:usr ) { 'JohnDoe' }
    let(:init) { InitSet.new }
    let(:jrep) { Reporter.new(init, usr) }

    describe '#username' do
      it 'should return username' do
        expect(jrep.username).to eq usr
      end
    end

    describe '#from' do
      it 'should return from' do
        expect(jrep.from).to eq init.period_from
      end
    end

    describe '#till' do
      it 'should return till' do
        expect(jrep.till).to eq init.period_till
      end
    end

    describe '#query' do
      it 'should throw exception' do
        begin
          jrep.send(:query, 'my_query')
          fail
        rescue SocketError => e
          expect(e.message).not_to be nil
        end
      end
    end

    describe '#jira_search_url' do
      def jira_search_url(url=nil, user=nil, pass=nil)
        jrep.send(:jira_search_url, url, user, pass)
      end

      it 'is an http url' do
        url = jira_search_url
        expect(url).not_to be nil
        expect(url).to start_with 'http'
      end

      it 'uses rest api' do
        expect(jira_search_url).to include('rest/api/2/search')
      end

      context 'when we use url and username' do
        let(:usr) { 'admin_username' }
        let(:url) { 'jira.mycompany.url' }
        it 'contains url and username' do
          url = jira_search_url(url, usr, nil)
          expect(url).to include(url)
          expect(url).to include(usr)
        end
      end
    end

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
  end
end
