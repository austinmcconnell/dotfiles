# Example Code for Initial Prompt

```python
from uuid import uuid4

class BookTitle:
    def __init__(self, title, author, isbn):
        self.title = title
        self.author = author
        self.isbn = isbn


class BookCopy:
    def __init__(self, isbn):
        self.id = uuid4()          # barcode
        self.isbn = isbn
        self.checked_out_to = None # user_id or None

    @property
    def checked_out(self):
        return self.checked_out_to is not None


class User:
    def __init__(self, first_name, last_name, address):
        self.id = uuid4()
        self.first_name = first_name
        self.last_name = last_name
        self.address = address


class Library:
    def __init__(self):
        self.titles_by_isbn = {}        # isbn -> BookTitle
        self.copies_by_id = {}          # copy_id -> BookCopy
        self.copy_ids_by_isbn = {}      # isbn -> set(copy_id)

    # catalog operations
    def add_title(self, title):
        if title.isbn in self.titles_by_isbn:
            raise ValueError("Title already exists")
        self.titles_by_isbn[title.isbn] = title

    def remove_title(self, isbn):
        if isbn in self.copy_ids_by_isbn and len(self.copy_ids_by_isbn[isbn]) > 0:
            raise ValueError("Cannot remove; copies still exist")
        self.titles_by_isbn.pop(isbn, None)

    # inventory operations
    def add_copy(self, isbn):
        if isbn not in self.titles_by_isbn:
            raise ValueError("Unknown ISBN")

        copy = BookCopy(isbn)
        self.copies_by_id[copy.id] = copy

        if isbn not in self.copy_ids_by_isbn:
            self.copy_ids_by_isbn[isbn] = set()
        self.copy_ids_by_isbn[isbn].add(copy.id)

        return copy.id

    def remove_copy(self, copy_id):
        copy = self.copies_by_id.pop(copy_id, None)
        if not copy:
            return

        isbn = copy.isbn
        if isbn in self.copy_ids_by_isbn:
            self.copy_ids_by_isbn[isbn].discard(copy_id)
            if not self.copy_ids_by_isbn[isbn]:
                del self.copy_ids_by_isbn[isbn]

    # circulation operations
    def checkout(self, copy_id, user_id):
        copy = self.copies_by_id[copy_id]
        if copy.checked_out:
            raise ValueError("Copy is already checked out")
        copy.checked_out_to = user_id

    def checkin(self, copy_id):
        copy = self.copies_by_id[copy_id]
        if not copy.checked_out:
            raise ValueError("Copy is not checked out")
        copy.checked_out_to = None

    def get_book_status(self, copy_id):
        copy = self.copies_by_id[copy_id]
        return copy.checked_out, copy.checked_out_to

    def get_user_loans(self, user_id):
        return [
            copy
            for copy in self.copies_by_id.values()
            if copy.checked_out_to == user_id
        ]
```
