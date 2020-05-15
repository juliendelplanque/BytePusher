Class {
	#name : #BPMemoryReference,
	#superclass : #BPEntityToResolve,
	#instVars : [
		'objectWithAddress'
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
