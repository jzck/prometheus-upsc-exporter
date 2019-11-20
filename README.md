# prometheus_upsc_exporter

lightweight docker build for exporting nut's `upsc` into prometheus.

container listens on `:9614`

# Examples

## simplest docker run example

`docker run -p9614:9614 -d jzck/upsc-exporter -e UPS_TARGET=ups@localhost --network=host`

Make sure an `upsd` server is running on the host so that `upsc` can contact it.

## docker-compose with nut-upsd server

basic compose setup with `upshift/nut-upsd`

```
services:
  nut-upsd:
    image: upshift/nut-upsd
    user: root
    restart: unless-stopped
    privileged: true
    expose:
      - 3493
    environment:
      - "SHUTDOWN_CMD=shutdown -h now"
      - "API_USER=upsmon"
      - "API_PASSWORD=secret"

  prom-upsc:
    image: jzck/upsc-exporter
    restart: unless-stopped
    depends_on:
      - nut-upsd
    environment:
      - "UPS_TARGET=ups@nut-upsd:3493"
    expose:
      - 9614
```

# Using with systemd

1. Copy files `upsc-exporter.socket` and `upsc-exporter@.service` to `/etc/systemd/system`
2. Edit port number in `upsc-exporter.socket` and paths in `upsc-exporter@.service` according to your configuration
3. `sudo systemctl enable upsc-exporter.socket`

