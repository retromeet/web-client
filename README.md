<h1><picture>
  <img alt="RetroMeet Web logo" src="https://github.com/retromeet/web-client/blob/main/app/assets/images/retromeet_long.png?raw=true">
</picture></h1>

RetroMeet is a free, open-source dating and friend-finding application. RetroMeet has a philosophy of giving more space to give more information about yourself and to help find people who share common interests with you. The whole philosophy of RetroMeet is described in [the philosophy](https://github.com/renatolond/retromeet-core/blob/main/docs/the_philosophy.md).

This repository contains the RetroMeet web client. You need a working RetroMeet core running locally or remotely on the web to be able to use this repository.

This client is made thinking you can only use one RetroMeet user at a time, you can however log in to any RetroMeet server.

## Development

RetroMeet is written in Ruby. Currently, instructions are only available to run RetroMeet without any kind of virtualization. Feel free to submit a PR to add to our instructions ;)

### Linting

We use Rubocop for linting. To make your experience easier, it's recommended that you enable rubocop in your IDE, depending on your IDE the way to do that might be different, but most of the Ruby Language servers support rubocop, so you should be able to enable it whether you're using NeoVim or VScode.

There's a [pronto](https://github.com/prontolabs/pronto) github action running on each pull request that will comment on any forgotten lint issues. You can also get ahead of it by enabling [lefthook](https://github.com/evilmartians/lefthook), you can do it by running locally: `lefthook install --force`. The `--force` is optional, but will override any other hooks you have in this repo only, so it should be safe to run. This will run pronto any time you try to push a branch.

### Development Setup

RetroMeet Web will connect to a RetroMeet instance. If you want to run everything locally, follow the steps to run [retromeet-core](https://github.com/renatolond/retromeet-core/tree/main?tab=readme-ov-file#development), and then you should be able to connect to it normally.

You can install dependencies with `./bin/setup`.

You need to generate the OAuth2 variables to access RetroMeet core. To do so, you need to run:

```sh
bundle exec rails oauth_client:create
```

If this is successful, it will output the three variables you need to add to your `.env.development`

You can then run the server with `./bin/dev`.

### Deploying to production

RetroMeet web needs a core API running to work. You can deploy one by checking [the instructions](https://github.com/retromeet/core/blob/main/README.md#deploying-to-production).

You need to have Ruby installed, the same version as the one in [.ruby-version](./.ruby-version). We recommend using one of the [ruby manager](https://www.ruby-lang.org/en/documentation/installation/#managers) for that to make it easier to switch between versions if needed.

You want to configure bundler to ignore test and development dependencies:

```sh
bundle config set without 'development test'
```

Then, install dependencies with:

```sh
bundle install -j$(getconf _NPROCESSORS_ONLN)
```

Run the following command to generate a `secret_key_base`:

```sh
bundle exec rails secret
```

Then, copy the output of that (a long string) as the `SECRET_KEY_BASE` in your `.env.production` file.

You need to also set `LOCAL_DOMAIN` and `RETROMEET_CORE_HOST` on that file.

Finally, run the following command:


```sh
bundle exec rails oauth_client:create
```

If this is successful, it will output the three variables you need to add to your `.env.production`

Configure a reverse proxy and run the server with:

```sh
bundle exec falcon host falcon_host.rb
```

TODO: come back and explain nginx configuration, add systemctl unit etc
