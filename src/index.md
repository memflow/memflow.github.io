# [memflow](https://github.com/memflow/memflow) - machine introspection framework

[![Crates.io](https://img.shields.io/crates/v/memflow.svg)](https://crates.io/crates/memflow)
![build and test](https://github.com/memflow/memflow/workflows/Build%20and%20test/badge.svg?branch=dev)
[![codecov](https://codecov.io/gh/memflow/memflow/branch/master/graph/badge.svg?token=XT7R158N6W)](https://codecov.io/gh/memflow/memflow)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Discord](https://img.shields.io/discord/738739624976973835?color=%20%237289da&label=Discord)](https://discord.gg/afsEtMR)

memflow is a library that allows live memory introspection of running systems and their snapshots. Due to its modular approach it trivial to support almost any scenario where Direct Memory Access is available.

The very core of the library is a [PhysicalMemory](https://docs.rs/memflow/latest/memflow/mem/phys_mem/trait.PhysicalMemory.html) that provides direct memory access in an abstract environment. This object that can be defined both statically, and dynamically with the use of the `inventory` feature. If `inventory` is enabled, it is possible to dynamically load libraries that provide Direct Memory Access.

Through the use of OS abstraction layers, like [memflow-win32](https://github.com/memflow/memflow-win32), user can gain access to virtual memory of individual processes, by creating objects that implement [MemoryView](https://docs.rs/memflow/latest/memflow/mem/memory_view/trait.MemoryView.html).

Bridging the two is done by a highly throughput optimized virtual address translation function, which allows for crazy fast memory transfers at scale.

The core is architecture independent (as long as addresses fit in 64-bits), and currently both 32, and 64-bit versions of the x86 family are available to be used.

For non-rust libraries, it is possible to use the [FFI](https://github.com/memflow/memflow/tree/main/memflow-ffi) to interface with the library.
