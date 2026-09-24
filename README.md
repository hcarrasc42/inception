# inception

A small production-style infrastructure, built with Docker: NGINX, WordPress, and MariaDB, each containerized from a base image and orchestrated with Docker Compose — no pre-built service images allowed.

Systems administration more than application code: writing each Dockerfile from a minimal base, wiring the containers together over an internal network, handling persistent volumes, and getting TLS termination and PHP-FPM to actually talk to each other correctly. `docker run` gets you a container; this is what it takes to run several of them as an actual service.

**Built with:** Docker · Linux · systems administration

---

A solo project completed as part of the core curriculum at [42 Urduliz](https://42urduliz.com). Part of my [GitHub profile](https://github.com/hcarrasc42).
