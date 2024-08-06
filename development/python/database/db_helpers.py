"""db_helpers.py

This module contains helper functions for database connector classes.
"""


def get_result_set_as_dict(columns, records):
    """Function to create list of dictionary records.

    Args:
        columns (list): List of column names.
        records (list): List of tuples (database records).

    Returns:
        list(dict): Each dict corresponds to a single record with keys as column names and values as column values.
    """
    result_set = [dict(zip([column[0] for column in columns], record)) for record in records]
    return result_set
