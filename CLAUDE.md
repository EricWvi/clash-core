# Clash-Core Analysis Summary

## Project Structure
```
main.go              # CLI entry: main.go:48 - flag parsing, hub.Parse() call
hub/                 # Core orchestration & REST API
├── executor/        # executor.Parse(), ApplyConfig() - config dispatch
├── route/           # REST API server
config/              # Configuration parsing & management  
tunnel/              # Core tunneling logic & traffic routing
adapter/             # Proxy adapters (inbound/outbound/groups)
├── inbound/
├── outbound/
├── outboundgroup/
├── provider/
listener/            # Network listeners (HTTP/SOCKS/TUN/etc)
├── http/
├── socks/
├── mixed/
├── redir/
├── tproxy/
├── tunnel/
├── auth/
dns/                 # DNS resolution & fake-IP functionality
rule/                # Traffic routing rules engine
transport/           # Protocol implementations
├── shadowsocks/
├── vmess/
├── trojan/
├── snell/
├── gun/
├── ssr/
component/           # Shared utilities & components
├── auth/
├── dhcp/
├── dialer/
├── fakeip/
├── resolver/
├── trie/
├── mmdb/
common/              # Low-level utilities
```

## Architecture Flow
Request Flow: Listener → Tunnel → Rule Engine → Adapter → Transport
- Configuration-Driven via YAML
- Plugin-Style Adapters
- Event-Driven with Go channels

## Key Entry Points
- main.go:48 - CLI entry with flag parsing
- hub.Parse() - main initialization
- executor.Parse() - config loading  
- executor.ApplyConfig() - config dispatch to subsystems
- route.Start() - REST API server

## Core Features
**Inbound**: HTTP/HTTPS, SOCKS5, TUN device, transparent proxy
**Outbound**: Shadowsocks(R), VMess, Trojan, Snell, SOCKS5, HTTP(S), Wireguard
**Rule Engine**: Domain, IP, process name, port-based routing
**Proxy Groups**: Load balancing, failover, latency selection
**Advanced**: Fake-IP DNS, transparent proxy, RESTful API, remote providers

## Dependencies
- github.com/miekg/dns - DNS functionality
- github.com/gorilla/websocket - WebSocket support
- github.com/go-chi/chi - HTTP router for API
- go.etcd.io/bbolt - Embedded database
- github.com/oschwald/geoip2-golang - GeoIP rules
- Go 1.21+ required

## Build System
- Makefile with 39+ cross-platform targets
- CGO_ENABLED=0 for static binaries
- Version injection via ldflags
- golangci-lint integration
- Docker support

## Development Commands
```bash
go mod download
make linux-amd64
make lint
make clean
./bin/clash-linux-amd64 -f config.yaml
```

## Code Quality Notes
- Well-organized modular structure
- Limited test coverage (only rule/parser_test.go found)
- Production-ready with extensive protocol support
- Complex configuration system
- Good concurrent design patterns