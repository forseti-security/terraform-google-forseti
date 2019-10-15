---
name: PR Template
about: This template is used for PR's.
title: ''
labels: ''
assignees: ''

---

Thanks for opening a Pull Request!

Here's a handy checklist to ensure your PR goes smoothly.

- [ ] I signed Google's [Contributor License Agreement](https://opensource.google.com/docs/cla/)
- [ ] My PR has been functionally tested.
- [ ] I have reviewed the [on_gke submodule](https://github.com/forseti-security/terraform-google-forseti/tree/master/modules/on_gke) and made sure changes are consistent with the root module.
- [ ] I have regenerated documentation by executing `make generate_docs`
- [ ] I have linted my changes be executing `make docker_test_lint`

These guidelines and more can be found in our [contributing guidelines](https://github.com/forseti-security/forseti-security/blob/dev/.github/CONTRIBUTING.md).
