# Quick start guide

## 1. Binary Installation

// TODO: provide linux/mac packages (aur, homebrew) and windows binaries

Currently, only source installation is available, so please follow the next section.

## 2. Compiling from Source

### 2.0. Prerequisites

memflow is written entirely in [Rust](https://www.rust-lang.org/). It is therefore required to have a Rust toolchain installed. memflow is verified to compile on the stable toolchain of Rust 1.45.1.

More information on how to install Rust can be obtained from the [rustup project website](https://rustup.rs/).

### 2.1. Connectors

Recommended way to manage multiple connectors is through the [memflowup](https://github.com/memflow/memflowup) utility. It requires [Python 3](https://www.python.org/).

#### 2.1.1. Linux / macOS in one line

```bash
$ curl -L https://raw.githubusercontent.com/memflow/memflowup/master/memflowup.py | python3
```

#### 2.1.2. With Git

Clone and run the script:

```bash
$ git clone https://github.com/memflow/memflowup.git
$ cd memflowup
$ python3 memflowup.py
```

Update installed connectors:

```bash
$ python3 memflowup.py update
```

### 2.2. CLI

#### 2.2.1 Client

Install the client:

```bash
$ cargo install --git https://github.com/memflow/memflow-cli/ memflow-cli
```

(If running local daemon) By default, memflow socket is only accessible to the memflow group, create it, and add your user:

```bash
$ sudo groupadd memflow
$ sudo usermod -aG memflow (username)
```

You will need to logout for the group changes to be applied
#### 2.2.2 Daemon

Daemon is currently only supported on Unix systems.

Install the daemon and create initial config:

```bash
$ cargo install --git https://github.com/memflow/memflow-cli/ memflow-daemon
$ sudo mkdir -p /etc/memflow/
$ curl -L https://raw.githubusercontent.com/memflow/memflow-cli/master/daemon.conf | sudo tee /etc/memflow/daemon.conf
```

## 3. Running in Docker

// TODO: implement + describe docker setup

## 4. The command-line interface

// TODO: show cli usage

## 5. Working with the library

// TODO: write and explain examples 
