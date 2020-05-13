Class {
	#name : #BPMemoryReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'objectWithAddress',
		'offset'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #'as yet unclassified' }
BPMemoryReference class >> on: anObjectWithAddress offset: anInteger [
	^ self new
		objectWithAddress: anObjectWithAddress;
		offset: anInteger;
		yourself
]

{ #category : #visiting }
BPMemoryReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPOffsetReference: self
]

{ #category : #'assembler-dispatch' }
BPMemoryReference >> forAssembler: aBPAssembler [ 
	^ self
]

{ #category : #accessing }
BPMemoryReference >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPMemoryReference >> objectWithAddress: anObject [
	objectWithAddress := anObject
]

{ #category : #accessing }
BPMemoryReference >> offset [
	^ offset
]

{ #category : #accessing }
BPMemoryReference >> offset: anObject [
	offset := anObject
]
