# A Docker image to use IBM Cloud CLI in continuous integration systems

This Docker image comes preinstalled with:
- IBM Cloud CLI and plugins,
- `kubectl`, `tfswitch`, `helm`, `minio`.

See [install-base.sh](./install-base.sh) and [install-ibmcloud.sh](./install-ibmcloud.sh) for the full list.

To run it locally:

```
docker run -it --volume $PWD:/root/mnt/home --workdir /root/mnt/home l2fprod/ibmcloud-ci
```

---

The program is provided as-is with no warranties of any kind, express or implied.
