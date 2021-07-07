#!/bin/sh
compile() {
    echo "building linux first..."
    if [ -d $PWD"/depends/x86_64-pc-linux-gnu/" ]; then
        clean
        compileLinux
    else
        compileLinuxDepends
        clean
        compileLinux
    fi

    echo "now windows..."
    if [ -d $PWD"/depends/x86_64-w64-mingw32/" ]; then
        clean
        compileWindows
    else
        compileWindowsDepends
        clean
        compileWindows
    fi
}

clean() {
    make clean
}

compileLinuxDepends() {
    echo "depends not built, building now"
    cd depends/
    make -j 2
    cd ..

    echo "built depends, src now"
}

compileLinux() {
    echo "built depends, src now"

    bash autogen.sh
    clear

    echo "autogen complete"

    ./configure --prefix=$(pwd)/depends/x86_64-pc-linux-gnu

    echo "configure complete"

    make -j 2

    echo "compile complete"
    moveLinux
}

compileWindowsDepends() {
    echo "depends not built, building now"
    cd depends/
    make HOST=x86_64-w64-mingw32 -j 2
    cd ..
}

compileWindows() {
    echo "built depends, src now"

    bash autogen.sh
    clear

    echo "autogen complete"

    ./configure --prefix=$(pwd)/depends/x86_64-w64-mingw32

    echo "configure complete"

    make -j 2

    echo "compile complete"
    moveWindows
}

moveLinux() {
    if [ -d "/root/linux-binaries/" ]; then
        echo "moving linux binaries"
        cp src/genixd /root/linux-binaries/
        cp src/genix-cli /root/linux-binaries/
        cp src/genix-tx /root/linux-binaries/
        chmod +x /root/linux-binaries/genixd /root/linux-binaries/genix-cli /root/linux-binaries/genix-tx
    else
        echo "creating dir & moving linux binaries"
        mkdir /root/linux-binaries/
        cp src/genixd /root/linux-binaries/
        cp src/genix-cli /root/linux-binaries/
        cp src/genix-tx /root/linux-binaries/
        chmod +x /root/linux-binaries/genixd /root/linux-binaries/genix-cli /root/linux-binaries/genix-tx
    fi
}

moveWindows() {
    if [ -d "/root/windows-binaries/" ]; then
        echo "moving windows binaries"
        cp src/qt/genix-qt.exe /root/windows-binaries/
        chmod +x /root/windows-binaries/genix-qt.exe
    else
        echo "creating dir & moving windows binaries"
        mkdir /root/windows-binaries/
        cp src/qt/genix-qt.exe /root/windows-binaries/
        chmod +x /root/windows-binaries/genix-qt.exe
    fi
}

compile
