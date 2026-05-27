class AppleMcp < Formula
  desc "Swift MCP server exposing macOS Calendar, Reminders, Contacts and Messages"
  homepage "https://github.com/gheydon/apple-mcp"
  url "https://github.com/gheydon/apple-mcp/releases/download/v0.1.1/apple-mcp-0.1.1-macos.tar.gz"
  sha256 "763f1270675df27bd86fcf6390c75bcd08db18226b0b95e2fc48464e640aa0be"
  license "GPL-2.0-only"
  version "0.1.1"

  depends_on macos: :sonoma

  def install
    bin.install "apple-mcp"
    prefix.install "LICENSE", "README.md"
  end

  def caveats
    <<~EOS
      apple-mcp talks to macOS personal-data frameworks. On first use of
      each tool group you will see a permission prompt:

        - Calendar     → Privacy & Security → Calendar
        - Reminders    → Privacy & Security → Reminders
        - Contacts     → Privacy & Security → Contacts
        - Messages     → send: Automation → Messages
                         read: Full Disk Access on the host process

      Wire it into your MCP host (Claude Desktop, etc.) by pointing the
      "command" field at:

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
  end
end
