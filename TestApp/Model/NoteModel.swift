//
//  ACNoteModel.swift
//  TestApp
//
//

import Foundation

/*
 * Modal Class mapped to API Mock call
 * Using Decodable Protocol to handle mapping with JSON response
 */

struct NoteModel: Decodable {
    let notes: [Note]
}

struct Note: Decodable {
    var message: String
    var date: String //Holds the Note creation date.
}
