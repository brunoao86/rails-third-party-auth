describe UserAuthenticationService::RequestGoogle do
  let(:raw_request) { spy('raw_request', env: raw_request_env) }
  let(:raw_request_env) do
    {
      "omniauth.auth" => google_response_obj
    }
  end
  let(:google_response_obj) do
    JSON.parse(google_response.to_json, object_class: OpenStruct)
  end
  let(:google_response) do
    {
      uid: 'dummy uid',
      info: {
        name: 'dummy name',
        email: 'dummy email',
        image: 'dummy image',
      },
      extra: {
        raw_info: {
          gender: 'dummy gender',
          locale: 'dummy locale'
        },
        id_info: {
          aud: dummy_request_token_value
        }
      },
      credentials: {
        token: 'dummy token',
        expires_at: 1501690375
      }
    }
  end
  let(:dummy_request_token_value) { 'dUmmy_r3qu3st_t0k3n' }

  subject { described_class.new(raw_request) }

  it { expect(subject).to be_a_kind_of(UserAuthenticationService::RequestBase) }

  describe 'initialization' do
    describe 'provider' do
      it { expect(subject.instance_variable_get(:@provider)).to eq('google') }
    end

    describe 'uid' do
      it { expect(subject.instance_variable_get(:@uid)).to eq('dummy uid') }
    end

    describe 'user_name' do
      it { expect(subject.instance_variable_get(:@user_name)).to eq('dummy name') }
    end

    describe 'user_gender' do
      it { expect(subject.instance_variable_get(:@user_gender)).to eq('dummy gender') }
    end

    describe 'user_email' do
      it { expect(subject.instance_variable_get(:@user_email)).to eq('dummy email') }
    end

    describe 'user_image' do
      it { expect(subject.instance_variable_get(:@user_image)).to eq('dummy image') }
    end

    describe 'user_locale' do
      it { expect(subject.instance_variable_get(:@user_locale)).to eq('dummy locale') }
    end

    describe 'credentials_token' do
      it do
        expect(subject.instance_variable_get(:@credentials_token)).to eq('dummy token')
      end
    end

    describe 'credentials_expiration' do
      it do
        expected = Time.at(1501690375)
        expect(subject.instance_variable_get(:@credentials_expiration)).to eq(expected)
      end
    end

    describe 'request_validation_token' do
      it do
        expected = 'dUmmy_r3qu3st_t0k3n'
        expect(subject.instance_variable_get(:@request_validation_token)).to eq(expected)
      end
    end
  end

  describe '#valid?' do
    before do
      ENV['GOOGLE_CLIENT_ID'] = 'dUmmy_r3qu3st_t0k3n'
    end

    context 'when request validation token is equal to the environment' do
      it { expect(subject.valid?).to eq(true) }
    end

    context 'when request validation token is NOT equal to the environment' do
      let(:dummy_request_token_value) { 'd1ff3r3nt_dUmmy_r3qu3st_t0k3n' }

      it { expect(subject.valid?).to eq(false) }
    end
  end
end
