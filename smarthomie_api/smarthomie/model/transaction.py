import datetime as dt

from marshmallow import Schema, fields


class Transaction(object):
    def __init__(self, name, amount, type):
        self.name = name
        self.amount = amount
        self.created_at = dt.datetime.now()
        self.type = type

    def __repr__(self):
        return '<Transaction(name={self.name!r})>'.format(self=self)


class TransactionSchema(Schema):
    name = fields.Str()
    amount = fields.Number()
    created_at = fields.Date()
    type = fields.Str()