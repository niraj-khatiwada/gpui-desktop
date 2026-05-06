install:
	cargo update && cargo bin --install
dev:
	cargo bacon

build-native:
	sh scripts/build-native.sh

build: build-native
	cargo build --release

build-dmg: build
	sh scripts/build-dmg.sh