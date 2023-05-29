---
layout: '~/layouts/Markdown.astro'
title: 'Forgejo Actions'
license: 'CC-BY-SA-4.0'
---

`Forgejo Actions` provides continuous integration driven from the files in the `.forgejo/workflows` directory of a repository.

# Quick start

- Verify that `Enable Repository Actions` is checked in the `Repository` tab of the `/{owner}/{repository}/settings` page.
  ![enable actions](../../../../images/v1.20/user/actions/enable-repository.png)
- Add the following to the `.forgejo/workflows/demo.yaml` file in the repository.
  ```yaml
  on: [push]
  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - run: echo All Good
  ```
  ![demo.yaml file](../../../../images/v1.20/user/actions/demo-yaml.png)
- Go to the `Actions` tab of the `/{owner}/{repository}/actions` page of the repository to see the result of the run.
  ![actions results](../../../../images/v1.20/user/actions/actions-demo.png)
- Click on the workflow link to see the details and the job execution logs.
  ![actions results](../../../../images/v1.20/user/actions/workflow-demo.png)

# Glossary

- **workflow:** a file in the `.forgejo/workflows` directory that contains **jobs**.
- **job:** a sequential set of **steps**.
- **step:** a command the **runner** is required to carry out.
- **runner:** the [Forgejo runner](https://code.forgejo.org/forgejo/runner) daemon tasked to execute the **workflows**.
