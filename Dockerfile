# 베이스 이미지 설정
FROM python:alpine

RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    libffi-dev \
    openssl-dev \
    mariadb-connector-c-dev \
    postgresql-dev \
    python3-dev \
    build-base \
    jpeg-dev \
    zlib-dev

# 빌드 인자 설정
ARG DATABASE_HOST
ARG DATABASE_PORT
ARG DATABASE_NAME
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD
ARG PORT
ARG TARGET_EC2_IP

# 작업 디렉터리 설정
WORKDIR /app

# 필요한 파일 복사
COPY requirements.txt .
COPY . .

# 환경 변수 설정
ENV PORT=${PORT}
ENV DATABASE_HOST=${DATABASE_HOST}
ENV DATABASE_PORT=${DATABASE_PORT}
ENV DATABASE_NAME=${DATABASE_NAME}
ENV DATABASE_USERNAME=${DATABASE_USERNAME}
ENV DATABASE_PASSWORD=${DATABASE_PASSWORD}
ENV TARGET_EC2_IP=${TARGET_EC2_IP}

# 파이썬 패키지 설치
RUN pip install --no-cache-dir -r requirements.txt

# 컨테이너 시작 명령어
CMD sh -c "python manage.py runserver 0.0.0.0:${PORT}"