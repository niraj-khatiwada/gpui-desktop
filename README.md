# GPUI
Cross platform desktop app using [gpui](https://www.gpui.rs/) & [gpui-components](https://github.com/longbridge/gpui-component#)

<div align="center">
    <img src="./assets/demo.jpg" width="768" />
</div>

### Building:
This project uses `cargo-run-bin` to use `bacon`(a hot reload tool for dev environment) to build from `Cargo.toml` instead of using it globally. This makes sure there's no any "It works on my machine" drama. So make sure to install [cargo-run-bin](https://crates.io/crates/cargo-run-bin) globally:

Install deps:
```
make install
```

Run the app in dev mode:
```
make watch
```

Run the app in release mode:
```
make build
```