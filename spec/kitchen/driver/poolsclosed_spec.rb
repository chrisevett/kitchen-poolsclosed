require_relative '../../spec_helper'
require 'pry-byebug'
require 'logger'
require 'stringio'
require 'kitchen/driver/poolsclosed'
require 'kitchen/provisioner/dummy'
require 'kitchen/transport/dummy'
require 'kitchen/verifier/dummy'

describe Kitchen::Driver::PoolsClosed do
  let(:logged_output) { StringIO.new }
  let(:logger)        { Logger.new(logged_output) }
  let(:config)        { { kitchen_root: '/kroot' } }
  let(:platform)      { Kitchen::Platform.new(name: 'fooos-99') }
  let(:suite)         { Kitchen::Suite.new(name: 'suitey') }
  let(:verifier)      { Kitchen::Verifier::Dummy.new }
  let(:provisioner)   { Kitchen::Provisioner::Dummy.new }
  let(:transport)     { Kitchen::Transport::Dummy.new }
  let(:state_file)    { double('state_file') }
  let(:state)         { Hash.new }
  let(:env) { Hash.new }
  let(:driver_object) { Kitchen::Driver::PoolsClosed.new(config) }

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

  before(:all) do
    #Kitchen::Driver::PoolsClosed.instance_eval { include RunCommandStub }
  end

  before(:each) { stub_const('ENV', env) }

  describe 'configuration' do
    it 'requires a username' do
    end

    it 'requires a password' do
    end

    it 'requires a poolsclosed url' do
    end

    it 'only supports windows' do
    end
  end

  describe '#create' do
    it 'calls machine endpoint on poolsclosed' do
    end

    it 'sets the machine name based on output' do
    end

    it 'fails on "nil" return value' do
    end
  end

  describe '#destroy' do
    it 'calls delete endpoint on poolsclosed with machine name argument' do
    end

    it 'passes machine name to poolsclosed' do
    end
  end
end
