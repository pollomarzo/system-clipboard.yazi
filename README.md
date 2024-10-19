# system-clipboard.yazi

## Demo

https://github.com/user-attachments/assets/74d59f49-266a-497e-b67e-d77e64209026

## Config

> [!NOTE]
> You need yazi 3.x for this plugin to work.

> [!Important]
> This plugin only works on wayland, using `wl-copy` command

## Configuration

Copy or install this plugin and add the following keymap to your `manager.prepend_keymap`:

```toml
[[manager.prepend_keymap]]
on = "y"
run = ["yank", "plugin system-clipboard"]
```
