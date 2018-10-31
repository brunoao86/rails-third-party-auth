# Rails third-party auth

A base Ruby on Rails application with the following third-party authentication: Google, Facebook, Twitter, LinkedIn and Github.

## Demo

https://rails-third-party-auth.herokuapp.com/

*Note:* This demonstration page is hosted by [Heroku](https://www.heroku.com) (:heart:) on a
free account, so, maybe it will take some seconds to load.


## Motives

I started this app because I wanted to make it easier to start new projects without
worrying myself about the authentication and to help others with code references and
[wiki tutorials](https://github.com/brunoao86/rails-third-party-auth/wiki).

And also, because:

- My first open source project! \o/

- To practice English (Please, forgive me in advance for any mistake! xD)

- Let's share experiences to improve our programming skils

## Getting Started

Ok, no more talking. Let's run this project on your local machine:

First of all, clone the repository on your dev folder:

```
git clone https://github.com/brunoao86/rails-third-party-auth.git
```

And then, enter on project's folder:

```
cd rails-third-party-auth
```

### For environments already prepared

If you are a Ruby on Rails developer, I suppose you have everything already
setted up.


So, your just have to install the all gems with bundler:

```
bundle
```

And run the project:

`rails server` or `rails s`

Or the tests:

`rake`

Now, the application is running but the login is **NOT** working. Why?
Well, I didn't put my personal keys from Google and Facebook on the code.
Go to [Configuring the application](#configuring-the-application) section and learn how to configure the application
with your own keys.

### Configuring Ruby on Rails environment

If this is your first Ruby on Rails application, you have more
commands to run but it's not a big deal.

I've tested this application only on *macOS Sierra* and *Linux Mint 17.1*.
I think you won't have problems to do the same on other distros and systems (*maybe
on windows*). Let me know if you had some problem. Here we go:

Follow theses steps to configure the environment:

- **Install RVM** (Ruby Version Manager - https://rvm.io/rvm/install)

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```

```
\curl -sSL https://get.rvm.io | bash
```

After this installation, please run `source ~/.bash_profile` or re-open your terminal
to load the rvm configuration properly.

- **Install Ruby**

Please, install a ruby version `>= 2.2.2`, for example:

```
rvm install ruby-2.4.1
```

- **Install Bundler**

On Mint / Ubuntu / Debian, run:

```
sudo apt-get install bundler
```

On macOs, with [Homebew](https://docs.brew.sh/Installation.html), run:

```
brew install bundler
```

- **Instal Node.js**


On Mint / Ubuntu / Debian, run:

```
sudo apt-get install nodejs
```

On macOs:

```
brew install node
```

We almost there! Now you have to install all the gems (dependence packages), running
the code below on the project's folder:

```
bundle
```

Finally, run the application with:

`rails server`

Check the application running at http://localhost:3000.

You must see the same login page of [demo](https://rails-third-party-auth.herokuapp.com/).


Now, as I said on the the previous section, the application is running but
the login is **NOT** working, right?

Go to the next section and learn how to make it work, configuring the application
with your own Google and Facebook keys.

## Configuring the application

Since your application is running properly, it is time to get your keys from Google
and Facebook!

I'm working on the Wiki with a lot of printscreens, but, as I didn't finish yet,
I will share the references that helped me:

### Google

Wiki: [How to configure Google Auth on the app](https://github.com/brunoao86/rails-third-party-auth/wiki/How-to-configure-Google-Auth-on-the-app)

### Facebook

Go to the developer page of Facebook:

- https://developers.facebook.com/apps/

And follow the **Step 1** of the post below from [Launch School](https://launchschool.com)
to configure your app and get your keys.
- [Integrate Facebook Graph APIs in Rails Applications](https://launchschool.com/blog/facebook-graph-api-using-omniauth-facebook-and-koala)

*Note:* Configure the *callback route* at the same way you did for Google.

### Twitter

Please, check the tutorial below, specially the section **Setting Up OmniAuth-Twitter**:
https://code.tutsplus.com/tutorials/twitter-sign-in-for-rails-application--cms-28097

My callback URL for the Heroku app is: https://rails-third-party-auth.herokuapp.com/auth/twitter/callback

If you are running it locally, your callback will be something like http://localhost:3000/auth/twitter/callback

### LinkedIn

Please, check the tutorial below to create your app on Linkedin:
https://auth0.com/docs/connections/social/linkedin

My callback URL for the Heroku app is: https://rails-third-party-auth.herokuapp.com/auth/linkedin/callback

If you are running it locally, your callback will be something like http://localhost:3000/auth/linkedin/callback

### GitHub

Please, check the tutorial below to create your app on GitHub:
https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/

My callback URL for the Heroku app is: https://rails-third-party-auth.herokuapp.com/auth/github/callback

If you are running it locally, your callback will be something like http://localhost:3000/auth/github/callback

### I have my keys. Now what?

Now it's the easiest part!

Just open the file [config/local_env.yml](https://github.com/brunoao86/rails-third-party-auth/blob/master/config/local_env.yml)
and put your keys for development environment.

And after that, stop the server and run it again.

The login with Google and Facebook must work like a charm! :sunglasses:

## Running the tests

The tests were implemented with [rspec-rails](https://github.com/rspec/rspec-rails).

Execute this command to run all the tests:

```
rake
```

The test coverage is managed by [simplecov](https://github.com/colszowka/simplecov).
To check the coverage run:

```
rake SIMPLE_COV=true
```

And then open the generated file with:

```
open coverage/index.html
```

## Deployment

For now, I will just give you the link that helped me to set up everything on Heroku.

Believe me, it's pretty easy:

https://devcenter.heroku.com/articles/getting-started-with-rails5

## Contributing

Please, just be nice with others. Everybody was a learner once.

Don't be afraid to contribute, every difference and misunderstandings can be discussed.

This is a small project, my first one, so, any contribution will be enjoyed! :heart:


## Next steps

### Documentation

As I said, I'm working on the Wiki to explain more about:

- Configure your app on Facebook Developer, Twitter, LinkedIn and GitHub

- Deploying your app with Heroku

- How to add new third-party authentications
