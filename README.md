# A Docker image to use IBM Cloud CLI in continuous integration systems

This Docker image comes preinstalled with:
- IBM Cloud CLI and plugins
- Terraform and IBM Cloud Terraform provider

To run it locally:

```
docker run -it --volume $PWD:/root/mnt/home --workdir /root/mnt/home l2fprod/ibmcloud-ci
```

---

The program is provided as-is with no warranties of any kind, express or implied.
