# CFWheels Example App

![ScreenShot](https://camo.githubusercontent.com/d2cda997b600d25b3ac7d2bd397aa8bd8ba893be/68747470733a2f2f6366776865656c732e6f72672f626c6f672f77702d636f6e74656e742f75706c6f6164732f323031382f30362f3132372e302e302e315f36303035305f61646d696e5f75736572732d65313532383239383635383535372e706e67)

This sample application is *not* a complete Content Management System, and is more of a starting point for your own
applications; it aims to demonstrate some of the framework's features such as Database migrations, routing etc.

## Installation

The installation process has been greatly simplyfied and now uses Commandbox, the Commandbox CFWheels-CLI module, and Forgbox.io

Lets get started. At the Commandbox prompt type:
```
wheels g app name=example datasourceName=exampleh2 template=cfwheels-template-example-app --setupH2
```

This will install a copy of the Example App template into a directory for us. Name the application and datasource and setup the H2 datasource for our use.

Then issue:
```
install
```
This will install all the dependencies the application requires. These include not only runtime dependencies but also development dependencies needed to wire up the datasource.

Finally start the server:
```
server start
```

If all goes well you should see the installation verification page in the browser that opens up.

## Documentation

See the [Wiki](https://github.com/cfwheels/cfwheels-example-app/wiki/Installation)

## Requirements

 - Commandbox
 - Commandbox CFWheels-CLI module
 - Tested on Lucee 5.x / ACF 2018
 - MySQL 5.x, H2
