import os
import json
import pathlib

cwd = pathlib.Path.cwd()
print(cwd)
file_dir =  cwd / 'data' / 'seasons'
print(file_dir)

def seasons_gather_data():
    #directory = file_dir
    season_docs = []
    for file in os.listdir(file_dir):
        with open(os.path.join(file_dir, file)) as f:
            data = f.read()
            raw_data = json.loads(data)
    for team in raw_data:
        season_docs.append(f"The {team['Name']} belong to the {team['Conference']} Conference.")
        season_docs.append(f"The {team['Name']} belong to the {team['Conference']} {team['Division']}")
        season_docs.append(f"The {team['Name']} won {team['Wins']} games")
        season_docs.append(f"The {team['Name']} lost {team['Losses']} games")
        season_docs.append(f"The {team['Name']} win {(team['Percentage'])*100}% of the time")
        season_docs.append(f"The {team['Name']} scored {team['PointsFor']} points")
        season_docs.append(f"The {team['Name']} won {team['DivisionWins']} division games")
        season_docs.append(f"The {team['Name']} lost {team['DivisionLosses']} division games")
        season_docs.append(f"The {team['Name']} won {team['ConferenceWins']} conference games")
        season_docs.append(f"The {team['Name']} lost {team['ConferenceLosses']} conference games")
        season_docs.append(f"The {team['Name']} rank {team['GlobalTeamID']} in the NFL")
        season_docs.append(f"The {team['Name']} rank {team['DivisionRank']} in the division")
        season_docs.append(f"The {team['Name']} rank {team['ConferenceRank']} in the conference")
        season_docs.append(f"The {team['Name']} won {team['HomeWins']} home games")
        season_docs.append(f"The {team['Name']} lost {team['HomeLosses']} home games")
        season_docs.append(f"The {team['Name']} won {team['AwayWins']} away games")
        season_docs.append(f"The {team['Name']} lost {team['AwayLosses']} away games")
        season_docs.append(f"The {team['Name']} has a win streak of {team['Streak']} games")
        season_docs.append(f"The {team['Team']} is the acronym for {team['Name']}")
    return season_docs

if __name__ == "__main__":
    data = seasons_gather_data()
