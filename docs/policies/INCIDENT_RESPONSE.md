# Incident Response

For this repo, likely incidents are:

- high CPU or GPU use while idle
- visual burn-in risk from insufficient drift
- broken full-screen launch behavior
- packaging or install regressions in the future `.saver` build

Response order:

1. reproduce locally
2. reduce the issue to the rendering core or host layer
3. patch and add a regression test or documented manual check
4. update `CHANGES.md` when the fix lands
