This is a dedicated repository for hosting Dora (dhcp server) from BlueCat Engineering at https://github.com/bluecatengineering/dora and Mininet (network emulator) from Mininet at https://github.com/mininet/mininet, in a Docker container. Please visit both the Dora and Mininet repositories for documentation.

To get started, we will build the image containing both Dora and Mininet. To build the image:

```
docker build -t dora_mininet .
```

When the image is done, start up the container using:

```
docker run -it --rm --privileged -e DISPLAY \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             -v /lib/modules:/lib/modules \
             dora_mininet
```

To test out Mininets sample configuration simply run the command `mn`

Now that the container is ready to go, refer back to Mininets repository to create your emulated network. Once you have set up your network you can start testing with Dora's DHCP server.
