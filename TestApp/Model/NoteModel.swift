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
    let name: String
    let inTime: String
    let outTime: String
    let address: String
    let zipCode: String
    let date: String //Holds the Note creation date.
}
