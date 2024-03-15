//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by X Y on 3/13/24.
//

import Foundation

class TriviaQuestionService{
    static func fetchQuestion(completion: @escaping ([TriviaQuestion])-> Void){
        guard let url = URL(string: "https://opentdb.com/api.php?amount=10") else{
            print("URL is not working")
            return
        }
        let task = URLSession.shared.dataTask(with: url){data,response, error in
            guard let data = data , error == nil else{
                assertionFailure("Error: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                print("Invalid response or status code")
                return
            }
            do {
                let questions = try parse(data: data)
                let triviaQuestions = questions.map {question in
                    return TriviaQuestion(category: question.category, question: question.question, type: question.type, correctAnswer: question.correct_answer, incorrectAnswers: question.incorrect_answers)}
                DispatchQueue.main.async{
                    completion(triviaQuestions)
                }
            }catch{
                print("Parsing error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    private static func parse(data: Data) throws -> [Question]
    {
        let decoder = JSONDecoder()
        let reponseData = try decoder.decode(TriviaResponse.self, from: data)
        return reponseData.results
    }
}


struct TriviaResponse: Decodable{
    let results : [Question]
}

struct Question: Decodable{
    let type : String
    let difficulty : String
    let category : String
    let question : String
    let correct_answer : String
    let incorrect_answers : [String]
    
    private enum CodingKeys: String, CodingKey{
        case category, difficulty, type, question
        case correct_answer = "correct_answer"
        case incorrect_answers = "incorrect_answers"
    }
}
