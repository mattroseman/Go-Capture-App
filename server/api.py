from urllib2 import Request, urlopen
from urllib import urlencode
import requests

client_id = "3f99b016467fa914b817"
client_secret = "69f2ed04fbe2aebc5bcd6b3c8c1d2d261ddf0f62"
grant_type = "738c14504d50579536839c86335985c0"
username = "stohio"
password = "stohio"
access_token = '8863fd9b4dfff0ac69704ca7c2dc9da5f1a77094'

# f = {'client_id' : client_id, 'client_secret' : client_secret, 'grant_type' : password, 'username' : 'stohio', 'password' : 'stohio'}
# values = urlencode(f)
#
# headers = {
#     'Content-Type': 'application/x-www-form-urlencoded'
# }
#
# request = Request('http://online-go.com/oauth2/access_token', data=values, headers=headers)
#
#
# response_body = urlopen(request).read()

def get_key():
    url = "https://online-go.com/oauth2/access_token"
    ogs_response = requests.post(url,
                                 data={"grant_type": "password", "client_id": client_id, "client_secret": client_secret,
                                       "username": username, "password": grant_type})
    access_token = ogs_response.json()['access_token']
    print access_token

url = "https://online-go.com/api/v1/me/games/sgf/"
vitals = requests.post(url, headers={"Authorization": "Bearer " + access_token}, files={'upload_file': open('myfile.sgf','rb')})
print vitals.json()


