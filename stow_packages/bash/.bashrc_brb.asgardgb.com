# Run-time modifying stuff (e.g., PATH, )

##
## AWS
export PATH="/home/gbiamby/.ebcli-virtual-env/executables:$PATH"

##
## CPU / GPU
## This workaround no longer works with newer Intel MKL lib versions.
# # For AMD CPU's, set this so that Intel MKL library will use AVX2 optimizations
# if (lscpu | grep "AMD Ryzen"); then
#     export MKL_DEBUG_CPU_TYPE=5
# fi

## CUDA
## For home desktop only. The way I installed the NVIDIA drivers made it necessary to set these
## manually for some reason:
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export PATH=/usr/local/ripgrep_all${PATH:+:${PATH}}
## Arch list for compiling some pytorch projects, DeepFill, and the other hackathon one:
# export TORCH_CUDA_ARCH_LIST="Turing,Ampere"
export TORCH_CUDA_ARCH_LIST=7.5
# export TORCH_CUDA_ARCH_LIST=8.6

## To force the nvidia-smi GPU order to be the same as the GPU device ordinals in pytorch:
export CUDA_DEVICE_ORDER=PCI_BUS_ID

# Misc. attempts to get video acceleration working in ubuntu/nvidia/wayland/(firefox||chrome)
# export LIBVA_DRIVER_NAME=nvidia
# export __EGL_VENDOR_LIBRARY_FILENAMES="/usr/share/glvnd/egl_vendor.d/10_nvidia.json"
# export VDPAU_DRIVER=nvidia
# export NVD_BACKEND=direct
export MOZ_DISABLE_RDD_SANDBOX=1
export EGL_PLATFORM=wayland

# 2023-07-13: Commented out the above `LIBVA_DRIVER_NAME` and `__EGL_VENDOR_LIBRARY_FILENAMES`
# entries and added this, as i'm currently using AMD dGPU to drive main display and only using
# NVIDIA dGPU for guest OS via qemu/kvm GPU pass-through:
export LIBVA_DRIVER_NAME=radeonsi

