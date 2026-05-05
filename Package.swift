// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SQLiteVec",
    platforms: [
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .executable(
            name: "SQLiteVecCLI",
            targets: ["SQLiteVecCLI"]
        ),
        .library(
            name: "SQLiteVec",
            targets: ["SQLiteVec"]
        ),
        .library(
            name: "CSQLiteVec",
            targets: ["CSQLiteVec"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "SQLiteVecCLI",
            dependencies: [
                "SQLiteVec"
            ]
        ),
        .target(
            name: "SQLiteVec",
            dependencies: [
                "CSQLiteVec"
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .target(
            name: "CSQLiteVec",
            publicHeadersPath: "include",
            cSettings: [
                .define("SQLITE_ENABLE_FTS5"),
                // Disable global memory-stats mutex (mem0.mutex). Without this,
                // every sqlite3_prepare_v2 call acquires a process-wide mutex,
                // causing Swift Concurrency cooperative threads to OS-block and
                // saturate the thread pool under concurrent test load. Equivalent
                // to calling sqlite3_config(SQLITE_CONFIG_MEMSTATUS, 0) before
                // any database is opened. See issue #324 / ADR 024.
                .define("SQLITE_DEFAULT_MEMSTATUS", to: "0"),
            ]
        ),
        .testTarget(
            name: "SQLiteVecTests",
            dependencies: [
                "SQLiteVec"
            ]
        ),
    ]
)
