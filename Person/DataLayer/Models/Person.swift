//
//  Person.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  Model that replicates the ParseSDK Model
//

import Foundation

struct Person: Codable, Identifiable, Hashable {
  let id: UUID
  let name: String
  let contactNumber: String
  var isPresent: Bool
}
