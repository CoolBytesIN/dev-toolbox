"""singlestore_connector.py

This module provides a connector class to interact with Singlestore database service.

Usage:
    >>> from development.python.database import SingleStoreConnector
    >>> with SingleStoreConnector('user', 'password', 'database', 'host') as s2:
    >>>     s2.execute_statement("SOME SQL QUERY")
"""

from singlestoredb import connect

from development.python.database.db_connector import DBConnector


class SingleStoreConnector(DBConnector):
    """SingleStore DBConnector class
    """

    def __init__(self, user, password, database, host, port="3306"):
        """Constructor for SingleStoreConnector class.

        Args:
            user (str): Database user.
            password (str): Database user's password.
            database (str): Database name.
            host (str): Host address.
            port (str, optional): Database service port. Defaults to "3306".
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
                port=self._port,
            )
        return self._conn
