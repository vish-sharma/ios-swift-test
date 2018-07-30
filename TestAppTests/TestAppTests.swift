//
//  TestAppTests.swift
//  TestAppTests
//
//  Created by Omm on 7/30/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import XCTest
@testable import TestApp

class TestAppTests: XCTestCase {
    
    let testViewModel = NotesViewModel()
    var expectation = XCTestExpectation()
    
    override func setUp() {
        super.setUp()
        let exp = expectation(description: "API Expectation")
        
        testViewModel.invokeApiCall(noteDataSource: NotesDataSource.MockJson) { (success, error) in
            if success == true {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Test Mock Response
    
    //Test Mock Array
    func testViewModelTestA() {
        let mockArrayCount = testViewModel.notesMockArray?.count
        XCTAssertNotNil(mockArrayCount, "Err - Character array is empty")
        XCTAssertTrue(testViewModel.notesMockArray!.count > 0, "Err- Array is empty")
    }
    
    //Test Fetch Note from Array Stack
    func testViewModelTestB() {
        let notesData = testViewModel.getNoteForIndex(0)
        XCTAssertNotNil(notesData?.message, "Err - Message is nil")
        XCTAssertNotNil(notesData?.date, "Err- Date is empty!")
    }
    
    //Test Count of Array Stack after Delete Note operation
    func testViewModelTestC() {
        if let originalCount = testViewModel.notesMockFilteredArray?.count {
            testViewModel.deleteNoteFromMockArray(0)
            if let countAfterDelete = testViewModel.notesMockFilteredArray?.count {
                XCTAssertTrue(originalCount > countAfterDelete)
            }
        }
    }
    
    
    //MARK: Test Core Data Response
    //NOTE - ADD CORE DATA BEFORE LAUNCHING THIS TEST CASE ELSE IT WILL FAIL
    
     //Test Core Data Notes Array
    func testViewModelTestD() {
        testViewModel.fetchNotesFromStore(noteDataSource: NotesDataSource.CoreData)
        
        let dataArrayCount = testViewModel.noteDataArray?.count
        XCTAssertNotNil(dataArrayCount, "Err - Core data stack is empty")
        XCTAssertTrue(testViewModel.noteDataArray!.count > 0, "Err- Data Array is empty")
    }
    
    //Test Fetch Note from Core Data
    func testViewModelTestE() {
        testViewModel.fetchNotesFromStore(noteDataSource: NotesDataSource.CoreData)
        
        let notesData = testViewModel.getNoteDataForIndex(0)
        XCTAssertNotNil(notesData?.message, "Err - Message is nil")
        XCTAssertNotNil(notesData?.date, "Err- Date is empty!")
    }
}
