import pathlib

cwd = pathlib.Path.cwd()
myfile = cwd / 'data' / 'nfl_article.txt'

def articles_gather_data():
    article_docs = []
    with open(myfile) as f:
        for lines in f:
            line = lines.rstrip()
            article_docs.append(line)
    return article_docs

if __name__ == "__main__":
    articles_gather_data()
