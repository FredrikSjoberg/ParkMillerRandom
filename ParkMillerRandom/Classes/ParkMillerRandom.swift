/*
* Copyright (c) 2009 Michael Baczynski, http://www.polygonal.de
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
* LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
* OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
* WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/**
* Implementation of the Park Miller (1988) "minimal standard" linear
* congruential pseudo-random number generator.
*
* For a full explanation visit: http://www.firstpr.com.au/dsp/rand31/
*
* The generator uses a modulus constant (m) of 2^31 - 1 which is a
* Mersenne Prime number and a full-period-multiplier of 16807.
* Output is a 31 bit unsigned integer. The range of values output is
* 1 to 2,147,483,646 (2^31-1) and the seed must be in this range too.
*
* @author Michael Baczynski, www.polygonal.de
*/

//
//  ParkMillerRandom.swift
//  ParkMillerRandom
//
//  Created by Fredrik Sjöberg on 16/07/15.
//  Copyright (c) 2015 Fredrik Sjoberg. All rights reserved.
//

import Foundation
import GameplayKit

private let r0:UInt32 = 2147483647
private let r1:UInt32 = 16807
private let dif:Float = 0.4999

class ParkMillerRandom {
    /// Allow seeds between [1, 0X7FFFFFFE]
    private var internalSeed: UInt32 = 1
    var seed: UInt32 {
        set {
            if newValue < 1 {
                internalSeed = 1
            }
            else {
                internalSeed = newValue
            }
        }
        get {
            return internalSeed
        }
    }
    
    init(seed: UInt32) {
        if seed < 1 {
            internalSeed = 1
        }
        else {
            internalSeed = seed
        }
    }
}

/**
* generator:
* new-value = (old-value * 16807) mod (2^31 - 1)
*/
extension ParkMillerRandom {
    private func gen() -> UInt32 {
        let value = UInt(internalSeed) * UInt(r1) % UInt(r0)
        internalSeed = UInt32(value)
        return internalSeed
    }
}

extension ParkMillerRandom : GKRandom {
    /**
    Generates a random Int from entire spectrum.
    
    - returns: Int
    */
    @objc func nextInt() -> Int {
        return Int(gen())
    }
    
    /**
    Generates a random Int less than upperBound
    
    - parameter upperBound: maximum
    
    - returns: Int 
    */
    @objc func nextIntWithUpperBound(upperBound: Int) -> Int {
        let low = -dif
        let high = Float(upperBound) + dif
        return Int(low + ((high - low) * nextUniform()))
    }
    
    /**
    Generates a random Float in [0,1] range
    
    - returns: Float [0,1]
    */
    @objc func nextUniform() -> Float {
        return Float(gen()) / Float(r0)
    }
    
    /**
    Generates a random Bool
    
    - returns: true or false
    */
    @objc func nextBool() -> Bool {
        let x = nextUniform()
        if x <= dif { return true }
        else { return false }
    }
}
