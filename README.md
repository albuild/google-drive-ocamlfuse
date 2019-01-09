# albuild-google-drive-ocamlfuse

Yet another unofficial [google-drive-ocamlfuse] package for Amazon Linux 2.

## Install (Amazon WorkSpaces)

### System Requirements

### Instructions

1. Download the package from [the Release page](https://github.com/albuild/google-drive-ocamlfuse/releases/tag/v0.1.0).

1. Install the package.

    ```
    sudo yum -y install albuild-google-drive-ocamlfuse-0.1.0-0.amzn2.x86_64.rpm
    ```

## Build (Amazon WorkSpaces)

### System Requirements

* Docker

### Instructions

1. Clone this repository.

    ```
    git clone https://github.com/albuild/google-drive-ocamlfuse.git
    ```

1. Go to the repository.

    ```
    cd google-drive-ocamlfuse
    ```

1. Build a new image.

    ```
    bin/build
    ```

1. Extract the built package from the image. The package will be copied to the ./rpm directory.

    ```
    bin/cp
    ```

1. Delete the image.

    ```
    bin/rmi
    ```

[google-drive-ocamlfuse]: https://github.com/astrada/google-drive-ocamlfuse
