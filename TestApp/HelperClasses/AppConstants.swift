//
//  AppConstants.swift
//  TestApp
//
//  Created by Omm on 7/27/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import UIKit

struct AppConstants {
    
    //Storyboard Keys
    struct StoryBoard {
        static let AddNoteSegue = "AddNoteSegue"
        static let NoteCell = "NoteCell"
        static let NoteTableViewCell = "NoteTableViewCell"
    }
    
    struct CoreData {
        static let NoteObjectEntity = "NoteObject"
        static let MessageAttribute = "message"
        static let DateAttribute = "date"
    }
    
    struct UIText {
        static let AlertTitle = "Load Notes Data"
        static let AlertMessage = "Fetch Notes based upon User preference"
        static let AlertCoreButton = "Core Data"
        static let AlertMockButton = "Mock Response"
    }
}
