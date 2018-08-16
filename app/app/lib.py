import os
from urllib.parse import urljoin

import requests
import spacy

from .jwt import concordance_jwt


class Processor:
    model_name = 'en_core_web_lg'
    _model = None

    @property
    def model(self):
        self._model = self._model or spacy.load(self.model_name)
        return self._model


class Requester:
    def __init__(self):
        self.url = 'http://{}:{}'.format(os.environ['PGRST_IP_ADDR'],
                                         os.environ['PGRST_PORT'])
        self.token = concordance_jwt()

    def request(method, endpoint, *, params=None, json=None):
        headers = {
            'Authorization': 'Bearer {}'.format(self.token),
            'Accept': 'application/javascript'
        }
        kwargs = {
            'headers': headers,
            'method': method,
            'url': urljoin(self.url, endpoint)
        }
        if params:
            kwargs['params'] = params
        elif data:
            kwargs['json'] = json
        return requests.request(**kwargs)
