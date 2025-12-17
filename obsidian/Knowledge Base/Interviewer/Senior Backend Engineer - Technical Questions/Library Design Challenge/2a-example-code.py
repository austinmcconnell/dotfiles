class Library:
    def __init__(self):
        self.titles_by_isbn = {}        # isbn -> BookTitle
        self.copies_by_id = {}          # copy_id -> BookCopy
        self.copy_ids_by_isbn = {}      # isbn -> set(copy_id)

        # reservations
        self.reservations_by_isbn = {}  # isbn -> deque([user_id, ...])
        self.user_reservations = {}     # user_id -> set(isbn)

    ...

    def checkin(self, copy_id):
        copy = self.copies_by_id[copy_id]
        if not copy.checked_out:
            raise ValueError('Copy is not checked out')

        isbn = copy.isbn
        copy.checked_out_to = None

        queue = self.reservations_by_isbn.get(isbn)
        if queue:
            next_user_id = queue.popleft()
            copy.checked_out_to = next_user_id

            if next_user_id in self.user_reservations:
                self.user_reservations[next_user_id].discard(isbn)
                if not self.user_reservations[next_user_id]:
                    del self.user_reservations[next_user_id]

            if not queue:
                del self.reservations_by_isbn[isbn]

    def reserve(self, isbn, user_id):
        ...
        if isbn not in self.reservations_by_isbn:
            self.reservations_by_isbn[isbn] = deque()
        self.reservations_by_isbn[isbn].append(user_id)
        ...
