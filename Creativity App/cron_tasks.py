#!/creativity_app/venv/lib python3.5

import time
last_time = time.time() - 60 * 2

import pandas as pd
from pymongo import MongoClient
import logging
from bson.objectid import ObjectId

logging.basicConfig(filename='python_falcon.log',level=logging.DEBUG)

levelTypes = ['tools','associations','problems','solutions']
levelDiffs = ['easy','medium','hard']
levelNums = range(1,11)

connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')

for levelType in levelTypes:
    for levelDiff in levelDiffs:
        for levelNum in levelNums:

            statements = connection['testdatabase']['testcollection'].find( { "$and" : [ { "created_at": { "$gt": last_time } },{ "levelDiff" : { "$eq" : levelDiff } }, { "levelType" : { "$eq" : levelType } }, { "levelID" : { "$eq" : str(levelNum) } } ] } )

            final_list = []
            for statement in statements:
                for response in statement['responses']:
                    final_list = final_list + response['responseNLTK']

            df2 = pd.DataFrame(pd.Series(final_list).value_counts())

            try:
                df = pd.read_csv('/home/bodily11/creativity_app/word_counts/{}_{}_{}.csv'.format(levelType,levelDiff,levelNum),index_col='Unnamed: 0')
                df = pd.DataFrame(pd.concat([df, df2], axis=1).fillna(0).sum(axis=1))
                df.to_csv('/home/bodily11/creativity_app/word_counts/{}_{}_{}.csv'.format(levelType,levelDiff,levelNum))

            except:
                df2.to_csv('/home/bodily11/creativity_app/word_counts/{}_{}_{}.csv'.format(levelType,levelDiff,levelNum))

def calculate_rarity_score(levelType,levelDiff,levelID,responseText):
    try:
        df = pd.read_csv("/home/bodily11/creativity_app/word_counts/{}_{}_{}.csv".format(levelType,levelDiff,levelID),index_col='Unnamed: 0')
    except:
        return 0
    freq = 0
    count = 0
    for word in responseText:
        try:
            freq += df.loc[word][0]
            count += 1
        except:
            return 0
    if count == 0 or freq == 0:
        return 0
    else:
        return 1/((freq / float(count)) / df.count()[0])

# code to calculate a new rarity score for all responses for all levels
connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
cursor = connection['testdatabase']['testcollection'].find({})

statements = [x for x in cursor]

responseIDs = []
rarity_scores = []
for statement in statements:
    for response in statement['responses']:
        responseIDs.append(response["responseID"])
        rarity_scores.append(calculate_rarity_score(statement['levelType'],statement['levelDiff'],statement['levelID'],response['responseNLTK']))

for x,responseID in enumerate(responseIDs):
    connection["testdatabase"]["testcollection"].update( { "responses" : { "$elemMatch" : { "responseID" : responseID } } }, { "$set": { "responses.$.rarity" : rarity_scores[x] } } )


#Update Leaderboard Collection
cursor = connection['testdatabase']['testcollectionleaderboard'].find({})

statements = [x for x in cursor]
for statement in statements:
    objectID = statement['responseObjectID']

    cursor2 = connection['testdatabase']['testcollection'].find({"_id" : ObjectId(objectID) })
    for scores in cursor2:
        rarity = 0
        likes = 0
        count = 0
        for score in scores['responses']:
            rarity += score['rarity']
            likes += score['likes']
            count += 1
    rarity = rarity / float(count)
    print(rarity,likes)
    connection['testdatabase']['testcollectionleaderboard'].update({"responseObjectID":str(objectID)},{"$set": { "likes" : likes , "rarity" : rarity } } )
