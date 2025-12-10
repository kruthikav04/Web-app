FROM python:3.10

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt

ENV PORT=5001
EXPOSE $PORT

CMD ["python", "app.py"]
