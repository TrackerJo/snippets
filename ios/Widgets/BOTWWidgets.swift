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
            BOTWEntry(date: Date(), botwData: BOTWData(text: "Joke"))
        }

        func getSnapshot(in context: Context, completion: @escaping (BOTWEntry) -> ()) {
            let entry = BOTWEntry(date: Date(), botwData: BOTWData(text: "Joke"))
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            let sharedDefaults = UserDefaults.init(suiteName: "group.kazoom_snippets")
            let flutterData = try? JSONDecoder().decode(BOTWData.self, from: (sharedDefaults?
                .string(forKey: "botwData")?.data(using: .utf8)) ?? Data())

            let entryDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())!
            let entry = BOTWEntry(date: entryDate, botwData: flutterData)

            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
}


struct BOTWData: Decodable, Hashable {
    let text: String
}



struct BOTWEntry: TimelineEntry {
    let date: Date
    let botwData: BOTWData?
}


struct BOTWEntryView : View {
    var entry: BOTWProvider.Entry

    var body: some View {
        ZStack{
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
                
            }
        }
    }
}



struct BOTWWidget: Widget {
    let kind: String = "Widgets"
    @State var gradientStyle = Gradient(colors: [
        .blue, .purple
    ])

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BOTWProvider()) { entry in
            if #available(iOS 17.0, *) {
                BOTWEntryView(entry: entry)
                    .containerBackground(gradientStyle, for: .widget)
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
}



//#Preview(as: .systemSmall) {
//    SnippetsWidget()
//} timeline: {
//    SnippetsEntry(date: Date(), snippetsData: SnippetsData(questions: ["What's your favorite color?"]))
//}
