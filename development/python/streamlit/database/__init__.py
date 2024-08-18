import streamlit as st

from development.python.database.postgres_connector import PostgresConnector


# 1. Show a spinner while a query is being executed on the database
with st.spinner("Running Postgres query..."):
    with PostgresConnector('user', 'password', 'database', 'host') as pg:
        pg.execute_statement("SOME SQL QUERY")


# 2. Cache resource so that it can be reused across multiple operations
# If `ttl` is omitted, the cache will persist indefinitely.
@st.cache_resource(ttl=3600)
def get_db_connector():
    # This Postgres db connector object will be cached
    pg = PostgresConnector('user', 'password', 'database', 'host')
    return pg


# 3. Cache data so that the database won't be overloaded
# If `ttl` is omitted, the cache will persist indefinitely.
@st.cache_data(ttl=3600)
def fetch_data():
    with st.spinner("Getting data from Postgres database..."):
        with PostgresConnector('user', 'password', 'database', 'host') as pg:
            result_set = pg.query_dict_records("SOME SQL QUERY")
            return result_set
