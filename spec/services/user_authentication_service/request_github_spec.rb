describe UserAuthenticationService::RequestGithub do
  let(:raw_request) { spy('raw_request', env: raw_request_env) }

  let(:raw_request_env) do
    {
      "omniauth.auth" => request_auth
    }
  end

  let(:request_auth) { double('request_auth') }

  subject { described_class.new(raw_request) }

  it { expect(subject).to be_a_kind_of(UserAuthenticationService::RequestBase) }

  describe 'initialization' do
    describe 'request_auth' do
      it { expect(subject.instance_variable_get(:@request_auth)).to eq(request_auth) }
    end
  end

  describe '#request_auth' do
    it { expect(subject.request_auth).to eq(request_auth) }
  end

  describe '#provider' do
    it { expect(subject.provider).to eq('github') }
  end

  describe 'dependents from request_auth' do
    let(:request_auth_obj) do
      JSON.parse(request_auth.to_json, object_class: OpenStruct)
    end

    let(:request_auth) do
      {
        uid: 'dummy uid',
        info: {
          name: 'dummy name',
          email: 'dummy email',
          image: 'dummy_raw_image_url',
        },
        extra: {
          access_token: {
            consumer: {
              key: dummy_request_token_value
            }
          }
        },
        credentials: {
          token: 'dummy token'
        }
      }
    end

    let(:dummy_request_token_value) { 'dUmmy_r3qu3st_t0k3n' }

    before { allow(subject).to receive(:request_auth).and_return(request_auth_obj) }

    describe '#uid' do
      it { expect(subject.uid).to eq('dummy uid') }
    end

    describe '#user_name' do
      it { expect(subject.user_name).to eq('dummy name') }
    end

    describe '#user_gender' do
      it { expect(subject.user_gender).to eq('') }
    end

    describe '#user_email' do
      it { expect(subject.user_email).to eq('dummy email') }
    end

    describe '#raw_image_url' do
      it { expect(subject.raw_image_url).to eq('dummy_raw_image_url') }
    end

    describe '#credentials_token' do
      it { expect(subject.credentials_token).to eq('dummy token') }
    end

    describe 'dependents from request_strategy' do
      before do
        allow(subject).to receive(:request_strategy).and_return(request_strategy_obj)
      end

      let(:request_strategy_obj) do
        JSON.parse(request_strategy.to_json, object_class: OpenStruct)
      end

      let(:request_strategy) do
        {
          options: {
            client_id: 'dummy request token',
          }
        }
      end

      describe '#request_validation_token' do
        it do
          expect(subject.request_validation_token).to eq('dummy request token')
        end
      end
    end
  end

  describe '#user_image_url' do
    before { allow(subject).to receive(:raw_image_url).and_return(raw_image_url) }

    context 'when raw_image_url is defined' do
      let(:raw_image_url) { 'http://dummy_raw_url' }

      it { expect(subject.user_image_url).to eq('http://dummy_raw_url?size=200') }
    end

    context 'when raw_image_url is NOT defined' do
      let(:raw_image_url) { '' }

      it { expect(subject.user_image_url).to be_nil }
    end
  end

  describe '#valid?' do
    let(:dummy_token) { 'dUmmy_r3qu3st_t0k3n' }

    before do
      allow(subject).to receive(:request_validation_token).and_return(dummy_token)
      ENV['GITHUB_CLIENT_ID'] = 'dUmmy_r3qu3st_t0k3n'
    end

    context 'when request validation token is equal to the environment' do
      it { expect(subject.valid?).to eq(true) }
    end

    context 'when request validation token is NOT equal to the environment' do
      let(:dummy_token) { 'd1ff3r3nt_dUmmy_r3qu3st_t0k3n' }

      it { expect(subject.valid?).to eq(false) }
    end
  end
end
