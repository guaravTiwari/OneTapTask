//
//  Participant.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  Model that represents the HTTP client Models
//

import Foundation

struct Participant: Codable {
  let id: UUID
  let name: String
  let contactNumber: String
  var isPresent: Bool
}
