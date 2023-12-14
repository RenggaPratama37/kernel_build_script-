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

# Export Neutron Clang 
echo "Export Neutron Clang to the PATH"
export PATH="$HOME/toolchains/neutron-clang/bin:$PATH"

# Let's make a defconfig
echo "importing defconfig"
make O=/data/out ARCH=arm64 vendor/bengal-perf_defconfig

# Let's start the build
make -j$(nproc --all) O=/data/out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-






