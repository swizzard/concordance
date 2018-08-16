FROM python:3.6

COPY . /home

RUN pip install -U pip && \
    pip install -r /home/requirements.txt && \
    python -m spacy download en_core_web_lg

CMD bash
