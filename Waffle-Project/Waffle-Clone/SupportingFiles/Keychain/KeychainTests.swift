//
//  KeychainTests.swift
//  Waffle-CloneTests
//
//  Created by Lubomir Valkov on 20.11.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import XCTest
@testable import Waffle_Clone


class KeychainTests: XCTestCase {
    var keychain: Keychain!

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.keychain = Keychain(keychainQueryable: Queryable(service: "Test"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveToKeychain() {
        do {
            try self.keychain.setValue("VALUE", for: "Test")
        } catch (let e) {
            XCTFail("Failed to save keychain: \(e.localizedDescription)")
        }
    }

    func testRetrieveKeychain() {
        do {
            try self.keychain.setValue("VALUE", for: "Test")
            let value = try self.keychain.getValue(for: "Test")
            XCTAssertEqual("VALUE", value)
        } catch (let e) {
            XCTFail("Failed to retrieve keychain: \(e.localizedDescription)")
        }
    }
    
    func testUpdateKeychain() {
        do {
            try self.keychain.setValue("VALUE", for: "Test")
            try self.keychain.setValue("NEWVALUE", for: "Test")
            let value = try self.keychain.getValue(for: "Test")
            XCTAssertEqual("NEWVALUE", value)
        } catch (let e) {
            XCTFail("Failed to update keychain: \(e.localizedDescription)")
        }
    }
    
    func testRemoveKeychain() {
        do {
            try self.keychain.setValue("VALUE", for: "Test")
            try self.keychain.removeValue(for: "Test")
            XCTAssertNil(try self.keychain.getValue(for: "Test"))
        } catch (let e) {
            XCTFail("Failed to remove value: \(e.localizedDescription)")
        }
    }
    
    func testRemoveAllValues() {
        do {
            try self.keychain.setValue("VALUE", for: "Test")
            try self.keychain.setValue("VALUE2", for: "Test2")
            try self.keychain.removeAllValues()
            XCTAssertNil(try self.keychain.getValue(for: "Test"))
            XCTAssertNil(try self.keychain.getValue(for: "Test2"))
        } catch (let e) {
            XCTFail("Failed to remove value: \(e.localizedDescription)")
        }
    }
}
