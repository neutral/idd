# Archival Process

Archive only when direction of the system changes, but the older path needs to be preserved for reference purposes.

Archive only on direction change (pivot, deprecation without drop-in replacement). Routine upgrades/refactors do not create a record.

Process:

- Ensure the files that are going to be archived are committed to git with no uncommitted changes and can be referenced at a commit hash.
- Delete the files that need to be archived
- Add an archival log to the local `_archived.md` file if it exists (or create one) to summarize the deleted files, create an archival commit.

An `_archived.md` file can be dropped entirely, or portions of its logs trimmed when they are no longer needed for context.

When portions of a file need to be archived, split it into two files beforehand and archive one of the files with the content that needs to be archived.

Use it extensively in the Arc folder (`intents/arc/`) to archive an arc once it is completed.
