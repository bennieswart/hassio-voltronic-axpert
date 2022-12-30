### This is a [hassio](https://hass.io) addon to monitor [voltronic axpert inverters](https://voltronicpower.com/en-US/Product/PV-Inverter).

<img src="https://voltronicpower.com/Content/images/product/20210803170137.jpg" width="300" /><img src="https://voltronicpower.com/Content/images/product/20210416171458.jpg" width="300" />

The inverter is connected by USB and data is published as JSON to an MQTT broker. It publishes the data to 3 topics:

- 'power/axpert' for the parallel data (some of these values seem to be only for the connected inverter even though they are returned by the parallel data command)
- 'power/axpert_settings' for the configured settings
- 'power/axpert{sn}' for the data from the connected inverter (configurable, {sn} is replaced with the serial number of the inverter)

You can then configure the sensors in Home Assistant like this:

```
sensors:
  - platform: mqtt
    name: "Power"
    state_topic: "power/axpert"
    unit_of_measurement: 'W'
    value_template: "{{ value_json.TotalAcOutputActivePower }}"
    expire_after: 60
```

See the following functions in [monitor.py](./monitor.py) for the values published on each topic:
- `power/axpert`: [get_parallel_data](./monitor.py#:~:text=def%20get_parallel_data)
- `power/axpert_settings`: [get_settings](./monitor.py#:~:text=def%20get_settings)
- `power/axpert{sn}`: [get_data](./monitor.py#:~:text=def%20get_data)

### Install

Add https://github.com/bennieswart/home-assistant-addons to the addon store repositories and you will get a `Axpert Inverter` listed there.
Note that this assumes the inverter is `/dev/hidraw0`. If you have other USB to Serial devices connected this might be wrong.

### Manual build and run

```
# Build the docker image
docker build --build-arg BUILD_FROM=alpine -t axpert-monitor .

# Run the container
# You will need to edit options.json or add the proper environment variables
docker run                                     \
    -dit                                       \
    --name axpert-monitor-0                    \
    --device /dev/hidraw0:/dev/hidraw0         \
    -v $(pwd)/options.json:/data/options.json  \
    -e MQTT_CLIENT_ID=axpert0                  \
    --restart unless-stopped                   \
    axpert-monitor
```

### Known working configurations

- Two Kodak OG-PLUS6.2 in parallel running on Raspberry Pi 4.

### Resources

A description of the serial communication protocol can be found in [docs/protocol.pdf](docs/protocol.pdf).

### Credit
This project was forked from [MindFreeze/hassio-axpert](https://github.com/MindFreeze/hassio-axpert) after it was deprecated.
