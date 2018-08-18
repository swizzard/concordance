import os

import jwt


def encode_jwt(role):
    payload = {'role': role}
    secret = os.environ['PGRST_JWT_SECRET']
    algorithm = 'HS256'
    return jwt.encode(payload, secret, algorithm).decode('ascii')


def anon_jwt():
    return encode_jwt(os.environ['DB_ANON_ROLE'])


def concordance_jwt():
    return encode_jwt(os.environ['DB_CONCORDANCE_ROLE'])
