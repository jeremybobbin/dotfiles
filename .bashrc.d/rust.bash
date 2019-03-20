export CARGO_CFG_COLOR=always
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
	name="Cargo.toml"
	ife $name || ife "../$name" || ife "../../$name"
}
