
if [[ -x /bin/rustc && -x /bin/cargo && -x /bin/rustup ]]; then
	export CARGO_CFG_COLOR=always
	export RUSTC_WRAPPER=sccache
	export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/src/

	rstd() {
		if [[ $# -eq 0 ]]; then
			rustup docs --std
			return 0
		fi
		toolchain="$HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/"
		query="file://$toolchain/share/doc/rust/html/std/index.html?search=$@"
		d $BROWSER "$query"
	}

	ct() {
		echo $(cargo locate-project | sed -e 's/{"root":"\(.*\)"}/\1/g')
	}

	rs_path() {
		echo $(cargo locate-project | sed -e 's_{"root":"\(.*\)/Cargo.toml"}_\1_g')
	}

	# Find Cargo 'release' executable
	fcre() {
		echo $(find $(rs_path)/target/release/ -maxdepth 1 -type f -executable | head -n 1)
	}
fi

