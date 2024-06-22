---
title: 'Code Search'
license: 'CC-BY-SA-4.0'
---

Forgejo supports code search through an indexer and `git-grep` as a fallback when [`REPO_INDEXER_ENABLED`](../../admin/config-cheat-sheet#indexer-indexer) is disabled.

# Basic (git-grep)

![Code search results page using git-grep](../_images/user/code-search/gitgrep.png)

If `REPO_INDEXER_ENABLED` is set to `false`, the code search function will be limited to a single repository and will use [`git-grep`](https://git-scm.com/docs/git-grep).

Currently, only fixed strings are supported and any case differences are ignored. The search results will include the matched line, along with a single line before and after the match.

Since, the searches are performed in the fly they may be performed on any valid branch or tag.

# Indexer

![Code search results page using indexer](../_images/user/code-search/indexer.png)

For advanced search queries and searching across an entire organisation or instance, `REPO_INDEXER_ENABLED: true` enables code search via bleve/elasticsearch.

However, search results are limited to the HEAD of the repository.
