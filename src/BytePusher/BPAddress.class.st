Class {
	#name : #BPAddress,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'memoryAddress'
	],
	#category : #'BytePusher-Assembly'
}

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

{ #category : #converting }
BPAddress >> asBPAddress [
	^ self
]

{ #category : #'assembly-dispatch' }
BPAddress >> forAssembly: anAssembly [
	^ self
]

{ #category : #comparing }
BPAddress >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ memoryAddress hash
]

{ #category : #accessing }
BPAddress >> memoryAddress [
	^ memoryAddress
]

{ #category : #accessing }
BPAddress >> memoryAddress: anObject [
	memoryAddress := anObject
]

{ #category : #printing }
BPAddress >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: (self memoryAddress printPaddedWith: $0 to: 7 base: 16).
	aStream nextPut: $)
]

{ #category : #accessing }
BPAddress >> store: aByte in: aByteArray [
	"Store aByte in aByteArray.
	 Indexing starts at 0 when using me, so I access index self + 1 in aByteArray.
	"
	^ aByteArray at: self memoryAddress + 1 put: aByte
]

{ #category : #writing }
BPAddress >> writeOn: aByteArray at: address [
	aByteArray
		at: address + 1 put: (self memoryAddress & 16rFF0000) >> 16;
		at: address + 2 put: (self memoryAddress & 16rFF00) >> 8;
		at: address + 3 put: (self memoryAddress & 16rFF).
]
