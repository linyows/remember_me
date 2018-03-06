require 'helper'

describe RememberMe::Model do
  before { @model = User.new }

  it { expect(@model.fields.has_key? 'remember_created_at').to be_truthy }
  it { expect(@model.fields['remember_created_at'].options[:type]).to eq Time }

  it { expect(@model.respond_to? :remember_me!).to be_truthy }
  it { expect(@model.respond_to? :forget_me!).to be_truthy }
  it { expect(@model.respond_to? :remember_expired?).to be_truthy }
  it { expect(@model.respond_to? :remember_expires_at).to be_truthy }
  it { expect(@model.respond_to? :rememberable_options).to be_truthy }
  it { expect(@model.respond_to? :rememberable_value).to be_truthy }

  describe '#remember_me!' do
    before { @model.remember_me! }
    it { expect(@model.remember_created_at.class).to eq Time }
  end

  describe '#forget_me!' do
    before do
      @model.remember_created_at = Time.now.utc
      @model.forget_me!
    end
    it { expect(@model.remember_created_at).to be_nil }
  end

  describe '#remember_expired?' do
    before { @model.remember_created_at = remember_created_at }
    subject { @model.remember_expired? }

    context 'when remembered' do
      context 'if expired' do
        let(:remember_created_at) { Time.now - 2.weeks }
        it { should be_truthy }
      end

      context 'if not expired' do
        let(:remember_created_at) { Time.now - 2.weeks + 1 }
        it { should be_falsey }
      end
    end

    context 'when not remembered' do
      let(:remember_created_at) { nil }
      it { should be_truthy }
    end
  end

  describe '#remember_expires_at' do
    before { @model.remember_created_at = remember_created_at }

    context 'when remembered' do
      let(:remember_created_at) { Time.now - 2.weeks }
      it { expect(@model.remember_expires_at).to eq (remember_created_at + 2.weeks) }
    end

    context 'when not remembered' do
      let(:remember_created_at) { nil }
      it { expect { @model.remember_expires_at }.to raise_error }
    end
  end

  describe '#rememberable_options' do
    let(:options) { User.rememberable_options }
    it { expect(@model.rememberable_options).to eq options }
  end

  describe '#rememberable_value' do
    let(:hash) { Digest::SHA1.hexdigest "#{@model.id}" }
    it { expect(@model.rememberable_value).to eq hash }
  end

  describe '.serialize_into_cookie' do
    subject { User.serialize_into_cookie @model }
    it { expect(subject).to be_instance_of Array }
    it { expect(subject[0]).to eq @model.id }
    it { expect(subject[1]).to eq @model.rememberable_value }
  end

  describe '.serialize_from_cookie' do
    let(:id) { @model.id.to_s }
    let(:remember_token) { @model.rememberable_value }
    let(:expired) { false }
    before do
      User.stub_chain(:where, :first).and_return(@model)
      @model.stub(:remember_expired?).and_return(expired)
    end
    subject { User.serialize_from_cookie(id, remember_token) }
    it { expect(subject).to eq @model }
  end

  describe '.rememberable_options' do
    let(:options) { {} }
    it { expect(User.rememberable_options).to eq options }
  end

  describe '.remember_for' do
    subject { User.remember_for }
    it { should eq 2.weeks }
  end
end
