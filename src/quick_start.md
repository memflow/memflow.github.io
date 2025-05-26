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

On Windows, install memflowup via cargo:
```
> cargo install memflowup --force
...
Installed package `memflowup v0.2.0` (executable `memflowup`)
```

#### Note
memflowup should __not__ be installed or ran as root or via sudo. By default rust installs cargo and all binaries installed via cargo on a per-user basis. This means running the installation as root will result in memflowup being placed in `/root/` (because it is the root user's home directory) and will also only be accessible from the root user.

### 2. Installing plugins

To get started quickly, you can pull all available plugins from the default registry:

```
> memflowup pull --all
```

This will download and install all memflow plugins from the registry (http://registry.memflow.io).

You can also view available plugins before installing:
```
> memflowup registry ls
```

Or install specific plugins:
```
> memflowup pull win32
> memflowup pull native
> memflowup pull qemu
```

To see what plugins are currently installed locally:
```
> memflowup plugins ls
```

memflow will automatically look for plugins in the installation directories and the current working directory.

Please make sure to __not__ run memflow as root (see the [note](#note) above).

### 3. Building plugins from source (optional)

If you prefer to build plugins from source, you can install directly from GitHub repositories:

```
> memflowup build https://github.com/memflow/memflow-coredump
```

Or build from a local folder:
```
> cd memflow-coredump
> memflowup build -p .
```

### 4. Updating plugins

To update all installed plugins, simply run:
```
> memflowup pull --all
```

You can also clean up old versions of plugins:
```
> memflowup plugins clean
```

### 5. Verify your installation and run an example

To test if everything is working properly the easiest method is to simply
use one of the [examples](https://github.com/memflow/memflow/tree/main/memflow/examples) provided in memflow.

To run the examples simply check out the memflow repo:
```
> git clone https://github.com/memflow/memflow
> cd memflow
```

And run one of the examples:
```
> cargo run --example process_list -- --os native
```
This example runs the process_list example (which just lists all processes on the system) using the [`memflow-native`](https://github.com/memflow/memflow-native) plugin. This plugin simply proxies your local OS calls to memflow (as in using [process_vm_readv](https://man7.org/linux/man-pages/man2/process_vm_readv.2.html) and [process_vm_writev](https://man7.org/linux/man-pages/man2/process_vm_writev.2.html)).

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

The recommended way to install memflowup is through our automated script:
```
> curl --proto '=https' --tlsv1.2 -sSf https://sh.memflow.io | bash
```

Alternatively you can install memflowup via cargo:
```
> cargo install memflowup --force
...
Installed package `memflowup v0.2.0` (executable `memflowup.exe`)
```

### 2. Installing plugins

To get started quickly, you can pull all available plugins from the default registry:

```
> memflowup pull --all
```

This will download and install all memflow plugins from the registry (http://registry.memflow.io).

You can also view available plugins before installing:
```
> memflowup registry ls
```

Or install specific plugins:
```
> memflowup pull win32
> memflowup pull native
> memflowup pull qemu
```

To see what plugins are currently installed locally:
```
> memflowup plugins ls
```

memflow will automatically look for plugins in the installation directories and the current working directory.

### 3. Building plugins from source (optional)

If you prefer to build plugins from source, you can install directly from GitHub repositories:

```
> memflowup build https://github.com/memflow/memflow-coredump
```

Or build from a local folder:
```
> cd memflow-coredump
> memflowup build -p .
```

### 4. Updating plugins

To update all installed plugins, simply run:
```
> memflowup pull --all
```

You can also clean up old versions of plugins:
```
> memflowup plugins clean
```

### 5. Verify your installation and run an example

To test if everything is working properly the easiest method is to simply
use one of the [examples](https://github.com/memflow/memflow/tree/main/memflow/examples) provided in memflow.

To run the examples simply check out the memflow repo:
```
> git clone https://github.com/memflow/memflow
> cd memflow
```
In case you are missing git you can install it from [here](https://git-scm.com/download/win).

And run one of the examples:
```
> cargo run --example process_list -- --os native
```
This example runs the process_list example (which just lists all processes on the system) using the [`memflow-native`](https://github.com/memflow/memflow-native) plugin. This plugin simply proxies your local OS calls to memflow (as in using [ReadProcessMemory](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-readprocessmemory) and [WriteProcessMemory](https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-writeprocessmemory)).

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

## Additional Commands

For more advanced usage, memflowup provides several additional commands:

### Getting help
```
> memflowup help
```

### Managing plugins
```
# Remove a specific plugin
> memflowup plugins remove coredump

# List all locally installed plugins
> memflowup plugins ls

# Clean up old plugin versions
> memflowup plugins clean
```

### Working with registries
```
# List all available plugins in the registry
> memflowup registry ls

# Configure a custom registry
> memflowup config set registry http://my-registry.io
> memflowup config set pub_key_file /home/user/key_file.pub
```

All plugins in the memflow-registry are signed and the signature is checked by memflowup during the download process. Using a custom registry requires setting up the appropriate public key that was used for signing the files in the registry.

## Troubleshooting

### Mac OS Issues
If you are using Mac OS and encounter an error building proc-macro2, run:
```
> xcode-select --install
```

### Migrating from memflowup 0.1
If you're upgrading from an older version of memflowup:
1. Delete all system-wide installed plugins in `/usr/lib/memflow`
2. Delete all installed plugins for the current user in `~/.local/lib/memflow`
3. Delete the `/etc/memflowup` folder
4. Reinstall all plugins via `memflowup pull --all`
