# CountDownTimer
Circle shaped countdown timer.

## Installation
<b>CocoaPods:</b>
<pre>
pod 'BKCountDownTimer'
</pre>
<b>Manual:</b>
<pre>
Copy <i>CircleBase.swift, CircleCount.swift, CircleTic.swift, CircleTimer.swift</i> to your project.
</pre>

## Preview
![](/img-prev.png)

## HowTo
![](/img-howto.png)

## Using Timer
```swift
vwCircle.startTimer(block: { (count, minute, second) in
    print("\(minute) : \(second)")
}) {
    print("complete")
}
```

## License

<i>BKCountDownTimer</i> is available under the MIT license. See the LICENSE file for more info.
