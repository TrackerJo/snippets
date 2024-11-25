import UIKit
import BackgroundTasks
import SwiftUI
import Flutter
import FirebaseMessaging
import WidgetKit


@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
      ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
         
          if #available(iOS 16.0, *) {
              UNUserNotificationCenter.current().setBadgeCount(0)
              UNUserNotificationCenter.current().removeAllDeliveredNotifications()
          } else {
              var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
              badgeManager.resetAlertBadgeNumber()
              UNUserNotificationCenter.current().removeAllDeliveredNotifications()
              
          }
          UserDefaults.init(suiteName: "group.kazoom_snippets")?.set(0, forKey: "badgeCount")
          
       

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
      }
    
    
    
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

    struct CodableDictionary: Decodable, Encodable {
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

    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           
//           // If you are receiving a notification message while your app is in the background,
//           // this callback will not be fired till the user taps on the notification launching the application.
//           // Print message ID.
//        let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
//        if(userInfo["type"] as! String == "widget-botw"){
//            var total: String = userInfo["blank"] as! String
//            if(total == "") {return}
//            total = total.replacingOccurrences(of: " of", with: "|")
//            var blank = total.split(separator: "|")[0]
//           var data = BOTWData(
//            text: String(blank),
//            answers: []
//           )
//            sharedDefaults?.set(encodeBOTWToJSON(botwData: data), forKey: "botwData")
//            WidgetCenter.shared.reloadAllTimelines()
//            if #available(iOS 13.0.0, *) {
//                var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
//                badgeManager.addAlertBadge()
//            } else {
//                // Fallback on earlier versions
//            }
//          } else if(userInfo["type"] as! String == "widget-question"){
//
//
//              var flutterData = try? JSONDecoder().decode(SnippetsData.self, from: (sharedDefaults?
//                  .string(forKey: "snippetsData")?.data(using: .utf8)) ?? Data())
//              if(flutterData == nil ){
//                  flutterData = SnippetsData(questions: [], ids: [], indexes: [], isAnonymous: [], hasAnswereds: [])
//              }
//
//         
//
//              var indexData = Int(userInfo["index"] as! String);
//             
//              var index = flutterData!.indexes.firstIndex(of: indexData!)
//              if(index == nil){
//                  index = -1
//              }
//
//            if(index == -1) {
//
//                flutterData!.questions.append(userInfo["question"] as! String);
//                flutterData!.ids.append(userInfo["snippetId"] as! String);
//              
//            flutterData!.indexes.append(indexData!);
//                flutterData!.isAnonymous.append(userInfo["snippetType"] as! String == "anonymous");
//                flutterData!.hasAnswereds.append(false);
//
//            } else {
//              //Old question
//                var oldId = flutterData!.ids[index!];
//              //Delete old responses
//                var oldResponses = try? JSONDecoder().decode(SnippetsRData.self, from: (sharedDefaults?
//                    .string(forKey: "snippetsResponsesData")?.data(using: .utf8)) ?? Data())
//
//                var newResponses: [String] = [];
//                for response in oldResponses!.responses {
//                    if(response.split(separator: "|")[3] == oldId) {
//                  continue;
//                }
//                newResponses.append(response);
//              }
//                oldResponses!.responses = newResponses;
//             
//                sharedDefaults?.set(encodeSnippetRDataToJSON(snippetsRData: oldResponses!), forKey: "snippetsResponsesData")
//                flutterData!.questions[index!] = userInfo["question"] as! String;
//                flutterData!.ids[index!] = userInfo["snippetId"] as! String;
//            
//                flutterData!.indexes[index!] = indexData!;
//                flutterData!.isAnonymous[index!] = userInfo["snippetType"] as! String == "anonymous";
//                flutterData!.hasAnswereds[index!] = false;
//            }
//           
//             
//
//            
//              sharedDefaults?.set(encodeSnippetsDataToJSON(snippetsData: flutterData!), forKey: "snippetsData")
//              
//              WidgetCenter.shared.reloadAllTimelines()
//              if #available(iOS 13.0.0, *) {
//                  var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
//                  badgeManager.addAlertBadge()
//              } else {
//                  // Fallback on earlier versions
//              }
//
//          } else if(userInfo["type"] as! String == "widget-botw-answer"){
//              var flutterData = try? JSONDecoder().decode(BOTWData.self, from: (sharedDefaults?
//                  .string(forKey: "botwData")?.data(using: .utf8)) ?? Data())
//             
//              let answer = Answer(uid: userInfo["uid"] as! String, answer: userInfo["answer"] as! String, displayName: userInfo["displayName"] as! String)
//              
//              var oldAnswers = flutterData!.answers
//            //Check if answer already exists
//             var oldAnswer = oldAnswers.first(where: {$0.uid == userInfo["uid"] as! String})
//            if(oldAnswer == nil) {
//              oldAnswers.append(answer);
//            } else {
//                if let i = oldAnswers.firstIndex(of: oldAnswer!) {
//                    oldAnswers[i] = answer
//                }
//                
//            }
//              flutterData!.answers = oldAnswers;
//            
//              sharedDefaults?.set(encodeBOTWToJSON(botwData: flutterData!), forKey: "botwData")
//              WidgetCenter.shared.reloadAllTimelines()
//            
//
//          } else if(userInfo["type"] as! String == "widget-snippet-response"){
//              var flutterData = try? JSONDecoder().decode(SnippetsRData.self, from: (sharedDefaults?
//                  .string(forKey: "snippetsResponsesData")?.data(using: .utf8)) ?? Data())
//              var oldResponses = flutterData!.responses
//              let responseString = "\(userInfo["displayName"] ?? "")|\(userInfo["question"] ?? "")|\(userInfo["response"] ?? "")|\(userInfo["snippetId"] ?? "")|\(userInfo["uid"] ?? "")|\(userInfo["snippetType"] as! String == "anonymous")|\(userInfo["answered"] ?? "")";
//              if(oldResponses.contains(responseString)) {
//                  return;
//                }
//              var answeredSnippets: [String] = []
//              oldResponses.append(responseString);
//              for response in oldResponses {
//                  var splitR = response.split(separator: "|")
//                  if(splitR[6] == "true" && !answeredSnippets.contains(String(splitR[3]))) {
//                      answeredSnippets.append(String(splitR[3]))
//                      
//                  }
//              }
//              for response in oldResponses {
//                  var splitR = response.split(separator: "|")
//                  if(splitR[6] != "true" && answeredSnippets.contains(String(splitR[3]))) {
//                      splitR[6] = "true"
//                      oldResponses[oldResponses.firstIndex(of: response)!] = splitR.joined(separator: "|")
//                      
//                  }
//              }
//            
//           
//              flutterData!.responses = oldResponses
//              print("RESPONSES: \(oldResponses)")
//             
//              sharedDefaults?.set(encodeSnippetRDataToJSON(snippetsRData: flutterData!), forKey: "snippetsResponsesData")
//                  WidgetCenter.shared.reloadAllTimelines()
//              
//                  // Fallback on earlier versions
//              
//              if #available(iOS 13.0.0, *) {
//                  var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
//                  badgeManager.addAlertBadge()
//              } else {
//                  // Fallback on earlier versions
//              }
//          } else if(userInfo["type"] as! String == "notification") {
//              if #available(iOS 13.0.0, *) {
//                  var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
//                  badgeManager.addAlertBadge()
//              } else {
//                  // Fallback on earlier versions
//              }
//            
//          }
//        
//        var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
//                          badgeManager.addAlertBadge()
               print("INFO: \(userInfo)")
           
           
           completionHandler(UIBackgroundFetchResult.newData)
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
        var questions: [String]
        var ids: [String]
        var indexes: [Int]
        var isAnonymous: [Bool]
        var hasAnswereds: [Bool]
    }
}

