
![Logo](portal-logo.png)

# PhenoMeNal Metadata Backend
Version: 1.1

## Description

Backend service for the PhenoMeNal Portal Metadata


## Key features

- Local Cloud Research Environment Deployment
- Metadata service

## Functionality

- Other Tools


## Tool Authors

- Sijin He (EMBL-EBI)
- Marco Enrico Piras (CRS4)

## Container Contributors

- [Sijin He](https://github.com/sh107) (EMBL-EBI)
- [Pablo Moreno](https://github.com/pcm32) (EMBL-EBI)
- [Marco Enrico Piras](https://github.com/kikkomep) (CRS4)

## Website

- http://portal.phenomenal-h2020.eu/


## Git Repository

- https://github.com/phnmnl/container-portal-metadata-backend.git

## Installation 

For local individual installation:

```bash
docker pull container-registry.phenomenal-h2020.eu/phnmnl/container-portal-metadata-backend
```

## Usage Instructions

For direct docker usage:

```bash
docker run -d -p 3001:80 -it container-registry.phenomenal-h2020.eu/phnmnl/container-portal-metadata-backend /bin/bash -c "entrypoint.sh 80"
```
