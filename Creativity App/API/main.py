import falcon
from falcon_multipart.middleware import MultipartMiddleware
from pymongo import MongoClient
import uuid
import base64
import json
import random
import bcrypt
import logging
from tasks import calculate_user_stats
import time
logging.basicConfig(filename='python_falcon.log',level=logging.DEBUG)

class SolveFinal(object):
    def on_get(self, req, resp):
        #problem 1
        var1 = 5
        var2 = 4
        var3 = var1 + var2
        prob1 = var3

        #problem 2
        index_array = []
        for x in range(10):
            index_array.append(x)
        prob2 = index_array

        #problem 3
        prob3 = index_array[4]

        #problem 4
        new_array = []
        for x in index_array:
            new_value = x + 10
            new_array.append(new_value)
        prob4 = new_array

        #problem 5
        def problem(array):
            sum = 0
            for x in array:
                sum += x
            return sum
        prob5 = problem(new_array)

        resp.body = json.dumps({"prob1":prob1,"prob2":prob2,"prob3":prob3,"prob4":prob4,"prob5":prob5})

class CheckSite(object):
    def on_get(self, req, resp):
        resp.body = falcon.HTTP_200

app = falcon.API(middleware=[MultipartMiddleware()])
app.req_options.auto_parse_form_urlencoded = True

checksite = CheckSite()
app.add_route('/', checksite)

solvefinal = SolveFinal()
app.add_route('/solvefinal', solvefinal)

#class Roku(object):
#    def on_get(self, req, resp):
#        resp.status = falcon.HTTP_200
#        word = req.get_param("movie")
#        from roku import Roku
#        import time
#
#        roku = Roku('192.168.1.108')
#
#        roku.home()
#        roku.right()
#        roku.select()
#
#        netflix = roku['Netflix']
#
#        netflix.launch()
#        time.sleep(3)
#
#        roku.back()
#        roku.select()
#        roku.literal(word)
#        time.sleep(3)
#
#        roku.right()
#        roku.right()
#        roku.right()
#        roku.right()
#        roku.right()
#        roku.right()
#        roku.select()
#        time.sleep(3)
#
#        roku.select() 
#
#roku_app = Roku()
#app.add_route('/roku',roku_app)

class GetRandomTen(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        levelID = req.get_param("levelID")
        levelType = req.get_param("levelType")
        levelDiff = req.get_param("levelDiff")
        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        users = connection['testdatabase']['testcollection'].aggregate([{'$match': {'levelID': levelID, 'levelType': levelType, 'levelDiff': levelDiff}}, {"$sample":{"size":10}}])
        responses_to_return = []
        for user in users:
            user_responses = []
            for response in user['responses']:
                if int(response['chances']) > 10:
                    pass
                else:
                    user_responses.append(response)
            if len(user_responses) == 0:
                responses_to_return.append({})
            elif len(user_responses) == 1:
                responses_to_return.append(response)
            else:
                responseNum = random.randrange(0,len(user_responses))
                finalResponse = user_responses[responseNum]
                responses_to_return.append(finalResponse)
        resp.body = json.dumps(responses_to_return)

getrandomten = GetRandomTen()

app.add_route('/getrandomten', getrandomten)


class CheckSession(object):
    def on_post(self, req, resp):
        resp.status = falcon.HTTP_200
        apiKey  = req.get_param("apiKey")
        username = req.get_param("username")

        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        sessionResponse = connection['testdatabase']['testcollectionlogin'].find( { "$and": [{"apiKey": apiKey},{"username":username}]}).count()
        if sessionResponse == 0:
            resp.body = json.dumps({"responseMessage":"No session found"})
        else:
            resp.body = json.dumps({"responseMessage":"Session Check Successful"})

checksession = CheckSession()

app.add_route('/checksession', checksession)


class CheckLogin(object):
    def on_post(self, req, resp):
        resp.status = falcon.HTTP_200
        email  = req.get_param("email")
        password = req.get_param("password")

        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        user_document = connection['testdatabase']['testcollectionlogin'].find({"email":email})
        if user_document.count() == 0:
            response = "No account found for this email address"
        else:
            for user in user_document:
                username = user["username"]
                apiKey = user["apiKey"]
                test = bcrypt.checkpw(password.encode('utf-8'), user["password"])
                if test:
                    response = "Login Successful"
                else:
                    response = "Incorrect password"
        resp.body = json.dumps({"responseMessage":response,"username":username,"apiKey":apiKey})

checklogin = CheckLogin()

app.add_route('/checklogin', checklogin)


class SubmitLogin(object):
    def on_post(self, req, resp):
        resp.status = falcon.HTTP_200
        email  = req.get_param("email")
        password = req.get_param("password")
        username = req.get_param("username")

        hashed = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt(13))

        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        email_response = connection['testdatabase']['testcollectionlogin'].find( { "email": email} ).count()
        if email_response == 0:
            email_flag = False
        else:
            email_flag = True

        username_response = connection['testdatabase']['testcollectionlogin'].find( { "username": username } ).count()
        if username_response == 0:
            username_flag = False
        else:
            username_flag = True

        if email_flag == False and username_flag == False:
            apiKey = str(uuid.uuid4())
            connection['testdatabase']['testcollectionlogin'].insert_one({
                    "email":email,
                    "username":username,
                    "password":hashed,
                    "apiKey":apiKey,
                    "created_at":float(time.time())
        })
            response = {"responseMessage":"Login Successful","apiKey":apiKey}
        elif email_flag == False and username_flag == True:
            response = {"responseMessage":"Username taken"}
        elif email_flag == True and username_flag == False:
            response = {"responseMessage":"Account already created with that email."}
        elif email_flag == True and username_flag == True:
            response = {"responseMessage":"Email and username already taken."}
        else:
            response = {"responseMessage":"This is very bad"}

        resp.body = json.dumps(response)


submitlogin = SubmitLogin()

app.add_route('/submitlogin', submitlogin)

class SubmitLike(object):
    def on_post(self, req, resp):
        resp.status = falcon.HTTP_200
        responseIDs = req.get_param_as_list("responseID")
        type_of_like = req.get_param("type_of_like")
        response_likes = []
        for response in responseIDs:
            response_likes.append(response)
        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        for response in response_likes:
            connection['testdatabase']['testcollection'].update({"responses": {"$elemMatch": {"responseID": response}}},{ "$inc": { "responses.$.{}".format(type_of_like) : 1}})
        resp.body = response


submitlike = SubmitLike()

app.add_route('/submitlike', submitlike)


class SubmitResponse(object):
    def on_post(self, req, resp):

        from nltk.tokenize import WordPunctTokenizer
        import string
        from nltk.corpus import stopwords as sw
        from nltk.stem import WordNetLemmatizer
        import pandas as pd
        stopwords = set(sw.words('english'))
        word_tokenize = WordPunctTokenizer()
        wordnet_lemmatizer = WordNetLemmatizer()

        def get_a_uuid():
            return uuid.uuid4()

        resp.status = falcon.HTTP_200
        userID = req.get_param("userID")
        levelID = req.get_param("levelID")
        levelType = req.get_param("levelType")
        levelDiff = req.get_param("levelDiff")
        responses = req.get_param_as_list("response")
        new_responses = []
        for response in responses:
            final_list = []
            response_nltk = response.lower()
            response_nltk = word_tokenize.tokenize(response_nltk)
            for x in response_nltk:
                if x in stopwords:
                    pass
                elif len(x) <= 1:
                    pass
                elif x[0] in string.punctuation or x[1] in string.punctuation or  x[-1] in string.punctuation:
                    pass
                else:
                    final_list.append(wordnet_lemmatizer.lemmatize(x))

            new_responses.append({
                 "responseID":str(get_a_uuid()),
                 "responseText":response,
                 "responseNLTK":final_list,
                 "likes":0,
                 "chances":0,
                 "user_choice":0,
                 "rarity":0,
                })

        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        objectID = connection['testdatabase']['testcollection'].insert({
                    "userID":userID,
                    "levelID":levelID,
                    "levelDiff":levelDiff,
                    "levelType":levelType,
                    "responses":new_responses,
                    "created_at":float(time.time())
        })

        calculate_user_stats.delay(new_responses,userID,levelID,levelType,levelDiff,str(objectID))

        resp.body = resp.status


submitresponse = SubmitResponse()

app.add_route('/submitresponse', submitresponse)


class GetUserLevelResponses(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        userID = req.get_param("userID")
        levelType = req.get_param("levelType")
        levelID = req.get_param("levelID")
        levelDiff = req.get_param("levelDiff")
        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        db = connection.testdatabase
        statements = db.testcollection.find({'$and':[{'userID': {'$eq': userID}},
                                                    {'levelID':{'$eq': levelID}},
                                                    {'levelType':{'$eq': levelType}},
                                                    {'levelDiff':{'$eq': levelDiff}}
                                                                ]})
        my_responses = []
        for statement in statements:
            for response in statement['responses']:
                my_responses.append(response)
        resp.body = json.dumps(my_responses)

getuserlevelresponses =  GetUserLevelResponses()

app.add_route('/getuserlevelresponses', getuserlevelresponses)

class GetLevelLeaderboard(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_200
        levelType = req.get_param("levelType")
        levelID = req.get_param("levelID")
        levelDiff = req.get_param("levelDiff")
        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        db = connection.testdatabase
        statements_raw = db.testcollectionleaderboard.find({'$and':[{'levelID':{'$eq': levelID}},
                                                                {'levelType':{'$eq': levelType}},
                                                                {'levelDiff':{'$eq': levelDiff}}
                                                                ]})
        statements = [s for s in statements_raw]
        if len(statements) == 0:
            resp.body = json.dumps({})
        elif len(statements) == 1:
            statement = statements[0]
            final_data = {}
            final_data = {
                   "quantity":statement["quantity"],
                   "detail":statement["detail"],
                   "likes":statement["likes"],
                   "rarity":statement["rarity"],
                   "categories":statement["categories"],
                   "userID":statement["userID"]
                           }
            resp.body = json.dumps(final_data)
        else:
            final_data = []
            for statement in statements:
                final_data.append({
                   "quantity":statement["quantity"],
                   "detail":statement["detail"],
                   "likes":statement["likes"],
                   "rarity":statement["rarity"],
                   "categories":statement["categories"],
                   "userID":statement["userID"]
                           })
            resp.body = json.dumps(final_data)

getlevelleaderboard =  GetLevelLeaderboard()

app.add_route('/getlevelleaderboard', getlevelleaderboard)

class GetUserStats(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_201
        userID = req.get_param("userID")
        levelType = req.get_param("levelType")
        levelID = req.get_param("levelID")
        levelDiff = req.get_param("levelDiff")
        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        db = connection.testdatabase
        statements = db.testcollectionleaderboard.find({'$and':[{'userID': {'$eq': userID}},
                                                                {'levelID':{'$eq': levelID}},
                                                                {'levelType':{'$eq': levelType}},
                                                                {'levelDiff':{'$eq': levelDiff}}
                                                                ]})
        test = []
        final_data = {}
        for statement in statements:
            test.append(statement)
        sorted_test = sorted(test, key=lambda k: k['created_at'])
        if len(sorted_test) > 0:
            x = sorted_test[-1]
            final_data = {'quantity':x['quantity'],
                         'detail':round(x['detail']),
                         'likes':x['likes'],
                         'categories':x['categories'],
                         'rarity':round(x['rarity'])
                         }

            resp.body = json.dumps(final_data)
        else:
            resp.body = "None"
        #resp.body = json.dumps({"quantity":quantity,"detail":detail,"likes":likes,"categories":semantic_similarity_score})

getuserstats =  GetUserStats()
app.add_route('/getuserstats', getuserstats)


class GetAllUserStats(object):
    def on_get(self, req, resp):
        resp.status = falcon.HTTP_201
        userID = req.get_param("userID")
        connection = MongoClient('mongodb://admin:admin123@127.0.0.1:27017')
        db = connection.testdatabase
        statements = db.testcollectionleaderboard.find({'userID': {'$eq': userID}})
        test = []
        for statement in statements:
            test.append(statement)
        sorted_test = sorted(test, key=lambda k: k['created_at'], reverse=True)
        if len(sorted_test) == 1:
            for x in sorted_test:
                final_data = {'quantity':x['quantity'],
                             'detail':round(x['detail']),
                             'likes':x['likes'],
                             'categories':x['categories'],
                             'rarity':round(x['rarity']),
                             'levelType':x['levelType'],
                             'levelDiff':x['levelDiff'],
                             'levelID':x['levelID']
                             }
            resp.body = json.dumps(final_data)

        elif len(sorted_test) > 1:
            final_data = []
            for x in sorted_test:
                final_data.append({'quantity':x['quantity'],
                                   'detail':round(x['detail']),
                                   'likes':x['likes'],
                                   'categories':x['categories'],
                                   'rarity':round(x['rarity']),
                                   'levelType':x['levelType'],
                                   'levelDiff':x['levelDiff'],
                                   'levelID':x['levelID']
                                  })

            resp.body = json.dumps(final_data)
        else:
            resp.body = None

getalluserstats =  GetAllUserStats()
app.add_route('/getalluserstats', getalluserstats)
