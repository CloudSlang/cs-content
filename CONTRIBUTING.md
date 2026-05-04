# CloudSlang Contribution Guide

Thank you for considering a contribution to CloudSlang content.

We actively welcome external contributors, including first-time open source contributors. Small fixes, docs updates, test improvements, and new integrations are all valuable.

## Ways To Contribute

- Open a bug report or enhancement request in GitHub Issues: https://github.com/CloudSlang/cs-content/issues
- Submit a fix or feature via pull request: https://github.com/CloudSlang/cs-content/pulls
- Improve content quality by adding or updating tests under [test/io/cloudslang/](test/io/cloudslang/)
- Improve developer documentation in [README.md](README.md), [DOCS.md](DOCS.md), and this guide

## Developer Workflow

### 1. Understand the Repository Layout

- Main content packs live under [content/io/cloudslang/](content/io/cloudslang/)
- Integration properties live under [configuration/properties/io/cloudslang/](configuration/properties/io/cloudslang/)
- Tests live under [test/io/cloudslang/](test/io/cloudslang/)
- Optional Python dependencies live under [python-lib/](python-lib/)

### 2. Pick a Change Scope

Keep PRs focused. Preferred scopes:

- One integration area (for example, one provider folder)
- One behavior fix
- One documentation topic

Focused changes are reviewed and merged faster.

### 3. Implement Changes

When updating or adding content:

- Keep behavior backward compatible when possible
- If input/output contracts change, document the change clearly in the PR description
- Add or update tests that demonstrate the new behavior

### 4. Validate Before Opening a PR

All contributed content is expected to pass validation and tests.

- Run content validation and tests with the CloudSlang Build Tool
- Follow content best practices from the CloudSlang documentation: http://www.cloudslang.io/#/docs
- If testing is not feasible (for example, hard-to-reproduce external environments), explain why in the PR

## Pull Request Expectations

### PR Checklist

Before requesting review, make sure your PR includes:

- A clear title and summary of what changed and why
- Linked issue (if applicable)
- Tests added or updated (or a clear justification if not possible)
- Any environment assumptions, credentials shape, or external dependencies
- Breaking-change notes for contract updates

### Review and Merge Process

- Every patch is reviewed, including patches from maintainers
- At least one maintainer approval is required before merge
- If checks fail, update the PR until checks pass
- If review feedback requests changes, please push follow-up commits and keep the PR discussion resolved

## Beta Content Policy

Content that depends on environments that are difficult to set up may be accepted as beta content.

- Beta content is named with the `beta_` prefix
- Beta content is not fully verified by the CloudSlang team
- Community help with validation environments is strongly encouraged

## Community Conduct

Whether you are a regular contributor or a newcomer, we care about making this community a safe place for you.

We are committed to providing a friendly, safe, and welcoming environment for everyone regardless of background or level of contribution.

- Be respectful and constructive
- Do not harass, demean, or exclude others
- Keep discussions professional and collaborative

Questions, feedback, or concerns are welcome at info@cloudslang.io.

## Sign Your Work (DCO)

All contributions must include sign-off to accept the DCO.

Use:

`git commit -s`

This adds a line like:

Signed-off-by: Jane Example <jane@example.com>

For legal reasons, anonymous or pseudonymous contributions are not accepted.

## Developer's Certificate of Origin

All contributions must include acceptance of the DCO:

Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
660 York Street, Suite 102,
San Francisco, CA 94110 USA

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
