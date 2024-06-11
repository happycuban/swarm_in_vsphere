
# SSH Configuration for Host in Octopus workers

This document provides information on how to set up SSH configuration for the servers Example: IP address `1.5.1.2`. This specific configuration will help streamline and secure your SSH connection to the server.

## Configuration Details

The following SSH configuration can be placed in the `.ssh/config` file of the system from which you intend to access `1.5.1.2`.

```text
Host *
    AddKeysToAgent yes
    StrictHostKeyChecking no
    ControlMaster auto
    ControlPath ~/.ssh/control-%C
    ControlPersist yes
    ServerAliveInterval 120

Host servername
    HostName 1.5.1.2
    User sysadmin
    Port 22
    IdentityFile /home/sysadmin/.ssh/priv_key
```

### Explanation of Configuration

1. **Host servername**: Defines an alias for the server block. You can connect by simply using `ssh servername`.

2. **HostName 1.5.1.2**: Specifies the actual IP address of the server.

3. **User sysadmin**: Sets `sysadmin` as the username for the connection.

4. **Port 22**: Defines the port for the SSH connection (22 is the default).

5. **StrictHostKeyChecking no**: Automatically adds new host keys to known hosts and prevents refusal to connect when a host key has changed.

6. **IdentityFile /home/sysadmin/.ssh/priv_key**: Specifies the private key file to be used for authentication.

7. **ControlMaster auto**: Enables multiple sessions to share a single connection.

8. **ControlPath ~/.ssh/control-%C**: Defines the location for the control socket file. `%C` creates a unique name for each connection.

9. **ControlPersist yes**: Keeps the master session open for subsequent connections, speeding up future connections.

10. **ServerAliveInterval 120**: Sends keep-alive messages every 120 seconds to maintain the connection.

### Security Considerations

- **StrictHostKeyChecking**: Setting this to `no` allows SSH to accept host keys automatically, which can reduce security. For sensitive environments, consider leaving it enabled.

- **IdentityFile**: Ensure that the private key file is securely stored with appropriate file permissions.

### Usage

To connect to the server with this configuration:

1. Add the above block to your local `.ssh/config` file.
2. Run `ssh 1.5.1.2` to connect.

This configuration should allow quicker and more reliable access to the server at `1.5.1.2`.