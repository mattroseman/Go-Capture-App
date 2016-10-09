from flask import Flask, render_template, request, url_for, jsonify
from src import imago
import base64
from PIL import Image
from io import BytesIO
import requests

app = Flask(__name__)


# route to handle scoring the game
@app.route('/api/score', methods=['POST'])
def handle_scoring():
	data = request.get_json(force=True)
	im = Image.open(BytesIO(base64.b64decode(data['image'])))
	im.save('accept.jpg', 'JPEG')

	# process the game
	url = imago.process_game('accept.jpg', 0)

	json = {'status' : 'success', 'white_score' : '20', 'black_score' : '10'}

	return jsonify(json)

# route to handle uploading the image
@app.route('/api/upload', methods=['POST'])
def handle_upload():
	data = request.get_json(force=True)
	im = Image.open(BytesIO(base64.b64decode(data['image'])))
	im.save('accept.jpg', 'JPEG')

	# process the game
	url = imago.process_game('accept.jpg', 1)
	print url

	json = {'status' : 'success', 'url' : url}
	print json

	return jsonify(json)

@app.route('/', methods=['POST', 'GET'])
def hello_world():
	json = {'status' : 'TESTING'}

	return jsonify(json)

