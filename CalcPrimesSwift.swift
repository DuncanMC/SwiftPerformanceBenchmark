//
//  CalcPrimesSwift.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 4/1/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Foundation

private let _theCalcPrimesSwiftInstance: CalcPrimesSwift = CalcPrimesSwift()

class CalcPrimesSwift:  NSObject, CalcPrimesProtocol
{
  var logPrimes = false
  var useSwiftArrays: Bool = true
  var foo: Array<Int>?
  var startTime: NSTimeInterval = 0
  var theComputeRecord: ComputeRecord?
  
    class func sharedInstance() -> CalcPrimesProtocol!
    {
    return _theCalcPrimesSwiftInstance
  }

  func calcPrimesWithComputeRecord(aComputeRecord: ComputeRecord!, withUpdateDisplayBlock theUpdateDisplayBlock: updateDisplayBlock!, andCompletionBlock theCalcPrimesCompletionBlock: calcPrimesCompletionBlock!)
  {
    if aComputeRecord!.swift_useArrayObjects
    {
      self.calcPrimesWithComputeRecordUsingArray(aComputeRecord,
        withUpdateDisplayBlock: theUpdateDisplayBlock,
        andCompletionBlock: theCalcPrimesCompletionBlock)
    }
    else
    {
      self.calcPrimesWithComputeRecordUsingBuffer(aComputeRecord,
        withUpdateDisplayBlock: theUpdateDisplayBlock,
        andCompletionBlock: theCalcPrimesCompletionBlock)
      
    }
  }
  
  func calcPrimesWithComputeRecordUsingBuffer(aComputeRecord: ComputeRecord!, withUpdateDisplayBlock theUpdateDisplayBlock: updateDisplayBlock!, andCompletionBlock theCalcPrimesCompletionBlock: calcPrimesCompletionBlock!)
  {
    theComputeRecord = aComputeRecord
    typealias UnsafeIntPointer = UnsafeMutablePointer<UInt32>
    typealias UnsafeIntArray = UnsafeMutableBufferPointer<UInt32>
    
    var primes: UnsafeIntArray
    var primeCount: Int = 0
    
    if let requiredComputeRecord = theComputeRecord
    {
      startTime = NSDate.timeIntervalSinceReferenceDate()
      let totalCount: NSInteger = requiredComputeRecord.totalToCalculate
      var candidate: UInt32 = 3
      var isPrime: Bool = false
      let byteSize = Int(requiredComputeRecord.totalToCalculate * sizeof(UInt32))
      let ptr = UnsafeIntPointer(malloc(size_t(byteSize)))
      primes = UnsafeIntArray(start: ptr, count: theComputeRecord!.totalToCalculate)
      primes[primeCount++] = 2
      
      while primeCount < totalCount
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
          primes[primeCount++] = candidate
          if (primeCount & 0x3ffff) == 0
          {
            self.updateTotal(primeCount,
              theComputeRecord: requiredComputeRecord,
              withUpdateDisplayBlock: theUpdateDisplayBlock)
          }
        }
        //Move on to the next (odd) number.
        candidate += 2;
        
      }
      self.updateTotal(primeCount,
        theComputeRecord: requiredComputeRecord,
        withUpdateDisplayBlock: theUpdateDisplayBlock)
      //println("Checking for swift completion block")
      
      if logPrimes
      {
        //print the last 10 primes calculated
        for var index = primeCount-11; index < primeCount; index++
        {
          let aPrime = primes[index]
          print("Prime[\(index)] = \(aPrime)", terminator: "")
        }
      }
      free(ptr)
      
      if theCalcPrimesCompletionBlock != nil
      {
        //println("calling swift completion block")
        dispatch_async(dispatch_get_main_queue(), theCalcPrimesCompletionBlock)
      }
    }
    
  }
  
  func calcPrimesWithComputeRecordUsingArray(aComputeRecord: ComputeRecord!, withUpdateDisplayBlock theUpdateDisplayBlock: updateDisplayBlock!, andCompletionBlock theCalcPrimesCompletionBlock: calcPrimesCompletionBlock!)
  {
    theComputeRecord = aComputeRecord
    //var useArrayObjects = false
    typealias UnsafeIntPointer = UnsafeMutablePointer<Int>
    typealias UnsafeIntArray = UnsafeMutableBufferPointer<Int>
    //--
//    let byteSize = UInt(theComputeRecord!.totalToCalculate * sizeof(Int))
//    var ptr = UnsafeIntPointer(malloc(byteSize))

    //--

    //bytes = [Int]() as unsafeArray
    var primes: Array<UInt32> = Array<UInt32>()
    
    if let requiredComputeRecord = theComputeRecord
    {
      startTime = NSDate.timeIntervalSinceReferenceDate()
      let totalCount: NSInteger = requiredComputeRecord.totalToCalculate
      var candidate: UInt32 = 3
      var isPrime: Bool = false
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
          if (primes.count & 0x3ffff) == 0
          {
            self.updateTotal(primes.count,
              theComputeRecord: requiredComputeRecord,
              withUpdateDisplayBlock: theUpdateDisplayBlock)
          }
        }
        //Move on to the next (odd) number.
        candidate += 2;
        
      }
      self.updateTotal(primes.count,
        theComputeRecord: requiredComputeRecord,
        withUpdateDisplayBlock: theUpdateDisplayBlock)
    }
    //println("Checking for swift completion block")
    
    if logPrimes
    {
      //print the last 10 primes calculated
      for var index = primes.count-11; index < primes.count; index++
      {
        let aPrime = primes[index]
        print("Prime[\(index)] = \(aPrime)")
      }
    }
    if theCalcPrimesCompletionBlock != nil
    {
      //println("calling swift completion block")
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

