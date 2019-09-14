Class {
	#name : #BPOffsetReference,
	#superclass : #BPReferenceToResolve,
	#instVars : [
		'objectWithAddress',
		'offset'
	],
	#category : #'BytePusher-Assembler'
}

{ #category : #'as yet unclassified' }
BPOffsetReference class >> on: anObjectWithAddress offset: anInteger [
	^ self new
		objectWithAddress: anObjectWithAddress;
		offset: anInteger;
		yourself
]

{ #category : #visiting }
BPOffsetReference >> acceptVisitor: aBPAssemblerVisitor [
	<generated>
	^ aBPAssemblerVisitor visitBPOffsetReference: self
]

{ #category : #accessing }
BPOffsetReference >> objectWithAddress [
	^ objectWithAddress
]

{ #category : #accessing }
BPOffsetReference >> objectWithAddress: anObject [
	objectWithAddress := anObject
]

{ #category : #accessing }
BPOffsetReference >> offset [
	^ offset
]

{ #category : #accessing }
BPOffsetReference >> offset: anObject [
	offset := anObject
]
