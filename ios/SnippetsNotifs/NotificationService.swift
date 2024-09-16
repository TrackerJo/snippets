//
//  NotificationService.swift
//  SnippetsNotifs
//
//  Created by Nathaniel Kemme Nash on 9/1/24.
//

import UserNotifications
import UIKit
import WidgetKit
import BackgroundTasks

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    @MainActor override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
        
       print("recieved notif")
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
//            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            var userInfo = bestAttemptContent.userInfo
//            var stringKeyedDict: [String: Any] = [:]
//            for (key, value) in userInfo {
//                if let stringKey = key as? String {
//                    stringKeyedDict[stringKey] = value
//                } else {
//                    // Handle cases where the key is not a String, if necessary
//                    print("Non-string key found: \(key)")
//                }
//            }
//
//            // Now you can use stringKeyedDict in your CodableDictionary
//            let codableDict = CodableDictionary(data: stringKeyedDict)
//            
//            print("modif title")
//            if let encodedData = try? JSONEncoder().encode(codableDict) {
//                // Save the encoded data to UserDefaults with the key "userInfo"
//                UserDefaults.standard.set(encodedData, forKey: "userInfo")
//                let request = BGProcessingTaskRequest(identifier: "com.kazoom.snippet.refreshWidgets")
////                request.earliest = Date(timeIntervalSinceNow: 15 * 60)
//                do {
//                     try BGTaskScheduler.shared.submit(request)
//                  } catch {
//                     print("Could not schedule app refresh: \(error)")
//                  }
//            }
            if(userInfo["type"] as! String == "new-botw"){
                var total: String = userInfo["blank"] as! String
                
                total = total.replacingOccurrences(of: " of", with: "|")
                var blank = total.split(separator: "|")[0]
               var data = BOTWData(
                text: String(blank),
                answers: []
               )
                sharedDefaults?.set(encodeBOTWToJSON(botwData: data), forKey: "botwData")
                WidgetCenter.shared.reloadAllTimelines()
               
              } else if(userInfo["type"] as! String == "question"){
    
    
                  var flutterData = try? JSONDecoder().decode(SnippetsData.self, from: (sharedDefaults?
                      .string(forKey: "snippetsData")?.data(using: .utf8)) ?? Data())
                  if(flutterData == nil ){
                      flutterData = SnippetsData(snippets: [])
                  }
                  var snippets: [Snippet] = []
                  for snipString in flutterData!.snippets {
                      snippets.append(parseSnippet(snippet: snipString))
                  }
    
    
    
                  var indexData = Int(userInfo["index"] as! String);
    
                  var index = snippets.firstIndex(where: { $0.index == indexData })
                  if(index == nil){
                      index = -1
                  }
    
                if(index == -1) {
                    snippets.append(Snippet(question: userInfo["question"] as! String, id: userInfo["snippetId"] as! String, index: indexData!, isAnonymous: userInfo["snippetType"] as! String == "anonymous", hasAnswered: false, removalDate: userInfo["removalDate"] as! String))
    
                
    
                } else {
                  //Old question
                    var oldId = snippets[index!].id;
                  //Delete old responses
                    var oldResponses = try? JSONDecoder().decode(SnippetsRData.self, from: (sharedDefaults?
                        .string(forKey: "snippetsResponsesData")?.data(using: .utf8)) ?? Data())
    
                    var newResponses: [String] = [];
                    for response in oldResponses!.responses {
                        if(response.split(separator: "|")[3] == oldId) {
                      continue;
                    }
                    newResponses.append(response);
                  }
                    oldResponses!.responses = newResponses;
    
                    sharedDefaults?.set(encodeSnippetRDataToJSON(snippetsRData: oldResponses!), forKey: "snippetsResponsesData")
                    snippets[index!] = Snippet(question: userInfo["question"] as! String, id: userInfo["snippetId"] as! String, index: indexData!, isAnonymous: userInfo["snippetType"] as! String == "anonymous", hasAnswered: false, removalDate: userInfo["removalDate"] as! String)
                    
                    
                }
                  
                  var newSnippets: [String] = []
                  
                  for snippet in snippets {
                      newSnippets.append(snipToString(snippet: snippet))
                  }
                  flutterData!.snippets = newSnippets
    
    
                  
    
                  sharedDefaults?.set(encodeSnippetsDataToJSON(snippetsData: flutterData!), forKey: "snippetsData")
    
               
    
              } else if(userInfo["type"] as! String == "widget-botw-answer"){
                  var flutterData = try? JSONDecoder().decode(BOTWData.self, from: (sharedDefaults?
                      .string(forKey: "botwData")?.data(using: .utf8)) ?? Data())
    
                  let answer = Answer(uid: userInfo["uid"] as! String, answer: userInfo["answer"] as! String, displayName: userInfo["displayName"] as! String)
    
                  var oldAnswers = flutterData!.answers
                //Check if answer already exists
                 var oldAnswer = oldAnswers.first(where: {$0.uid == userInfo["uid"] as! String})
                if(oldAnswer == nil) {
                  oldAnswers.append(answer);
                } else {
                    if let i = oldAnswers.firstIndex(of: oldAnswer!) {
                        oldAnswers[i] = answer
                    }
    
                }
                  flutterData!.answers = oldAnswers;
    
                  sharedDefaults?.set(encodeBOTWToJSON(botwData: flutterData!), forKey: "botwData")
                  WidgetCenter.shared.reloadAllTimelines()
    
    
              } else if(userInfo["type"] as! String == "snippetAnswered"){
                  var flutterData = try? JSONDecoder().decode(SnippetsRData.self, from: (sharedDefaults?
                      .string(forKey: "snippetsResponsesData")?.data(using: .utf8)) ?? Data())
                  var oldResponses = flutterData!.responses
                  let responseString = "\(userInfo["displayName"] ?? "")|\(userInfo["question"] ?? "")|\(userInfo["response"] ?? "")|\(userInfo["snippetId"] ?? "")|\(userInfo["uid"] ?? "")|\(userInfo["snippetType"] ?? "")|\(userInfo["answered"] ?? "")";
                  if(!oldResponses.contains(responseString)) {
                      var answeredSnippets: [String] = []
                      oldResponses.append(responseString);
                      for response in oldResponses {
                          var splitR = response.split(separator: "|")
                          if(splitR[6] == "true" && !answeredSnippets.contains(String(splitR[3]))) {
                              answeredSnippets.append(String(splitR[3]))
        
                          }
                      }
                      for response in oldResponses {
                          var splitR = response.split(separator: "|")
                          if(splitR[6] != "true" && answeredSnippets.contains(String(splitR[3]))) {
                              splitR[6] = "true"
                              oldResponses[oldResponses.firstIndex(of: response)!] = splitR.joined(separator: "|")
        
                          }
                      }
        
        
                      flutterData!.responses = oldResponses
                      print("RESPONSES: \(oldResponses)")
                      
        
                      sharedDefaults?.set(encodeSnippetRDataToJSON(snippetsRData: flutterData!), forKey: "snippetsResponsesData")
                          WidgetCenter.shared.reloadAllTimelines()
                    }
                 
    
                      // Fallback on earlier versions
    
                
              }
            
            if let userDefaults = UserDefaults(suiteName: "group.kazoom_snippets") {
                let badgeCount = userDefaults.integer(forKey: "badgeCount")
                if badgeCount > 0 {
                    userDefaults.set(badgeCount + 1, forKey: "badgeCount")
                    bestAttemptContent.badge = badgeCount + 1 as NSNumber
                    
                } else {
                    userDefaults.set(1, forKey: "badgeCount")
                    bestAttemptContent.badge = 1
                }
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    // A custom Codable wrapper for Any type
    struct AnyCodable: Codable {
        let value: Any
        
        init(_ value: Any) {
            self.value = value
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let intValue = try? container.decode(Int.self) {
                value = intValue
            } else if let doubleValue = try? container.decode(Double.self) {
                value = doubleValue
            } else if let stringValue = try? container.decode(String.self) {
                value = stringValue
            } else if let boolValue = try? container.decode(Bool.self) {
                value = boolValue
            } else if let arrayValue = try? container.decode([AnyCodable].self) {
                value = arrayValue.map { $0.value }
            } else if let dictValue = try? container.decode([String: AnyCodable].self) {
                value = dictValue.mapValues { $0.value }
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch value {
            case let intValue as Int:
                try container.encode(intValue)
            case let doubleValue as Double:
                try container.encode(doubleValue)
            case let stringValue as String:
                try container.encode(stringValue)
            case let boolValue as Bool:
                try container.encode(boolValue)
            case let arrayValue as [Any]:
                let codableArray = arrayValue.map { AnyCodable($0) }
                try container.encode(codableArray)
            case let dictValue as [String: Any]:
                let codableDict = dictValue.mapValues { AnyCodable($0) }
                try container.encode(codableDict)
            default:
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Unsupported type"))
            }
        }
    }

    struct CodableDictionary: Codable {
        var data: [String: AnyCodable]
        
        init(data: [String: Any] = [:]) {
            self.data = data.mapValues { AnyCodable($0) }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            data = try container.decode([String: AnyCodable].self, forKey: .data)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(data, forKey: .data)
        }
        
        enum CodingKeys: String, CodingKey {
            case data
        }
    }

    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func encodeSnippetsDataToJSON(snippetsData: SnippetsData) -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(snippetsData)
            
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding SnippetsData: \(error)")
            return nil
        }
    }
    
    func encodeSnippetRDataToJSON(snippetsRData: SnippetsRData) -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(snippetsRData)
            print("SNIPPETRDATA: \(String(data: jsonData, encoding: .utf8) ?? "")")
            
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding SnippetsData: \(error)")
            return nil
        }
    }
    
    func encodeBOTWToJSON(botwData: BOTWData) -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(botwData)
            
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding SnippetsData: \(error)")
            return nil
        }
    }
    
    func parseSnippet(snippet: String) -> Snippet {
        var split = snippet.split(separator:"|")
        return Snippet(question: String(split[0]), id: String(split[1]), index: Int(split[2]) ?? 0, isAnonymous: split[3] == "anonymous", hasAnswered: split[4] == "true", removalDate: String(split[5]))
    }
    
    func snipToString(snippet: Snippet) -> String {
        return "\(snippet.question)|\(snippet.id)|\(snippet.index)|\(snippet.isAnonymous ? "anonymous" : "normal")|\(snippet.hasAnswered)|\(snippet.removalDate)"
    }
    
    
     struct SnippetsRData: Decodable, Hashable, Encodable {
         var responses: [String]
         
         
      
         
     }
    
    struct BOTWData: Decodable, Hashable, Encodable {
        let text: String
        var answers: [Answer]
    }


    struct Answer: Decodable, Hashable, Encodable {
        let uid: String
        let answer: String
        let displayName: String
    }
    
    struct SnippetsData: Decodable, Hashable, Encodable {
        var snippets: [String]
    }

    struct Snippet: Decodable, Hashable {
        var question: String
        var id: String
        var index: Int
        var isAnonymous: Bool
        var hasAnswered: Bool
        var removalDate: String
        
    }

}
