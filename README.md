# urdfdev

A containerized URDF development environment

## Get started

```bash
docker run -p 6800:6800 -v $(pwd):/data coord-e/urdfdev your_robot.urdf
```

Then open [localhost:6800/vnc.html](localhost:6800/vnc.html) in your browser
