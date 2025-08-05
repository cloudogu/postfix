---
title: "Developer Guide"
---

# Developer Guide

This article is suitable for all those who want to develop on the Postfix dogu.

## Requirements

* It is necessary to install the following programs:
    * [git](https://git-scm.com/) - see link.
    * vagrant
    * docker

## Set up the development environment

1. clone the repository:
   ```
   git clone https://github.com/cloudogu/postfix.git
   ```

## Development on the Postfix dogu

### Prerequisites

- A running Vagrant machine for the CES

### Postfix Dogu build

The build process of the Dogus is always executed in the Vagrant machine.

1. change to the root directory of the Postfix dogu (in vagrant)
2. build the dogu

```
   cesapp build .
```

Now the dogu should be built, updated, and started automatically.
