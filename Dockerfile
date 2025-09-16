FROM python:3.11.7

WORKDIR /usr/src/app

COPY . .

RUN python -m pip install --upgrade pip && pip install -r requirements.txt
RUN python manage.py migrate
RUN python manage.py loaddata restaurants

CMD python manage.py runserver 0.0.0.0:8000

EXPOSE 8001