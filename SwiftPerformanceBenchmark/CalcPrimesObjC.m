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

//-------------------------------------------------------------------------------------------------------
#pragma mark - Class methods
//-------------------------------------------------------------------------------------------------------

+ (instancetype) sharedInstance
{
  static CalcPrimesObjC *_sharedCalcPrimesObjC;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^
                {
                  _sharedCalcPrimesObjC = [[CalcPrimesObjC alloc] init];
                });
  return _sharedCalcPrimesObjC;
}

//-------------------------------------------------------------------------------------------------------
#pragma mark - Instance methods
//-------------------------------------------------------------------------------------------------------

- (void) calcPrimesWithComputeRecord: (ComputeRecord *) aComputeRecord
              withUpdateDisplayBlock: (updateDisplayBlock) theUpdateDisplayBlock
                  andCompletionBlock: (calcPrimesCompletionBlock)
theCalcPrimesCompletionBlock;
{
  //NSLog(@"Entering %s", __PRETTY_FUNCTION__);
  theComputeRecord = aComputeRecord;
  startTime = [NSDate timeIntervalSinceReferenceDate];
  int		index;				//Used as an index into primes[].
  int		prime_count;  //The number of primes we'e found so far
  int		candidate;		//The number we are considering as a possible prime
  BOOL   is_prime;
  
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
      if ((prime_count & 0x3ffff) == 0)
      {
        [self updateTotal: prime_count
          inComputeRecord: aComputeRecord
   withUpdateDisplayBlock: theUpdateDisplayBlock];
      }
    }
    //Move on to the next (odd) number.
    candidate += 2;
  }
  [self     updateTotal: prime_count
        inComputeRecord: aComputeRecord
 withUpdateDisplayBlock: theUpdateDisplayBlock];
  
  //print the last 10 primes calculated
  printf("\nPrimes calculated in Objective-C:\n");
  for (int index = prime_count - 11; index< prime_count; index++)
    printf("Prime[%d] = %d\n", index, primes[index]);
  
  if (theCalcPrimesCompletionBlock != nil)
    dispatch_async(dispatch_get_main_queue(),^
                   {
                     theCalcPrimesCompletionBlock();
                   }
                   );

  free(primes);
}

//-------------------------------------------------------------------------------------------------------

- (void)  updateTotal: (NSInteger) newTotal
      inComputeRecord: (ComputeRecord *) aComputeRecord
withUpdateDisplayBlock:  (updateDisplayBlock) theUpdateDisplayBlock;
{
  NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
  aComputeRecord.objC_totalTime = now - startTime;
  aComputeRecord.objC_totalCalculated = newTotal;
  aComputeRecord.objC_primesPerSecond = aComputeRecord.objC_totalCalculated/aComputeRecord.objC_totalTime;
  if (theUpdateDisplayBlock != nil)
    dispatch_async(dispatch_get_main_queue(),^
                   {
                     theUpdateDisplayBlock();
                   }
                   );
}

@end
