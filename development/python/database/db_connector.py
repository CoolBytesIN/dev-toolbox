"""db_connector.py

This module provides an abstract class for database connector classes.
"""

import logging
from abc import ABC, abstractmethod

logger = logging.getLogger()
logger.setLevel(logging.INFO)


class DBConnector(ABC):
    """DBConnector Abstract Class
    """

    @property
    @abstractmethod
    def __get_connection__(self):
        """To be implemented in subclass. This should return a database connection object.
        """
        pass

    @property
    @abstractmethod
    def __get_cursor__(self):
        """To be implemented in subclass. This should return a database cursor object.
        """
        pass

    def __close_connection__(self):
        """Method to terminate the database connection.
        """
        self.__get_connection__.close()

    def __enter__(self):
        """No special operations to be done when entering the context manager.
        """
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        """Safely terminate the database connection, with enhanced exception handling.
    
        Args:
            exc_type (type): The type of the exception.
            exc_value (Exception): The exception instance.
            traceback (traceback): Traceback object with exception details.
            
        Returns:
            bool: False if an exception occurred, allowing the exception to propagate.
                True if no exception occurred, suppressing any further propagation.
        """
        try:
            if exc_type is not None:
                logger.error(f"An exception occurred: {exc_value}", exc_info=(exc_type, exc_value, traceback))
            self.__close_connection__()
        except Exception as e:
            logger.error(f"Failed to close database connection: {e}", exc_info=True)
            return False
        
        return exc_type is None
    
    def execute_statement(self, sql, bind_vars=None):
        """Method to execute SQL statements that don't return a result-set.
        Examples: INSERT, DELETE etc.

        Args:
            sql (str): SQL query to be executed.
            bind_vars (tuple): Bind variables for the SQL Query.
        """
        with self.__get_cursor__ as cur:
            logger.info(f"SQL query about to be executed: {sql}")
            cur.execute(sql, bind_vars)

    def query_dict_records(self, sql, bind_vars=None):
        """Method to execute SQL statements that return a result-set.
        The result-set is returned as a list of dictionaries.

        Args:
            sql (str): SQL query to be executed.
            bind_vars (tuple): Bind variables for the SQL Query.

        Returns:
            list: List of database records (each record a dict).
        """
        with self.__get_cursor__ as cur:
            logger.info(f"SQL query about to be executed: {sql}")
            cur.execute(sql, bind_vars)
            return cur.fetchall()
