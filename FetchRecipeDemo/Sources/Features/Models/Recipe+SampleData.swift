//
//  Recipe+SampleData.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

extension Recipe {
    static var sample: Recipe {
        return .init(
            id: .init(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
            name: "Apam Balik",
            cuisine: "Malaysian",
            largeImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
            smallImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
            sourceURL: .init(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"),
            youtubeURL: .init(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")
        )
    }
    
    static var sampleList: [Recipe] {
        return [
            .sample,
            .init(
                id: .init(uuidString: "b5db2c09-411e-4bdf-9a75-a194dcde311b")!,
                name: "BeaverTails",
                cuisine: "Canadian",
                largeImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/large.jpg")!,
                smallImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/3b33a385-3e55-4ea5-9d98-13e78f840299/small.jpg")!,
                sourceURL: .init(string: "https://www.tastemade.com/videos/beavertails"),
                youtubeURL: .init(string: "https://www.youtube.com/watch?v=2G07UOqU2e8")
            ),
            .init(
                id: .init(uuidString: "8938f16a-954c-4d65-953f-fa069f3f1b0d")!,
                name: "Blackberry Fool",
                cuisine: "British",
                largeImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/large.jpg")!,
                smallImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/ff52841a-df5b-498c-b2ae-1d2e09ea658d/small.jpg")!,
                sourceURL: .init(string: "https://www.bbc.co.uk/food/recipes/blackberry_fool_with_11859"),
                youtubeURL: .init(string: "https://www.youtube.com/watch?v=kniRGjDLFrQ")
            ),
            .init(
                id: .init(uuidString: "303ce395-af37-4cff-87b4-09c75a4e07ed")!,
                name: "Key Lime Pie",
                cuisine: "American",
                largeImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d23ad009-8f17-428f-a41f-5f3b5bc51883/large.jpg")!,
                smallImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/d23ad009-8f17-428f-a41f-5f3b5bc51883/small.jpg")!,
                sourceURL: .init(string: "https://www.bbcgoodfood.com/recipes/2155644/key-lime-pie"),
                youtubeURL: .init(string: "https://www.youtube.com/watch?v=q4Rz7tUkX9A")
            ),
            .init(
                id: .init(uuidString: "563dbb27-5323-443c-b30c-c221ae598568")!,
                name: "Budino Di Ricotta",
                cuisine: "Italian",
                largeImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/large.jpg")!,
                smallImageURL: .init(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/2cac06b3-002e-4df7-bb08-e15bbc7e552d/small.jpg")!,
                sourceURL: .init(string: "https://thehappyfoodie.co.uk/recipes/ricotta-cake-budino-di-ricotta"),
                youtubeURL: .init(string: "https://www.youtube.com/watch?v=6dzd6Ra6sb4")
            )
        ]
    }
}
