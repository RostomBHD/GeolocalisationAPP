//
//  Data.swift
//  Assignement2
//
//  Created by Benhamada, Rostom on 02/12/2021.
//

import Foundation

struct unicampusart: Decodable {
    let id: String
    let title: String?
    let artist: String?
    let yearOfWork: String
    let type: String?
    let Information: String?
    let lat: String?
    let long: String?
    let location: String
    let locationNotes: String
    let ImagefileName: String?
    let thumbnail: String
    let lastModified: String
    let enabled: String
}
struct AllCampusArts: Decodable {
    let campusart: [unicampusart]
}

struct location_section {
    var building : String
    var artwork_info : [unicampusart]
}

var sections = [location_section]()

