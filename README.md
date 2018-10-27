# urdfdev

A containerized URDF development environment

## Get started

```bash
docker run -p 6080:6080 -v $(pwd):/data coord-e/urdfdev your_robot.urdf
```

Then open [localhost:6080](http://localhost:6080/) in your browser

## Usage

```bash
docker run -p 6080:6080 -v $(pwd):/data coord-e/urdfdev <path-to-your-robot> [source-file...]
```

Example using `git ls-files` to collect source files:

```bash
docker run -p 6080:6080 -v $(pwd):/data coord-e/urdfdev your_robot.urdf $(git ls-files)
```

## Use xacro

You can use xacro file directly.
It will be converted by `rosrun xacro xacro` in `/data` in the container.

Example:

```bash
docker run -p 6080:6080 -v $(pwd):/data coord-e/urdfdev robots/your_robot.xacro
```
