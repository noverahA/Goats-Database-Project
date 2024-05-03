# Project Setup Guide

## One-Time Installation

### Python and Dependencies

Install Python, pip, and psycopg2 packages:

```bash
sudo pacman -Syu
sudo pacman -S python-pip python-psycopg2 python-flask
```

## Database Setup

1. Create a PostgreSQL database named 'goats':

    ```bash
    createdb goats
    ```

2. Access the 'goats' database in psql:

    ```bash
    psql goats
    ```

3. Import the schema files:

    ```bash
    \i schema.sql
    \i group13_schema.sql
    ```

## Usage

1. Set the FLASK_APP environment variable to 'app.py':

    ```bash
    export FLASK_APP=app.py
    ```

2. Run the Flask application:

    ```bash
    flask run
    ```

3. Open your web browser and navigate to [http://127.0.0.1:5000/](http://127.0.0.1:5000/) to access the application.

## References

- John Degood: [flask7dbs](https://github.com/jdegood/flask7dbs)
