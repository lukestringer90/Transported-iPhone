# Transported for iPhone

In 2014 I built and released Transported for iPhone. In late 2016 Apple Maps added support for UK transport information. This along with my waining enthusiasm to continue updating and supporting Transported for iPhone I have decided to make it free on the App Store and open source the code base.

Transported provides live bus and tram times for the South and West Yorkshire areas. It does this by providing a seeded Core Data database of transport nodes taken from [data.gov](http://data.gov.uk/dataset/naptan). A CSV of transport nodes from data.gov is sanitised removing any old nodes no longer in used, and is then transformed in JSON that can be easily imported into Core Data. This data is stored in a "static" persistent store which is shipped with the app. User data (favourited stops, recently viewed stops etc) is stored in a separate persistent store.

Each transport node represents a bus of tram stop, and is identified by a NAPTAN code. A NAPTAN code is then used to scrape the South Yorkshire Passenger Transported Executive or West Yorkshire Passenger Transported Executive websites for live departure data. This logic is implemented in the `LJSYourNextBus` cocoapod - see [here](https://github.com/lukestringer90/LJSYourNextBus) for more information.

**Please note**: there are some large files in this repo, namely the Core Data sqlite files that constitue the seeded database of transport nodes.
