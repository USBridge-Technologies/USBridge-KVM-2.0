# Version History

This repository serves as a structured archive for all deprecated USBridge software releases, encompassing desktop clients, mobile application binaries, and system firmware images.

## Operational Purpose

While operating on the latest stable build is strictly recommended for optimal performance and security, access to legacy software versions is structurally critical for production infrastructure management.

* **Controlled Rollback:** Rapidly downgrade to a validated client or firmware build if unexpected compatibility regressions occur on legacy target hardware.
* **Deterministic Debugging:** Isolate and reproduce anomalous behavior by explicitly matching the client-stack version to a specific historical automation environment.
* **Version Pinning:** Retrieve specific, cryptographically verified binaries for deployment within strictly regulated enterprise environments where software lifecycle policies prohibit automatic updates.

---

## Archive Data Structure

As incremental updates are deployed, all deprecated versions are systematically relegated to this archive and documented under a standardized technical format.

| Artifact Component | Technical Specification |
| :--- | :--- |
| **Version Identifier** | Semantic versioning string coupled with the exact compilation timestamp (e.g., `v2.0`). |
| **Binary Distributions** | Direct, secure payload links across all supported architectural platforms (Windows, macOS, Linux, iOS, Android). |
| **Cryptographic Checksums** | SHA-256 hashes generated for every binary artifact to guarantee payload integrity and prevent supply-chain tampering. |
| **Changelog Reference** | Direct routing to the detailed architectural release notes associated with that specific historical build. |

---

## Current Archive Status

The product lifecycle is currently operating exclusively on the initial production baseline (`v2.0`). Consequently, no deprecated builds have been relegated to this archive at this time.

Upon the deployment of subsequent over-the-air (OTA) updates or client application releases, the original `v2.0` distributions and their associated cryptographic signatures will be migrated to this repository to form the foundational archive set.
