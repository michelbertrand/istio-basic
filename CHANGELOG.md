# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [1.0.4] - 07-03-2025
### Added
- Initial release of the Istio Basic Helm Chart.
- Ratings service
- Reviews service v1, v2 and v3
- Productpage service
- Envoy filter using Lua scripts
- General error fix / Specially for pod labels in Service
- The default log level for istio-proxy is warn, change the lua scipt to use logWarn instead of logInfo
- Added script to manage creation or deletion of the chart from bookinfo and istio resources
- Bug fxes to create the application