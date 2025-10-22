//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Mari Batilando on 4/6/23.
//

import Foundation

struct TriviaQuestion: Decodable {
  let category: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
    
  //match API keys to variables
  private enum CodingKeys: String, CodingKey {
    case category
    case question
    case correctAnswer = "correct_answer"
    case incorrectAnswers = "incorrect_answers"
  }
  
  // Custom initializer to decode HTML entities
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let rawCategory = try container.decode(String.self, forKey: .category)
    let rawQuestion = try container.decode(String.self, forKey: .question)
    let rawCorrectAnswer = try container.decode(String.self, forKey: .correctAnswer)
    let rawIncorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
    
    self.category = rawCategory.htmlDecoded
    self.question = rawQuestion.htmlDecoded
    self.correctAnswer = rawCorrectAnswer.htmlDecoded
    self.incorrectAnswers = rawIncorrectAnswers.map { $0.htmlDecoded }
  }
}

struct TriviaAPIResponse: Decodable {
  let results: [TriviaQuestion]
}

extension String {
  var htmlDecoded: String {
    guard let data = self.data(using: .utf8) else { return self }
    
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ]
    
    guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
      return self
    }
    
    return attributedString.string
  }
}
