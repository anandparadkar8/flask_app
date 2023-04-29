from flask import Flask

app = Flask(__name__)

@app.route("/")
def start():
    return "Welcome to Gada electronic"


@app.get("/rooms")
def get_room():
    return "Inside the store room"


if __name__ == "__main__":
    app.run(host="0.0.0.0",port="5000")

