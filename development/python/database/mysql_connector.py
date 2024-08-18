"""mysql_connector.py

This module provides a connector class to interact with MySQL database service.

Usage:
    >>> from development.python.database.mysql_connector import MySQLConnector
    >>> with MySQLConnector('user', 'password', 'database', 'host') as ms:
    >>>     ms.execute_statement("SOME SQL QUERY")
"""

from mysql.connector import connect

from development.python.database.db_connector import DBConnector


class MySQLConnector(DBConnector):
    """MySQL DBConnector class
    """

    def __init__(self, user, password, database, host, port="3306"):
        """Constructor for MySQLConnector class.

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
                port=self._port
            )
        return self._conn

    @property
    def __get_cursor__(self):
        """Method to get a database cursor object
        """
        return self.__get_connection__.cursor(dictionary=True)
