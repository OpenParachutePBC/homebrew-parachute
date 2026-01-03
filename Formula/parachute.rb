class Parachute < Formula
  desc "AI orchestration server for your knowledge vault"
  homepage "https://github.com/OpenParachutePBC/parachute"
  url "https://github.com/OpenParachutePBC/parachute-base/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1cff8bdcd400e48c7a4b56ea038e31d7eb0e6a099e15b280380a5493b3daf86e"
  license "MIT"
  head "https://github.com/OpenParachutePBC/parachute-base.git", branch: "main"

  depends_on "python@3.13"

  def install
    # Create virtual environment with Python 3.13
    venv = virtualenv_create(libexec, "python3.13")

    # Install dependencies
    system libexec/"bin/pip", "install", "-r", "requirements.txt"

    # Install the parachute package
    venv.pip_install buildpath

    # Create wrapper scripts that use the venv
    (bin/"parachute-server").write <<~EOS
      #!/bin/bash
      export VIRTUAL_ENV="#{libexec}"
      export PATH="#{libexec}/bin:$PATH"
      exec "#{libexec}/bin/python" -m parachute.server "$@"
    EOS

    (bin/"parachute-supervisor").write <<~EOS
      #!/bin/bash
      export VIRTUAL_ENV="#{libexec}"
      export PATH="#{libexec}/bin:$PATH"
      exec "#{libexec}/bin/python" -m supervisor.main "$@"
    EOS

    # Install the management script
    bin.install "parachute.sh" => "parachute"
  end

  def post_install
    # Create log and data directories
    (var/"log").mkpath
    (var/"parachute").mkpath
  end

  service do
    run [opt_bin/"parachute-server"]
    environment_variables VAULT_PATH: "#{Dir.home}/Parachute",
                          PORT: "3333",
                          HOST: "0.0.0.0"
    keep_alive true
    log_path var/"log/parachute.log"
    error_log_path var/"log/parachute.log"
    working_dir var/"parachute"
  end

  def caveats
    <<~EOS
      Parachute Base Server has been installed!

      To start now and restart at login:
        brew services start parachute

      Or run manually:
        parachute-server

      With supervisor (web UI at http://localhost:3330):
        parachute-supervisor

      Using the CLI:
        parachute start      # Start server
        parachute status     # Check status
        parachute stop       # Stop server

      Configuration:
        Vault: ~/Parachute (override with VAULT_PATH)
        Port:  3333 (override with PORT)
        Logs:  #{var}/log/parachute.log
    EOS
  end

  test do
    # Start server in background
    pid = fork do
      exec bin/"parachute-server"
    end

    # Wait for startup
    sleep 5

    # Check health endpoint
    begin
      output = shell_output("curl -sf http://localhost:3333/api/health")
      assert_match(/ok|healthy/i, output)
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
