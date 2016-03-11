# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

module MSS
  module Core
    describe Client do

      ## before each test we are creating a fake service interface

      before(:each) do

        MSS::SERVICES['Dummy'] = MSS::SvcDetails.new('Dummy',
          :full_name => 'Amazon Dummy', # like a crash test dummy
          :method_name => :dummy)

        module ::MSS
          class Dummy

            include ServiceInterface

            endpoint_prefix 'dummy', :global => true

            class Client < Core::Client
              API_VERSION = '2000-01-02'
            end

            class Client::V20000102 < Client

              signature_version :Version4, 'dummy'

              API_VERSION = Time.now.strftime('%Y-%m-%d')

              add_client_request_method(:sample_method) do
              end
            end

          end
        end

        MSS::Core::Configuration.add_service(
          'Dummy', 'dummy', 'dummy.amazonmss.com')

      end

      after(:each) do
        ::MSS.send(:remove_const, :Dummy)
      end

      let(:client_class) { ::MSS::Dummy::Client }

      let(:request_class) { ::MSS::Dummy::Request }

      let(:config_options) {{}}

      let(:config) { stub_config.with(config_options) }

      let(:client) { client_class.new(:config => config) }

      context 'config' do

        it 'merges service specific :endpopint option' do
          MSS.config(:dummy => { :endpoint => 'abc.xyz.com' })
          MSS::Dummy::Client.new.config.dummy_endpoint.should eq('abc.xyz.com')
        end

        it 'merges service specific :port option' do
          MSS.config(:dummy => { :port => 123 })
          MSS::Dummy::Client.new.config.dummy_port.should eq(123)
        end

        it 'merges service specific :region option' do
          MSS.config(:dummy => { :region => 'REGION' })
          MSS::Dummy::Client.new.config.dummy_region.should eq('REGION')
        end

      end

      context 'logging' do

        let(:logger) { double('logger') }

        let(:config_options) {{ :logger => logger }}

        let(:response) { client.stub_for(:sample_method) }

        it 'logs to the configured logger after each request' do
          logger.should_receive(:info)
          client.sample_method
        end

        it 'calls the logger method that matches the log level' do
          config.stub(:log_level).and_return(:notice)
          logger.should_receive(:notice)
          client.sample_method
        end

        it 'passes the formatted log message to the logger' do
          config.log_formatter.stub(:format).and_return('LOG-MESSAGE')
          logger.should_receive(:info).with('LOG-MESSAGE')
          client.sample_method
        end

        it 'passes the response to the log formatter to build the message' do

          config.log_formatter.should_receive(:format).
            with(response).
            and_return('LOG-MESSAGE')

          logger.should_receive(:info).with('LOG-MESSAGE')

          client.sample_method

        end

        context '#log_warning' do

          it 'sends warning messages here' do
            logger.should_receive(:warn).with do |msg|
              msg.should match(/^\[mss-sdk-gem-warning\] msg/)
              msg
            end
            client.log_warning('msg')
          end

          it 'sends warning messages to $stderr when no logger is configured' do
            $stderr.should_receive(:puts).with do |msg|
              msg.should match(/^\[mss-sdk-gem-warning\] msg/)
              msg
            end
            client.with_options(:logger => nil).log_warning('msg')
          end

        end

      end

    end
  end
end