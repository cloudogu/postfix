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

- a running multinode cluster
- the kubectx set to the cluster

### Postfix Dogu build

1. build the dogu

```
   make build
```

Now the dogu should be built, updated, and started automatically.
