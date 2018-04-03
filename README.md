# 2RS-Viewer

The purpose of this system is to show the following data:

* The current athlete's heartbeat (in beats per minute - BPM);
* The current power performed by the athlete (in watts);
* The current speed performed by the athlete (in Rows per Minute - RPM);
* The time elapsed (in minutes and seconds - min:s)
* The current difficulty (as integer)
* An animation of the current athlete performance;
* An animation of the corresponding ideal performance.

## Contributing

### Installing [Godot](https://godotengine.org/)

* From [Steam](http://store.steampowered.com/):
    1. Simply search for Godot and install it :)

* Linux:
    1. Download the latest version at [https://godotengine.org/download/linux](https://godotengine.org/download/linux)
    1. Extract the binary
    1. Run the binary

* MacOS:
    1. Run the following command:

        ```shell
        $ brew cask install godot
        ```

* Windows:
    1. Download the latest version at [https://godotengine.org/download/windows](https://godotengine.org/download/windows)
    1. Extract the binary
    1. Run the binary

### Importing the Project

1. Clone this repository:

    ```shell
    $ git clone git@github.com:remarema-unb/2rs-viewer.git
    ```
1. Start Godot
1. Click on **Import** button
1. Locate the project directory
1. Select the `project.godot` file
1. Click on **Import & Edit** button

### Executing the 2RS-Viewer in Development

1. If you have a local instance of [2RS-Controller](github.com/remarema-unb/2rs-controller), start it before executing 2RS-Viewer
    1. If you don't have a local instance, using a terminal go to the `mocks/controller` directory
    1. Start the mocked 2RS-Controller:

        ```shell
        $ sudo docker-compose up
        ```
1. In Godot, click on **Play** button (or press `F5` key)

## History

![v0.0.0.1](https://github.com/remarema-unb/2rs-viewer/wiki/screenshots/2018-04-03_v0_0_0_1.png)

> Figure 1 - 2RS-Viewer v0.0.0.1
