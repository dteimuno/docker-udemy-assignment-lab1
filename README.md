# Custom Alpine-Based Application Dockerfile

## Overview
This repository contains a Dockerfile for building a lightweight container image based on the `alpine:latest` image. The container includes a custom application along with essential tools like OpenSSH Server and Vim.

## Features
- **Base Image**: Uses the lightweight `alpine:latest` image.
- **Installed Packages**:
  - OpenSSH Server
  - Vim
  - `gcompat` for compatibility.
- **Custom Application**:
  - Application files are stored in the `/app-files` directory.
  - Environment variable `ADMIN_USER` is set, written to a file, and then unset for security.
  - The application binary, `custom`, is the entry point of the container.

## Dockerfile Breakdown

### 1. Base Image
```dockerfile
FROM alpine:latest
```
- The image is built using `alpine:latest` for its minimal size and security.

### 2. Package Installation
```dockerfile
RUN apk add openssh-server vim gcompat;exit 0
```
- Installs the required tools for the application and environment setup.

### 3. Working Directory
```dockerfile
WORKDIR /app-files
```
- Sets the working directory for the container to `/app-files`.

### 4. Environment Variable Management
```dockerfile
#Set env variable of ADMIN_USER.
# In future, the value will be retrieved from Vault.

# Add Value of ENV Variable to a file.
RUN export ADMIN_USER="appadmin"\
    && echo $ADMIN_USER > ./user-creds.txt \
# Unset the ENV Variable after value added to file.
    && unset ADMIN_USER
```
- Sets an environment variable `ADMIN_USER` (currently hardcoded as `appadmin`).
- Writes the value of `ADMIN_USER` to a file named `user-creds.txt`.
- Unsets the `ADMIN_USER` variable for security after saving its value.

### 5. Copy Application Files
```dockerfile
# Copy The App contents stored in custom-app folder to app-files.
# The txt files in custom-app can be ignored/skipped.
COPY custom-app /app-files
```
- Copies all files from the `custom-app` directory to the container's `/app-files` directory.
- Text files in `custom-app` are ignored/skipped.

### 6. Expose Port
```dockerfile
EXPOSE 8080
```
- Exposes port `8080` for the application.

### 7. Set Entrypoint
```dockerfile
# Start app binary named custom.
CMD ["/app-files/custom"]
```
- Defines the entry point of the container as the `custom` binary in `/app-files`.

## Usage

### Build the Image
Run the following command to build the Docker image:
```bash
docker build -t custom-alpine-app .
```

### Run the Container
Run the container using:
```bash
docker run -p 8080:8080 custom-alpine-app
```

### Verify
- SSH Server and Vim are installed.
- `user-creds.txt` contains the value of `ADMIN_USER`.
- Application runs on port `8080`.

## Future Enhancements
- Fetch `ADMIN_USER` value dynamically from a secret management system like HashiCorp Vault.
- Add error handling for package installations and application runtime.
- Enable selective copying and exclude text files during the `COPY` operation.

 
