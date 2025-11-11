### 1. 빌드 단계
FROM python:3.11.7 AS builder

# Django에서 MySQL을 사용하기 위해 필요한 소프트웨어를 설치합니다.
# 이때 설치하는 소프트웨어는 모두 빌드에 쓰이는 무거운 소프트웨어입니다.
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# requirements만 먼저 복사
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 프로젝트 전체 복사
COPY . .

### 2. 런타임 단계
FROM python:3.11.7-slim

# Django에서 MySQL을 사용하기 위해 필요한 libmariadb3를 설치합니다.
# libmariadb3는 mysqlclient 실행용(Runtime) 패키지로 매우 가볍습니다.
RUN apt-get update && apt-get install -y \
    libmariadb3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# builder에서 설치된 라이브러리를 복사합니다.
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# 프로젝트 코드를 복사해옵니다.
COPY --from=builder /usr/src/app /usr/src/app

CMD python manage.py makemigrations --noinput &&\
	python manage.py migrate --noinput &&\
	python manage.py loaddata restaurants &&\
    python manage.py runserver 0.0.0.0:8000

EXPOSE 8000