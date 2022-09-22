<p align="center">
  <img src="assets/resources/deborah_256.png" alt="deb-get">
  <br />
  <tt>deborah</tt>
</p>

<p align="center">
  <b>
    A <tt>Flutter</tt> front-end for <tt>deb-get</tt>.
  </b>
</p>

<h2 align="center"></h2>
<p align="center" style="color: red;"><b>WARNING</b></p>
<p align="center">
    <tt>deborah</tt> is still in its early stage of infancy. There are things that may not work properly. If so, keep calm, and send a pull request ! 
</p>

## Introduction

`deborah` brings the functionallities of [deb-get](https://github.com/wimpysworld/deb-get) to all desktop users.

------------------------------------

## Installation

Since `deborah` uses [deb-get](https://github.com/wimpysworld/deb-get), you first need to install that. 

Then, download the .deb from the [release](https://github.com/ymauray/deborah/releases) page, and install it using this command :
```sh
$ sudo apt install ./deborah_xxxxxx.deb
```

You can install `deborah` using [deb-get](https://github.com/wimpysworld/deb-get) it with this command :

```sh
$ sudo deb-get install deborah
```

------------------------------------

## Usage

Run `deborah` from your applications menu. It will run `deb-get` to get the list of all packages available, and present them in a nice, searchable list.

You can expand a package to see its description, and install or uninstall it with the click of a button.

In the left side menu, you will find a button to check for updates. It will run `deb-get` again, and display a list of packages that can be updated.

You can also use a specific version of `deb-get` instead of the one in your current path.

------------------------------------

## Contributing

Contributions are welcome, however, some rules must be followed to prevent chaos.

1. **All commits must be signed.** Although this might be seen as a barrier for contributors, it is  something that must be done only once, and that will bring value to any future contribution. 
2. **Pull requests should be named properly.** Again, what can be seen as an hindrance will, in the long run, improve the quality of the contributions, and shorten the time it takes to merge relevent pull requests.

**Signing your commits**

Have a look at the [github documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits), you will find everything you need. If you use [GitKraken](https://www.gitkraken.com/) - and you should - then it will help you create your keys and set everything up for you.

**Naming your pull requests**

We use the [Conventional Commits](https://www.conventionalcommits.org) specification to check that the pull request - not the individual commits - are properly named. For that, we use a GitHub action that will check the pull request automatically.

Examples for valid PR titles:
 - fix: Correct typo.
 - feat: Add support for Node 12.
 - refactor!: Drop support for Node 6.
 - feat(ui): Add Button component.

Note that since PR titles only have a single line, you have to use the ! syntax for breaking changes.

Available types:
 - feat: A new feature
 - fix: A bug fix
 - docs: Documentation only changes
 - style: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
 - refactor: A code change that neither fixes a bug nor adds a feature
 - perf: A code change that improves performance
 - test: Adding missing tests or correcting existing tests
 - build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
 - chore: Other changes that don't modify src or test files
 - revert: Reverts a previous commit
