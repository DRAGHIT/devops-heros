FROM python:3.12-slim
WORKDIR /app
COPY app app
CMD ["python", "-c", "from app.calculator import add; print(add(10,5))"]
