<h2 align="center">
  <img src="assets/resources/deborah_128.png" alt="deb-get">
  <br />
  <tt>deborah</tt>
</h2>

<p align="center">
  <b>
    A <tt>Flutter</tt> front-end for <tt>deb-get</tt>.
  </b>
</p>

<h1 align="center"/>
<h2 align="center">
    <p style="color: red;"><b>WARNING</b>
</h2>
<p align="center">
    <tt>deborah</tt> is in early alpha stage, and should absolutely and definitely not be used in production.<br/>
    Some functionalities are missing, others are broken.
</p>
<h1 align="center">
    You've been warned.
</h1>

## Introduction

`deborah` brings the functionallities of [deb-get](https://github.com/wimpysworld/deb-get) to all desktop users.

## Installation

Since `deborah` uses [deb-get](https://github.com/wimpysworld/deb-get), you first need to install that. 

Then, you can install `deborah` with the following command:

```sh
$ sudo deb-get install deborah
```

## Usage

Run `deborah` from your applications menu. It will run `deb-get` to get the list of all packages available, and present them in a nice, searchable list.

You can expand a package to see its description, and install or uninstall it with the click of a button.

In the left side menu, you will find a button to check for updates. It will run `deb-get` again, and display a list of packages that can be updated.

You can also use a specific version of `deb-get` instead of the one in your current path.
