require 'helper'

describe RememberMe::Model do
  before :all do
    class User
      include Mongoid::Document
      include RememberMe::Model
      def save(arg = {})
        true
      end
    end
    @model = User.new
  end

  it { expect(@model.fields.has_key? 'remember_created_at').to be_true }
  it { expect(@model.fields['remember_created_at'].options[:type]).to eq Time }
  it { expect(@model.respond_to? :remember_me!).to be_true }

  describe '#remember_me!' do
    before { @model.remember_me! }
    it { expect(@model.remember_created_at.class).to eq Time }
  end

  describe '#forget_me!' do
    it { expect(@model.respond_to? :forget_me!).to be_true }
  end
end
