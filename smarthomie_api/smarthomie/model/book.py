from marshmallow import post_load

from .transaction import Transaction, TransactionSchema
from .transaction_type import TransactionType


class Book(Transaction):
    def __init__(self, name, amount):
        super(Book, self).__init__(name, amount, TransactionType.BOOK)

    def __repr__(self):
        return '<Book(name={self.name!r})>'.format(self=self)


class BookSchema(TransactionSchema):
    @post_load
    def make_book(self, data, **kwargs):
        return Book(**data)