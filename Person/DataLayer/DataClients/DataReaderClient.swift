//
//  DataReaderClient.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  This Class represents the ParseSDK Client
//  Fetches list of people from Database(User Defaults currently)
//


import Foundation

final class DataReaderClient {
  
  private let server = ServerReplica()
  
  func fetchPeople() async throws -> [Person] {
    let data = try await server.allParticipants()
    return try JSONDecoder().decode([Person].self, from: data)
  }
  
  func fetchPerson(with id: UUID) async throws -> Person? {
    let data = try await server.person(with: id)
    return try JSONDecoder().decode(Person.self, from: data)
  }
}
