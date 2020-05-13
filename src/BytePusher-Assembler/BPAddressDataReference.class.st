Class {
	#name : #BPAddressDataReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'byteIndex',
		'objectWithAddress'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressDataReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		byteIndex: byteIndex;
		yourself
]

{ #category : #visiting }
BPAddressDataReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddressDataReference: self
]

{ #category : #accessing }
BPAddressDataReference >> address [
	^ self objectWithAddress address
]

{ #category : #accessing }
BPAddressDataReference >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPAddressDataReference >> byteIndex: anObject [
	byteIndex := anObject
]

{ #category : #initialization }
BPAddressDataReference >> initialize [
	super initialize.
	self byteIndex: 0
]

{ #category : #accessing }
BPAddressDataReference >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPAddressDataReference >> objectWithAddress: anObject [
	objectWithAddress := anObject
]
