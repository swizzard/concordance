FROM python:3.6

COPY . /home/app

RUN pip install -U pip                           \
    && pip install -r /home/app/requirements.txt \
    && python -m spacy download en_core_web_lg
