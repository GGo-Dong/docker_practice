### 1. Build Stage
FROM python:3.11.7 AS builder
WORKDIR /usr/src/app

# requirements만 먼저 복사 → pip install 캐시 보장
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 프로젝트 전체 복사
COPY . .

### 2. Runtime Stage
# python-slim 에는 mysql 연동을 위한 패키지가 빠져있어서 기본 이미지를 가져옴
FROM python:3.11.7
WORKDIR /usr/src/app

# builder에서 설치된 라이브러리 복사
COPY --from=builder /usr/local/lib/python3.11 /usr/local/lib/python3.11
COPY --from=builder /usr/local/bin /usr/local/bin

# 프로젝트 코드 복사
COPY --from=builder /usr/src/app /usr/src/app

# 컨테이너 실행 시: makemigrations → migrate → loaddata → runserver
CMD sh -c "python manage.py makemigrations --noinput && \
           python manage.py migrate --noinput && \
           python manage.py loaddata restaurants && \
           python manage.py runserver 0.0.0.0:8000"

EXPOSE 8000