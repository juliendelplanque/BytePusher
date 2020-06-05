Class {
	#name : #BPEntityToResolve,
	#superclass : #BPEntity,
	#instVars : [
		'offset'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #offset }
BPEntityToResolve >> + anInteger [ 
	^ self copy
		offset: self offset + anInteger;
		yourself
]

{ #category : #testing }
BPEntityToResolve >> hasOffset [
	^ self offset ~= 0
]

{ #category : #initialization }
BPEntityToResolve >> initialize [
	super initialize.
	self offset: 0
]

{ #category : #accessing }
BPEntityToResolve >> offset [
	^ offset
]

{ #category : #accessing }
BPEntityToResolve >> offset: anObject [
	offset := anObject
]
