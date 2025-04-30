//
//  DataServiceProtocol.swift
//  Bevia
//
//  Created by Eugenio Herrera on 29/04/25.
//
import Foundation

protocol DataServiceProtocol {
    // Baby operations
    // FIXME: This needs to be fixed, "Cannot find type 'Baby' in scope" error 
    func saveBaby(_ baby: Baby) -> Bool
    func loadBaby(withID id: UUID) -> Baby?
    func loadAllBabies() ->[Baby]
    func deleteBaby(withID id: UUID) -> Bool
}
