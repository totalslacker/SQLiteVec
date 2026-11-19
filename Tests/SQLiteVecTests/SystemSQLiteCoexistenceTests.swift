// Regression guard: a client must be able to import Apple's system `SQLite3`
// module and `CSQLiteVec` in the same Swift module.
//
// This file is the test. If CSQLiteVec ever exports a header whose structs
// differ from the SDK's copy (as sqlite3ext.h's `sqlite3_api_routines` did,
// e.g. vendored 3.51.0 vs the macOS 27.2 SDK's 3.54.0), this target fails to
// compile with "'sqlite3_api_routines' has different definitions in different
// modules". See the note on the CSQLiteVec target in Package.swift.
//
// Linux has no `SQLite3` Clang module, so the check only runs on Apple
// platforms.

#if canImport(SQLite3)
import CSQLiteVec
import SQLite3
import XCTest

final class SystemSQLiteCoexistenceTests: XCTestCase {
    func testSystemSQLite3AndCSQLiteVecCanBeImportedTogether() {
        // Touch a symbol both modules declare, so the importer has to
        // reconcile the two declarations rather than skipping them.
        XCTAssertGreaterThan(sqlite3_libversion_number(), 0)
    }
}
#endif
