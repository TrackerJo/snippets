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
        SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?", "Pancakes or Waffles?"], ids: ["sdwd", "ss"], indexes: [0, 1], isAnonymous: [false, false]), index: 0)
        }

        func getSnapshot(in context: Context, completion: @escaping (SnippetsEntry) -> ()) {
            let entry = SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?", "Pancakes or Waffles?"], ids: ["sdwd", "ss"], indexes: [0, 1], isAnonymous: [false, false]), index: 0)
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
            let flutterData = try? JSONDecoder().decode(SnippetsData.self, from: (sharedDefaults?
                .string(forKey: "snippetsData")?.data(using: .utf8)) ?? Data())
             let currentDate = Date()
             var entries: [SnippetsEntry] = []
             var entryCount = 1200
             if(flutterData != nil){
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
             
             let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(60)))
            completion(timeline)

        }
}

struct SnippetsData: Decodable, Hashable {
    let questions: [String]
    let ids: [String]
    let indexes: [Int]
    let isAnonymous: [Bool]
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
                    
                    Text(entry.snippetsData!.questions[entry.index])
                        .font(.system(size: 25, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                        .minimumScaleFactor(0.3)
                        .widgetURL(URL(string:"/home/widget/question/?id=" + entry.snippetsData!.ids[entry.index] + "&question=" + entry.snippetsData!.questions[entry.index].replacingOccurrences(of: "?", with: "~") + "&type=normal"))
                   
                    
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
    SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?", "Pancakes or Waffles?"], ids: ["sdwd", "ss"], indexes: [0, 1], isAnonymous: [false, false]), index: 0)
}
