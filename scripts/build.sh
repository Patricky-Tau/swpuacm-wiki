# !/bin/sh

sudo apt install cargo

cargo install mdbook --vers 0.4.21
cargo install mdbook{-katex,-catppuccin}

export PATH="~/.cargo/bin:$PATH"
