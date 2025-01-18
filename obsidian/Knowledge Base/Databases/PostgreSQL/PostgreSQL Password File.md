# PostgreSQL Password File (.pgpass)

The `.pgpass` file allows storing PostgreSQL connection passwords securely to avoid typing them
repeatedly in the terminal.

## Location

- macOS/Unix/Linux: `~/.pgpass`

## File Format

Each line follows this pattern:

```hostname:port:database:username:password```

Example:

```ini
localhost:5432:mydb:postgres:mypassword
remote.host:5432:*:dbuser:anotherpassword
```

## Important Security Notes

- File permissions must be set to 600 (user read/write only)

```shell
  chmod 600 ~/.pgpass
```

- Each line can use * as a wildcard for any field except password
- The first matching line is used

## Usage Examples

```shell
# Connect without password prompt
psql -h localhost -U postgres mydb

# Backup database without password prompt
pg_dump -h localhost -U postgres mydb > backup.sql
```
