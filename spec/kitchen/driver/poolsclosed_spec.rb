require_relative '../../spec_helper'
require 'pry-byebug'
require 'logger'
require 'stringio'
require 'kitchen/driver/poolsclosed'
require 'kitchen/provisioner/dummy'
require 'kitchen/transport/dummy'
require 'kitchen/verifier/dummy'
require 'webmock/rspec'

describe Kitchen::Driver::Poolsclosed do
  # it looks like this is all boilerplate because i see it in
  # the kitchen-vagrant and kitchen-ec2 projects
  # maybe the one dude copied the other

  let(:logged_output) { StringIO.new }
  let(:logger)        { Logger.new(logged_output) }
  let(:config)        { { kitchen_root: '/kroot', poolsclosed_baseurl: 'http://mypool:42069/' } }
  let(:platform)      { Kitchen::Platform.new(name: 'windows2012r2') }
  let(:suite)         { Kitchen::Suite.new(name: 'suitey') }
  let(:verifier)      { Kitchen::Verifier::Dummy.new }
  let(:provisioner)   { Kitchen::Provisioner::Dummy.new }
  let(:transport)     { Kitchen::Transport::Dummy.new }
  let(:state_file)    { double('state_file') }
  let(:state)         { Hash.new }
  let(:env)           { Hash.new }
  let(:driver_object) { Kitchen::Driver::Poolsclosed.new(config) }

  let(:driver) do
    d = driver_object
    instance
    d
  end

  let(:instance) do
    Kitchen::Instance.new(
      verifier: verifier,
      driver: driver_object,
      logger: logger,
      suite: suite,
      platform: platform,
      provisioner: provisioner,
      transport: transport,
      state_file: state_file
    )
  end

  before(:each) { stub_const('ENV', env) }

  describe '#create' do
    # note: decided to check for the platform on create
    # because test-kitchen hasn't instantiated the platform
    # object when we do the verify step.
    context 'windows platform' do
      before { allow(driver).to receive(:poolsclosed_machine).and_return('mynewbox') }
      before { allow(platform).to receive(:os_type).and_return('windows') }

      it 'does not throw an error when the os is windows' do
        expect { driver.create(state) }.to_not raise_error
      end
    end

    context 'not windows platform' do
      before { allow(platform).to receive(:os_type).and_return('unix') }

      before { allow(driver).to receive(:poolsclosed_machine).and_return('mynewbox') }
      it 'throws an error when the os is unix' do
        expect { driver.create(state) }.to raise_error(
          Kitchen::UserError, /Error. Only windows is supported./
        )
      end
    end

    context 'instances are available, happy path' do
      it 'sets the machine name based on poolsclosed' do
        allow(driver).to receive(:poolsclosed_machine).and_return('mynewbox')
        driver.create(state)
        expect(state).to include(hostname: 'mynewbox')
      end
    end

    context 'no remaining instances' do
      it 'raises an appropriate error' do
        allow(driver).to receive(:poolsclosed_machine).and_return(nil)
        expect { driver.create(state) }.to raise_error(
          Kitchen::InstanceFailure, /Error, no available instances in poolsclosed/
        )
      end
    end

    context 'connection unavailable' do
      it 'raises an appropriate error' do
        stub_request(:get, "#{config[:poolsclosed_baseurl]}machine")
          .to_return(status: [500, 'FUUUCK'])

        expect { driver.create(state) }.to raise_error(
          Kitchen::InstanceFailure, /Error, could not obtain machine name from poolsclosed. Error code 500/
        )
      end
    end
  end

  describe '#destroy' do
    context 'connection available, happy path' do
      it 'calls delete in poolsclosed with hostname from state' do
        allow(driver).to receive(:poolsclosed_delete).and_return(true)
        expect { driver.destroy(state) }.to_not raise_error
      end

      it 'calls delete in state' do
        state[:hostname] = 'myawesomebox'
        allow(driver).to receive(:poolsclosed_delete).and_return(true)
        driver.destroy(state)
        expect(state).to_not include(hostname: 'myawesomebox')
      end
    end

    context 'connection unavailable' do
      it 'raises an appropriate error' do
        state[:hostname] = 'myawesomebox'
        stub_request(:any, "#{config[:poolsclosed_baseurl]}machine?machineName=myawesomebox")
          .to_return(status: [500, 'FUUUCK'])
        expect { driver.destroy(state) }.to raise_error(
          Kitchen::InstanceFailure, /Error, could not delete machine from poolsclosed. Error code 500/
        )
      end
    end
  end
end
