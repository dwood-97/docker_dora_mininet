This is a dedicated repository for hosting Dora (dhcp server) from BlueCat Engineering at https://github.com/bluecatengineering/dora and Mininet (network emulator) from Mininet at https://github.com/mininet/mininet, in a Docker container. Please visit both the Dora and Mininet repositories for documentation.

To get started, we will build the image containing both Dora and Mininet. To build the image:

```
docker build -t docker_dora_mininet .
```

When the image is done, we will now create a network for our container:

```
docker network create --subnet=172.16.0.0/16 docker_dora_mininet_network
```

Now that our image and network are all set up, lets run the container:

```
docker run -it --rm --privileged -e DISPLAY \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             -v /lib/modules:/lib/modules \
             --net docker_dora_mininet_network \
             --ip 172.16.0.6 \
             docker_dora_mininet
```

To test out Mininets sample configuration simply run the command `mn`

To test out Dora cd into /dora and run `cargo run`

Now that the container is ready to go, refer back to Mininets repository to create your emulated network. Once you have set up your network you can start testing with Dora's DHCP server.
