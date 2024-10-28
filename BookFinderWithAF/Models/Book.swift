//
//  Book.swift
//  BookFinderWithAF
//
//  Created by jhshin on 10/28/24.
//

import Foundation

struct Book: Codable {
	let title: String
	let authors: [String]
	let thumbnail: String
	let price: Int
	let contents: String
	let url: String
	let publisher: String
}

struct Meta: Codable {
	let isEnd: Bool
	enum CodingKeys: String, CodingKey{
		case isEnd = "is_end"
	}
}

struct Root: Codable {
	let meta: Meta
	let books: [Book]
	enum CodingKeys: String, CodingKey {
		case books = "documents"
		case meta
	}
}
