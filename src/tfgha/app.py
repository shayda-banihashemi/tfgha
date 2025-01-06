import chromadb
from flask import Flask

import weeks_app
import seasons_app
import articles_app
#import duckdb
from chromadb.config import Settings
from chromadb.utils import embedding_functions
import functools
import time
#comment1
def timer(func):
    @functools.wraps(func)
    def wrapper_timer(*args, **kwargs):
        start_time = time.perf_counter()
        value = func(*args, **kwargs)
        end_time = time.perf_counter()
        run_time = end_time - start_time
        print(f"Ran {func.__name__!r} in {run_time:.4f} secs")
        return value

    return wrapper_timer

RELOAD_DB = True

chroma_client = chromadb.PersistentClient(
    path="./database",
    settings=Settings(anonymized_telemetry=False))

collection = chroma_client.get_or_create_collection(name="my_collection")

def agg_data():
    seasons = seasons_app.seasons_gather_data()
    weeks = weeks_app.weeks_gather_data()
    articles = articles_app.articles_gather_data()
    all_docs = articles + weeks + seasons
    return all_docs

def load_data(docs):
    ids = [f"id{num}" for num in range(1, len(docs) +1 )]
    collection.upsert(documents=docs, ids=ids)

@timer
def query():
    run_query = collection.query(
        query_texts=["what information is there on Baltimore"],
        n_results=2)
    return run_query

app = Flask(__name__)

@app.route('/')
def main():
    if RELOAD_DB:
        results = agg_data()
        load_data(results)
    findings = query()
    return findings

"""p = main()
print(p)"""
app.run(host='0.0.0.0', port=5001)
#comment
