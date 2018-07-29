//
//  ApiManager.swift
//  TestApp
//
//  Created by Omm on 7/27/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import UIKit

class NoteApiManager: NSObject {
    
    /*
     * Fetch Data from MockNotes and parse it to Model Class.
     * Use completion for passing back data to ViewModel Class.
     *
     * In Real time, we generally use URLSession to fetch API response.
     */
    
    public func fetchNotesFromAPICall (completion:(NoteModel?, Error?)->Void) {
        
        let url = Bundle.main.url(forResource: "MockNotes", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            if let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                print(jsonString)
            }
            
            //Decode JSON to Modal Object
            let decoder = JSONDecoder()
            let apiData = try decoder.decode(NoteModel.self, from: data)
            completion(apiData, nil)
        } catch let error {
            print("Error \(error.localizedDescription)")
        }
    }
}

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

