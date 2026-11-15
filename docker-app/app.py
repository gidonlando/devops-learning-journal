
from flask import Flask
import redis
import os

app = Flask(__name__)

APP_ENV = os.getenv("APP_ENV", "development")

cache = redis.Redis(
    host=os.getenv("REDIS_HOST", "redis"),
    port=6379,
    decode_responses=True
)

@app.route("/")
def home():
    count = cache.incr("visits")
    return (
        f"Environment: {APP_ENV}\n"
        f"Visit number: {count}\n"
    )

@app.route("/healthcheck")
def health():
    cache.ping()
    return "healthy\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
