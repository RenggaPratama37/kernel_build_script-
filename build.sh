# Kernel Script Compiler by Rengga Pratama
echo "Kernel Script Compiler by Rengga Pratama"
# exit build directory
cd ..

# Remove previous build if available
if [ -d "$out"]; then
    echo "Deleting previous build"
    rm -r "$out" 
fi    
# Let's enter the directory
echo "Enter kernel_xiaomi_lime"   
cd kernel_xiaomi_lime
kernel_direktory="$(pwd)" 

# Compile Preparation
    cd "$HOME"
    sudo apt install bc
    sudo apt install flex
    sudo apt install zstd
    sudo apt install libarchive-tools
# Option Neutron clang as a Custom Clang Compile
if [ "$response" == "y" ]  || [ "$response" == "Y" ]; then
    echo "Preparing Neutron Clang Environtment..."
    if [ -d "$HOME/toolchains/neutron-clang" ]; then
        echo "Neutron clang has been installed"
    else
        echo "Installing Neutron Clang"         
        mkdir -p "$HOME/toolchains/neutron-clang"
        cd "$HOME/toolchains/neutron-clang"
        curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
        sudo chmod +x antmant
        ./antman -S
    fi
    cd "kernel_directory"    
    export PATH="$HOME/toolchains/neutron-clang/bin:$PATH"
fi
# Let's make a defconfig
echo "importing defconfig"
make O=/data/out ARCH=arm64 vendor/bengal-perf_defconfig

# Let's start the build
make -j$(nproc --all) O=/data/out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-






