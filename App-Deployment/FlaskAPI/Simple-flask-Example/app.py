from types import MethodType
from flask import Flask, jsonify



items=[
    {'id':0,"name":"John", "age":30, "car":"Scoda Octavia"},
    {'id':1,"name":"jane", "age":20, "car":"Honda Accord"}
]


app = Flask(__name__)
app.debug= True

@app.route('/')
def index():
    return 'Welcome to flask. This is main Deployment'

@app.route("/items/<int:id>", methods=['GET'])
def get(id):
    return jsonify({'Item':items[id]})


if __name__=='__main__':
    app.run(debug=True)


