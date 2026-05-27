class AppleMcp < Formula
  desc "Swift MCP server exposing macOS Calendar, Reminders, Contacts and Messages"
  homepage "https://github.com/gheydon/apple-mcp"
  url "https://github.com/gheydon/apple-mcp/releases/download/v0.2.0/apple-mcp-0.2.0-macos.tar.gz"
  sha256 "09966bde44fe442ca8eabc5c787bd5d9515232788cde02bb5c2e134690c0e696"
  license "GPL-2.0-only"
  version "0.2.0"

  depends_on macos: :sonoma

  def install
    bin.install "apple-mcp"
    prefix.install "LICENSE", "README.md"
  end

  def caveats
    <<~EOS
      To wire apple-mcp into your MCP host (Claude Desktop, Claude Code), run:

        apple-mcp register

      It detects the hosts you have installed, asks per-host before changing
      anything, and backs up the existing config to <config>.bak. To remove
      the entry later, run `apple-mcp unregister`.

      Then restart your MCP host. On first use of each tool group macOS will
      ask for the relevant permission:

        - Calendar     → Privacy & Security → Calendar
        - Reminders    → Privacy & Security → Reminders
        - Contacts     → Privacy & Security → Contacts
        - Messages     → send: Automation → Messages
                         read: Full Disk Access on the host process

      If you prefer to edit JSON by hand, point the "command" field at:

        #{opt_bin}/apple-mcp
    EOS
  end

  test do
    require "open3"
    init = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"brew-test","version":"0"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    Open3.popen3("#{bin}/apple-mcp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(init)
      stdin.close
      sleep 2
      Process.kill("TERM", wait_thr.pid) rescue nil
      output = stdout.read
      assert_match "calendar_list_calendars", output
      assert_match "messages_send", output
    end

    # The version subcommand should match the formula version
    assert_match version.to_s, shell_output("#{bin}/apple-mcp version")
  end
end
