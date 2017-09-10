describe UserPresenter do
  let(:user) { FactoryGirl.create(:user, gender: gender) }
  let(:gender) { 'male' }

  subject { described_class.new(user) }

  describe '#gender' do
    context 'when gender is defined' do
      it 'returns the translated gender' do
        expect(subject.gender).to eq('Male')
      end
    end

    context 'when gender is NOT defined' do
      let(:gender) { nil }

      it { expect(subject.gender).to be_nil }
    end
  end

  describe 'delegation behavior' do
    attributes = [
      :id, :provider, :uid, :name, :oauth_token, :oauth_expires_at, :created_at,
      :updated_at, :email, :image_url, :locale, :image
    ]

    attributes.each do |attribute|
      describe "##{attribute}" do
        it { expect(subject.send(attribute)).to eq(user.send(attribute)) }
      end
    end
  end
end
