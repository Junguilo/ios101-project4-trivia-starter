//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by June Eguilos on 10/21/25.
//

import Foundation

class TriviaQuestionService {
    static func fetchRandomQuestion(completion: (([TriviaQuestion]) -> Void)? = nil) {
        let url = URL(string: "https://opentdb.com/api.php?amount=10&category=25&difficulty=medium")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // this closure is fired when the response is received //code from lab
            guard error == nil else {
              assertionFailure("Error: \(error!.localizedDescription)")
              return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
              assertionFailure("Invalid response")
              return
            }
            guard let data = data, httpResponse.statusCode == 200 else {
              assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
              return
            }
            // at this point, `data` contains the data received from the response
            let questions = parse(data: data)
            completion?(questions)
        }
        task.resume()
    }
    
    private static func parse(data: Data) -> [TriviaQuestion] {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(TriviaAPIResponse.self, from: data)
            return response.results
        } catch {
            print("Error decoding trivia questions: \(error)")
            return []
        }
    }
    
    
}
