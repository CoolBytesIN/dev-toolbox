"""postgres_connector.py

This module provides a connector class to interact with Postgres database service.

Usage:
    >>> from database.postgres_connector import PostgresConnector
    >>> with PostgresConnector(user, password, database, host) as pg:
    >>>     pg.execute_statement("SOME SQL QUERY")
"""

import psycopg2
from psycopg2 import extensions

from database.db_connector import DBConnector
from database.db_helpers import get_result_set_as_dict


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
    def get_connection(self):
        """Property to get database connection object.

        Returns:
            obj: Database connection object.
        """
        if self._conn is None:
            self._conn = psycopg2.connect(
                user=self._user,
                password=self._password,
                database=self._database,
                host=self._host,
                port=self._port
            )
            # By default, psycopg2 statements aren't auto-committing
            self._conn.set_isolation_level(extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        return self._conn

    def close_connection(self):
        """Method to close database connection.
        """
        self.get_connection.close()

    def execute_statement(self, sql):
        """Method to execute SQL statements that don't return any result-set.
        Examples: INSERT, DELETE etc.

        Args:
            sql (str): SQL query to be executed.
        """
        with self.get_connection.cursor() as cur:
            cur.execute(sql)

    def query_records_as_dict(self, sql):
        """Method to execute SQL statements that return a result-set.
        The result-set is returned as a list of dictionaries.

        Args:
            sql (str): SQL query to be executed.

        Returns:
            list: List of database records (each record a dict).
        """
        with self.get_connection.cursor() as cur:
            cur.execute(sql)
            return get_result_set_as_dict(cur.description, cur.fetchall())
