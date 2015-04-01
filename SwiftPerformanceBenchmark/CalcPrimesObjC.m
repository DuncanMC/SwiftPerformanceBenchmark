//
//  CalcPrimesObjC.m
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

#import "CalcPrimesObjC.h"
#import "SwiftPerformanceBenchmark-Swift.h"

@implementation CalcPrimesObjC

+ (instancetype) sharedCalcPrimesObjC
{
  static CalcPrimesObjC *_sharedCalcPrimesObjC;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
                {
                  _sharedCalcPrimesObjC = [[CalcPrimesObjC alloc] init];
                });
  return _sharedCalcPrimesObjC;
}

- (void) calcPrimesWithComputeRecord: (ComputeRecord *) aComputeRecord;
{
  theComputeRecord = aComputeRecord;
  startTime = [NSDate timeIntervalSinceReferenceDate];
  int		index;				//Used as an index into primes[].
  int		prime_count;  //The number of primes we'e found so far
  int		candidate;		//The number we are considering as a possible prime
  int   is_prime;
  
  int *primes = (int *)malloc(sizeof(int) * aComputeRecord.totalToCalculate);
  
  NSInteger totalCount = aComputeRecord.totalToCalculate;
  
  primes[0] =		2;
  prime_count =	1;
  candidate =		3;
  startTime = [NSDate timeIntervalSinceReferenceDate];
  while (prime_count < totalCount)
  {
    is_prime = true;
    //Loop through all the primes we've already found.
    for (index = 0; index < prime_count; index++)
    {
      //If our candidate number is evenly divisible by another prime
      if (candidate % primes[index] == 0)
      {
        //Then it is not a prime, so stop checking this number
        is_prime = false;
        break;
      }
      else
        //If this candidate is less than the square of the current prime, it's a prime.
        if (candidate  < primes[index]*primes[index])
        {
          is_prime = true;
          break;
        }
      
    }
    if (is_prime)
    {
      primes[prime_count++] = candidate;
      if ((prime_count & 0xfffffU) == 0)
      {
        [self updateTotal: prime_count inComputeRecord: aComputeRecord];
      }
    }
    //Move on to the next (odd) number.
    candidate += 2;
  }
  [self updateTotal: prime_count inComputeRecord: aComputeRecord];
  free(primes);
}

- (void)  updateTotal: (NSInteger) newTotal
      inComputeRecord: (ComputeRecord *) aComputeRecord;
{
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  aComputeRecord.objC_totalTime = now - startTime;
  aComputeRecord.objC_totalCalculated = newTotal;
  aComputeRecord.objC_primesPerSecond = aComputeRecord.objC_totalCalculated/aComputeRecord.objC_totalTime;
  if (self.updateDisplayBlock)
    dispatch_async(dispatch_get_main_queue(),^
                   {
                     self.updateDisplayBlock();
                   }
                   );
}

@end
