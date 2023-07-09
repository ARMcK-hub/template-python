FROM armck/python-base:latest

LABEL   deployable="true" \
        decription="This is the deployable version of the WEF application container. \
                    It only includes nessecary items to run the application."

# Set Working Directory
ENV WORKDIR=/template-python
WORKDIR ${WORKDIR}

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Bring project files into container
COPY ./poetry.lock ./pyproject.toml ${WORKDIR}/
COPY ./snek_case ${WORKDIR}/snek_case

RUN cd $WORKDIR/ && poetry install --no-root --without=dev


# ----- Container Command -----
# exec commands do not run in shell by default (See: https://docs.docker.com/engine/reference/builder/#cmd)
CMD ["/bin/bash", "-c", "poetry run uvicorn snek_case.main:app --host 0.0.0.0 --port 8008"]
