# 베이스로 삼을 이미지
FROM python:3.11.7

# 작업 디렉토리를 /usr/src/app 으로 옮김
# mkdir /usr/src/app && cd /usr/src/app 과 같은 효과
WORKDIR /usr/src/app

# Dockerfile이 위치한 경로의 모든 파일(빌드 컨텍스트)을 WORKDIR로 옮김
COPY . .

# 이미지 빌드 할 때 1번만 실행할 커맨드
RUN python -m pip install --upgrade pip
RUN pip install -r requirements.txt
RUN python manage.py makemigrations
RUN python manage.py migrate

# 데이터 추가하는 커맨드
# RUN python manage.py loaddata restaurants

# 컨테이너 실행 시 함께 실행되는 커맨드
CMD python manage.py runserver 0.0.0.0:8000

EXPOSE 8000