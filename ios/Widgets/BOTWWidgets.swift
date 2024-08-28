//
//  Widgets.swift
//  Widgets
//
//  Created by Nathaniel Kemme Nash on 8/25/24.
//

import WidgetKit
import SwiftUI

struct BOTWProvider: TimelineProvider {
    func placeholder(in context: Context) -> BOTWEntry {
            BOTWEntry(date: Date(), botwData: BOTWData(text: "Joke", answers: []), index: -1)
        }

        func getSnapshot(in context: Context, completion: @escaping (BOTWEntry) -> ()) {
            let entry = BOTWEntry(date: Date(), botwData: BOTWData(text: "Joke", answers: []), index: -1)
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
            let flutterData = try? JSONDecoder().decode(BOTWData.self, from: (sharedDefaults?
                .string(forKey: "botwData")?.data(using: .utf8)) ?? Data())

//            let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
//            let entry = BOTWEntry(date: entryDate, botwData: flutterData)
            let currentDate = Date()
            var entries: [BOTWEntry] = []
            var entryCount = 1800
            
            if(flutterData != nil ){
                for secondOffset in 0..<entryCount {
                    let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset * 3, to: currentDate)!
                    let index = secondOffset % (flutterData!.answers.count + 1)
                    let entry = BOTWEntry(date: entryDate,botwData: flutterData, index: index - 1)
                    entries.append(entry)
                }
            } else {
                let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
                let entry = BOTWEntry(date: entryDate, botwData: flutterData, index: -1)
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(30)))

            completion(timeline)
        }
}


struct BOTWData: Decodable, Hashable {
    let text: String
    let answers: [Answer]
}



struct BOTWEntry: TimelineEntry {
    let date: Date
    let botwData: BOTWData?
    let index: Int
    
}

struct Answer: Decodable, Hashable {
    let uid: String
    let answer: String
    let displayName: String
}


struct BOTWEntryView : View {
    var entry: BOTWProvider.Entry
   
    var body: some View {
        ZStack{
            if(entry.botwData == nil){
                Text("Open Snippets")
                    .font(.system(size: 25, weight: .heavy))
                    .foregroundColor(.white.opacity(0.8))
            } else
            if(entry.index == -1 && entry.botwData != nil){
                VStack {
                    if(entry.botwData != nil && entry.botwData!.text.split(separator: " ").count > 1 ){
                        Text( entry.botwData!.text.split(separator: " ")[0] )
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.white.opacity(0.8))
                            .minimumScaleFactor(entry.botwData!.text.split(separator: " ")[0].count > 5 ? 0.5 : 0.6)
                        Text( entry.botwData!.text.split(separator: " ")[1] )
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.white.opacity(0.8))
                            .minimumScaleFactor(entry.botwData!.text.split(separator: " ")[1].count > 5 ? 0.5 : 0.6)
                            .minimumScaleFactor(entry.botwData!.text.split(separator: " ")[1].count > 5 ? 0.5 : 0.6)
                    } else {
                        
                        Text( entry.botwData?.text ?? "")
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.white.opacity(0.8))
                            .minimumScaleFactor((entry.botwData?.text ?? "").count > 5 ? 0.5 : 0.8)
                    }
                    Text("of the")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                    Text("Week")
                        .font(.system(size: 40, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                        .widgetURL(URL(string: "/home/widget/?index=0"))

                    
                }
            } else {
                VStack {
                    Text(entry.botwData!.answers[entry.index].answer)
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Text(entry.botwData!.answers[entry.index].displayName)
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(.white.opacity(0.8))
                        .widgetURL(URL(string: "/home/profile/widget/?uid=" + entry.botwData!.answers[entry.index].uid))

                    
                }
                
            }
        }
    }
    
    
        
}

struct SnippetConfig: Decodable, Hashable {
    let gradient: String
}

struct BOTWWidget: Widget {
    let kind: String = "Widgets"
    @State var gradientStyle = Gradient(colors: [
        .blue, .purple
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
        StaticConfiguration(kind: kind, provider: BOTWProvider()) { entry in
            if #available(iOS 17.0, *) {
                BOTWEntryView(entry: entry)
                    .containerBackground(getGradient(), for: .widget)
            } else {
                BOTWEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Snippet of the Week")
        .description("Shows the Snippet of the Week and on the weekend will show others responses")
        .supportedFamilies([.systemSmall])
    }
    
    func getGradient() -> Gradient {
       
        let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
        let flutterData = try? JSONDecoder().decode(SnippetConfig.self, from: (sharedDefaults?
            .string(forKey: "botwConfig")?.data(using: .utf8)) ?? Data())
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
    BOTWWidget()
} timeline: {
    BOTWEntry(date: Date(), botwData: BOTWData(text: "Joke", answers: [Answer(uid: "", answer: "Cats and dogs teeheee", displayName: "Nathaniel Kemme Nash")]), index: 0)
}
