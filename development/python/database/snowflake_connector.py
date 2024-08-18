"""snowflake_connector.py

This module provides a connector class to interact with Snowflake database service.

Usage:
    >>> from development.python.database.snowflake_connector import SnowflakeConnector
    >>> with SnowflakeConnector('user', 'password', 'database', 'schema', 'account') as sf:
    >>>     sf.execute_statement("SOME SQL QUERY")
"""

from snowflake.connector import connect, DictCursor

from development.python.database.db_connector import DBConnector


class SnowflakeConnector(DBConnector):
    """Snowflake DBConnector class
    """

    def __init__(self, user, password, database, schema, account):
        """Constructor for SnowflakeConnector class.

        Args:
            user (str): Database user.
            password (str): Database user's password.
            database (str): Database name.
            schema (str): Database schema name.
            account (str): Snowflake account name.
        """
        self._user = user
        self._password = password
        self._database = database
        self._schema = schema
        self._account = account
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
                schema=self._schema,
                account=self._account,
            )
        return self._conn

    @property
    def __get_cursor__(self):
        """Method to get a database cursor object
        """
        return self.__get_connection__.cursor(DictCursor)
