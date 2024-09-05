//
//  SnippetResponses.swift
//  SnippetResponses
//
//  Created by Nathaniel Kemme Nash on 8/26/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SnippetsEntry {
        SnippetsEntry(date: Date(), snippetsData: SnippetsData(responses: ["Rick Astley|What's your favorite color?|Red|a|a|a|a"]), responses: [Response(displayName: "Rick Astley", question: "What's your favorite color?", response: "Red", snippetId: "", snippetType: "normal", isAnswered: true, userId: "")], index: 0)
        }

    func getSnapshot(in context: Context, completion: @escaping (SnippetsEntry) -> ())  {
        let entry = SnippetsEntry(date: Date(), snippetsData: SnippetsData(responses: ["Rick Astley|What's your favorite color?|Red|a|a|a|a"]), responses: [Response(displayName: "Rick Astley", question: "What's your favorite color?", response: "Red", snippetId: "", snippetType: "normal", isAnswered: true, userId: "")], index: 0)
        completion(entry)
        
        }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
        var flutterData = try? JSONDecoder().decode(SnippetsData.self, from: (sharedDefaults?
            .string(forKey: "snippetsResponsesData")?.data(using: .utf8)) ?? Data())
         let currentDate = Date()
         var entries: [SnippetsEntry] = []
         var entryCount = 1200
         if(flutterData != nil){
             
             if(flutterData!.responses.count == 0){
                 let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
                 let entry = SnippetsEntry(date: entryDate, snippetsData: flutterData, responses: [], index: -2)
                 entries.append(entry)
             } else {
                 
                 for secondOffset in 0..<entryCount {
                     let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 3, to: currentDate)!
                     let index = secondOffset % (flutterData!.responses.count)
                     var responses: [Response] = []
                     for response in 0..<flutterData!.responses.count {
                         responses.append(parseResponse(response: flutterData!.responses[response]))
                     }
                     let entry = SnippetsEntry(date: entryDate,snippetsData: flutterData, responses: responses, index: index)
                     entries.append(entry)
                 }
             }
         } else {
             let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
             let entry = SnippetsEntry(date: entryDate, snippetsData: flutterData, responses: [], index: -1)
             entries.append(entry)
         }
         
         let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(15)))
    
        completion(timeline)
    }
    
    func parseResponse(response: String) -> Response {
        var split = response.split(separator:"|")
        return Response(displayName: String(split[0]), question: String(split[1]), response: String(split[2]), snippetId: String(split[3]), snippetType:String(split[5]), isAnswered: split[6] == "true", userId: String(split[4]))
    }
}

struct SnippetsData: Decodable, Hashable {
    var responses: [String]
 
    
}

struct SnippetsEntry: TimelineEntry {
    let date: Date
    let snippetsData: SnippetsData?
    let responses: [Response]
    let index: Int
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

struct SnippetResponsesEntryView : View {
    var entry: Provider.Entry
    
    
    func openSnippets() -> some View{
        return VStack {
            Text("Open Snippets")
                .font(.system(size: 25, weight: .heavy))
                .foregroundColor(.white.opacity(0.8))
                .widgetURL(URL(string:"/"))
        }
    }
    
    func answerSnippet() -> some View{
        return VStack {
            Text("Q: " + entry.snippetsData!.responses[entry.index].split(separator:"|")[1]).font(.system(size: 20, weight: .heavy))
                .foregroundColor(.white.opacity(0.8))
                .minimumScaleFactor(0.2)
            Spacer()
            
            Text("Answer snippet first to see others responses")
                .font(.system(size: 15, weight: .heavy))
                .foregroundColor(.white.opacity(0.8))
                .minimumScaleFactor(0.2)
                .widgetURL(URL(string:"/home/question/widget/?id=" + entry.snippetsData!.responses[entry.index].split(separator:"|")[3] + "&question=" + entry.snippetsData!.responses[entry.index].split(separator:"|")[1].replacingOccurrences(of: "?", with: "~") + "&type=" + entry.snippetsData!.responses[entry.index].split(separator:"|")[5]))
            Spacer()
        }
    }
    
    func snippetResponse() -> some View {
        return VStack(alignment: .leading, content: {
            Text(entry.responses[entry.index].displayName)
                .font(.system(size: 30, weight: .heavy))
                .foregroundColor(.white.opacity(0.8))
                .minimumScaleFactor(0.2)
                Spacer()
            Text("Q: " + entry.responses[entry.index].question)
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(.white.opacity(0.8))
                .minimumScaleFactor(0.2)
            Spacer()
            Text("A: " + entry.responses[entry.index].response)
                .font(.system(size: 20, weight: .heavy))
                .foregroundColor(.white.opacity(0.8))
                .minimumScaleFactor(0.2)
                .widgetURL(URL(string:"/home/discussion/widget/?snippetId=" + entry.responses[entry.index].snippetId + "&snippetQuestion=" + entry.responses[entry.index].question.replacingOccurrences(of: "?", with: "~") + "&snippetType=" + entry.responses[entry.index].snippetType + "&displayName=" + entry.responses[entry.index].displayName + "&response=" + entry.responses[entry.index].response + "&userId=" + entry.responses[entry.index].userId))
            Spacer()
        })
    }

    var body: some View {
        if(entry.index == -1){
            openSnippets()
        } else if(entry.index == -2){
            VStack {
                Text("No Responses")
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(.white.opacity(0.8))
                    .widgetURL(URL(string:"/"))
                
            }
        }else if(entry.snippetsData!.responses[entry.index].split(separator:"|")[6] == "false"){
            answerSnippet()
        } else {
            snippetResponse()
               
        }
    }
}

struct SnippetConfig: Decodable, Hashable {
    let gradient: String
}

struct SnippetResponses: Widget {
    let kind: String = "SnippetResponses"
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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SnippetResponsesEntryView(entry: entry)
                    .containerBackground(getGradient(entry: entry), for: .widget)
            } else {
                SnippetResponsesEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Snippet Responses")
        .description("Cycles through all your friends responses")
        
    }
    
    func getGradient(entry: SnippetsEntry) -> Gradient {
        if(entry.index >= 0){
            if(entry.responses[entry.index].snippetType == "anonymous"){
                return gradientStyleA
            }
        }
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
        let flutterData = try? JSONDecoder().decode(SnippetConfig.self, from: (sharedDefaults?
            .string(forKey: "snippetsResponsesConfig")?.data(using: .utf8)) ?? Data())
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



//#Preview(as: .systemMedium) {
//    SnippetResponses()
//} timeline: {
//    SnippetsEntry(date: Date(), snippetsData: SnippetsData(responses: ["Rick Astley|What's your favorite color?|Red|a|a|a|a"]), configuration: ConfigurationAppIntent(), responses: [Response(displayName: "Rick Astley", question: "What's your favorite color?", response: "Red", snippetId: "", snippetType: "", isAnswered: false, userId: "")], index: 0)
//}
