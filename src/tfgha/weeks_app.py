import os
import json
import pathlib

cwd = pathlib.Path.cwd()
file_dir =  cwd / 'data' / 'weeks'

def weeks_gather_data():
    directory = file_dir
    weeks_docs = []
    for file in os.listdir(directory):
        with open(os.path.join(directory, file)) as f:
            data = f.read()
            raw_data = json.loads(data)
            for game in raw_data:
                if game['HomeScore'] > game['AwayScore']:
                    weeks_docs.append(f"The home team {game['HomeTeam']} won against the away team {game['AwayTeam']} by "
                                f"{game['HomeScore'] - game['AwayScore']} points on {game['StadiumDetails']['PlayingSurface']} "
                                f"{game['StadiumDetails']['Type']}")
                else:
                    weeks_docs.append(f"The away team {game['AwayTeam']} won against the home team {game['HomeTeam']} by "
                                f"{game['AwayScore'] - game['HomeScore']} points")
    return weeks_docs

if __name__ == "__main__":
    weeks_gather_data()