# FetchRecipeDemo

![Swift Version](https://badgen.net/badge/swift/6.0%2B/purple)
![iOS](https://img.shields.io/badge/iOS-16.4+-blue?logo=apple)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## Overview

**FetchRecipeDemo** is a SwiftUI-based iOS application that loads, filters, and displays a list of recipes grouped in alphabetical sections. The app features image caching, navigation, and responsive UI.

## Table of Contents

- [App Preview](#app-preview)
- [Focus Areas](#focus-areas)
- [Time Spent](#time-spent)
- [Trade-offs and Decisions](#trade-offs-and-decisions)
  - [Image Caching](#image-caching)
  - [Swift 6](#swift-6)
  - [Deployment Target](#deployment-target)
  - [Testing Framework](#testing-framework)
- [Weakest Part of the Project](#weakest-part-of-the-project)
- [Additional Information](#additional-information)
  - [Features](#features)
  - [Architecture Notes](#architecture-notes)


## App Preview

<table>
  <tr>
    <td align="center"><strong>Recipe List</strong></td>
    <td align="center"><strong>Recipe Detail</strong></td>
    <td align="center"><strong>Image Cache</strong></td>
  </tr>
  <tr>
    <td><img src="media/recipeList.gif" alt="RecipeList" width="200"/></td>
    <td><img src="media/recipeDetail.gif" alt="RecipeView" width="200"/></td>
    <td><img src="media/imageCache.gif" alt="ImageCache" width="200"/></td>
  </tr>
</table>

## Focus Areas

I am a firm believer in proper separation of concerns regardless of the scope of a project, so that's where I primarily focused for this exercise. 

This demo app could have easily consisted of two views containing all logic for networking and image caching, but anyone can do that. My goal was to demonstrate how I typically approach any project, which is to establish boundaries between the different aspects of the app and utilize abstractions in the place of concrete dependencies.

Each view is only responsible for what is relevant to it, and the two files that contain logic each utilize dependency injection to perform their duties, which not only makes testing easier but allows for easier modifications in the future (irrelevant for this project but extremely useful in production apps).

I would much rather spend more time up front crafting a solid, modular foundation to ensure things are easy to read, easy to understand, and easy to change, especially after months of not touching the project.

## Time Spent

It took around **5 hours** to build.

- **Planning & Design**: ~30 minutes  
- **Implementation**: ~3 hours  
- **Testing & Debugging**: ~1 hour  
- **Polish & Cleanup**: ~30 minutes  

## Trade-offs and Decisions

### Image Caching

Full disclosure, I completely overlooked the part about not using built-in data caching for the images, so I initially used AsyncImage. After verifying the requirements, I swapped it out for a manual solution. I considered simply caching the images in memory, which would have been simple but would only have reduced network usage for the current session, so I opted to use the caches directory instead. 

I did something similar in a recent open-source project I published a few months ago, so it was relatively straightforward. And while Apple says any data stored in the caches directory would be purged by the system when necessary, I still think it's helpful to allow users to manually purge the cache, so I included the option in Settings.

### Swift 6

Dealing with the strict concurrency rules of Swift 6 is quite a challenge, but I didn't encounter many issues in this project. The only point that could be of concern is my use of **Combine** in `RecipeListViewModel` to offload recipe filtering to a background thread before publishing the results on the main thread. In my experience, Combine and **Swift Concurrency** don't seem to work well together (or at all). However, I got around this by choosing to only annotate the necessary methods in `RecipeListViewModel` with `@MainActor` so I could safely use the Combine pipeline without any issues.

### Deployment Target

I saw that you all support iOS 16+, so I wanted to reflect that. I'm really hoping you mean 16.4, as that is the version that includes most modern SwiftUI capabilities. I can work with SwiftUI for older versions of iOS, but it's just a little tricky, especially for navigation. I actually wrote a few articles about this exact topic, in case you're interested in seeing my methods. [Here's the link](https://medium.com/@nikolai.nobadi/navigating-swiftui-in-pre-ios-16-projects-crafting-custom-solutions-3abbc53b20f7)

There were only two areas that were affected by this decision. First was in `MainTabBar`. I was using the new `Tab` feature to create the tab items, so I had to drop that in favor of the old `.tabItem` modifiers (which wasn't a big deal).

Second was in my `EmptyListViewModifier`, which uses `ContentUnavailableView` from iOS 17. I could have just as easily removed `ContentUnavailableView`, but I figured it would be helpful to demonstrate that I can support multiple versions of iOS in my code, and in a way that doesn't add complexity to the main features of the app.

### Testing framework

I chose **Swift Testing** because it is so much fun to use, though I am completely comfortable writing tests using **XCTest**.

I learned a useful trick to test for **memory leaks** using XCTest, and I recently was able to come up with a method to use a similar approach in Swift Testing, so I included that in my project (`TrackingMemoryLeaks`). The file is actually a snippet from a swift package I created and use in most of my projects to streamline testing called [NnTestKit](https://github.com/nikolainobadi/NnTestKit).

## Weakest Part of the Project

The UI.

My specialty is in system architecture and building comprehensive test suites. I can easily design a modular architecture, but my interest wanes when I have to design a user interface. This is why I always prefer to collaborate with a UI Designer when working on a project. I have no issues converting a Figma design (or Canva or wireframes) to SwiftUI code. It is only when I have to create the design myself where I falter. 

If needed, I can certainly do it, but for me, it takes significantly more time to design a user interface than it does to design both a backend database and the architecture of an app.

## Additional Information

### Features

- Remote recipe loading from JSON
- Real-time filtering
- Alphabetical grouping via `RecipeSectionBuilder`
- Async image caching with `ImageCacheManager`
- Built-in tests using the `Testing` framework

### Architecture Notes

- MVVM pattern with `RecipeListViewModel` driving state
- Functional reactive updates with `@Published` and Combine
- Lightweight, modular, and testable components
- Caching powered by SHA256-hashed filenames for uniqueness
