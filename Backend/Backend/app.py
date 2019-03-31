import os
from flask import Flask, flash, request, redirect, url_for, Response
from werkzeug.utils import secure_filename
import recognition

UPLOAD_FOLDER = os.getcwd()
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/", methods=['GET', 'POST'])
def add_photo():
    file = request.files['file']
    filename = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
    print('start')
    resp = recognition.start(filename)
    print(resp)
    return Response(resp, mimetype='application/json')

if __name__ == "__main__":
    app.run(host='10.128.31.22', port='3333')
