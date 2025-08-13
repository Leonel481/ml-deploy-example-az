from flask import Flask, request, jsonify
import joblib
import numpy as np
from sklearn.datasets import load_iris

app = Flask(__name__)

# Load the model and class names
model = joblib.load('iris_model.pkl')
iris = load_iris()
class_names = iris.target_names

@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    prediction = model.predict(np.array(data['input']).reshape(1, -1))
    class_name = class_names[int(prediction[0])]
    return jsonify({
        'prediction': int(prediction[0]),
        'class_name': class_name
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)