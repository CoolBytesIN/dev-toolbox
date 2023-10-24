"""db_connector.py

This module provides an abstract class for database connector classes.
"""

from abc import ABC, abstractmethod

class DBConnector(ABC):
    """DBConnector Abstract Class
    """

    @property
    @abstractmethod
    def get_connection(self):
        """To be implemented in subclass. This should return a database connection object.
        """
        pass

    @abstractmethod
    def close_connection(self):
        """To be implemented in subclass. This should terminate the database connection.
        """
        pass

    def __enter__(self):
        """No special operations to be done when entering the context manager.
        """
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        """Safely terminate the database connection, in case of failures.
        """
        self.close_connection()
        return exc_type is None
