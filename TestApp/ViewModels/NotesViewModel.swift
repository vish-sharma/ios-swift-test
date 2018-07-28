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
    
    override init() {
        apiManager = NoteApiManager()
    }
    
    func invokeApiCall (completion:(Bool, Error?) -> ()) {
        apiManager.fetchNotesFromAPICall { (result, error) in
            guard error == nil else {
                print("Failed to fetch Data")
                return
            }
            if let noteArr = result?.notes {
                self.notesArray = noteArr
            }
            completion(true, nil)
        }
    }
    
   //MARK: Table Delegate Wrapper
    
    func numberOfRows() -> Int {
        if let count = self.notesArray?.count {
            return count
        }
        return 1
    }
    
    /*
     * Method to fetch Note for Cell Indexpath.
     * Compeltion handler pass Note Model object to cell,or Error
     */
    func getNoteForIndex(_ index:Int) -> Note?  {
        
        if self.notesArray != nil {
            if let count = self.notesArray?.count,  let noteArr = self.notesArray  {
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
    
}
