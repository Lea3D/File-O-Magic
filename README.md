# File-O-Magic

## Overview
File-O-Magic is a tool designed to transfer files from one directory to another based on custom search criteria, with the added flair of customizable themes for a more personalized experience.

## Structure
- **/scripts/**: Houses the core scripts, including frontend, backend, and batch starter.
- **/configs/**: Stores configuration files for the various color themes.
- **/functions/**: Contains reusable functions, such as color handling, file selection, and user interface (UI) behavior.

## Usage
1. Modify the `.cfg` files located in the `configs` folder to personalize your color themes.
2. Execute the `start.bat` file to launch the graphical user interface (GUI).

## Tested Hardware

- **Operating System**: Windows 11 Pro (Version: 23H2, Build: 22631.4112)
- **VM Hypervisor**: Unraid 7 Beta 2 (KVM)
- **Processor**: 12 vCPUs (Intel passthrough)
- **Memory**: 8.5 GB
- **Graphics Card**: NVIDIA GTX 1080 (Passthrough, using vbios)
- **Disk**: Virtio, vdisk1.img
- **TPM**: Enabled (TPM 2.0)
- **Windows Feature Experience Pack**: 1000.22700.1034.0

### Additional Configuration Details

- **Hypervisor Type**: KVM on Unraid 7 Beta 2
- **Memory Allocation**: 8912896 KiB (~8.5 GB)
- **Graphics Passthrough**: NVIDIA GTX 1080 with custom VBIOS
- **Disk Setup**: Virtio interface for virtual disk

## Notes

- **Disclaimer**: I'm just a random ADHD-equipped female from Germany, in a love-hate relationship with ChatGPT-4o, hoping it won’t gaslight me one day.
- **Development Status**: This tool is under "heavy development" *cough*, so errors may and will occur. It's probably broken AF, as I (ChatGPT) wrote it for messin' around with some Radarr movie directories.