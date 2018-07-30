//
//  NotesViewModel.swift
//  TestApp
//
//  Created by Omm on 7/27/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import UIKit
import CoreData

/*
 * View Model class handling interaction between View Controllers and Model object.
 * VCs synch up with View Model class to talk with APIManager, Model
 */

public enum NotesDataSource {
    case CoreData
    case MockJson
}

class NotesViewModel: NSObject {
    var apiManager: NoteApiManager
    var dataSource: NotesDataSource?
    
    //Mock Response Arrays
    var notesMockArray : [Note]?
    var notesMockFilteredArray : [Note]?
    
    //Core Data Model Object Arrays
    var noteDataArray: [NSManagedObject]?
    var noteFilteredDataArray: [NSManagedObject]?
    
    override init() {
        apiManager = NoteApiManager()
    }
    
    /*
     * Method to fetch Notes data from Mock JSON response
     */
    public func invokeApiCall (noteDataSource:NotesDataSource, completion:(Bool, Error?) -> ()) {
        dataSource = noteDataSource
        apiManager.fetchNotesFromAPICall { (result, error) in
            guard error == nil else {
                print("Failed to fetch Data")
                return
            }
            if let noteArr = result?.notes {
                notesMockArray = noteArr
                notesMockFilteredArray = notesMockArray
            }
            completion(true, nil)
        }
    }
    
   //MARK: Common Func
    
    /*
     * Wrapper method to return Number of rows for Table View
     */
    public func numberOfRows() -> Int {
        if dataSource == NotesDataSource.CoreData {
            if let count = self.noteFilteredDataArray?.count {
                return count
            }
        } else  {
            if let count = self.notesMockFilteredArray?.count {
                return count
            }
        }
        return 0
    }
    
    /*
     * Method to Add new Notes.
     * Appends new notes to Mock/Core Data array
     */
    
    public func addNewNote(_ newNote: Note) {
        if dataSource == NotesDataSource.CoreData {
            addNoteToCoreData(newNote)
        } else {
            addNoteToMockArray(newNote)
        }
    }
    
    /*
     * Method to Delete Notes.
     * Deletes selected notes to Mock/Core Data array
     */
    
    public func deleteNote(atIndex: Int) {
        if dataSource == NotesDataSource.CoreData {
            deleteNoteFromCoreData(atIndex)
        } else {
            deleteNoteFromMockArray(atIndex)
        }
    }
    
    //MARK: Mock Response
    
    public func addNoteToMockArray(_ newNote: Note) {
        
        if newNote.message != "" {

            notesMockFilteredArray?.append(newNote)
            notesMockArray?.append(newNote)
        }
    }
    
    public func deleteNoteFromMockArray(_ index: Int) {
        notesMockFilteredArray?.remove(at: index)
        notesMockArray?.remove(at: index)
    }
    
    /*
     * Method to fetch Note for Cell Indexpath.
     * Compeltion handler pass Note Model object to cell
     */
    public func getNoteForIndex(_ index:Int) -> Note?  {
        
        if self.notesMockFilteredArray != nil {
            if let count = self.notesMockFilteredArray?.count,  let noteArr = self.notesMockFilteredArray {
                
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
    
    /*
     * Method to filter Notes.
     * Returns filtered notes with Notes filtered array
     */
    public func filterNotesArray(inputStr: String) {
        guard !inputStr.isEmpty else {
            notesMockFilteredArray = notesMockArray
            return
        }
        notesMockFilteredArray = notesMockArray?.filter({ (note) -> Bool in
            return note.message.lowercased().contains(inputStr.lowercased())
        })
    }
}

//MARK: Core Data

extension NotesViewModel {
    /*
     * Method to Add new Notes to Core Data storage.
     * Appends new notes to Notes array
     */
    public func addNoteToCoreData (_ newNote: Note) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: AppConstants.CoreData.NoteObjectEntity, in: managedContext)!
        
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(newNote.message, forKey: AppConstants.CoreData.MessageAttribute)
        note.setValue(newNote.date, forKey: AppConstants.CoreData.DateAttribute)
        
        do {
            try managedContext.save()
            noteDataArray?.append(note)
            noteFilteredDataArray?.append(note)
        } catch let err as NSError {
            print("Failed to save an item",err)
        }
    }
    
    /*
     * Method to Delete Note from Core Data.
     */
    func deleteNoteFromCoreData(_ index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: AppConstants.CoreData.NoteObjectEntity)
        
        if var dataArray = noteFilteredDataArray {
            for object in 0 ..< dataArray.count {
                if object == index {
                    managedContext.delete(dataArray[object])
                    dataArray.remove(at: index)
                }
            }
        }
        
        do {
            try managedContext.save()
            noteDataArray = try managedContext.fetch(fetchRequest)
            noteFilteredDataArray = noteDataArray
        } catch let err {
            print("Failed to delete note -",err)
        }
        
    }
    
    /*
     * Method to get Note from Index.
     * Compeltion handler pass Note Model object to Table view cell
     */
    public func getNoteDataForIndex(_ index:Int) -> Note?  {
        
        if self.noteDataArray != nil {
            
            if let count = self.noteFilteredDataArray?.count {
                for noteIndex in 0 ..< count {
                    if noteIndex == index {
                        
                        if let noteArr = self.noteFilteredDataArray {
                            let note = noteArr[noteIndex]
                            
                            let noteObject = Note(message: (note.value(forKeyPath: AppConstants.CoreData.MessageAttribute) as? String)!, date: (note.value(forKeyPath: AppConstants.CoreData.DateAttribute) as? String)!)
                            
                            return noteObject
                        }
                    }
                }
            }
        }
        return nil
    }
    
    /*
     * Method to fetch Note from Core Data.
     * Creates Local Arrays of Notes
     */
    
    func fetchNotesFromStore(noteDataSource:NotesDataSource) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: AppConstants.CoreData.NoteObjectEntity)
        do {
            noteDataArray = try managedContext.fetch(fetchRequest)
            noteFilteredDataArray = noteDataArray
        } catch let err {
            print("Failed to fetch notes -",err)
        }
        
        dataSource = noteDataSource
    }
    
    /*
     * Method to filter Notes in Core Data.
     */
    
    func filterNotesDataArray(inputStr: String) {
        guard !inputStr.isEmpty else {
            noteFilteredDataArray = noteDataArray
            return
        }
        
        noteFilteredDataArray = noteDataArray?.filter({ (note) -> Bool in
            let noteMessage = (note.value(forKeyPath: AppConstants.CoreData.MessageAttribute) as? String)!.lowercased()
            return noteMessage.contains(inputStr.lowercased())
        })
    }
}

