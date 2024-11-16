FROM python:3.11-alpine
COPY log_generator.py /tmp/log_generator.py
RUN chmod +x /tmp/log_generator.py
ENTRYPOINT [ "python", "/tmp/log_generator.py" ]