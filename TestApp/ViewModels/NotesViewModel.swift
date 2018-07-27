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
    var notesArray : NoteModel?
    
    override init() {
        apiManager = NoteApiManager()
    }
    
    func invokeApiCall (completion:(Bool, Error?) -> ()) {
        apiManager.fetchNotesFromAPICall { (result, error) in
            guard error == nil else {
                print("Failed to fetch Data")
                return
            }
            self.notesArray = result
            completion(true, nil)
        }
    }
    
}
