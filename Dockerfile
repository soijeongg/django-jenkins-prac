FROM python:alpine
# 다운로드!!
RUN apk update

WORKDIR /app
COPY requirements.txt .
COPY  . .
ENV PORT 3000
CMD ["python", "manage.py", "runserver", "0.0.0.0:$PORT"]