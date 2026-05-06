use std::{path::PathBuf, process::Command};

fn get_native_bin_(name: &str) -> PathBuf {
    #[cfg(debug_assertions)]
    {
        return PathBuf::from("dist/native").join(name);
    }

    #[cfg(not(debug_assertions))]
    {
        return std::env::current_exe()
            .expect("failed to get exe path")
            .parent()
            .expect("no parent dir")
            .to_path_buf()
            .join(name);
    }
}

pub fn pick_color() -> Result<Option<String>, String> {
    let output = Command::new(get_native_bin_("color-picker"))
        .output()
        .map_err(|err| err.to_string())?;

    if !output.status.success() {
        return Ok(None);
    }

    let stdout = String::from_utf8_lossy(&output.stdout).to_string();

    if stdout.trim() == "null" {
        Ok(None)
    } else {
        Ok(Some(stdout))
    }
}

pub fn show_dialog(
    title: &str,
    description: Option<&str>,
    ok_text: Option<&str>,
) -> Result<Option<bool>, String> {
    let mut cmd = Command::new(get_native_bin_("dialog"));

    cmd.arg(title);

    if let Some(desc) = description {
        cmd.arg(desc);
    }

    if let Some(ok) = ok_text {
        if description.is_none() {
            cmd.arg("");
        }
        cmd.arg(ok);
    }

    let output = cmd.output().map_err(|err| err.to_string())?;

    if !output.status.success() {
        return Ok(None);
    }

    let stdout = String::from_utf8_lossy(&output.stdout);

    match stdout.trim() {
        "ok" => Ok(Some(true)),
        "cancel" => Ok(Some(false)),
        _ => Ok(None),
    }
}
