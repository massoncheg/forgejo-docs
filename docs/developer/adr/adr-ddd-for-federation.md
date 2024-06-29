---
title: 'ADR: DDD for Federation'
license: 'CC-BY-SA-4.0'
---

## Status

WIP

## Context

With federation we introduced a topic independent to existing gitea. This will give us the chance to choose other architecture principles.

Discussion see: https://codeberg.org/forgejo/discussions/issues/179

## Decision

tbd

## Choices

### 1. Do federation stuff following Domain Driven Design in combination with Dependency Injection

**Let's do federation related stuff following DDD as whole. But let's keep the existing codebase as is.**

Reason for this proposal are:

1. Federation is new, so it might be possible to adjust the architecture for the new code. For existing (f3 code) we might find a way of migration and I offer help :-)
2. Keep the existing functionality in existing layout will keep compatibility for gitea contributions - as long as we can use them.

Code-Example can be found here: https://codeberg.org/forgejo/forgejo/pulls/4193

#### 1.1 Aspects and Properties

1. Entities and value structs: they contain as much domain logic as possible.
2. Aggregates: they are atomary units in terms of persistence. This, however, has still some room for improvement :)
3. Interfaces for infrastructure: infrastructure is encapsulated from domain logic by interfaces. This allows unit testing in combination with mocks.
4. Service: services provide logic that does not belong to a single aggregate or entity, or is using infrastructure.
5. Poor man's dependency injection: services contain infrastructure implementations. This allows to differentiate composition of used infrastructure between production or test usage. This also has room for improvement, because we do not have an application context singleton (as in Spring Boot).

#### 1.2 Expected Benefit

1. We can unittest all paths in service. Integration test has only to cover the most important paths like "Happy Path" or "Failure Path".
2. We can decide to separate `domain` from `domain_test`
3. We can split up the (in future probable) huge federation service along the domain aggregates `FederationHost`, `User`. This will lead to packages `domain/FederationHost` having a `FederationService` or `domain/User` having a `UserService`. This will help to keep the services focussed around one domain.
4. Refactorings of domain stays simple, as we have all paths under unit tests.
5. Aggregates are way to model out meaningful submodules in terms of domain. We can improve & sharpen this model in a iterative way. Therefor are Aggregates also the point defining the shape of used repositories and apis.
6. Aggregates bring the chance of performance improvements: If accessing db multiple times for one use case in my experience often leads to bad performance compared to "load all on start & save all at the end". But minimizing the times of accessing db stands against amount of data being loaded every time. A good & sharp modelled aggregate might reflect the sweet spot between both bad performing borders.

#### 1.3 See also

1. Wiki: https://en.wikipedia.org/wiki/Domain-driven_design
2. MartinFowler: https://martinfowler.com/bliki/DomainDrivenDesign.html
3. Distilled eBook: https://dl.ebooksworld.ir/motoman/AW.Domain-Driven.Design.Distilled.www.EBooksWorld.ir.pdf
