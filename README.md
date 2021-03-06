##SwiftPerformanceBenchmark
---------------

This is a hybrid Swift/Objective-C project for Mac OS.

It was written as a performance benchmark to compare Swift and OBjective-C in a memory and compute-intensive task.

It calculates large arrays of prime numbers in both languages and tracks the amount of time required for both.

For the Swift test, you can choose to use either an Array object or an Array<UInt32>

For the Objective-C test, you can choose between NSArrays or C arrays.


It demonstrates a number of different techniques:

 * Definining classes in both Swift and Objective-C using a common protocol so that they can be used interchangeably. 
 * Using Mac OS Cocoa Bindings to attach a window's UI elements directly to properties of an object.
 * Running time-consuming tasks in the background with GCD and reporting status back on the main thread.


It also uncovers a limitation with the current version of Swift (1.1?) It seems that you can't use KVO or Cocoa bindings to observe properties of an object, or link them with Mac OS Cocoa Bindings unless you write extra code. Cocoa bindings work perfectly when you change the property values from Objective-C, but the KVO methods fail to fire when you change the property values from Swift code.

The fix for this is to write custom willSet/didSet methods for the properties being observed that manaully call the methods willChangeValueForKey and didChangeValueForKey.

An example is the property swift_totalCalculated, defined in ComputedRecrod.swift.

	  var swift_totalCalculated: Int = 0
	    {
	    willSet(newValue)
	    {
	      self.willChangeValueForKey("swift_totalCalculated")
	    }
	    didSet(oldValue)
	    {
	      self.didChangeValueForKey("swift_totalCalculated")
	    }
	  }


