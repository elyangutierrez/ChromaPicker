<div align="center">

<img src="Assets/package_icon.png" alt="ChromaPicker Icon" width="128"/>

</div>

<h1 align="center">ChromaPicker</h1>

<div align="center">

<hr>

A SwiftUI package that gives you a new and improved color picker.

</div>

## Table Of Contents

 <ol>
    <li><a href="#about">About</a></li>
    <li><a href="#features">Features</a></li>
    <li><a href="#examples">Examples</a></li>
    <li><a href="#installation">Installation</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
</ol>

<hr>

## About

ChromaPicker is a highly performant, native SwiftUI color picking package designed for modern IOS applications. Built from the ground up to support both single color and complex gradient selections, it features a buttery-smooth 2D interactive grid pad, dynamic live-reordering gradient stops, and seamless orientation adaptation. 

## Features

-  Single color and complex gradient selections 
-  Inspired and modern design
-  Custom sliders
-  Input fields for easy access 
-  Seamless setup and configuration

## Examples

<div style="display:flex; justify-content:center; gap:20px; text-align:center;">
  <div>
    <h3>Single Selection</h3>
    <img src="Assets/single_example.gif">
  </div>

  <div>
    <h3>Stops Selection</h3>
    <img src="Assets/stops_example.gif">
  </div>
</div>

## Installation 

### Requirements

Swift: `>=6.2.4`

Xcode: `>=26.3`

iOS: `>=26.0`

### Swift Package Manager (Xcode)

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository URL: `https://github.com/elyangutierrez/ChromaPicker.git`
3. Choose the version rule you want (e.g., "Up to Next Major Version") and click **Add Package**.

### Swift Package Manager (Package.swift)
If you are building your own Swift Package, add ChromaPicker as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/elyangutierrez/ChromaPicker.git", from: "1.0.0")
]
```

Then, add it to your target's dependencies:

```swift
.target(
    name: "YourTarget",
    dependencies: ["ChromaPicker"]
)
```

## Usage

## License