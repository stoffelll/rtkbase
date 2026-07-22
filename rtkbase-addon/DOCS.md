# RTKBase Home Assistant add-on

The add-on supports two GNSS receiver connection modes on Home Assistant OS
`amd64`.

## TCP receiver

Use this mode when a serial-to-network adapter exposes the receiver as a TCP
stream:

```yaml
receiver_connection: tcp
tcp_source_host: 192.168.2.49
tcp_source_port: 6638
serial_device: ""
serial_settings: 115200:8:n:1
```

RTKBase connects to the remote stream and republishes the raw receiver data
inside the add-on on `localhost:5015`. Port `2101` remains reserved for NTRIP.

## USB serial receiver

Use this mode for a USB-UART or directly attached USB GNSS receiver:

```yaml
receiver_connection: serial
tcp_source_host: ""
tcp_source_port: 6638
serial_device: /dev/serial/by-id/usb-example_receiver
serial_settings: 115200:8:n:1
```

Prefer a stable `/dev/serial/by-id/...` path over `/dev/ttyUSB0` or
`/dev/ttyACM0`. The selected device must be visible in Home Assistant hardware
information and passed to the add-on.

The receiver format, such as `ubx` or `rtcm3`, is still configured in the
RTKBase settings page. Restart the add-on after changing the connection mode or
source.

The deprecated `virtual_com_port_*` options are accepted temporarily so an
existing TCP configuration can migrate without recreating a pseudo-terminal.
