"""snowflake_connector.py

This module provides a connector class to interact with Snowflake database service.

Usage:
    >>> from database.snowflake_connector import SnowflakeConnector
    >>> with SnowflakeConnector('user', 'password', 'database', 'schema', 'account') as sf:
    >>>     sf.execute_statement("SOME SQL QUERY")
"""

from snowflake.connector import connect

from database.db_connector import DBConnector
from database.db_helpers import get_result_set_as_dict


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
    def get_connection(self):
        """Property to get database connection object.

        Returns:
            obj: Database connection object.
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
