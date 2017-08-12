describe UserAuthenticationService::RequestProviderBuilder do
  let(:raw_request) do
    {
      'provider' => provider
    }
  end

  describe '.build' do
    context 'when it is a google request' do
      let(:provider) { 'google_oauth2' }
      let(:request_google) { double('request_google') }

      before do
        allow(UserAuthenticationService::RequestGoogle).to receive(:new)
          .with(raw_request).and_return(request_google)
      end

      it 'initializes RequestGoogle with raw_request' do
        expect(described_class.build(raw_request)).to eq(request_google)
      end
    end

    context 'when it is a facebook request' do
      let(:provider) { 'facebook' }
      let(:request_facebook) { double('request_facebook') }

      before do
        allow(UserAuthenticationService::RequestFacebook).to receive(:new)
          .with(raw_request).and_return(request_facebook)
      end

      it 'initializes RequestFacebook with raw_request' do
        expect(described_class.build(raw_request)).to eq(request_facebook)
      end
    end
  end
end
