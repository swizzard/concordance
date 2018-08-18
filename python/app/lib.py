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

    def request(self, method, endpoint, params=None, json=None):
        headers = {
            'Authorization': 'Bearer {}'.format(self.token),
            'Accept': 'application/json',
            'Prefer': 'return=representation;resolution=ignore-duplicates',
        }
        kwargs = {
            'headers': headers,
            'method': method,
            'url': urljoin(self.url, endpoint)
        }
        if params:
            kwargs['params'] = params
        elif json:
            kwargs['json'] = json
        return requests.request(**kwargs)

    def get(self, endpoint, params=None):
        return self.request('GET', endpoint, params=params)

    def post(self, endpoint, json, params=None):
        return self.request('POST', endpoint, json=json, params=params)

    def patch(self, endpoint, json, params=None):
        return self.request('PATCH', endpoint, json=json, params=params)

    def delete(self, endpoint, params=None):
        return self.request('DELETE', endpoint, params=params)
