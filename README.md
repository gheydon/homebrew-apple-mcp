# homebrew-apple-mcp

Homebrew tap for [apple-mcp](https://github.com/gheydon/apple-mcp) — a Swift MCP server exposing macOS Calendar, Reminders, Contacts, and Messages.

## Install

```sh
brew install gheydon/apple-mcp/apple-mcp
```

(Optionally `brew tap gheydon/apple-mcp` first if you prefer the two-step form.)

The formula installs a notarized universal (`arm64 + x86_64`) binary at:

```
$(brew --prefix)/bin/apple-mcp
```

## Upgrade

```sh
brew update
brew upgrade apple-mcp
```

## Uninstall

```sh
brew uninstall apple-mcp
brew untap gheydon/apple-mcp
```

## Wiring into an MCP host

Point your MCP client's `command` field at the installed binary. For Claude Desktop:

```json
{
  "mcpServers": {
    "apple": {
      "command": "/opt/homebrew/bin/apple-mcp"
    }
  }
}
```

On Intel Macs the path is `/usr/local/bin/apple-mcp`. Use `which apple-mcp` to confirm.

## License

This tap repository's Formula files are released into the public domain. The `apple-mcp` binary itself is licensed under [GPL-2.0](https://github.com/gheydon/apple-mcp/blob/main/LICENSE).
