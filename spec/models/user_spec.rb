describe User do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }

  describe '#presenter' do
    let(:presenter) { double('presenter') }

    before { allow(UserPresenter).to receive(:new).with(subject).and_return(presenter) }

    it 'returns the user presenter' do
      expect(subject.presenter).to eq(presenter)
    end
  end
end
