# Quick start guide

Here you can find quick-start guides to run memflow on [Windows](#windows) and [Linux](#linux).

## Linux

### 1. Installing memflowup

Please make sure that rustup and cargo are properly installed on your system and cargo has at least version 1.70.0. You can verify the version via:
```
> cargo --version
cargo 1.74.1 (ecb9851af 2023-10-18)
```
In case your cargo/rust version is outdated you can instruct `rustup` to update your toolchain:
```
> rustup update
info: syncing channel updates for 'stable-x86_64-pc-windows-msvc'
info: syncing channel updates for 'nightly-x86_64-pc-windows-msvc'
info: checking for self-update

  stable-x86_64-pc-windows-msvc unchanged - rustc 1.74.1 (a28077b28 2023-12-04)
  nightly-x86_64-pc-windows-msvc unchanged - rustc 1.76.0-nightly (a96d57bdb 2023-12-15)

info: cleaning up downloads & tmp directories
```

After setting up cargo properly you can install memflowup via our install script:
```
> curl --proto '=https' --tlsv1.2 -sSf https://sh.memflow.io | bash
```

Alternatively you can install memflowup via cargo:
```
> cargo install memflowup --force
...
Installed package `memflowup v0.1.0` (executable `memflowup.exe`)
```

#### Note
memflowup should __not__ be installed or ran as root or via sudo. By default rust installs cargo and all binaries installed via cargo on a per-user basis. This means running the installation as root will result in memflowup being placed in `/root/` (because it is the root user's home directory) and will also only be accessible from the root user.

### 2. Installing plugins

When running `memflowup` for the first time it is recommended to use the interactive mode and install memflow from the stable branch.

Installing packages system-wide will place all plugins in `/usr/local/lib/memflow`.\
Installing packages per user will place all plugins in `$HOME/.local/lib/memflow`.

You might also want to build all packages from source for now.

memflow will later automatically look in both of those directories (and the current working directory) for plugins.

Please make sure to __not__ run memflow as root (see the [note](#note) above)
```
> memflowup interactive
do you want to build packages from source? [y/N]: y 
Running in interactive mode. You can always re-run memflowup to install additional packages, or to different paths.
do you want to install the initial packages system-wide? [Y/n]: n
which channel do you want to use? [stable/DEVELOPMENT]: development
Available packages in dev channel:
0. memflow-win32 - CorePlugin
1. memflow-native - CorePlugin
2. memflow-qemu - CorePlugin
3. memflow-coredump - CorePlugin
4. memflow-pcileech - CorePlugin

Type packages to install by number, name, or type * for all:
*

...
Initial setup done!
```

It is always possible to re-run interactive mode and redo the initial setup.

### 2. Updating plugins

To update all the installed plugins simply run `memflowup update`:
```
> memflow update --help
Updates all installed packages

Usage: memflowup update [OPTIONS]

Options:
      --ignore-user-index
      --ignore-upstream-index
      --ignore-builtin-index
  -s, --system                 Enables system-wide installation for all users
  -d, --dev
  -h, --help                   Print help
```

In case you installed the plugins like in the example above you can simply use the development branch and install them non system-wide:
```
> memflowup update -d
```

### 3. Verify your installation and run an example

To test if everything is working properly the easiest method is to simply
use one of the [examples](https://github.com/memflow/memflow/tree/stable/memflow/examples) provided in memflow.

To run the examples simply check out the memflow repo with the appropiate version:
```
> git clone --depth 1 --branch stable https://github.com/memflow/memflow
> cd memflow
```

You can safely ignore the warning about the 'detached HEAD' state. This happens because we are checking out a specific tag in the memflow repo.

And run one of the examples:
```
> cargo run --example process_list -- --os native
```
This examples runs the process_list example (which just lists all processes on the system) using the [`memflow-native`](https://github.com/memflow/memflow-native) plugin. This plugin simply proxies your local OS calls to memflow (as in using [process_vm_readv](https://man7.org/linux/man-pages/man2/process_vm_readv.2.html) and [process_vm_writev](https://man7.org/linux/man-pages/man2/process_vm_writev.2.html)).

If everything went well you should see a list of all open processes:
```
> cargo run --example process_list -- --os native
  PID   SYS ARCH  PROC ARCH NAME

...
```


## Windows

### 1. Installing memflowup
Please make sure that rustup and cargo are properly installed on your system and cargo has at least version 1.70.0. You can verify the version via:
```
> cargo --version
cargo 1.74.1 (ecb9851af 2023-10-18)
```
In case your cargo/rust version is outdated you can instruct `rustup` to update your toolchain:
```
> rustup update
info: syncing channel updates for 'stable-x86_64-pc-windows-msvc'
info: syncing channel updates for 'nightly-x86_64-pc-windows-msvc'
info: checking for self-update

  stable-x86_64-pc-windows-msvc unchanged - rustc 1.74.1 (a28077b28 2023-12-04)
  nightly-x86_64-pc-windows-msvc unchanged - rustc 1.76.0-nightly (a96d57bdb 2023-12-15)

info: cleaning up downloads & tmp directories
```

After setting up cargo properly you can install memflowup via cargo:
```
> cargo install memflowup --force
...
Installed package `memflowup v0.1.0` (executable `memflowup.exe`)
```

### 2. Installing plugins

When running `memflowup` for the first time it is recommended to use the interactive mode and install memflow from the stable branch.

Installing packages system-wide will place all plugins in `%ProgramFiles%\memflow\`.\
Installing packages per user will place all plugins in `%UserProfile%\Documents\memflow\`.

You might also want to build all packages from source for now.

memflow will later automatically look in both of those directories (and the current working directory) for plugins.
```
> memflowup interactive
do you want to build packages from source? [y/N]: y 
Running in interactive mode. You can always re-run memflowup to install additional packages, or to different paths.
do you want to install the initial packages system-wide? [Y/n]: n
which channel do you want to use? [stable/DEVELOPMENT]: development
Available packages in dev channel:
0. memflow-win32 - CorePlugin
1. memflow-native - CorePlugin
2. memflow-qemu - CorePlugin
3. memflow-coredump - CorePlugin
4. memflow-pcileech - CorePlugin

Type packages to install by number, name, or type * for all:
*

...
Initial setup done!
```

It is always possible to re-run interactive mode and redo the initial setup.

### 2. Updating plugins

To update all the installed plugins simply run `memflowup update`:
```
> memflow update --help
Updates all installed packages

Usage: memflowup.exe update [OPTIONS]

Options:
      --ignore-user-index
      --ignore-upstream-index
      --ignore-builtin-index
  -s, --system                 Enables system-wide installation for all users
  -d, --dev
  -h, --help                   Print help
```

In case you installed the plugins like in the example above you can simply use the development branch and install them non system-wide:
```
> memflowup update -d
```

### 3. Verify your installation and run an example

To test if everything is working properly the easiest method is to simply
use one of the [examples](https://github.com/memflow/memflow/tree/stable/memflow/examples) provided in memflow.

To run the examples simply check out the memflow repo with the appropiate version:
```
> git clone --depth 1 --branch stable https://github.com/memflow/memflow
> cd memflow
```

You can safely ignore the warning about the 'detached HEAD' state. This happens because we are checking out a specific tag in the memflow repo.
In case you are missing git you can install it from [here](https://git-scm.com/download/win).

And run one of the examples:
```
> cargo run --example process_list -- --os native
```
This examples runs the process_list example (which just lists all processes on the system) using the [`memflow-native`](https://github.com/memflow/memflow-native) plugin. This plugin simply proxies your local OS calls to memflow (as in using [ReadProcessMemory](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-readprocessmemory) and [WriteProcessMemory](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory)).

If everything went well you should see a list of all open processes:
```
> cargo run --example process_list -- --os native
  PID   SYS ARCH  PROC ARCH NAME
    0   x86_64     x86_64   [System Process] () (Alive)
    4   x86_64     x86_64   System () (Alive)
  300   x86_64     x86_64   Secure System () (Alive)
  348   x86_64     x86_64   Registry () (Alive)
  952   x86_64     x86_64   smss.exe () (Alive)
 1316   x86_64     x86_64   csrss.exe () (Alive)
 1412   x86_64     x86_64   wininit.exe () (Alive)
 1420   x86_64     x86_64   csrss.exe () (Alive)
 1484   x86_64     x86_64   services.exe () (Alive)

...
```
