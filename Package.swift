import PackageDescription

let package = Package(
    name: "MediaType",
    dependencies: [
        .Package(url: "https://github.com/Zewo/InterchangeData.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/String.git", majorVersion: 0, minor: 4),
    ]
)
