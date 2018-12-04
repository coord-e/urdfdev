# urdfdev

A containerized URDF development environment

## Get started

```bash
docker run -p 6080:6080 -v $(pwd):/data coorde/urdfdev dev your_robot.urdf
```

Then open [localhost:6080](http://localhost:6080/) in your browser

## Usage

```bash
docker run -p 6080:6080 -v $(pwd):/data coorde/urdfdev <subcommand> <path-to-your-robot> [source-file...]
```

### Available subcommands

- `dev`: Development mode with auto reload andv rebuild
- `build`: Build provided xacro file and check output with `check_urdf`

### Source file list

In `dev` mode, urdfdev attempt to watch all changes in `/data` and this sometimes causes annoying reloads with text editor's temporary files. (like `vim`)
You can specify source file list after robot file path to prevent that behavior.

### Examples

Example using `git ls-files` to collect source files:

```bash
docker run -p 6080:6080 -v $(pwd):/data coorde/urdfdev dev your_robot.urdf $(git ls-files)
```

You can use xacro file directly.
It will be converted by `rosrun xacro xacro` in `/data` in the container.

Example:

```bash
docker run -p 6080:6080 -v $(pwd):/data coorde/urdfdev dev robots/your_robot.xacro
```
