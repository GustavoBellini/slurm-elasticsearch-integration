# SLURM Elasticsearch Integration

A lightweight integration between SLURM and Elasticsearch using the `jobcomp/script` plugin.

This project exports SLURM job completion information directly to Elasticsearch, enabling visualization and monitoring through Kibana dashboards.

## Features

- Simple Bash implementation
- No additional agents required
- Direct integration with Elasticsearch
- Compatible with Kibana dashboards
- Uses native SLURM JobComp plugin

## Requirements

- SLURM
- Elasticsearch
- curl

## Configuration

Edit `/etc/slurm/slurm.conf` and add:

```ini
JobCompType=jobcomp/script
JobCompLoc=/usr/local/bin/integration-slurm-elk.sh
```

Reload SLURM configuration:

```bash
scontrol reconfigure
```

## Installation

Copy the script:

```bash
cp integration-slurm-elk.sh /usr/local/bin/
chmod 755 /usr/local/bin/integration-slurm-elk.sh
```

Edit the script and configure <IP>, <user> and <password>:

```bash
ELASTICSEARCH_URL="http://<IP>:9200/slurm_jobs/_doc"
USER="<user>"
PASSWORD="<password>"
```

## How it works

When a job finishes, SLURM executes the configured script.

The script collects all environment variables provided by SLURM and sends them as a JSON document to Elasticsearch.

## Example Document

```json
{
  "@timestamp": "2026-06-02T15:00:00Z",
  "JOBID": "12345",
  "USERNAME": "user01",
  "JOBNAME": "my_job",
  "JOBSTATE": "COMPLETED",
  "NODES": "node01",
  "SUBMIT": "1780488093",
  "ELIGIBLE": "1780488093",
  "START": "1780488094",
  "END": "1780488104",
  "LIMIT": "UNLIMITED",
  "STDOUT": "/patch/script_job_%N.out",
  "WORK_DIR": "/patch/work_dir_user"  
}
```

## Kibana

The indexed data can be used to create dashboards for:

- Cluster utilization
- Job history
- User activity
- Queue statistics
- Resource consumption

## License

MIT License
