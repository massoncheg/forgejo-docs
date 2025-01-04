---
title: Federation Architecture
license: 'CC-BY-SA-4.0'
---

While implementing federation in Forgejo we introduced some concepts from DomainDrivenDesign:

1. **Aggregate**: Aggregates are clusters of objects (entities or values) which are handled atomic when it comes to persistence.
2. **Validation**: Every object should express it's own validity, whenever someone is interested in
   1. we collect as many invalidity information as possible in one shoot - so we return a list of validation issues if there are some.
   2. Objects entering the lifetime are checked for validity on the borders (after loaded from and before stored to DB, after being newly created (New\* functions) or after loaded via web / REST).

Objects in forgefed package reflect Objects from ap or f3 lib but add some Forgejo specific enhancements like more specific validation.

## Federation Model

![diagram](../_mermaid/_images/developer/federation-architecture-1.svg)

## Normalized URI used as ID

In order to use URIs as ID we've to normalize URIs.

A normalized user URI looks like: `https://federated-repo.prod.meissa.de/api/v1/activitypub/user-id/1`

In order to normalize URIs we care:

1. Case (all to lower case): `https://federated-REPO.prod.meissa.de/api/v1/activitypub/user-id/1`
2. No relative path: `https://federated-repo.prod.meissa.de/api/v1/activitypub/user-id/../user-id/1`
3. No parameters: `https://federated-repo.prod.meissa.de/api/v1/activitypub/user-id/1?some-parameters=1`
4. No Webfinger: `https://user1@federated-repo.prod.meissa.de` (with following redirects)
5. No default api: `https://federated-repo.prod.meissa.de/api/activitypub/user-id/1`
6. No authorization: `https://user:password@federated-repo.prod.meissa.de/api/v1/activitypub/user-id/1`
7. No default ports: `https://federated-repo.prod.meissa.de:443/api/v1/activitypub/user-id/1`
8. Accept non default ports: `http://localhost:3000/api/v1/activitypub/user-id/1`
