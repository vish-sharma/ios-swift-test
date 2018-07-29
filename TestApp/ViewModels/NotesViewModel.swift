//
//  NotesViewModel.swift
//  TestApp
//
//  Created by Omm on 7/27/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import UIKit

/*
 * View Model class handling interaction between View Controllers and Model object.
 * VCs synch up with View Model class to talk with APIManager, Model
 */

class NotesViewModel: NSObject {
    var apiManager: NoteApiManager
    var notesArray : [Note]?
    var notesFilteredArray : [Note]?
    
    override init() {
        apiManager = NoteApiManager()
    }
    
    public func invokeApiCall (completion:(Bool, Error?) -> ()) {
        apiManager.fetchNotesFromAPICall { (result, error) in
            guard error == nil else {
                print("Failed to fetch Data")
                return
            }
            if let noteArr = result?.notes {
                self.notesArray = noteArr
                notesFilteredArray = notesArray
            }
            completion(true, nil)
        }
    }
    
   //MARK: Table Delegate Wrapper
    
    public func numberOfRows() -> Int {
        if let count = self.notesFilteredArray?.count {
            return count
        }
        return 1
    }
    
    /*
     * Method to fetch Note for Cell Indexpath.
     * Compeltion handler pass Note Model object to cell,or Error
     */
    public func getNoteForIndex(_ index:Int) -> Note?  {
        
        if self.notesArray != nil {
            if let count = self.notesFilteredArray?.count,  let noteArr = self.notesFilteredArray  {
                for noteIndex in 0 ..< count {
                    if noteIndex == index {
                        let note = noteArr[noteIndex]
                        return note
                    }
                }
            }
        }
        return nil
    }
    
    //MARK: Add/Delete Note
    
    /*
     * Method to Add new Notes.
     * Appends new notes to Notes array
     */
    public func addNewNote(_ newNote: Note) {
        print(newNote.message)
        if newNote.message != "" {
            notesFilteredArray?.append(newNote)
            notesArray?.append(newNote)
        }
    }
    
    /*
     * Method to filter Notes.
     * Returns filtered notes with Notes filtered array
     */
    public func filterNotesArray(inputStr: String) {
        guard !inputStr.isEmpty else {
            notesFilteredArray = notesArray
            return
        }
        notesFilteredArray = notesArray?.filter({ (note) -> Bool in
            return note.message.lowercased().contains(inputStr.lowercased())
        })
    }
    
}

