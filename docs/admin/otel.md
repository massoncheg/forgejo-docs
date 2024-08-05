---
title: 'Open Telemetry integration'
license: 'CC-BY-SA-4.0'
---

[OpenTelemetry](https://opentelemetry.io/) is a open source standard which allows for instrumentation of an application.
It enabled administrator to measure Forgejo performance to find potential issues
and act on them before they become unmanagable or just for debugging performance.

Forgejo currently implements only tracing part of the specification, with metrics handled by Prometheus.

## Quick Setup

Administrator can enable the feature by setting the feature flag `[opentelemetry].ENABLED` to `true`. The predefined exporter configuration will try to send data to `localhost:4318` via `http/protobuf` protocol.

## Resources

Administrator can set the name and custom attributes to enrich the exported items with more metadata. By default Forgejo sets `service.name` to `forgejo`, but this can be changed with `[opentelemetry].SERVICE_NAME` setting.
Custom resource attributes can be set with `[opentelemetry].RESOURCE_ATTRIBUTES` in format `key=value,key2=value2`. It's best to follow the [Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/resource/) for resource while adding custom attributes as collection stores may visualize them better or handle in a more specific way.

Additionally more metadata can be automatically added using resource detectors controllable with `[opentelemetry].RESOURCE_DETECTORS`. Available options can be found in [config cheat sheet](../config-cheat-sheet/#opentelemetry-opentelemetry). The detectors aren't a stable Open Telemetry specification and can be removed or added later releases.

## Tracing

Traces are one of signals in Open Telemetry specification. Gathering of them can be turned off and on individually by setting `[opentelemetry].TRACES_EXPORTER=none` to disable exporter and therefore traces. Alternatively it can be set to `otlp`, which is the default and only other supported value, to enable the OTLP exporter.

Which spans will be sent can be infuenced with `[opentelemetry].TRACES_SAMPLER` and `[opentelemetry].TRACES_SAMPLER_ARG` options. Not all samplers support the argument. More details can be found in the [config cheat sheet](../config-cheat-sheet/#opentelemetry-opentelemetry).

## OTLP Exporter

The default exporter is configurable in `[opentelemetry.exporter.otlp]` section and it's subsections if needed. It follows naming of the [opentelemetry exporter configuration options](https://opentelemetry.io/docs/specs/otel/protocol/exporter/#configuration-options) all of which are listed below:

- `ENDPOINT=http://localhost:4318` - urlf for the collector
- `CERTIFICATE=` - path to certificate for TLS
- `CLIENT_CERTIFICATE=` - path to client certificate for TLS
- `CLIENT_KEY=` - path to client key for TLS
- `COMPRESSION=` - compression switch, can be set to gzip
- `HEADERS=` - key value list of headers to use
- `PROTOCOL=http/protobuf` - which protocol to use for exports, supports `grpc` and `http/protobuf`
- `TIMEOUT=10s` - controls the timeout of the export

If `ENDPOINT` contains `unix` or `http` the insecure flag is transparently set.
