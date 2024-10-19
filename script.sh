###############################################################################
#
# Docker Restart Policies Command Reference
# Author: Md Toriqul Islam
# Description: Reference commands for exploring Docker restart policies
# Note: This is a reference file. Do not execute directly.
#
###############################################################################

#------------------------------------------------------------------------------
# 'Always' Restart Policy Commands
#------------------------------------------------------------------------------

# Start a container with 'always' restart policy
docker run -d --name always-demo --restart always alpine \
    /bin/sh -c 'while true; do date; sleep 5; done'

# Check container status and restart count
docker ps --filter "name=always-demo"
docker inspect always-demo --format '{{.RestartCount}}'

# Container will restart even after manual stop and daemon restart
docker stop always-demo
systemctl restart docker  # Container will restart automatically

#------------------------------------------------------------------------------
# 'Unless-Stopped' Restart Policy Commands
#------------------------------------------------------------------------------

# Start a container with 'unless-stopped' policy
docker run -d --name unless-stopped-demo --restart unless-stopped alpine \
    /bin/sh -c 'while true; do date; sleep 5; done'

# Monitor container status
docker ps --filter "name=unless-stopped-demo"

# Container won't restart after manual stop and daemon restart
docker stop unless-stopped-demo
systemctl restart docker  # Container remains stopped

#------------------------------------------------------------------------------
# 'On-Failure' Restart Policy Commands
#------------------------------------------------------------------------------

# Start container with 'on-failure' policy and max restart count
docker run -d --name on-failure-demo --restart on-failure:3 alpine \
    /bin/sh -c 'exit 1'

# Monitor restart attempts
docker ps -a --filter "name=on-failure-demo"
docker inspect on-failure-demo --format '{{.RestartCount}}'

#------------------------------------------------------------------------------
# Monitoring & Inspection Commands
#------------------------------------------------------------------------------

# View container logs
docker logs always-demo
docker logs -f always-demo  # Follow log output

# Inspect restart policy configuration
docker inspect always-demo --format '{{.HostConfig.RestartPolicy}}'

# View detailed container information
docker inspect always-demo

# Monitor resource usage
docker stats always-demo

#------------------------------------------------------------------------------
# Testing Commands
#------------------------------------------------------------------------------

# Test graceful shutdown
docker stop -t 30 always-demo  # Give 30 seconds for graceful shutdown

# Force container termination
docker kill always-demo

# Check container state transitions
docker events --filter 'container=always-demo' --filter 'type=container' \
    --filter 'event=die|stop|start'

#------------------------------------------------------------------------------
# Cleanup Commands
#------------------------------------------------------------------------------

# Remove specific containers
docker rm -f always-demo
docker rm -f unless-stopped-demo
docker rm -f on-failure-demo

# Remove all stopped containers
docker container prune

# Remove containers and their volumes
docker rm -v always-demo

###############################################################################
# Notes:
#
# - Replace container names (e.g., 'always-demo') with your actual container names
# - Adjust sleep times and restart counts based on your needs
# - Some commands require root/sudo privileges (e.g., systemctl)
# - Always verify commands in a test environment first
#
###############################################################################