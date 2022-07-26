# FROM python:3.7-slim
# RUN mkdir /app
# ADD . /app
# WORKDIR /app
# RUN pip install --no-cache-dir -r requirements.txt
# CMD ["python", "app.py"]

# FROM python:3.7-slim

# ENV CONTAINER_HOME=/app
# WORKDIR $CONTAINER_HOME

# ADD requirements.txt .

# # keep the parent server directory structure for relative imports
# # RUN mkdir server
# # ADD server $CONTAINER_HOME/server

# RUN pip install --no-cache-dir -r requirements.txt
# CMD ["python", "app.py"]

FROM python:3.6

# COPY requirements.txt . 
COPY . . 
# Download Python dependencies
RUN pip install -r api/requirements.txt
#WORKDIR /app
EXPOSE 5000
CMD ["python", "app.py"]