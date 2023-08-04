# Use the official Python base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the poetry.lock and pyproject.toml files to the container
COPY poetry.lock pyproject.toml /app/

# Install Poetry and dependencies
RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Copy the application code to the container
COPY . /app

# Run migrations
RUN poetry run python manage.py makemigrations && \
    poetry run python manage.py migrate

# Expose the port on which the application will listen
EXPOSE 8000

# Start the application
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
