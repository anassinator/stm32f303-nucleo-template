STM32F303RE Nucleo template
===========================

This is a basic GCC template and playground for the STM32F303RE Nucleo
development board.

Prerequisites
-------------
You will need to install the following:
* `arm-none-eabi-gcc`
* [stlink](https://github.com/texane/stlink)

Compiling
---------
Simply run:

```bash
make
```

Uploading
---------
Simply connect your Nucleo board and run:

```bash
make install
```

The device's `LD2` LED should start blinking.
