FROM ubuntu:latest

# Update package list and install dependencies
RUN apt-get update && apt-get install -y python3 python3-pip && apt-get clean

# Install Flask and Gunicorn
RUN pip install Flask gunicorn

# Set working directory
WORKDIR /home

# Copy the necessary files
COPY helloWorld.py /home/helloWorld.py
COPY run.py /home/run.py

# Expose port
EXPOSE 5000

# Run the app using Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "run:app"]

