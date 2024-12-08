from flask import Flask
import chromadb

app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello from Python deployed with poetry"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
