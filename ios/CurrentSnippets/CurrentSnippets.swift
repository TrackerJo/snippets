//
//  Widgets.swift
//  Widgets
//
//  Created by Nathaniel Kemme Nash on 8/25/24.
//

import WidgetKit
import SwiftUI



struct SnippetsProvider: TimelineProvider {
    func placeholder(in context: Context) -> SnippetsEntry {
        SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?", "Pancakes or Waffles?"], ids: ["sdwd", "ss"], indexes: [0, 1], isAnonymous: [false, false], hasAnswereds: [false, false], anonymousRemovalDate: ""), index: 0)
        }

        func getSnapshot(in context: Context, completion: @escaping (SnippetsEntry) -> ()) {
            let entry = SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?", "Pancakes or Waffles?"], ids: ["sdwd", "ss"], indexes: [0, 1], isAnonymous: [false, false], hasAnswereds: [false, false],anonymousRemovalDate: ""), index: 0)
            completion(entry)
        }
    func parseResponse(response: String) -> Response {
        var split = response.split(separator:"|")
        return Response(displayName: String(split[0]), question: String(split[1]), response: String(split[2]), snippetId: String(split[3]), snippetType:String(split[5]), isAnswered: split[6] == "true", userId: String(split[4]))
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
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
            var flutterData = try? JSONDecoder().decode(SnippetsData.self, from: (sharedDefaults?
                .string(forKey: "snippetsData")?.data(using: .utf8)) ?? Data())
            
            
             let currentDate = Date()
             var entries: [SnippetsEntry] = []
             var entryCount = 1200
             if(flutterData != nil){
                 if(flutterData!.anonymousRemovalDate != ""){
                     var dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                     
                     var AremovalDate = dateFormatter.date(from: flutterData!.anonymousRemovalDate)
                     if(currentDate >= AremovalDate!){
                         var indexOfAnonymous = flutterData!.isAnonymous.firstIndex(of: true)
                         flutterData!.questions.remove(at: indexOfAnonymous!)
                         flutterData!.ids.remove(at: indexOfAnonymous!)
                         flutterData!.hasAnswereds.remove(at: indexOfAnonymous!)
                         flutterData!.isAnonymous.remove(at: indexOfAnonymous!)
                         var resData = try? JSONDecoder().decode(SnippetsRData.self, from: (sharedDefaults?
                             .string(forKey: "snippetsResponsesData")?.data(using: .utf8)) ?? Data())
                         if(resData != nil){
                             var responsesList = resData!.responses
                             for response in responsesList {
                                 var responseObj = parseResponse(response: response)
                                 if(responseObj.snippetType == "anonymous"){
                                     resData!.responses.remove(at: responsesList.firstIndex(of: response)!)
                                 }
                             }
                             sharedDefaults?.set(encodeSnippetRDataToJSON(snippetsRData: resData!), forKey: "snippetsResponsesData")
                         }
                         flutterData!.anonymousRemovalDate = ""
                         sharedDefaults?.set(encodeSnippetsDataToJSON(snippetsData: flutterData!), forKey: "snippetsData")
                         
                         
                         
                     }
                 }
                 for secondOffset in 0..<entryCount {
                     let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 3, to: currentDate)!
                     let index = secondOffset % (flutterData!.questions.count)
                     let entry = SnippetsEntry(date: entryDate,snippetsData: flutterData, index: index)
                     entries.append(entry)
                 }
             } else {
                 let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
                 let entry = SnippetsEntry(date: entryDate, snippetsData: flutterData, index: -1)
                 entries.append(entry)
             }
             
             let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(15)))
            completion(timeline)

        }
    func decodeJSONToSnippetsData(jsonString: String) -> SnippetsData? {
        let decoder = JSONDecoder()
        if(jsonString == ""){
            return nil
        }
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error converting string to Data")
            return nil
        }
        
        do {
            let snippetsData = try decoder.decode(SnippetsData.self, from: jsonData)
            print("JSONDATA: \(snippetsData)")
            return snippetsData
        } catch {
            print("Error decoding JSON to SnippetsData: \(error)")
            return nil
        }
    }
}

struct SnippetsData: Decodable, Hashable, Encodable {
    var questions: [String]
    var ids: [String]
    var indexes: [Int]
    var isAnonymous: [Bool]
    var hasAnswereds: [Bool]
    var anonymousRemovalDate: String
}

struct SnippetsRData: Decodable, Hashable, Encodable {
    var responses: [String]
    
    
 
    
}

struct Response: Decodable, Hashable {
    let displayName: String
    let question: String
    let response: String
    let snippetId: String
    let snippetType: String
    let isAnswered: Bool
    let userId: String
}

struct SnippetsEntry: TimelineEntry {
    let date: Date
    let snippetsData: SnippetsData?
    let index: Int
}

struct SnippetConfig: Decodable, Hashable {
    let gradient: String
}


struct SnippetsEntryView : View {
    var entry: SnippetsProvider.Entry
    
    func answeredSnippet() -> some View {
        let id: String = entry.snippetsData!.ids[entry.index]
        let question: String = entry.snippetsData!.questions[entry.index].replacingOccurrences(of: "?", with: "~")
        let isAnonymous: String = entry.snippetsData!.isAnonymous[entry.index] ? "anonymous" : "normal"
        return Text(entry.snippetsData!.questions[entry.index])
            .font(.system(size: 25, weight: .heavy))
            .foregroundColor(.white.opacity(0.8))
            .minimumScaleFactor(0.3)
            .widgetURL(URL(string: "/home/responses/widget/?id=" + id + "&question=" + question + "&type=" + isAnonymous))
    }
    
    func unansweredSnippet() -> some View {
        let id: String = entry.snippetsData!.ids[entry.index]
        let question: String = entry.snippetsData!.questions[entry.index].replacingOccurrences(of: "?", with: "~")
        let isAnonymous: String = entry.snippetsData!.isAnonymous[entry.index] ? "anonymous" : "normal"
        return Text(entry.snippetsData!.questions[entry.index])
            .font(.system(size: 25, weight: .heavy))
            .foregroundColor(.white.opacity(0.8))
            .minimumScaleFactor(0.3)
            .widgetURL(URL(string: "/home/question/widget/?id=" + id + "&question=" + question + "&type=" + isAnonymous))
    }
    var body: some View {
        ZStack{
            if(entry.index == -1){
                VStack {
                    
                    Text("Open Snippets")
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                   
                    
                }
            } else {
                VStack {
                    
                    if(entry.snippetsData!.hasAnswereds[entry.index]){
                        answeredSnippet()
                    } else {
                        unansweredSnippet()
                    }
                   
                    
                }
                
            }
            
        }
    }
}

struct SnippetsWidget: Widget {
    let kind: String = "Widgets"
    @State var gradientStyle = Gradient(colors: [
        .blue, .purple
    ])
    @State var gradientStyleA = Gradient(colors: [
        .gray, .black
    ])
    @State var gradientStyleBG = Gradient(colors: [
        .blue, .green
    ])
    @State var gradientStyleOR = Gradient(colors: [
        .orange, .red
    ])
    @State var gradientStyleYR = Gradient(colors: [
        .yellow, .red
    ])
    @State var gradientStylePP = Gradient(colors: [
        .pink, .purple
    ])
    
    
    
    
    
    

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SnippetsProvider()) { entry in
            if #available(iOS 17.0, *) {
                SnippetsEntryView(entry: entry)
                    .containerBackground(getGradient(entry: entry), for: .widget)
            } else {
                SnippetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Current Snippets")
        .description("Shows the Current Snippets")
        .supportedFamilies([.systemSmall])
    }
    
    func getGradient(entry: SnippetsEntry) -> Gradient {
        if(entry.snippetsData != nil){
            if(entry.snippetsData!.isAnonymous[entry.index]){
                return gradientStyleA
            }
        }
        let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
        let flutterData = try? JSONDecoder().decode(SnippetConfig.self, from: (sharedDefaults?
            .string(forKey: "snippetsConfig")?.data(using: .utf8)) ?? Data())
        if(flutterData == nil) {
            return gradientStyle
        }
        if(flutterData!.gradient == "bluePurple"){
            return gradientStyle
        }
        if(flutterData!.gradient == "blueGreen"){
            return gradientStyleBG
        }
        if(flutterData!.gradient == "orangeRed"){
            return gradientStyleOR
        }
        if(flutterData!.gradient == "yellowRed"){
            return gradientStyleYR
        }
        if(flutterData!.gradient == "pinkPurple"){
            return gradientStylePP
        }
        return gradientStyle
        
        
    }
}

#Preview(as: .systemSmall) {
    SnippetsWidget()
} timeline: {
    SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?", "Pancakes or Waffles?"], ids: ["sdwd", "ss"], indexes: [0, 1], isAnonymous: [false, false], hasAnswereds: [false, false], anonymousRemovalDate: ""), index: 0)
}
