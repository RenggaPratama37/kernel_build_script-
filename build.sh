# Kernel Script Compiler by Rengga Pratama
echo "Kernel Script Compiler by Rengga Pratama"
# exit build directory
script_directory="$(pwd)"
cd ..
workspace_directory="$(pwd)"

# Remove previous build if available
if [ -d "$out"]; then
    echo "Deleting previous build"
    rm -r "$out" 
fi    
# Let's enter the directory
echo "Enter kernel_xiaomi_lime"   
cd kernel_xiaomi_lime
kernel_directory="$(pwd)" 

# Compile Preparation
    cd "$HOME"
# Checking packages
    packages=("bc" "flex" "zstd" "libarchive-tools")
    for package in "${packages[@]}" ; do
        if dpkg -s "$package" &> /dev/null; then
            echo "$package has been installed"
        else
            echo "installing $package"
            sudo apt install -y "$package"
        fi
    done                 


# Option Neutron clang as a Custom Clang Compile
while true; do
read -p "Do you want to use Neutron Clang as compiler? (y/n):" response
if [ "$response" == "y" ]  || [ "$response" == "Y" ]; then
    echo "Preparing Neutron Clang Environtment..."
    if [ -d "$HOME/toolchains/neutron-clang" ]; then
        echo "Neutron clang has been installed"
    else
        echo "Installing Neutron Clang"         
        mkdir -p "$HOME/toolchains/neutron-clang"
        cd "$HOME/toolchains/neutron-clang"
        curl -LO "https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman"
        sudo chmod +x antman
        ./antman -S
        ./antman --patch=glibc
    fi
    cd "$kernel_directory"    
    export PATH="$HOME/toolchains/neutron-clang/bin:$PATH"
    break
elif [ "$response" == "n" ]  || [ "$response" == "N" ]; then
    cd "$kernel_directory"
    break
else 
    echo "Invalid Option"            
fi
done

# Let's make a defconfig
echo "importing defconfig"
make O=/$workspace_directory/out ARCH=arm64 vendor/bengal-perf_defconfig

# Let's start the build
make -j$(nproc --all) O=/$workspace_directory/out ARCH=arm64 CC=clang CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi-

# Zipping the Image
cd ..
cp $script_directory/Anykernel3/* .  
cp out/arch/arm64/boot/Image Anykernel3
cd Anykernel3
rm -r .github
rm .git  
zip Anykernel3
rm -r Anykernel3

# Renaming zip

mv Anykernel3.zip "renium_$(date '+%d%m%y%H%M').zip

