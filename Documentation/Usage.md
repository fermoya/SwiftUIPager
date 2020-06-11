# Usage

## Initialization

Creating a `Pager` is very simple. You just need to pass:
- `Binding` to the current page
- `Array` of items 
- `KeyPath` to an identifier
- `ViewBuilder` factory method to create each page

```swift
@State var page: Int = 0
var items = Array(0..<10)

var body: some View {
    Pager(page: $page
          data: items,
          id: \.identifier,
          content: { index in
              // create a page based on the data passed
              Text("Page: \(index)")
     })
 }
```

> **Note:** All examples require `import SwiftUIPager` at the top of the source file.

## UI customization

`Pager` is easily customizable through a number of view-modifier functions.  You can change the orientation, the direction of the scroll, the alignment, the space between items or the page aspect ratio, among others:

By default, `Pager` is configured as:
- Horizontal, left to right direction.
- Items have center alignment inside `Pager` and take all the space available
- Current page is centered in the scroll
- Only the page is hittable and reacts to swipes
- Finite, that is, it doesn't loop the pages

> **Note** `Pager` has no intrinsic size. This means that its size depends on the available space or the extrinsic size specified with `frame` modifier.
>
> If you're using the [leacy support](/Documentation/Legacy.md), you'll need to wrap any reference to `Pager` with `if #available(iOS 13, *)` or any other platform and version you may require.

### Configure your page size

There are two ways to achieve this. You can use `preferredItemSize` to let `Pager` know which size your items should have. The framework will automatically calculate the `itemAspectRatio` and the necessary `padding` for you. You can also use `itemAspectRatio` to change the look of the page. Pass a value lower than 1 to make the page look like a card:

<img src="/resources/usage/page_aspect_ratio_lower_than_1.png" alt="itemAspectRatio lower than 1" height="640"/>

whereas a value greater than one will make it look like a box:

<img src="/resources/usage/page_aspect_ratio_greater_than_1.png" alt="itemAspectRatio greater than 1" height="640"/>

### Orientation and direction

By default, `Pager` will create a horizontal container. Use `vertical` to create a vertical pager:

```swift
Pager(...)
    .vertical()
```

<img src="/resources/usage/vertical-pager.gif" alt="Vertical pager" height="640"/>

Pass a direction to `horizontal` or `vertical` to change the scroll direction. For instance, you can have a horizontal `Pager` that scrolls right-to-left:

```swift
Pager(...)
    .itemSpacing(10)
    .alignment(.start)
    .horizontal(.rightToLeft)
    .itemAspectRatio(0.6)
```

<img src="/resources/usage/orientation-alignment-start.gif" alt="Pages aligned to the start of the pager" height="640"/>

### Alignment

Pass a position to `itemAspectRatio` or `preferredItemSize` to specify the alignment along the vertical / horizontal axis for a horizontal / vertical `Pager`. Change its position along the horizontal / vertical  axis of a horizontal / vertical `Pager` by using `alignment`: 

```swift
Pager(...)
     .itemSpacing(10)
     .horizontal()
     .padding(8)
     .itemAspectRatio(1.5, alignment: .end)    // will move the items to the bottom of the container
     .alignment(.center)                       // will align the first item to the leading of the container
```

<img src="/resources/usage/item-alignment-start.gif" alt="Pages positioned at the start of the horizontal pager" height="640"/>

## Animations

### Scale

Use `interactive` to add a scale animation effect to those pages that are unfocused, that is, those elements whose index is different from `pageIndex`:

```swift
Pager(...)
    .interactive(0.8)
```

<img src="/resources/usage/interactive-pagers.gif" alt="Interactive pager" height="640"/>

### Rotation

You can also use `rotation3D` to add a rotation effect to your pages:

```swift
Pager(...)
    .itemSpacing(10)
    .rotation3D()
```

<img src="/resources/usage/pager-rotation3D.gif" alt="Rotation 3D" height="640"/>

### Loop

Transform your `Pager` into an endless sroll by using `loopPages`:

<img src="/resources/usage/endless-pager.gif" alt="Endless pager" height="640"/>

## Events

Use `onPageChanged` to react to any change on the page index:

```swift
Pager(...)
     .onPageChanged({ (newIndex) in
         // do something
     })
```

## Add pages on demand

You can use `onPageChanged` to add new items on demand whenever the user is getting to the last page:

```swift

@State var page: Int = 0
@State var data = Array(0..<5)

var body: some View {
    Pager(...)
        .onPageChanged({ page in
            guard page == self.data.count - 2 else { return }
            guard let last = self.data.last else { return }
            let newData = (1...5).map { last + $0 }
            withAnimation {
                self.data.append(contentsOf: newData)
            }
        })
}
```

## Examples

For more information, please check the [sample app](/Example). There are included several common use-cases:

- See [`InfiniteExampleView`](/Example/SwiftUIPagerExample/Examples/InfiniteExampleView.swift) for more info about `loopPages` and using `onPageChanged` to add items on the fly.
- See [`ColorsExampleView`](/Example/SwiftUIPagerExample/Examples/ColorsExampleView.swift) for more info about event-driven `Pager`.
- See [`EmbeddedExampleView`](/Example/SwiftUIPagerExample/Examples/EmbeddedExampleView.swift) for more info about embedding `Pager` into a `ScrollView`.
- See [`NestedExampleView`](/Example/SwiftUIPagerExample/Examples/NestedExampleView.swift) for more info about nesting `Pager`.
- See [`BizarreExampleView`](/Example/SwiftUIPagerExample/Examples/BizarreExampleView.swift) for more info about other features of `Pager`.

If you have any issues or feedback, please open an issue or reach out to me at [fmdr.ct@gmail.com](mailto:fmdr.ct@gmail.com).  
Please feel free to collaborate and make this framework better. 
