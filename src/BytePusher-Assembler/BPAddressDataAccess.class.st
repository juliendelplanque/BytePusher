Class {
	#name : #BPAddressDataAccess,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'address',
		'byteIndex'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPAddressDataAccess class >> address: address byteIndex: byteIndex [
	^ self new
		address: address;
		byteIndex: byteIndex;
		yourself
]

{ #category : #visiting }
BPAddressDataAccess >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPAddressDataAccess: self
]

{ #category : #accessing }
BPAddressDataAccess >> address [
	^ address
]

{ #category : #accessing }
BPAddressDataAccess >> address: anObject [
	address := anObject
]

{ #category : #accessing }
BPAddressDataAccess >> byteIndex [
	^ byteIndex
]

{ #category : #accessing }
BPAddressDataAccess >> byteIndex: anObject [
	byteIndex := anObject
]

{ #category : #initialization }
BPAddressDataAccess >> initialize [
	super initialize.
	self byteIndex: 0
]
