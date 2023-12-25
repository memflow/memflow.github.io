# Announcing memflow 0.2.0

Today, we are proud to release the first stable version of memflow 0.2! 3 years in the making, this
is certainly a monumental release. In this post, we will go through the key changes to the fastest
and most flexible physical memory introspection and forensics framework to date.

## Key changes

### 0. [memflowup](https://github.com/memflow/memflowup)

Not a library change, but the ecosystem change! We now have a rust-written memflowup utility that
makes it much easier to manage your memflow installation. Key features:

- Download binary builds (optional).
- Split between stable and dev versions.
- Custom install scripts, for more complicated plugins
  - Used by [`memflow-kvm`](https://github.com/memflow/memflow-kvm) for DKMS install.
  - Entry point for these is `install.rhai` script at the root of the package's repo.

You can get started with memflowup by running the following:

```
> curl --proto '=https' --tlsv1.2 -sSf https://sh.memflow.io | sh
```

### 1. OS layers and modularity

With the advent of 0.2 series, we now abstracted most of `memflow-win32` functionality behind
shared set of traits. These traits allow the user to interact with the operating system in unified
manner. In addition, we now made OS a plugin, just as Connectors were in 0.1! And finally, we do
indeed have multiple OS backends available, right now:

- [`memflow-win32`](https://github.com/memflow/memflow-win32), for Windows analysis, given physical
  memory access.
- [`memflow-native`](https://github.com/memflow/memflow-native), for syscall based interaction with
  the running operating system.
- WIP: `memflow-linux`
  - Don't expect much anytime soon, because the challenge of cross-version, zero-knowledge linux
    support is a tricky one.

With this, OS-independent code that works with `memflow-win32`, should also work on local OS. Here's
an example of such code:

```rust
use memflow::prelude::v1::*;

// We don't care what type of process we get, so long as it's a process
fn module_address(process: &mut impl Process, module: &str) -> Result<Address> {
    let module = process.module_by_name(module)?;
    Ok(module.base)
}
```

In addition, modularization of operating systems allows for greater portability of connectors. For
instance, we have now split `memflow-qemu-procfs` into
[`memflow-qemu`](https://github.com/memflow/memflow-qemu), which (optionally) accepts an OS layer.
This way, you can not only analyze QEMU VMs running on your computer, but you can also open them up
in a nested way on a machine that is already being analyzed through DMA. As seen in this chart:

```asciirend
dynamic_w = true
dynamic_h = false
fov = 4.5
ortho = true
disable_zoom = true
# Scene:
{
    "camera_props": {
        "proj_mode": "Orthographic",
        "fov": 1.0,
        "near": 0.01,
        "far": 100.0
    },
    "camera_controller":{"fov_y":1.0,"focus_point":[0.0,0.0,0.0],"rot":[-0.19996414, -0.08282786, 0.37361234, 0.90197986],"dist":2.0,"in_motion":"None","scroll_sensitivity":0.02,"orbit_sensitivity":1.0,"last_down":false,"pressed":false},
    "objects":[
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                0.0,0.0,0.0,1.0
            ],
            "material":0,
            "ty":{
                "Primitive":{
                    "Line":{
                        "start":[-0.75,0.0,1.5,1.0],
                        "end":[-0.25,0.0,0.5,1.0]
                    }
                }
            }
        },
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                0.0,0.0,0.0,1.0
            ],
            "material":0,
            "ty":{
                "Primitive":{
                    "Line":{
                        "start":[-0.25,0.0,0.5,1.0],
                        "end":[0.25,0.0,-0.5,1.0]
                    }
                }
            }
        },
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                0.0,0.0,0.0,1.0
            ],
            "material":0,
            "ty":{
                "Primitive":{
                    "Line":{
                        "start":[0.25,0.0,-0.5,1.0],
                        "end":[0.75,0.0,-1.5,1.0]
                    }
                }
            }
        },
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                -0.75,0.0,1.5,1.0
            ],"material":1,"ty":{"Cube":{"size":[1.0,1.0,0.5]}},"text":"memflow-kvm"
        },
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                -0.25,0.0,0.5,1.0
            ],"material":1,"ty":{"Cube":{"size":[1.0,1.0,0.5]}},"text":"memflow-win32"
        },
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                0.25,0.0,-0.5,1.0
            ],"material":1,"ty":{"Cube":{"size":[1.0,1.0,0.5]}},"text":"memflow-qemu"
        },
        {
            "transform":[
                1.0,0.0,0.0,0.0,
                0.0,1.0,0.0,0.0,
                0.0,0.0,1.0,0.0,
                0.75,0.0,-1.5,1.0
            ],"material":1,"ty":{"Cube":{"size":[1.0,1.0,0.5]}},"text":"memflow-win32"
        }
    ],
    "bg":{"color":[0.0,0.0,0.0]},
    "dithering":{"count_frames":false,"frame_cnt":4181}
}
```

### 2. Stable ABI

In 0.1, the Connectors were turned into plugins through use of Rust trait objects. This was an okay
solution at the time, however, we knew that it was not a safe one - changes in Rust versions could
change the layout of those trait objects, leading to crashes or other misbehavior, in case of
mismatch of plugin's `rustc` version and the one of the user's code. While the layout has remained
stable most of the time, the tides started to shift a few years ago, as more effort was put into
trait objects on the compiler front.

For 0.2, we knew we could not keep the status quo, so, we built `cglue`. The crate allows for
simple and flexible ABI safe code generation, suited for the needs of `memflow`. Throughout the
(very long) beta period, we received 0 crash reports stemming from ABI instability, while 0.1 had
such cases. Therefore, we can conclude that it was a good investment that already made memflow more
stable.

In `0.2.0-betaX` series, you may have encountered "invalid ABI" errors, well, fear not, because in
stable series, we commit to not breaking the ABI across entirety of `0.2` series, so this problem
should be a thing of the past for most users.

### 3. Memory constrained vtop

memflow 0.2 introduces the most scalable virtual address translation backend, period. The backend
is able to walk entire page tree in milliseconds, targeting any modern memory architecture (x86 and
ARM support out-of-the box, sufficient building blocks for RISC-V). In addition, compared to 0.1,
the new backend uses fixed-size buffers, meaning RAM usage will no longer blow up on large
translation ranges.

### 4. 64-bit and 128-bit address spaces, on all architectures

We now support analyzing 64-bit operating systems on 32-bit machines. In addition, if there was a
theoretical 128-bit architecture, we would support that as well. However, it's more of a PoC and we
do not expect this to be needed in the foreseeable future.

The support can be toggled through `64_bit_mem` (default) and `128_bit_mem` features. Do note that
these feature toggles do change memflow's ABI and it should not be possible to mix the plugin
features.

### 5. Shared `MemoryView`

In 0.1, we have had a split between physical and virtual memory. The reason for the split is
caching - we wish minimize latency by caching read-only memory in high-latency scenarios.
However, to tell the cache what mode the memory is in (readable/writeable/executable), you must add
metadata with each request. Meanwhile, this metadata may only be filled in by the virtual address
translation backend.

If user submits an I/O operation - they can't possibly know whether the request is going to a
read-only, or a writeable page, therefore they just submit `UNKNOWN` page flags. This is
complicated, therefore, we have lowered the gap between virtual and physical memory access through
use of `MemoryView` trait. This trait not only removes the need for the user to explicitly submit
the page flags, but also brings all I/O helpers that existed in virtual memory contexts. To use
`MemoryView` on physical memory, just use the `phys_view` function:

```rust
use memflow::prelude::v1::*;

fn main() -> Result<()> {
    let inventory = Inventory::scan();
    let mut conn = inventory.create_connector("dummy", None, None)?;

    // Create a physical memory view
    let mut view = conn.phys_view();

    // Read from phys addr 0
    let value: u64 = view.read(0.into())?;

    Ok(())
}
```

### 6. C and C++ are now first-class citizen

The FFI is now automatically generated using `cbindgen` and `cglue-bindgen`. It may initially seem
like a downgrade, however, this way we can ensure entirety of memflow's plugin-focused API surface
can be both accessed, and implemented by foreign languages, such as C and C++.

The key to using the new FFI, is reading Rust documentation and examples, and then finding the
function equivalents in the headers. There are a few quirks here and there, but after understanding
them, using the FFI should not be hard. For inspiration, see the following:

- [C examples](https://github.com/memflow/memflow/tree/0.2.0/memflow-ffi/examples/c)
- [C++ examples](https://github.com/memflow/memflow/tree/0.2.0/memflow-ffi/examples/cpp)
- [CMake template](https://github.com/memflow/memflow-cmake-example)

## Side projects

`memflow` is as useful as the projects utilizing it. To get started with the new version faster,
you may want to have a look at some of them. Here's the list of first-party releases:

- [`reflow`](https://github.com/memflow/reflow) - execute code on top of virtual memory.
- [`scanflow`](https://github.com/memflow/scanflow) - basic CheatEngine features in a command line
  interface.
- [`cloudflow`](https://github.com/memflow/cloudflow) (WIP) - flexible filesystem based way to
  interact with memflow.
- [`memflow-py`](https://github.com/memflow/memflow-py) - python bindings for memflow (courtesy of
  emesare).

## Reflection

0.2 took way longer than we originally anticipated. This is mostly due to changing living
conditions and the fact that both ko1N and I are only working on the project in hobbyist capacity.
In addition, we pushed for perfection from documentation and implementation front - a feat
infeasible at the current point. We do believe memflow is the framework that is going to bring the
most empowerement to users, however, there are still ways to go.

## Next up - Async Metamorphosis

Next, we will work towards integrating [`mfio`](https://github.com/memflow/mfio) into memflow,
which will enable higher scalability and simplicity. The key change is going to be transition from
synchronous to asynchronous API. There are still a lot of open questions regarding this, such as
FFI handling, how much the individual pieces of memflow's code will have to change, and how
multithreading needs to be handled. However, we are confident those questions are not impossible
to solve. Once the metamorphosis is done, we can consider the structure of memflow done. What comes
afterwards, is rapid feature development. It will definitely be an exciting time to be alive. So
let's just get there, shall we?

\- h33p
