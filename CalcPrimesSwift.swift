//
//  CalcPrimesSwift.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 4/1/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Foundation

private let _theCalcPrimesSwiftInstance: CalcPrimesSwift = CalcPrimesSwift()

class CalcPrimesSwift: NSObject, CalcPrimesProtocol
{
  var startTime: NSTimeInterval = 0
  var theComputeRecord: ComputeRecord?
  class func sharedInstance() -> CalcPrimesProtocol
  {
    return _theCalcPrimesSwiftInstance
  }
  
  func calcPrimesWithComputeRecord(aComputeRecord: ComputeRecord!, withUpdateDisplayBlock theUpdateDisplayBlock: updateDisplayBlock!, andCompletionBlock theCalcPrimesCompletionBlock: calcPrimesCompletionBlock!)
  {
    //println("In \(__FUNCTION__)")
    theComputeRecord = aComputeRecord
    if let requiredComputeRecord = theComputeRecord
    {
      startTime = NSDate.timeIntervalSinceReferenceDate()
      var totalCount: NSInteger = requiredComputeRecord.totalToCalculate
      var candidate: Int = 3
      var isPrime: Bool = false
      var primes: [Int] = [Int]()
      primes.reserveCapacity(requiredComputeRecord.totalToCalculate)
      
      primes.append(2)

      while primes.count < totalCount
      {
        isPrime = true
        //Loop through all the primes we've already found.
        for oldPrime in primes
        {
          if candidate % oldPrime == 0
          {
            isPrime = false
            break
          }
          if candidate < oldPrime * oldPrime
          {
            isPrime = true
            break
          }
        }
        if isPrime
        {
          primes.append(candidate)
          if (primes.count & 0xfffff) == 0
          {
            self.updateTotal(primes.count,
              theComputeRecord: requiredComputeRecord,
              withUpdateDisplayBlock: theUpdateDisplayBlock)
          }
        }
      }
      self.updateTotal(primes.count,
        theComputeRecord: requiredComputeRecord,
        withUpdateDisplayBlock: theUpdateDisplayBlock)
    }
    println("Checking for swift completion block")
    if theCalcPrimesCompletionBlock != nil
    {
      println("calling swift completion block")
      dispatch_async(dispatch_get_main_queue(), theCalcPrimesCompletionBlock)
    }
  }
  
  
  func updateTotal(newTotal: NSInteger,
    theComputeRecord: ComputeRecord,
    withUpdateDisplayBlock theUpdateDisplayBlock: updateDisplayBlock!)
  {
    let now = NSDate.timeIntervalSinceReferenceDate()
    let totalTime = now - startTime
    dispatch_async(dispatch_get_main_queue())
      {
        theComputeRecord.swift_totalTime = totalTime
        theComputeRecord.swift_totalCalculated = newTotal
        theComputeRecord.swift_primesPerSecond = Int(Double(newTotal)/totalTime)
      }
    if theUpdateDisplayBlock != nil
    {
      dispatch_async(dispatch_get_main_queue(), theUpdateDisplayBlock)
    }
  }
}

