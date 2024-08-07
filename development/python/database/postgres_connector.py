"""postgres_connector.py

This module provides a connector class to interact with Postgres database service.

Usage:
    >>> from development.python.database import PostgresConnector
    >>> with PostgresConnector('user', 'password', 'database', 'host') as pg:
    >>>     pg.execute_statement("SOME SQL QUERY")
"""

from psycopg2 import connect
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

from development.python.database.db_connector import DBConnector


class PostgresConnector(DBConnector):
    """PostGreSQL DBConnector class
    """

    def __init__(self, user, password, database, host, port="5432"):
        """Constructor for PostgresConnector class.

        Args:
            user (str): Database user.
            password (str): Database user's password.
            database (str): Database name.
            host (str): Host address.
            port (str, optional): Database service port. Defaults to "5432".
        """
        self._user = user
        self._password = password
        self._database = database
        self._host = host
        self._port = port
        self._conn = None

    @property
    def __get_connection__(self):
        """Method to get a database connection object
        """
        if self._conn is None:
            self._conn = connect(
                user=self._user,
                password=self._password,
                database=self._database,
                host=self._host,
                port=self._port
            )
            
            # By default, psycopg2 statements aren't auto-committing
            self._conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        return self._conn
