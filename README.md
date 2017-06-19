# System Requirements

- Node v8.x
- MongoDB 3.4.x

# Components

The Stoplight platform is broken up in to 4 main components, described below. Each component has a folder in the "components" folder, with a basic start.sh script. Additionally, each component has a environment file in the "env" folder, that defines the various variables required for the component to function.

## App

*Required.*

The app server serves up the Stoplight UI. This is the primary point of ingress for most users using Stoplight. It is what they will load in their web browser, and connect the desktop app to.

## API

*Required.*

The API server is what the App server (described above) connects to to fetch and persist data.

## Prism Conductor

*Optional. Required to run scenarios (testing and orchestration).*

The Prism Conductor server runs scenario collections.

## Prism Multi

*Optional. Required to run prism instances (mock servers, proxy servers).*

The Prism Multi server runs prism instances.

NOTE that this component must be setup with a wildcard subdomain, for example http://*.prism-proxy-dev.io. Each prism instance that is created gets a unique host, for example http://service1-mock.prism-proxy-dev.io. This is preferrable to storing the instance id in a path (http://prism-proxy-dev.io/service-mock) because it means that you don't need to change your API code - all you need to do is change your host variable.

# Installation

While installation will of course depend on your environment, there are some basic steps to follow.

1. Provision an Ubuntu or Centos system.
2. Install Node v8.
3. Install and start a MongoDB 3.4 server if it will be run on this machine.
4. Clone or copy this repository onto the machine.
5. Update the variables in the .env files. Make sure to replace {PUBLIC_SYSTEM_IP} with your system's publicly accessible IP address (even if only accessible within your private network).
6. In each component folder, run the start.sh script to start the server.
7. Visit http://{PUBLIC_SYSTEM_IP}:3000 (or whichever port you chose in the app.env file) to view your enterprise stoplight instance.
