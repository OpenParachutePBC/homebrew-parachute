# Homebrew Tap for Parachute

This is the official Homebrew tap for [Parachute](https://github.com/OpenParachutePBC/parachute) - AI orchestration for your knowledge vault.

## Installation

```bash
# Add the tap
brew tap openparachutepbc/parachute

# Install parachute
brew install parachute
```

## Usage

### As a Service (Recommended)

```bash
# Start now and restart at login
brew services start parachute

# Stop the service
brew services stop parachute

# Restart
brew services restart parachute

# Check status
brew services info parachute
```

### Manual

```bash
# Run server directly
parachute-server

# Run with supervisor (web UI at localhost:3330)
parachute-supervisor

# Use the CLI
parachute start
parachute status
parachute stop
```

## Configuration

Environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `VAULT_PATH` | `~/Parachute` | Path to your knowledge vault |
| `PORT` | `3333` | Server port |
| `HOST` | `0.0.0.0` | Bind address |

To customize for the service:

```bash
# Create override file
mkdir -p ~/Library/LaunchAgents
brew services stop parachute

# Edit the plist
nano ~/Library/LaunchAgents/homebrew.mxcl.parachute.plist

# Restart
brew services start parachute
```

## Logs

```bash
# View logs
tail -f /usr/local/var/log/parachute.log

# Or on Apple Silicon
tail -f /opt/homebrew/var/log/parachute.log
```

## Updating

```bash
brew update
brew upgrade parachute
brew services restart parachute
```

## Uninstalling

```bash
brew services stop parachute
brew uninstall parachute
brew untap openparachutepbc/parachute
```

## Development

To install from HEAD (latest main branch):

```bash
brew install --HEAD parachute
```

To test locally before publishing:

```bash
brew install --build-from-source ./Formula/parachute.rb
```

## Links

- [Parachute Repository](https://github.com/OpenParachutePBC/parachute)
- [Parachute Base Server](https://github.com/OpenParachutePBC/parachute-base)
- [Issue Tracker](https://github.com/OpenParachutePBC/parachute/issues)
