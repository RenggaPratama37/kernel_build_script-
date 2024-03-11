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
    packages=("bc" "flex" "zstd" "libarchive-tools" "gcc-aarch64-linux-gnu" \
                "make" "bison" "binutils" "lld" "llvm" "libssl-dev" "libssl-doc") 
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
make O=/$script_directory/out ARCH=arm64 vendor/bengal-perf_defconfig

# Let's start the build
while true;
do
    read -p "Using LLVM and LLVM_IAS? (Y/n/x (for exit)):" response
    if [ "$response" == "y" ]  || [ "$response" == "Y" ]; 
    then
        make -j$(nproc --all) O=/$script_directory/out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- LLVM=1 LLVM_IAS=1
    elif [ "$response" == "n" ]  || [ "$response" == "N" ];
    then
        make -j$(nproc --all) O=/$script_directory/out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-
    elif [ "$response" == "x" ];
    then
        echo "Exiting script."
        break
    else
        echo "Invalid Option"
        break
    fi

    # Periksa apakah kompilasi selesai
    if [ -f "$script_directory/out/arch/arm64/boot/Image.gz" ]; then
        echo "Build completed successfully."
        break
    fi
done

if [ -f "$script_directory/out/arch/arm64/boot/Image.gz" ];
then
    # Zipping the Image
    cd "$script_directory"
    mkdir -p kernel
    cp -r "$script_directory"/AnyKernel3/* kernel/
    cp out/arch/arm64/boot/Image kernel/
    cd kernel
    zip -r kernel *

    # Renaming zip
    echo "renaming zip"
    mv kernel.zip $script_directory
    cd $script_directory
    mv kernel.zip "renium_$(date '+%d%m%y%H%M').zip"

    # Clean up file after building
    echo "cleaning file after build completed"
    #rm -r out
    #rm -r kernel
else
    echo "Build Failed"
    cd $script_directory
fi