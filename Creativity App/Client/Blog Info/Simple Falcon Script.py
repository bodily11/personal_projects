import falcon
class CheckSite(object):
    def on_get(self, req, resp):
        resp.body = falcon.HTTP_200
app = falcon.API()
checksite = CheckSite()
app.add_route('/', checksite)