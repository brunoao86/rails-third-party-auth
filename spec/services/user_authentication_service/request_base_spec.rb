describe UserAuthenticationService::RequestBase do
  required_methods = %i(
    provider
    uid
    user_name
    user_gender
    user_email
    user_image_url
    user_locale
    credentials_token
    credentials_expiration
    valid?
  )

  describe 'attr_readers' do
    required_methods.each do |method|
      it { expect(subject).to respond_to(method) }

      describe "##{method}" do
        it { expect{subject.send(method)}.to raise_error(NoMethodError) }
      end
    end
  end
end
