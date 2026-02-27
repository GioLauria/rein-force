<!-- Docs updated (2026-02-27): General simulator behavior changed (see README/docs). -->
# .githooks/pre-push

- **Location:** .githooks/pre-push
- **Purpose:** Prevent direct tag pushes and encourage using `scripts/tag_release.sh` which enforces changelog updates and annotated tags.
- **Behavior:** Intercepts pushes to `refs/tags/*`. If the tag starts with `v`, it runs the release script and aborts original push (the script itself performs pushes). Non-`v` tags are rejected.
- **Notes:** This is a protective policy. You can disable locally by clearing `core.hooksPath` or editing the hook.
