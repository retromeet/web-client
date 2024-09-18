# RetroMeet

RetroMeet is a free, open-source dating and friend-finding application. RetroMeet has a philosophy of giving more space to give more information about yourself and to help find people who share common interests with you. The whole philosophy of RetroMeet is described in [the philosophy](https://github.com/renatolond/retromeet-core/blob/main/docs/the_philosophy.md).

This repository contains the RetroMeet web client. You need a working RetroMeet core running locally or remotely on the web to be able to use this repository.

This client is made thinking you can only use one RetroMeet user at a time, you can however log in to any RetroMeet server.

## Development

RetroMeet is written in Ruby. Currently, instructions are only available to run RetroMeet without any kind of virtualization. Feel free to submit a PR to add to our instructions ;)

### Linting

We use Rubocop for linting. To make your experience easier, it's recommended that you enable rubocop in your IDE, depending on your IDE the way to do that might be different, but most of the Ruby Language servers support rubocop, so you should be able to enable it whether you're using NeoVim or VScode.

There's a [pronto](https://github.com/prontolabs/pronto) github action running on each pull request that will comment on any forgotten lint issues. You can also get ahead of it by enabling [lefthook](https://github.com/evilmartians/lefthook), you can do it by running locally: `lefthook install --force`. The `--force` is optional, but will override any other hooks you have in this repo only, so it should be safe to run. This will run pronto any time you try to push a branch.

### Setup

RetroMeet Web will connect to a RetroMeet instance. If you want to run everything locally, follow the steps to run [retromeet-core](https://github.com/renatolond/retromeet-core/tree/main?tab=readme-ov-file#development), and then you should be able to connect to it normally.

You can install dependencies with `./bin/setup` and then you can run the server with `./bin/dev`.
