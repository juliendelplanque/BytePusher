Class {
	#name : #BPAddress,
	#superclass : #BPEntity,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'memoryAddress'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddress class >> fromByteArray: aByteArray [
	^ self lowByte: aByteArray third middleByte: aByteArray second highByte: aByteArray first
]

{ #category : #'instance creation' }
BPAddress class >> lowByte: lowByte middleByte: middleByte highByte: highByte [
	^ self memoryAddress: lowByte | (middleByte << 8) | (highByte << 16)
]

{ #category : #'instance creation' }
BPAddress class >> memoryAddress: memoryAddress [
	^ self new
		memoryAddress: memoryAddress;
		yourself
]

{ #category : #arithmetic }
BPAddress >> + anInteger [
	^ BPAddress memoryAddress: self memoryAddress + anInteger
]

{ #category : #arithmetic }
BPAddress >> - anInteger [
	^ BPAddress memoryAddress: self memoryAddress - anInteger
]

{ #category : #comparing }
BPAddress >> < aBPAddress [
	"Answer whether the receiver is less than the argument."

	^ self memoryAddress < aBPAddress memoryAddress
]

{ #category : #arithmetic }
BPAddress >> << anInteger [
	^ BPAddress memoryAddress: self memoryAddress << anInteger
]

{ #category : #comparing }
BPAddress >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ memoryAddress = anObject memoryAddress
]

{ #category : #arithmetic }
BPAddress >> >> anInteger [
	^ BPAddress memoryAddress: self memoryAddress >> anInteger
]

{ #category : #visiting }
BPAddress >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddress: self
]

{ #category : #accessing }
BPAddress >> access: aByteArray [
	"Access the value stored at myself in aByteArray.
	 Indexing starts at 0 when using me, so I access index self + 1 in aByteArray.
	"
	^ aByteArray at: self memoryAddress + 1
]

{ #category : #accessing }
BPAddress >> accessInteger: aByteArray [
	"Access the 24-bits integer stored at myself in aByteArray.
	 Indexing starts at 0 when using me, so I access index self + 1 in aByteArray.
	"
	^ ((self access: aByteArray) << 16)
		| (((self + 1) access: aByteArray) << 8)
			| ((self + 2) access: aByteArray)
]

{ #category : #accessing }
BPAddress >> address [
	^ self
]

{ #category : #converting }
BPAddress >> asAddressReference [
	^ BPAddressReference new
		objectWithAddress: self;
		yourself
]

{ #category : #converting }
BPAddress >> asBPAddress [
	^ self
]

{ #category : #converting }
BPAddress >> asByteArray [
	^ { self higherByte. self middleByte. self lowerByte } asByteArray
]

{ #category : #converting }
BPAddress >> asDataReference [
	^ BPAddressDataReference new
		objectWithAddress: self;
		yourself
]

{ #category : #accessing }
BPAddress >> byteAt: anInteger [
	"Access one of the bytes composing myself.
	 anInteger can only be 0, 1 or 2.
	"
	anInteger = 0
		ifTrue: [ ^ self higherByte ].
	anInteger = 1
		ifTrue: [ ^ self middleByte ].
	anInteger = 2
		ifTrue: [ ^ self lowerByte ].
	
	self error: 'A BytePusher address is encoded on 3 bytes.'
]

{ #category : #'assembler-dispatch' }
BPAddress >> forAssembler: aBPAssembler [ 
	^ self
]

{ #category : #'assembler-dispatch' }
BPAddress >> forAssembly: anAssembly [
	^ self
]

{ #category : #comparing }
BPAddress >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ memoryAddress hash
]

{ #category : #accessing }
BPAddress >> hex [
	"Returns the hexadecimal string representing the address."
	^ self memoryAddress printPaddedWith: $0 to: 6 base: 16
]

{ #category : #accessing }
BPAddress >> higherByte [
	^ (self memoryAddress & 16rFF0000) >> 16
]

{ #category : #accessing }
BPAddress >> higherByte: aByte [
	self memoryAddress: (self memoryAddress & 16r00FFFF) | (aByte << 16)
]

{ #category : #accessing }
BPAddress >> lowerByte [
	^ self memoryAddress & 16r0000FF
]

{ #category : #accessing }
BPAddress >> lowerByte: aByte [
	self memoryAddress: (self memoryAddress & 16rFFFF00) | aByte
]

{ #category : #accessing }
BPAddress >> memoryAddress [
	^ memoryAddress
]

{ #category : #accessing }
BPAddress >> memoryAddress: anInteger [
	(anInteger between: 0 and: MAX_ADDRESS)
		ifFalse: [ BPInvalidAddressValue signalForValue: anInteger ].
	memoryAddress := anInteger
]

{ #category : #accessing }
BPAddress >> middleByte [
	^ (self memoryAddress & 16r00FF00) >> 8
]

{ #category : #accessing }
BPAddress >> middleByte: aByte [
	self memoryAddress: (self memoryAddress & 16rFF00FF) | (aByte << 8)
]

{ #category : #printing }
BPAddress >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: self hex.
	aStream nextPut: $)
]

{ #category : #accessing }
BPAddress >> store: aByte in: aByteArray [
	"Store aByte in aByteArray.
	 Indexing starts at 0 when using me, so I access index self + 1 in aByteArray.
	"
	(self memoryAddress between: 0 and: aByteArray size - 1)
		ifFalse: [ SubscriptOutOfBounds signalFor: self memoryAddress lowerBound: 0 upperBound: aByteArray size - 1 in: aByteArray ].
	^ aByteArray at: self memoryAddress + 1 put: aByte
]

{ #category : #accessing }
BPAddress >> storeAddress: anAddress in: aByteArray [
	"Store anAddress in aByteArray as 3 consecutive bytes starting at myself.
	"
	self storeInteger: anAddress memoryAddress in: aByteArray.
		
		
]

{ #category : #accessing }
BPAddress >> storeInteger: anInteger in: aByteArray [
	"Store anInteger in aByteArray in the 3 consecutive bytes starting at myself.
	"
	self store: anInteger >> 16 & 16rFF in: aByteArray.
	self + 1 store: anInteger >> 8 & 16rFF in: aByteArray.
	self + 2 store: anInteger & 16rFF in: aByteArray
]

{ #category : #writing }
BPAddress >> writeOn: aByteArray at: address [
	self deprecated: 'Was used in old assembler.'.
	aByteArray
		at: address + 1 put: self higherByte;
		at: address + 2 put: self middleByte;
		at: address + 3 put: self lowerByte.
]
