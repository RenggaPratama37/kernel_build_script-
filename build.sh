# Kernel Script Compiler by Rengga Pratama
echo "Kernel Script Compiler by Rengga Pratama"
# exit build directory
script_directory="$(pwd)"
cd ..
workspace_directory="$(pwd)"

# Let's enter the directory
echo "Enter kernel_xiaomi_lime"   
cd kernel_xiaomi_lime
kernel_directory="$(pwd)" 

# Compile Preparation
    cd "$HOME"
# Checking packages
    packages=("bc" "flex" "zstd" "libarchive-tools" "gcc-aarch64=linux-gnu")
    for package in "${packages[@]}" ; do
        if dpkg -s "$package" &> /dev/null; then
            echo "$package has been installed"
        else
            echo "installing $package"
            sudo apt install -y "$package"
        fi
    done                 
    cd $kernel_directory
    
# export everything
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-

# Let's make a defconfig
echo "importing defconfig"
make O=/$workspace_directory/out ARCH=arm64 vendor/bengal-perf_defconfig

# Let's start the build
make -j$(nproc --all) O=/$workspace_directory/out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-

# Zipping the Image
cd "$workspace_directory"
mkdir -p AnyKernel3
cp -r "$script_directory"/AnyKernel3/* AnyKernel3/
cp out/arch/arm64/boot/Image AnyKernel3/
cd AnyKernel3
zip -r AnyKernel3.zip *
mv AnyKernel3.zip ..
cd "$workspace_directory"

# Renaming zip
mv AnyKernel3.zip "renium_$(date '+%d%m%y%H%M').zip"

# Clean up file after building
rm -r out
rm -r AnyKernel3