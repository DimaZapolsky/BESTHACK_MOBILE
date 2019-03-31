import os
from flask import Flask, flash, request, redirect, url_for
from werkzeug.utils import secure_filename
from Backend.Backend.recognition import main

UPLOAD_FOLDER = '/Users/timurvankov/Documents/projects/server/'
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route("/", methods=['GET', 'POST'])
def add_photo():
    file = request.files['file']
    filename = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
    resp = main(app.config['UPLOAD_FOLDER'] + filename)
    return Response(resp, mimetype='application/json')

if __name__ == "__main__":
    app.run(host='10.128.31.238', port='3333')
