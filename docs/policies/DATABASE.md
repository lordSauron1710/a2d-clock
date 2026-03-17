# Database

The current prototype has no database.

Storage policy:

- keep user preferences local and lightweight
- prefer `UserDefaults` or a small settings store over a database
- only introduce a database when there is persistent structured data that justifies it
