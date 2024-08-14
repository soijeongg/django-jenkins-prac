FROM python:alpine
# 테스트
RUN apk update

WORKDIR /app
COPY requirements.txt .
COPY  . .
ENV PORT 3000
CMD ["python", "manage.py", "runserver", "0.0.0.0:$PORT"]