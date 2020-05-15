Class {
	#name : #BPNextInstructionReference,
	#superclass : #BPEntityToResolve,
	#instVars : [
		'offset'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'instance creation' }
BPNextInstructionReference class >> offset: offset [
	^ self new
		offset: offset;
		yourself
]

{ #category : #'instance creation' }
BPNextInstructionReference class >> offset: offset byteIndex: byteIndex [
	^ self new
		offset: offset;
		offset: byteIndex;
		yourself
]

{ #category : #visiting }
BPNextInstructionReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPNextInstructionReference: self
]

{ #category : #converting }
BPNextInstructionReference >> asAddressReference [
	^ BPAddressReference new
		address: self;
		yourself
]

{ #category : #converting }
BPNextInstructionReference >> asDataReference [
	^ BPAddressDataReference new
		objectWithAddress: self;
		yourself
]

{ #category : #initialization }
BPNextInstructionReference >> initialize [
	super initialize.
	self offset: 0
]

{ #category : #accessing }
BPNextInstructionReference >> offset [
	^ offset
]

{ #category : #accessing }
BPNextInstructionReference >> offset: anObject [
	offset := anObject
]
