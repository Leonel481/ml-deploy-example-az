# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Install poetry for dependency management
RUN pip install poetry

# Set the working directory in the container
WORKDIR /app

# Copy the poetry configuration files
COPY pyproject.toml poetry.lock ./

# Config poetry to create virtual environments in the project directory
RUN poetry config virtualenvs.in-project true

# Copy the rest of the application code into the container
COPY . .

# Install any needed packages specified in requirements.txt
RUN poetry install --only main --no-root

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run serve_model.py when the container launches
CMD ["poetry", "run", "python", "serve_model.py"]