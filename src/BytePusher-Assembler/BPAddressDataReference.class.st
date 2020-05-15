Class {
	#name : #BPAddressDataReference,
	#superclass : #BPEntityToResolve,
	#instVars : [
		'objectWithAddress'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressDataReference class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		offset: byteIndex;
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

{ #category : #initialization }
BPAddressDataReference >> initialize [
	super initialize.
	self offset: 0
]

{ #category : #accessing }
BPAddressDataReference >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPAddressDataReference >> objectWithAddress: anObject [
	objectWithAddress := anObject
]
