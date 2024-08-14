FROM python:alpine
# 테스트
RUN apk update
#확인

WORKDIR /app
COPY requirements.txt .
COPY  . .
ENV PORT 3000
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "manage.py", "runserver", "0.0.0.0:$PORT"]