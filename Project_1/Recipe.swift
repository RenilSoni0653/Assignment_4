//
//  File.swift
//  Project_1
//
//  Created by Raj-Renil on 2023-12-06.
//

struct RecipeDetails: Codable {
    let title: String
    let imageURL: String
    // Add other properties as needed to match the JSON response
    
    // CodingKeys if property names in struct differ from JSON keys
    enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "image"
        // Match other properties with JSON keys
    }
}
