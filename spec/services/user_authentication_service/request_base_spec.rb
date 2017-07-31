require "spec_helper"

describe UserAuthenticationService::RequestBase do
  describe 'attr_readers' do
    it { expect(subject).to respond_to(:provider) }
    it { expect(subject).to respond_to(:uid) }
    it { expect(subject).to respond_to(:user_name) }
    it { expect(subject).to respond_to(:user_gender) }
    it { expect(subject).to respond_to(:user_email) }
    it { expect(subject).to respond_to(:user_image) }
    it { expect(subject).to respond_to(:user_locale) }
    it { expect(subject).to respond_to(:credentials_token) }
    it { expect(subject).to respond_to(:credentials_expiration) }
  end

  describe '#valid?' do
    it { expect{subject.valid?}.to raise_error(NoMethodError) }
  end
end
