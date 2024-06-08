//
//  DataWriterClient.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  This Class represents the API Service, that is being used to write data to the server
//

import Foundation

final class DataWriterClient {
  
  private let server = ServerReplica()

  func personJustCheckedIn(with id: UUID) {
    Task {
      try await server.checkinMember(with: id)
    }
  }
}
