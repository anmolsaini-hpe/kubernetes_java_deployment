import requests
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/api/reverse', methods=['GET'])
def reverse_message():
    response = requests.get('http://first-service:5000/api/message')
    json_data = response.json()
    reversed_message = json_data['message'][::-1]
    return jsonify({"id": json_data["id"], "message": reversed_message})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
