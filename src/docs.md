# Documentation

## 1. Introduction

At its core a program that is written using memflow usually consists of 4 layers.

connector backend ← memflow core ← memflow-[os] ← frontend code

- The connector is the interface that provides access to raw physical memory.
- The memflow core will provide higher-level functions to interface with virtual memory.
- The memflow-[os] module abstracts operating system specific functionality and encapsulates drivers, processes, and modules.
- The frontend code is the actual high-level implementation of the program logic.

## 2. Virtual Memory Translation

// TODO: describe how virtual memory translation works (in memflow)

## 3. What happens on initialization?

### 3.1. Windows targets

The initialization phase of memflow for a win32 target consists of the following stages:

### 1. Finding the START_BLOCK in physical memory.

The START_BLOCK of the operating system usually sits in the lower physical memory region and contains information about the DTB when windows is initialized.
Additionally, it contains an address that gives us a hint on where to find the actual ntoskrnl.exe.

### 2. Finding the ntoskrnl.exe in virtual memory

Using the DTB that we acquired in the previous step it is now possible to construct a virtual memory reader.
This reader is then being used to find a valid PE header for the “ntoskrnl.exe” binary.

### 3. Finding the GUID and WinVersion of the ntoskrnl.exe

Microsoft provides program databases (PDBs) for all of their released Windows kernels.
These PDB files contain all information required for debugging a program.
They are usually used in conjunction with WinDbg to analyze or debug a system directly.

We are mostly interested in struct member offsets that are contained in those PDBs.
For this purpose memflow has a built-in feature that downloads and loads those PDB files to find the appropiate offsets for the current windows installation.
It is mandatory to acquire the GUID of the ntoskrnl.exe to acquire the proper PDB.

On top of that memflow will try and fetch the version and build-number of windows.
This build number is updated less frequently and is not as accurate as using the PDB directly.
This windows version can however be useful in cases where memflow does not have access to the Microsoft symbol store (e.g. it might be down, you might not have internet access on the machine running memflow or you might have compiled memflow for no-std environments).

In cases where the appropriate offsets cannot be obtained from a PDB, memflow has a built-in database of known windows offsets for each version and build number.
The version info acquired earlier is then used to find the proper offsets table from that database.

### 4. How does the caching work?

// TODO: write about caching 
